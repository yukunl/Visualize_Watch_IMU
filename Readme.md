## About this project

This is application is an end to end pipeline that streams apple watch IMU and heart rate data in real time to your computer python server via socketIO. The server then visualize, and store the data. 

## Installation and Requirements

### Client side:
install xcode and make sure you are using Swift 4/5 and Xcode 10.x +. Download ActivityCollector and open with XCode. 

### Server side: 
install socketIO python using 

```bash
$ pip install python-socketio
```

## Using the system

### 1. For the client side: 
download the ActivityCollector folder, which contains the apple watch app code. In `Config.xcconfig`, change the `PUBLIC_IP` and `PORT_NUMBER` to desired IP and ports. Then compile the code and load on your apple watch device. Note: when running this system on your own device for the first time, be sure to change the signature of this project, which can be done in the main project icon -> Signing & Capabilities, and also need to change the `NSExtension` -> `NSExtensionAttributes` -> `WKAppBundleIdentifier` to the watchkit BundleID. 
### 2. For the server side: 
Boot up the server with python `data_reciever.py`. When prompted, put in the username. Once the server is running, we can start the apple watch app button, and data should be streaming on the server. This data will be also saved in file format of `[name]_data.csv`. You can modify the path and file suffix, format within the server config.
### 3. Graphing and saveing the streamed data: 
Run 
```bash
$ python gyro_plot.py
$ python plot_graph.py
```
 to show the graph of the data. When prompted for user name, please put in the same username as the data_reciever. From here, you should be able to visualize your watch IMU data on your computer. 


### further documentations
links below could be useful:

for swift related socketIO issues: For socketIO related issues: further documentation can be viewed here: https://github.com/socketio/socket.io-client-swift

for python related socketIO issues: https://python-socketio.readthedocs.io/en/latest/server.html#installation 
