# Initialize JTAG connection
import intel_jtag
import sys
print("Initializing JTAG connection")
try:
    ju = intel_jtag.intel_jtag_uart()
except Exception as e:
    print(e)
    sys.exit(0)
print("JTAG Connected")
print("Reading Data.... (Press \"Q\" to exit)")

buffer = []  # Initialize a buffer to store received bytes


clear_data = True  # Flag to indicate whether to clear incoming data before encountering 255

while True:
    try:
        read_packet = ju.read()
    except Exception as e:
        print(e)

    if len(read_packet):
        # Append the received bytes to the buffer
        buffer.extend(read_packet)
        print(buffer)

