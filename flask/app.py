from flask import Flask, request, jsonify
import csv
import os
from datetime import datetime

app = Flask(__name__)
CSV_FILE = 'sensor_data.csv'

# 初回起動時にCSVファイルがなければ作成
if not os.path.exists(CSV_FILE):
    with open(CSV_FILE, mode='w', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(['timestamp', 'temperature', 'latitude', 'longitude'])

@app.route('/')
def index():
    return 'Flask Test'

@app.route('/upload', methods=['POST'])
def upload():
    data = request.get_json()
    if not data:
        return jsonify({'status': 'error', 'message': 'No data received'}), 400

    temperature = data.get('temperature')
    latitude = data.get('latitude')
    longitude = data.get('longitude')
    timestamp = datetime.now().isoformat()

    with open(CSV_FILE, mode='a', newline='') as f:
        writer = csv.writer(f)
        writer.writerow([timestamp, temperature, latitude, longitude])

    return jsonify({'status': 'ok', 'received': data})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
