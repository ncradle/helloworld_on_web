from flask import Flask
from flask_cors import CORS

app = Flask(__name__)
CORS(app)


@app.route("/")
def hello_world() -> str:
    return "Hello, World!"


if __name__ == "__main__":
    app.run(debug=True, host="localhost", port=5000)
