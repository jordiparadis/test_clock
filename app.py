from flask import Flask, jsonify  # Import Flask for handling web requests and jsonify for creating JSON responses
from flask_cors import CORS       # Import CORS to enable Cross-Origin Resource Sharing (CORS) for the API
import time                       # Import time for generating the current timestamp

# Initialize the Flask application
app = Flask(__name__)

# Enable CORS for all routes in the app, allowing cross-origin requests
CORS(app)

# Define a route for the endpoint '/clock'
@app.route('/clock')
def clock():
    # Generate the current Unix timestamp
    timestamp = time.time()
    # Return the timestamp as a JSON response
    return jsonify({"timestamp": timestamp})

# Run the app if this script is executed directly
if __name__ == '__main__':
    # Start the Flask application on all network interfaces (0.0.0.0) and port 5000
    app.run(host='0.0.0.0', port=5000)
