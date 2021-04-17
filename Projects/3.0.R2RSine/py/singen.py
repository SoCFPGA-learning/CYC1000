import math # import the python math library to get the sin() function and the pi constant

filename = "sin.hex"	# name of output file
mem_len = 256 			# declare how large we want our memory to be
f = open(filename, "w") # open or create our memory initialization file for writing

for i in range(mem_len):
	radians = math.pi * 2.0 * i / mem_len	 # convert index in range [0, 256) to radians in range [0, 2pi)
	fvalue = (math.sin(radians) + 1.0) / 2.0 # get sin of radians in range [-1.0, 1.0] and convert to range of value [0.0, 1.0]
	ivalue = int(255 * fvalue)				 # convert range of value to [0.0, 255.0] and convert value to int to get range [0x0, 0xFF]
	s = hex(int(ivalue))[2:]					 # convert value to a hexadecimal string and strip off leading "0x"
	f.write(s + "\n")		 				 # write the string to our file

print("wrote", mem_len, "element sine wave to", filename)
	
f.close() # close the file