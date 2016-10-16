import socket
import sys
#import RPi.GPIO as GPIO
import time
import math
#import pyautogui


mysock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
# mysock.setblocking(0)
mysock.settimeout(1)
address = ('fii.to', 10002)

capaL = 100  # capacity of lung(number of packets)
numBreath = list()
valid = list()


w = 800  # width of convas
h = 600  # hight of convas
step = w * h / capaL  # length for each stroke

red = color(237, 28, 36)
blue = color(46, 49, 146)

for p in range(capaL):
    numBreath.append(str(p))
    valid.append('True')

def Dloop():
    n = 0
    for a in range(capaL):
        data = numBreath[a]
        mysock.sendto(data, address)
        
        try:
            recv_data, addr = mysock.recvfrom(1000)
            print recv_data

            if recv_data == str(n):
                valid[n] = 'True'
            else:
                valid[n] = 'False'
            n = n + 1
        except mysock.timeout:
            print "timeout"

    return


# visualization
def setup():
    size(w, h)
    background(0)
    loadPixels()

def draw():
    for i in range(capaL):
        pos = i * step
        if valid[i] == 'True':
            for o in range(step):
                pixels[o + pos] = red

        else:
            for o in range(step):
                pixels[o + pos] = blue


#    pyautogui.keypress('space')
    Dloop()
    updatePixels()
    print valid
    pos = 0
    time.sleep(5)

# socket.close()

def keypressed(key):
    pass