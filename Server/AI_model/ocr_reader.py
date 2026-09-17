import cv2
import numpy as np
import onnxruntime as ort


class OCRReader:

    def __init__(self, model_path):
        self.session = ort.InferenceSession(
            model_path,
            providers=["CPUExecutionProvider"]
        )

        self.input_name = self.session.get_inputs()[0].name

        print("OCR ONNX providers:",
              self.session.get_providers())

        print("OCR input:",
              self.session.get_inputs()[0].shape)

        print("OCR output:",
              self.session.get_outputs()[0].shape)

    def read_text(self, image):

        if image is None:
            return None

        # BGR -> RGB
        image = cv2.cvtColor(
            image,
            cv2.COLOR_BGR2RGB
        )

        # PP-OCR recognition input
        image = self._resize_norm_img(image)

        output = self.session.run(
            None,
            {
                self.input_name: image
            }
        )

        return self._decode(output[0])

    def _resize_norm_img(self, image):

        img_h = 48
        img_w = 320

        h, w = image.shape[:2]

        ratio = w / float(h)

        resized_w = min(
            img_w,
            max(1, int(img_h * ratio))
        )

        image = cv2.resize(
            image,
            (resized_w, img_h)
        )

        image = image.astype(
            np.float32
        ) / 255.0

        image = (image - 0.5) / 0.5

        # Pad to 320 width
        padded = np.zeros(
            (img_h, img_w, 3),
            dtype=np.float32
        )

        padded[:, :resized_w, :] = image

        # HWC -> CHW
        padded = np.transpose(
            padded,
            (2, 0, 1)
        )

        # Add batch dimension
        padded = np.expand_dims(
            padded,
            axis=0
        )

        return padded

    def _decode(self, output):

        # CTC greedy decoding
        predictions = output[0]

        if predictions.ndim == 3:
            predictions = predictions[0]

        indexes = np.argmax(
            predictions,
            axis=1
        )

        # Character dictionary
        chars = self._get_characters()

        result = []
        last_index = -1

        for index in indexes:

            index = int(index)

            # CTC blank
            if index == 0:
                last_index = index
                continue

            # Remove repeated characters
            if index == last_index:
                continue

            if index < len(chars):
                result.append(chars[index])

            last_index = index

        text = "".join(result)

        return text.strip()

    def _get_characters(self):

        # PP-OCRv5 English dictionary
        characters = [
            "blank"
        ]

        characters += list(
            "0123456789"
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            "abcdefghijklmnopqrstuvwxyz"
        )

        return characters