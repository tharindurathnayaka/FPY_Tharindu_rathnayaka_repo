// cpu tb

`include "cpu.v"
`include "../Data_memory/data_memory.v"
`include "../instruction_memory/instruction_memory.v"


    `timescale 1ns/100ps

module cpu_tb;
    parameter CLOCK_PERIOD = 10;
    integer  k;

    
    reg CLK,RESET ,CLK_INC,CLK_50;

    reg[4:0]INC;

    wire [31:0] INSTRUCTION;
    wire [3:0]DATA_MEM_READ;
    wire [2:0]DATA_MEM_WRITE;

    wire DATA_MEM_BUSYWAIT,INSTR_MEM_BUSYWAIT;

    wire [31:0]PC, DATA_MEM_ADDR, DATA_MEM_WRITE_DATA, DATA_MEM_READ_DATA;
    wire [39:0] R_OUT,FR_OUT,M_OUT,PC_OUT,CLK_OUT,INS_OUT;



    // Instantiate the CPU
    cpu dut (
    CLK, RESET, PC, INSTRUCTION, DATA_MEM_READ, DATA_MEM_WRITE,
    DATA_MEM_ADDR, DATA_MEM_WRITE_DATA, DATA_MEM_READ_DATA,
    DATA_MEM_BUSYWAIT, INSTR_MEM_BUSYWAIT,CLK_INC,INC,R_OUT,FR_OUT
);


    data_memory data_memory1 (CLK,CLK_50,RESET,DATA_MEM_READ,DATA_MEM_WRITE,DATA_MEM_ADDR, DATA_MEM_WRITE_DATA, DATA_MEM_READ_DATA,
    DATA_MEM_BUSYWAIT,CLK_INC,INC,M_OUT);

    instruction_memory instruction_memory1(CLK,RESET,PC,INSTRUCTION,INSTR_MEM_BUSYWAIT,PC_OUT,CLK_OUT,INS_OUT);







   
    
    // Dump wavedata to vcd file
    initial 
    begin
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, dut);
        $dumpvars(0, data_memory1);
        $dumpvars(0, instruction_memory1);
        
        for (k = 0; k < 32; k = k + 1)
            $dumpvars(1, dut.ID_REG_FILE.REGISTERS[k]);
    end

    // Clock pulse
    initial CLK = 1'b1;
    always #(CLOCK_PERIOD / 2) CLK = ~CLK;

    initial
    begin
        RESET =1;
        #12
        RESET =0;

        



        

        
        #1000
/*
        $display("Register 1 ",dut.ID_REG_FILE.REGISTERS[1]);
        $display("Register 2 ",dut.ID_REG_FILE.REGISTERS[2]);
        $display("Register 3 ",dut.ID_REG_FILE.REGISTERS[3]);
        $display("Register 4 ",dut.ID_REG_FILE.REGISTERS[4]);
        $display("Register 5 ",dut.ID_REG_FILE.REGISTERS[5]);
        $display("Register 6 ",dut.ID_REG_FILE.REGISTERS[6]);
        $display("Register 7 ",dut.ID_REG_FILE.REGISTERS[7]);
        $display("Register 8 ",dut.ID_REG_FILE.REGISTERS[8]);
        $display("Register 9 ",dut.ID_REG_FILE.REGISTERS[9]);
       /$display("Register 10 ",dut.ID_REG_FILE.REGISTERS[10]);
*/
 


        $display("Register 1 ",dut.ID_REG_FILE.REGISTERS[1]);
        $display("Register 2 ",dut.ID_REG_FILE.REGISTERS[2]);
        $display("Register 3 ",dut.ID_REG_FILE.REGISTERS[3]);
        $display("Register 4 ",dut.ID_REG_FILE.REGISTERS[4]);
        $display("Register 5 ",dut.ID_REG_FILE.REGISTERS[5]);
        $display("Register 6 ",dut.ID_REG_FILE.REGISTERS[6]);
        $display("Register 7 ",dut.ID_REG_FILE.REGISTERS[7]);
        $display("Register 8 ",dut.ID_REG_FILE.REGISTERS[8]);
        $display("Register 9 ",dut.ID_REG_FILE.REGISTERS[9]);
        $display("Register 10 ",dut.ID_REG_FILE.REGISTERS[10]);


        

        $display("Mem 0 ",data_memory1.memory_array[0]);
        $display("Mem 1 ",data_memory1.memory_array[4]);
        $display("Mem 2 ",data_memory1.memory_array[8]);
        $display("Mem 3 ",data_memory1.memory_array[12]);
        $display("Mem 4 ",data_memory1.memory_array[16]);
        $display("Mem 5 ",data_memory1.memory_array[20]);


        $finish;
    end




endmodule