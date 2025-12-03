from flask import Flask, request, jsonify, render_template
import csv
import os

app = Flask(__name__)

CSV_FILE = "data.csv"

@app.route('/')
def index():
    data = []
    if os.path.exists(CSV_FILE):
        with open(CSV_FILE, newline='') as f:
            reader = csv.DictReader(f)
            data = list(reader)
    return render_template('index.html', data=data)

@app.route('/upload', methods=['POST'])
def upload():
    content = request.json
    print("Received:", content)

    file_exists = os.path.isfile(CSV_FILE)

    with open(CSV_FILE, 'a', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=['temperature', 'latitude', 'longitude'])
        if not file_exists:
            writer.writeheader()
        writer.writerow(content)

    return jsonify({'status': 'ok', 'received': content})

if __name__ == '__main__':
    app.run(debug=True)