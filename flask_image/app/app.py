from redis import Redis
from flask import Flask
import sys
import subprocess
import os

app = Flask(__name__)
redis_host = str(sys.argv[1])
r = Redis(redis_host, socket_connect_timeout=3)


#Check if counter already exists, if not create it
if(not r.exists("counter")):
    r.set("counter", 0) 

@app.route('/')
def index():
    return ('', 204)

@app.route('/healthz')
def healthz():
    return 'ok'

#Incrementing alert counter and returning 204 (No Content)
@app.route('/alert', methods=['GET', 'POST'])
def alerting():
    r.incr("counter")
    return ('', 204) 

@app.route('/counter')
def counter():
    return r.get("counter")

#Get github hash (without downloading the package) printing out the first 7 characters 
@app.route('/version')
def version():
    githash = str(subprocess.run(['/bin/sh', '-c', 'git ls-remote https://github.com/madacsbotond/aimotive.git HEAD'],stdout=subprocess.PIPE)).split()[-1].replace('stdout=b\'', "").split('\\')
    return githash[0][0:7]

if __name__ == "__main__":
    port = int(os.environ.get('PORT', 5000))
    app.run(debug=True, host='0.0.0.0', port=port)