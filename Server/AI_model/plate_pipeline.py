from detector import Detector
from ocr_reader import OCRReader


class PlatePipeline:

    def __init__(
        self,
        detector_model,
        ocr_model,
        conf=0.4
    ):

        self.detector = Detector(
            model_path=detector_model,
            conf=conf
        )

        self.ocr_reader = OCRReader(
            model_path=ocr_model
        )

    def process_image(self, image_path):

        plate_crop = self.detector.detect(
            image_path
        )

        if plate_crop is None:
            return None

        return self.ocr_reader.read_text(
            plate_crop
        )