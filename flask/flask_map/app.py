from flask import Flask, render_template, request, jsonify
from flask_cors import CORS
import csv

app = Flask(__name__)
CORS(app)

@app.route('/')
def index():
    return render_template('map.html')

@app.route('/gps-data')
def gps_data():
    data = []
    with open('location_log.csv', newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            data.append({
                'lat': float(row['latitude']),
                'lng': float(row['longitude'])
            })
    return jsonify(data)

@app.route('/upload', methods=['POST'])
def upload():
    data = request.json
    # 例: data = {"latitude": 34.7, "longitude": 135.5, "temperature": 26.7}

    # CSVファイルに追記
    with open('location_log.csv', 'a', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow([data.get('latitude'), data.get('longitude')])

    return jsonify({"status": "success", "received": data})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
