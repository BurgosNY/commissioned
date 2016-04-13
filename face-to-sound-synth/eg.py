import time
import rtmidi

""" basic example. prompts user to select output port; repeatedly sends note to port """

midiout = rtmidi.MidiOut()
available_ports = midiout.get_ports()
proceed_to_send = False

print("number of available ports: " + str(len(available_ports)))

if len(available_ports) > 0:

    print("which port?")
    print("")
    for (i,port) in zip(range(0, len(available_ports)), available_ports):
        print(str(i) + ": " + str(port))

    portnum = int(input())

    midiout.open_port(portnum)
    proceed_to_send = True
    print("opening port " + str(portnum))
else:
    print("open virtual port? (y/n)")
    yn = input()
    if yn == "y":
        midiout.open_virtual_port("My virtual output")
        proceed_to_send = True

note_on = [0x90, 60, 112] # channel 1, middle C, velocity 112
note_off = [0x80, 60, 0]

while proceed_to_send:
    midiout.send_message(note_on)
    time.sleep(0.5)
    midiout.send_message(note_off)



del midiout
