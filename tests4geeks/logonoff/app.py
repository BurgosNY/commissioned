from flask import Flask, jsonify, json, request, Response, render_template

# from mongokat import Collection, Document
# from pymongo import MongoClient
# from bson.objectid import ObjectId
# from bson.errors import InvalidId


app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')


@app.route('/auth')
def auth():
    return render_template('index.html')

if __name__ == '__main__':
    app.debug = True
    app.run()
