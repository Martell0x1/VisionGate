import easyocr
import cv2

class OCRReader:
    def __init__(self, languages=None):
        self.reader = easyocr.Reader(languages or ['en'])

    def read_text(self, image_path):
        """Read text from image using EasyOCR."""
        img = cv2.imread(image_path)
        if img is None:
            return None

        results = self.reader.readtext(img)
        if not results:
            return None

        return " ".join([res[1] for res in results])
