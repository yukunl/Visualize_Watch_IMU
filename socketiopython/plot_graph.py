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
    y1 = data['accx']
    y2 = data['accy']
    y3 = data['accz']



    plt.cla()
    plt.plot(x, y1, label= 'acc x')
    plt.plot(x, y2, label= 'acc y')
    plt.plot(x, y3, label= 'acc z')


    plt.legend(loc='upper left')
    plt.tight_layout()



ani = FuncAnimation(plt.gcf(), animate, interval = 200)
plt.tight_layout
plt.show()