from plate_pipeline import PlatePipeline

if __name__ == "__main__":
    yolov9_dir = r"E:/AI model/yolov9_minimal"
    weights_path = r"E:/AI model/Plate_detect_model.pt"
    image_path = r"E:/AI model/test.png"

    pipeline = PlatePipeline(yolov9_dir, weights_path, conf=0.5)
    plate_text = pipeline.process_image(image_path)

    if plate_text:
        print(f"Detected Plate: {plate_text}")
    else:
        print("No plate detected.")
