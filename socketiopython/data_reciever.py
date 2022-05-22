import csv
import eventlet
import socketio
import config

username = input("Please enter your name: ")
print("Hello " + username + " !")
csvFileName =  username + config.FILENAME_SUFFIX
path = config.PATH + csvFileName

# time = 0
# accX = 0
# accY = 0

fieldnames = ["time", "accx", "accy", "accz", "pitch", "roll", "yaw"]

with open(csvFileName, 'w') as csv_file:
    csv_writer = csv.DictWriter(csv_file, fieldnames= fieldnames)
    csv_writer.writeheader()

sio = socketio.Server()
app = socketio.WSGIApp(sio, static_files={
    '/': {'content_type': 'text/html', 'filename': 'index.html'}
})

@sio.event
def connect(sid, environ):
    print('connect ', sid)
    pass

@sio.event
def disconnect(sid):
    print('disconnect ', sid)
    pass


@sio.event
def pythonPort(sid, data):
    # print("data: " + str(data["time"]))
    # print("data: " + str("time"))
    with open(csvFileName, 'a') as csv_file:
        csv_writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
        info = {
            "time" : data["time"],
            "accx" : data["accX"],
            "accy" : data["accY"],
            "accz" : data["accZ"],
            "pitch" : data["pitch"],
            "roll" : data["roll"],
            "yaw" : data["yaw"]
            # "heartRate" : data["heartRate"]
            
        }
        csv_writer.writerow(info)
        

        # time = data["time"]
        # accX = data["accX"] 
        # accY = data["accY"]

eventlet.wsgi.server(eventlet.listen((config.PUBLIC_IP, config.PORT)), app)