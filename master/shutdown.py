import RPi.GPIO as GPIO
import time
import os

GPIO.setmode(GPIO.BCM)
GPIO.setup(18,GPIO.IN,pull_up_down = GPIO.PUD_UP)

def Shutdown(channel):
	os.system("sudo shutdown -h now")

GPIO.add_event_detect(18,GPIO.FALLING, callback = Shutdown, bouncetime = 2000)

while 1:
	time.sleep(1)
