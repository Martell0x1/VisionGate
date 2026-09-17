import os

from flask import Flask, request, jsonify

from plate_pipeline import PlatePipeline


app = Flask(__name__)

BASE_DIR = os.path.dirname(
    os.path.abspath(__file__)
)

detector_model = os.path.join(
    BASE_DIR,
    "best_cpu_fp32_unified.onnx"
)

ocr_model = os.path.join(
    BASE_DIR,
    "en_PP-OCRv5_rec_mobile.onnx"
)


pipeline = PlatePipeline(
    detector_model=detector_model,
    ocr_model=ocr_model,
    conf=0.4
)


@app.route("/predict", methods=["POST"])
def predict():

    if "file" not in request.files:
        return jsonify({
            "error": "No file provided"
        }), 400

    file = request.files["file"]

    upload_dir = os.path.join(
        BASE_DIR,
        "uploads"
    )

    os.makedirs(
        upload_dir,
        exist_ok=True
    )

    temp_path = os.path.join(
        upload_dir,
        file.filename
    )

    try:

        file.save(temp_path)

        plate_text = pipeline.process_image(
            temp_path
        )

        return jsonify({
            "licensePlate": plate_text or ""
        })

    finally:

        if os.path.exists(temp_path):
            os.remove(temp_path)


if __name__ == "__main__":

    app.run(
        host="0.0.0.0",
        port=5000
    )