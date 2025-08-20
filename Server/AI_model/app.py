import os
from flask import Flask, request, jsonify
from plate_pipeline import PlatePipeline

app = Flask(__name__)

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

yolov9_dir = os.path.join(BASE_DIR, "yolov9_minimal")
weights_path = os.path.join(BASE_DIR, "Plate_detect_model.pt")

pipeline = PlatePipeline(yolov9_dir, weights_path, conf=0.4)

@app.route("/predict", methods=["POST"])
def predict():
    if "file" not in request.files:
        return jsonify({"error": "No file provided"}), 400

    file = request.files["file"]

    upload_dir = os.path.join(BASE_DIR, "uploads")
    os.makedirs(upload_dir, exist_ok=True)

    temp_path = os.path.join(upload_dir, file.filename)
    file.save(temp_path)

    plate_text = pipeline.process_image(temp_path)

    os.remove(temp_path)

    return jsonify({
        "licensePlate": plate_text if plate_text else ""
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
