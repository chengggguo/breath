import socket
import sys
#import RPi.GPIO as GPIO
import time
import math
#import pyautogui


mysock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
address = ('localhost',10002)

capaL = 600  # capacity of lung(number of packets)
numBreath = list()
valid = list()


w = 800 #width of convas
h = 600 #hight of convas
step = w*h/capaL #length for each stroke

red = color(237, 28, 36)
blue = color(46, 49, 146)

for p in range(capaL):
    numBreath.append(str(p))
    valid.append('True')

def Dloop():
  n = 0
  for a in range(capaL):
    data = numBreath[a]
    mysock.sendto(data,address)
#    if mysock.settimeout(10):
#        pass

    recv_data, addr = mysock.recvfrom(1000)

    if recv_data == str(n):
      valid[n] = 'True'
    else:
      valid[n] = 'False'
    n = n + 1

  return



####visualization
def setup():
  size(w,h)
  background(0)
  loadPixels()
  print "setup"

def draw():
    print "drawing"
    for i in range(capaL):
        pos = i*step
        if valid[i] == 'True':
            for o in range(step):
                pixels[o + pos] = red

        else:
            for o in range(step):
                pixels[o + pos] = blue
        

#    pyautogui.keypress('space')
    time.sleep(5)
    Dloop()
    updatePixels()
    print valid

    pos = 0



#socket.close()