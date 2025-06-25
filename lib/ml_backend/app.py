from flask import Flask, request, jsonify
from ultralytics import YOLO
from PIL import Image
import io
import torch

app = Flask(__name__)

# Load the model
model = YOLO(r"E:\farmelonn\lib\ml_backend\models\best.pt") # Path to your YOLOv8 model

# Define class names if you have them
class_names = ['Anthracnose', 'Downy Mildew', 'Mosaic Virus', 'Powdery Mildew', 'Gummy Stem Blight', 'Whiteflies', 'Aphids', 'Leaf Miners', 'Cutworms', 'Red Melon Beetle']

@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'No image uploaded'}), 400

    file = request.files['image']
    img = Image.open(file.stream).convert("RGB")

    # Run inference
    results = model(img)
    names = results[0].names
    detections = results[0].boxes

    if detections is None or len(detections) == 0:
        return jsonify({'prediction': 'No disease detected'})

    prediction = []
    for box in detections:
        class_id = int(box.cls[0])
        name = names[class_id]
        conf = float(box.conf[0])
        prediction.append({'class': name, 'confidence': round(conf, 2)})

    return jsonify({'prediction': prediction})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
