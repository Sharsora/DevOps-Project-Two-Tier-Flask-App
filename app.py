from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return '#DevOpsWithUs\nHello DevOps Enthusiasts, I am Prashant Gohel!'
