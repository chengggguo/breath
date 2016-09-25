  #import RPi.GPIO as GPIO
import time
import smbus

bus = smbus.SMBus(1)

DEVICE = 0x27
IODIRA = 0x00
GPIOA = 0x12

#bus.write_byte_data(DEVICE,IODIRA,0x80)

while True:

	MySwitch = bus.read_byte_data(DEVICE,GPIOA)
#	print MySwitch
	if MySwitch and 0b10000000 == 0b10000000:
		print "Switch was pressed"
		time.sleep(1)

