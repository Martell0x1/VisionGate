import subprocess
from pathlib import Path
import cv2

import warnings
warnings.filterwarnings("ignore")

class Detector:
    def __init__(self, yolov9_dir, weights_path, conf=0.5):
        self.yolov9_dir = Path(yolov9_dir)
        self.weights_path = Path(weights_path)
        self.conf = conf

    def detect(self, image_path):
        """Run YOLOv9 detect.py, read bbox, crop plate using OpenCV."""
        image_path = Path(image_path)
        img_name = image_path.stem

        # Run YOLO detection with save-txt (no auto-crop)
        cmd = [
            "python",
            str(self.yolov9_dir / "detect.py"),
            "--weights", str(self.weights_path),
            "--source", str(image_path),
            "--conf", str(self.conf),
            "--save-txt",
            "--project", str(self.yolov9_dir / "runs"),
            "--name", "plate_detect",
            "--exist-ok"
        ]
        subprocess.run(cmd, check=True)

        # Find labels file
        labels_dir = self.yolov9_dir / "runs" / "plate_detect" / "labels"
        label_file = labels_dir / f"{img_name}.txt"
        if not label_file.exists():
            print("No label file found — no detection?")
            return None

        # Load original image
        img = cv2.imread(str(image_path))
        if img is None:
            return None
        h, w, _ = img.shape

        # Read YOLO format: class cx cy width height (normalized)
        with open(label_file, "r") as f:
            line = f.readline().strip()
            if not line:
                return None
            _, cx, cy, bw, bh = map(float, line.split())

        # Convert to pixel coords
        x1 = int((cx - bw / 2) * w)
        y1 = int((cy - bh / 2) * h)
        x2 = int((cx + bw / 2) * w)
        y2 = int((cy + bh / 2) * h)

        # Ensure valid bounds
        x1, y1 = max(0, x1), max(0, y1)
        x2, y2 = min(w, x2), min(h, y2)

        # Crop
        crop_img = img[y1:y2, x1:x2]
        crop_path = self.yolov9_dir / "runs" / "plate_detect" / f"{img_name}_crop.jpg"
        cv2.imwrite(str(crop_path), crop_img)

        return str(crop_path)
