It's important to understand how heiracrchy and placement of files accordingly help with the simulation and 
implementation of these labs. Below is how these files would look in the Sources tab of Vivado's Workspace.

File Architecture:

Design sources:
	lab1.vhd

Simulation Sources:
	first lab1_TB.vhd
		then UUT:lab1 (lab1.vhd)
