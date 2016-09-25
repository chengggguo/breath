import RPi.GPIO as GPIO
import time             # GPIO valve control

GPIO.setmode(GPIO.BOARD)
GPIO.setup(32, GPIO.OUT)

def RC_analog(Pin):
	counter = 0 
	GPIO.setup(Pin, GPIO.OUT)
	GPIO.output(Pin, GPIO.LOW)
	time.sleep(0.1)
	GPIO.setup(Pin,GPIO.IN)
#	counter = counter+1
	while(GPIO.input(Pin) == GPIO.LOW):
		counter = counter+1
	return counter

#Main program loop

while True:

	print RC_analog(37)




#while True:
#	GPIO.output(32, GPIO.HIGH)
#	time.sleep(1)
#	GPIO.output(32, GPIO.LOW)
#	time.sleep(1)


