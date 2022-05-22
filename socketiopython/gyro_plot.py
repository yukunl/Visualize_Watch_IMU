# import socketio
from itertools import count
import pandas as pd 
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

plt.style.use('fivethirtyeight')

username = input("Please enter your name: ")
print("Hello " + username + " !")
csvFileName = username + "_data.csv"

def animate(i):
    data = pd.read_csv(csvFileName)
    x = data['time']
    y4 = data['pitch']
    y5 = data['roll']
    y6 = data['yaw']


    plt.cla()
    plt.plot(x, y4, label= 'pitch')
    plt.plot(x, y5, label= 'roll')
    plt.plot(x, y6, label= 'yaw')

    plt.legend(loc='upper left')
    plt.tight_layout()



ani = FuncAnimation(plt.gcf(), animate, interval = 200)
plt.tight_layout
plt.show()