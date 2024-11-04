from flask import Flask, jsonify, send_from_directory
import time

app = Flask(__name__)

# Serve the index.html file as the root
@app.route('/')
def serve_index():
    return send_from_directory('.', 'index.html')

# Serve the clock endpoint with Unix timestamp
@app.route('/clock')
def clock():
    return jsonify(int(time.time()))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)