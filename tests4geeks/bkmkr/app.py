from flask import Flask, jsonify, json, request, Response, render_template


# imports for working with mongo from python
from mongokat import Collection, Document
from pymongo import MongoClient
from bson.objectid import ObjectId
from bson.errors import InvalidId

# mongokat's Document and Collection classes let you define helper
# methods for you database collections.  The Document class also lets
# you define hooks and validators

class LinkDocument(Document):
    def get_link(self):
        return self['link']

    def get_title(self):
        if 'title' in self.keys():
            return self['title']
        else:
            return 'untitled'

    def get_read_status(self):
        if 'readStatus' in self.keys():
            return self['readStatus']
        else:
            return False

    def to_json_view(self):
        return {'_id' : str(self['_id']),
                'link': self.get_link(),
                'title' : self.get_title(),
                'readStatus' : self.get_read_status()}

    def toggle_read_status(self):
        self["readStatus"] = not self.get_read_status()
        self.save()
        return self.to_json_view()


class LinksCollection(Collection):
    document_class = LinkDocument

    def find_all(self):
        return self.find()
    
    def search_title(self, qs):
        return self.find({"$text" : {"$search" : qs}})            

    def just_unread(self):
        return self.find({"$or" : [{"readStatus" : False},
                                   {"readStatus" : {"$exists" : False}}]})
        

app = Flask(__name__)

client = MongoClient()
LinksClient = LinksCollection(collection=client.dirt.links)

@app.route('/')
def index():
    data = LinksClient.find_all()
    return render_template('index.html', links=data)

@app.route('/all')
def list_article_links():
    data = LinksClient.find()
    jsondata = {'links' : [d.to_json_view() for d in data]}
    resp = jsonify(jsondata)
    resp.status_code = 200
    return resp

@app.route('/add', methods=['POST'])
def add_link():
    #    data = request.json
    data = {'link' : request.form['add_url'],
            'title' : request.form['add_title']}
    LinksClient.insert_one( data )
    #    return Response( "OK", status=200 )
    return index()

@app.route('/search')
def search_title():
    link_data = LinksClient.search_title(request.args['q'])
    return render_template('index.html', links=link_data)

@app.route('/toggleread/<linkid>')
def toggle_read(linkid):
    try:
        linkdoc = LinksClient.find_one( ObjectId(linkid) )
        if linkdoc:
            json_resp = linkdoc.toggle_read_status()            
            resp = jsonify(json_resp)
            resp.status_code = 200
            return resp
        else:
            resp = jsonify({'error' : 'no such document: ' + linkid})
            resp.status_code = 404
            return resp
    except InvalidId:
        return "Bad Input"



@app.route('/unread')
def list_unread():
    link_data = LinksClient.just_unread()
    return render_template('index.html', links=link_data)
    
if __name__ == '__main__':
    app.debug = True
    app.run()

    
