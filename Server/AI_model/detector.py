from pathlib import Path

import cv2
import numpy as np
import onnxruntime as ort


class Detector:
    def __init__(self, model_path, conf=0.4, input_size=640):
        self.model_path = Path(model_path)
        self.conf = conf
        self.input_size = input_size

        self.session = ort.InferenceSession(
            str(self.model_path),
            providers=["CPUExecutionProvider"]
        )

        self.input_name = self.session.get_inputs()[0].name

        print("ONNX Providers:", self.session.get_providers())
        print("Input:", self.input_name)

    def _preprocess(self, image):
        """
        Letterbox resize image to 640x640 and convert to YOLO format.
        """
        shape = image.shape[:2]  # current shape [height, width]
        
        # Scale ratio (new / old)
        r = min(self.input_size / shape[0], self.input_size / shape[1])
        
        new_unpad = int(round(shape[1] * r)), int(round(shape[0] * r))
        dw, dh = self.input_size - new_unpad[0], self.input_size - new_unpad[1]  # wh padding
        
        dw /= 2  # divide padding into 2 sides
        dh /= 2

        if shape[::-1] != new_unpad:  # resize
            img = cv2.resize(image, new_unpad, interpolation=cv2.INTER_LINEAR)
        else:
            img = image.copy()
            
        top, bottom = int(round(dh - 0.1)), int(round(dh + 0.1))
        left, right = int(round(dw - 0.1)), int(round(dw + 0.1))
        
        img = cv2.copyMakeBorder(img, top, bottom, left, right, cv2.BORDER_CONSTANT, value=(114, 114, 114))

        # Convert to RGB, normalize, HWC -> CHW
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        img = img.astype(np.float32) / 255.0
        img = np.transpose(img, (2, 0, 1))
        img = np.expand_dims(img, axis=0)

        return img, r, dw, dh

    def detect(self, image_path):
        """
        Detect license plate and return cropped plate image.
        """
        image = cv2.imread(str(image_path))

        if image is None:
            return None

        original_h, original_w = image.shape[:2]

        input_tensor, ratio, pad_w, pad_h = self._preprocess(image)

        outputs = self.session.run(
            None,
            {self.input_name: input_tensor}
        )

        predictions = outputs[0]

        # Remove batch dimension -> (5, 8400)
        predictions = np.squeeze(predictions, axis=0)
        
        # Transpose -> (8400, 5)
        predictions = predictions.T

        if predictions.ndim != 2:
            return None

        # Filter by confidence
        scores = predictions[:, 4]
        mask = scores > self.conf
        
        filtered_preds = predictions[mask]
        filtered_scores = scores[mask]
        
        if len(filtered_preds) == 0:
            return None
            
        # Extract cx, cy, w, h
        cx = filtered_preds[:, 0]
        cy = filtered_preds[:, 1]
        bw = filtered_preds[:, 2]
        bh = filtered_preds[:, 3]
        
        # Convert to top-left x, y for NMSBoxes
        x1 = cx - bw / 2
        y1 = cy - bh / 2
        
        nms_boxes = np.stack([x1, y1, bw, bh], axis=1).tolist()
        nms_scores = filtered_scores.tolist()
        
        indices = cv2.dnn.NMSBoxes(nms_boxes, nms_scores, score_threshold=self.conf, nms_threshold=0.45)
        
        if len(indices) == 0:
            return None
            
        # Get the highest confidence box from NMS
        idx = indices[0]
        if isinstance(idx, (list, np.ndarray)):
            idx = idx[0]
            
        best_cx = cx[idx]
        best_cy = cy[idx]
        best_w = bw[idx]
        best_h = bh[idx]
        
        # Convert coordinates from 640x640 (padded) back to original image
        best_cx = (best_cx - pad_w) / ratio
        best_cy = (best_cy - pad_h) / ratio
        best_w = best_w / ratio
        best_h = best_h / ratio

        x1 = int(best_cx - best_w / 2)
        y1 = int(best_cy - best_h / 2)
        x2 = int(best_cx + best_w / 2)
        y2 = int(best_cy + best_h / 2)

        # Clamp coordinates
        x1 = max(0, min(x1, original_w))
        y1 = max(0, min(y1, original_h))
        x2 = max(0, min(x2, original_w))
        y2 = max(0, min(y2, original_h))

        if x2 <= x1 or y2 <= y1:
            return None

        crop = image[y1:y2, x1:x2]

        if crop.size == 0:
            return None

        return crop