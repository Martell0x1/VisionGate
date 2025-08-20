from detector import Detector
from ocr_reader import OCRReader

class PlatePipeline:
    def __init__(self, yolov9_dir, weights_path, conf=0.5):
        self.detector = Detector(yolov9_dir, weights_path, conf)
        self.ocr_reader = OCRReader(['en'])

    def process_image(self, image_path):
        """Detect plate, crop with OpenCV, OCR it, return string."""
        plate_img_path = self.detector.detect(image_path)
        if not plate_img_path:
            return None
        return self.ocr_reader.read_text(plate_img_path)
