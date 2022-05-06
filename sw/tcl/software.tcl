# Copyright 2020 ETH Zurich
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# add fc execution trace
set rvcores [find instances -recursive -bydu cv32e40x_core -nodu]
set tracer [find instances -recursive -bydu cv32e40x_tracer -nodu]


if {$rvcores ne ""} {

    add wave -group "Software Debugging" $rvcores/clk_i
    add wave -group "Software Debugging" -divider "Instructions at ID stage, sampled half a cycle later"
    add wave -group "Software Debugging" /tb_top/cv32e40x_tb_wrapper_i/cv32e40x_core_i/instr_addr_o 
    add wave -group "Software Debugging" /tb_top/cv32e40x_tb_wrapper_i/cv32e40x_core_i/instr_rdata_i 

if {$tracer ne ""} {
    add wave -group "Software Debugging" $tracer/insn_disas
    add wave -group "Software Debugging" $tracer/insn_pc
    add wave -group "Software Debugging" $tracer/insn_val
}

	

    # add wave -group "Software Debugging" -divider "Program counter at ID and IF stage"
    # add wave -group "Software Debugging" $rvcores/id_stage_i/ID_EX_PIPE_REGISTERS
    # add wave -group "Software Debugging" $rvcores/if_stage_i/IF_ID_PIPE_REGISTERS
    # add wave -group "Software Debugging" -divider "Register File contents"
    # add wave -group "Software Debugging" $rvcores/cv32e40x_core_i/boot_addr_i 
    # add wave -group "Software Debugging" $rvcores/register_file_wrapper_i/register_file_i/mem
}

configure wave -namecolwidth  250
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -timelineunits ns
