import subprocess
from multiprocessing.shared_memory import SharedMemory

# CAMs note: This is running candump and looking at can version -can0. "can0" is not refering to master or slave ESC ID 
process = subprocess.Popen(['candump', 'can0', '-L'], stdout=subprocess.PIPE, universal_newlines=True)
rpm_shm = SharedMemory(name="rpm", create=True, size=32)
rpm_buffer = rpm_shm.buf
temp_rpm = 0
rpm_buffer[:] = temp_rpm.to_bytes(32, byteorder='big')

Iterations = 10000
NUM_ITERATIONS = Iterations
KNOWN_CAN_IDS = []
CAN_UNSORTED = ""

print("Entering Loop: ")

while True:
	# while statement is blocked until there is a new line to read
	output = process.stdout.readline()
	#print(output.strip())
	
	timestamp, interface, data = output = output.strip().split(" ",2)
	can_id, raw_data = data.split("#",1)
	
	# print("Timestamp: " + timestamp)
	# print("Interface: " + interface)
	# print("CAN ID: " + can_id)
	# print("Raw Data: " + raw_data)
	print("Output: " + timestamp + " " + interface + " " + data + "\n")

	can_id = int(can_id, 16)
	#print(can_id)
	raw_data = int(raw_data, 16)

	# can_id 2368 might not be RPM with current ESCs. Currently under investigations
	if can_id == 2368:
		rpm = raw_data >> 32
		curr_all_units = (raw_data >> 16) & 0xFFFF
		latest_duty_cycle = raw_data & 0xFFFF
		print("RPM: " + str(rpm))
		print("Total current in all units * 10: " + str(curr_all_units))
		print("Latest duty cycle * 1000: " + str(latest_duty_cycle))
		
		rpm_buffer[:] = rpm.to_bytes(32, byteorder='big')
		
	# can_id 142 might not be total amphrs on current ESCs. Currently under Investigation	
	elif can_id == 142:
		total_amphrs_consumed = raw_data >> 32
		total_regen_hrs = raw_data & 0xFFFFFFFF
		print("Total amp hours consumed by unit * 10000: " + str(total_amphrs_consumed))
		print("Total regen amp hours back into batt * 10000: " + str(total_regen_hrs))
		
	#print()
	
	# For CAN_SORTED_DATA no dupicate items are added. Each time code is run it check the new incomming data
	# FIXME INCOMPLETE!!!
	if NUM_ITERATIONS > 0:
		print(str(NUM_ITERATIONS))
		NUM_ITERATIONS = NUM_ITERATIONS - 1
		
		# Gather Unsorted Data
		CAN_UNSORTED += timestamp + " " + interface + " " + data + "\n"
		
		# Sort Data
		"""if len(KNOWN_CAN_IDS) == 0:
			KNOWN_CAN_IDS.append({"id": can_id, "raw_data": [raw_data]})
		else:
			recorded_id = False
			for can_info in KNOWN_CAN_IDS:
				if recorded_id == False:
					id = can_info.get("id")
					if id == can_id:
						# So we can find pattern in the raw data and make something usefull with it
						can_info.get("raw_data").append(raw_data)
						recorded_id = True
						break
			if recorded_id == False:
				KNOWN_CAN_IDS.append({"id": can_id, "raw_data": [raw_data]})
			"""
			
	elif NUM_ITERATIONS == 0:
		#CAN_INFO_FILE = open("CAN_INFO_SORTED.txt" ,"w")
		#Header = """This file contains sorted data from the can bus generated from 'can_parse.py' and currently records {Iterations} CAN bus Interactions.
		#The purpose of this file is to give some insight into the CAN data given from the command: candump.
		#
		#"""
		print("Finish Test!!!")
		#CAN_INFO_FILE.close()
		RAW_INFO_FILE = open("CAN_INFO_RAW.txt", "w")
		RAW_INFO_FILE.write(CAN_UNSORTED)
		RAW_INFO_FILE.close()
		# So this doesnt repeat...
		NUM_ITERATIONS = -1

	return_code = process.poll()
	if return_code is not None:
		print("Return code: ", return_code)
		for output in process.stdout.readlines():
			print(output.strip())
		break

	
