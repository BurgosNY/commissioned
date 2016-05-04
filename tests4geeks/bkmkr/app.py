from flask import Flask, jsonify, json, request, Response

# imports for working with mongo from python
from mongokat import Collection, Document
from pymongo import MongoClient


# mongokat's Document and Collection classes let you define helper
# methods for you database collections.  The Document class also lets
# you define hooks and validators

class ArticleLink(Document):
    def to_json_data(self):
        return {'link': self['link'], 'title' : self['title']}


    # TODO: show off 


class ArticleLinks(Collection):
    document_class = ArticleLink

    def search_title(self, qs):
        data = self.find({"$text" : {"$search" : qs}})            
        return {'links' : [d.to_json_data() for d in data]}

    def tagged(self, tags):
        data = self.find({'tags' : {'$in' : tags}});
        return {'links' : [d.to_json_data() for d in data]}

app = Flask(__name__)

client = MongoClient()
LinksClient = ArticleLinks(collection=client.dirt.links)

@app.route('/')
def list_article_links():
    data = LinksClient.find()
    jsondata = {'links' : [d.to_json_data() for d in data]}
    resp = jsonify(jsondata)
    resp.status_code = 200
    return resp

@app.route('/add', methods=['POST'])
def add_link():
    data = request.json 
    LinksClient.insert_one( data )
    return Response( "OK", status=200 )

@app.route('/search')
def search_title():
    link_data = LinksClient.search_title(request.args['q'])
    resp = jsonify(link_data)
    resp.response_code = 200
    return resp 


if __name__ == '__main__':
    app.debug = True
    app.run()

    
