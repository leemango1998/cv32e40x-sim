## Example Testbench

This directory provides a very simple testbench to simulate the CV32E40X core. 
The BSP file is a copy from https://github.com/openhwgroup/core-v-verif/tree/master/cv32e40p/bsp, but it works while https://github.com/openhwgroup/core-v-verif/tree/master/cv32e40x/bsp not. 
## To run a hello-world program
Call `make custom-vsim-run` to build the hello-world.elf and hello-world.hex and run it in vsim shell mode, or `make custom-vsim-run-gui` in vsim GUI mode.
## More test cases
More test cases can be founded in https://github.com/openhwgroup/core-v-verif/tree/master/cv32e40x/tests. You could add a test program here and build your own make target in Makefile.
