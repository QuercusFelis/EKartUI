import subprocess
from multiprocessing.shared_memory import SharedMemory

process = subprocess.Popen(['candump', 'can0', '-L'], stdout=subprocess.PIPE, universal_newlines=True)
rpm_shm = SharedMemory(name="rpm", create=True, size=32)
rpm_buffer = rpm_shm.buf
temp_rpm = 0
rpm_buffer[:] = temp_rpm.to_bytes(32, byteorder='big')


while True:
	output = process.stdout.readline()
	#print(output.strip())
	
	timestamp, interface, data = output = output.strip().split(" ",2)
	can_id, raw_data = data.split("#",1)
	
	# print("Timestamp: " + timestamp)
	# print("Interface: " + interface)
	# print("CAN ID: " + can_id)
	# print("Raw Data: " + raw_data)
	
	can_id = int(can_id, 16)
	#print(can_id)
	raw_data = int(raw_data, 16)
	
	if can_id == 2368:
		rpm = raw_data >> 32
		curr_all_units = (raw_data >> 16) & 0xFFFF
		latest_duty_cycle = raw_data & 0xFFFF
		print("RPM: " + str(rpm))
		print("Total current in all units * 10: " + str(curr_all_units))
		print("Latest duty cycle * 1000: " + str(latest_duty_cycle))
		
		rpm_buffer[:] = rpm.to_bytes(32, byteorder='big')
		
		
	elif can_id == 142:
		total_amphrs_consumed = raw_data >> 32
		total_regen_hrs = raw_data & 0xFFFFFFFF
		print("Total amp hours consumed by unit * 10000: " + str(total_amphrs_consumed))
		print("Total regen amp hours back into batt * 10000: " + str(total_regen_hrs))
		
	print()
	
	return_code = process.poll()
	if return_code is not None:
		print("Return code: ", return_code)
		for output in process.stdout.readlines():
			print(output.strip())
		break
