## Example Testbench

This directory provides a very simple testbench to simulate the CV32E40X core. 
## What's changed?
* All the source codes and scripts are from [core-v-verif/cv32e40x](https://github.com/openhwgroup/core-v-verif/tree/master/cv32e40x) and [openhwgroup/cv32e4px](https://github.com/openhwgroup/cv32e40x). The rtl sorce code version is [core-v-verif/cv32e40x](https://github.com/openhwgroup/cv32e40x/tree/1d56e0e1eae6925c62fbbf2fea8a3fe155ac802a).
* The BSP file is a copy from [core-v-verif/cv32e40p/bsp](https://github.com/openhwgroup/core-v-verif/tree/master/cv32e40p/bsp), but it works while [core-v-verif/cv32e40x/bsp](https://github.com/openhwgroup/core-v-verif/tree/master/cv32e40x/bsp) not.
* Bug fixes at [tb/cv32e40x_tb_wrapper.sv](https://github.com/leemango1998/cv32e40x-sim/blob/59987251d43d368f805ec3e2c2b55cc5f7f57ba8/tb/cv32e40x_tb_wrapper.sv#L120)
## To run a hello-world program
Call `make custom-vsim-run` to build the hello-world.elf and hello-world.hex and run it in vsim shell mode, or `make custom-vsim-run-gui` in vsim GUI mode.
## More test cases
More test cases can be founded in https://github.com/openhwgroup/core-v-verif/tree/master/cv32e40x/tests. You could add a test program here and build your own make target in Makefile.
