# File Description:
#	Run the command 'candump can0 -L' and then read info from the CAN bus. This runs the command candump for the
# 	can interface 'can-0' (interface is set up in start_ui.sh). The data is then uploaded to various shared memory's
#	which can be shared to various files such as DashboardController.py.
#
# 	Currently the file is in a 'Test Mode' so it will record Iterations /1,000 (s) of data from the canbus. It creates
#	two files 'CAN_INFO_SORTED.txt' and 'CAN_INFO_RAW.txt'. 
#
#	Info on structure of CAN messages ie. can_id (CAN_PACKET_STATUS), controller id's (Master == 0x01, Slave == 0x02)
# 	and and the data for all of these packets (raw_data) can be found at
#	https://dongilc.gitbook.io/openrobot-inc/tutorials/control-with-can#4.-can-bus-load-test


import subprocess
from multiprocessing.shared_memory import SharedMemory

# CAMs note: This is running candump and looking at can version -can0. "can0" is not refering to master or slave ESC ID 
process = subprocess.Popen(['candump', 'can0', '-L'], stdout=subprocess.PIPE, universal_newlines=True)

# Shared memories: Data to share with DashboardController.py
# FIXME close() the shared Memories!
rpm_shm = SharedMemory(name="rpm", create=True, size=32)
current_shm = SharedMemory(name="current", create=True, size=16)
watt_hrs_shm = SharedMemory(name="watt_hr", create=True, size=32)
watt_hrs_charged_shm = SharedMemory(name="watt_hrs_charged", create=True, size=32)
v_in_shm = SharedMemory(name="v_in", create=True, size=16)

rpm_buffer = rpm_shm.buf
temp_rpm = 0
rpm_buffer[:] = temp_rpm.to_bytes(32, byteorder='big')
current_buffer = current_shm.buf
temp_current = 0
current_buffer[:] = temp_current.to_bytes(16, byteorder='big')
watt_hrs_buffer = watt_hrs_shm.buf
temp_watt_hrs = 0
watt_hrs_buffer[:] = temp_watt_hrs.to_bytes(32, byteorder='big')
watt_hrs_charged_buffer = watt_hrs_charged_shm.buf
temp_watt_hrs_charged = 0
watt_hrs_charged_buffer[:] = temp_watt_hrs_charged.to_bytes(32, byteorder='big')
v_in_buffer = v_in_shm.buf
temp_v_in = 0
v_in_buffer[:] = temp_v_in.to_bytes(32, 'big')

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

	# can_id 0x901 (2305) is the Master CAN_STATUS_PACKET that has RPM, current, and duty cycle
	if can_id == 2305:
		rpm = raw_data >> 32
		curr_all_units = (raw_data >> 16) & 0xFFFF
		latest_duty_cycle = raw_data & 0xFFFF
		#print("RPM: " + str(rpm))
		#print("Total current in all units * 10: " + str(curr_all_units))
		#print("Latest duty cycle * 1,000: " + str(latest_duty_cycle))
		rpm_buffer[:] = rpm.to_bytes(32, byteorder='big')
		current_buffer[:] = curr_all_units.to_bytes(16, byteorder='big')
		
	# can_id 0xF01 (3841) is the Master CAN_STATUS_PACKET_3 that has watt_hrs and watt_hrs_charged
	elif can_id == 3841:
		watt_hrs = raw_data >> 32
		watt_hrs_charged = raw_data & 0xFFFFFFFF
		#print("Watt hrs * 10,000: " + str(watt_hrs))
		#print("Watt hrs charged * 10,000: " + str(watt_hrs_charged))
		watt_hrs_buffer[:] = watt_hrs.to_bytes(32, "big")
		watt_hrs_charged_buffer[:] = watt_hrs_charged.to_bytes(32, "big")

	# can_id 0x1B01 (6913) is the Master CAN_STATUS_PACKET_5 that has tacho_value, v_in, and two reserved bytes
	elif can_id == 6913:
		v_in = (raw_data >> 16) & 0xFFFF
		#print("V_in * 10: " str(v_in))
		v_in_buffer[:] = v_in.to_bytes(16, byteorder='big')
		
	#print()
	
	# For CAN_SORTED_DATA no dupicate items are added. Each time code is run it check the new incomming data
	# FIXME INCOMPLETE!!!
	if NUM_ITERATIONS > 0:
		print(str(NUM_ITERATIONS))
		NUM_ITERATIONS = NUM_ITERATIONS - 1
		
		# Gather Unsorted Data
		CAN_UNSORTED += timestamp + " " + interface + " " + data + "\n"
		
		# Sort Data
		if len(KNOWN_CAN_IDS) == 0:
			KNOWN_CAN_IDS.append({"id": can_id, "raw_data": [raw_data]})
		else:
			for can_info in KNOWN_CAN_IDS:
				if can_info.get("id") == can_id:
					can_info.get("raw_data").append(raw_data)
					break
			# else statement only executes if the break statement was not reached
			else:
				KNOWN_CAN_IDS.append({"id": can_id, "raw_data": [raw_data]})

			
	# At the end of a test save the results		
	elif NUM_ITERATIONS == 0:
		print("Finished Running Test!")

		CAN_INFO_FILE = open("CAN_INFO_SORTED.txt" ,"w")
		Header = """This file contains sorted data from the can bus generated from 'can_parse.py' and currently records {Iterations} CAN bus Interactions.
		The purpose of this file is to give some insight into the CAN data given from the command: candump. All CanIds and Data shown in this
		file are in Hex.
		
		Found CAN IDs:
		"""
		for CanData in KNOWN_CAN_IDS:
			Header += hex(CanData.get("id"))[2:].upper() + " "
		Header += "\n\nCANID" + "{:<8}".format("RAW DATA")
		for CanData in KNOWN_CAN_IDS:
			Header += "\n\nid: " + hex(CanData.get("id"))[2:].upper() + "\n"
			for RawData in CanData.get("raw_data"):
				Header += "\t\t" + hex(RawData)[2:].upper() +"\n" 
		CAN_INFO_FILE.write(Header)
		CAN_INFO_FILE.close()
		print("Created CAN_INFO_SORTED.txt")
		
		RAW_INFO_FILE = open("CAN_INFO_RAW.txt", "w")
		RAW_INFO_FILE.write(CAN_UNSORTED)
		RAW_INFO_FILE.close()
		print("Created CAN_INFO_RAW.txt")

		# So this doesnt repeat...
		NUM_ITERATIONS = -1

	return_code = process.poll()
	if return_code is not None:
		print("Return code: ", return_code)
		for output in process.stdout.readlines():
			print(output.strip())
		break

	
