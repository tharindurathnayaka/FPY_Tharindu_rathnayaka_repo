import tkinter as tk
import time
import threading
import intel_jtag
import sys
import os
from tkinter import PhotoImage

#Global variables
buffer = []  # Initialize a buffer to store received bytes
R1=R2=R3=R4=R5=4
M1=M2=M3=M4=M5=2
R6=R7=R8=R9=R10=9
INS=CLK_R=CLK_ROLD=0
PC=0
PC_OLD=-3
inc=0
status=0
JTAG ="Not Connected"
DATA_L="Not Connected"
d_status=1;
INS_P =["NOP","NOP","NOP","NOP","NOP"]
INC1=DM=JTW=JTP=0





#Functions-------------------------------------------------------

def close_window():

    root.destroy()

def restart_program():
    python = sys.executable
    os.execl(python, python, *sys.argv)
def jtag_read():


    global buffer, R1,R2,R3,R4,R5,M1,M2,M3,M4,M5,R6,R7,R8,R9,R10,PC,inc,status,INS,CLK_R,JTAG,DATA_L,data_logger,INS_P,CLK_ROLD,DM,JTW,JTP

    try:
        read_packet = ju.read()
    except Exception as e:
        print(e)
        jtag_d_label.config(text=f"{e}")
        sys.exit()

    if len(read_packet):

        # Append the received bytes to the buffer
        buffer.extend(read_packet)

        while len(buffer) >= 5:
            if(DM==0):
                DM=1;
            else:
                DM=0;
            # Extract and print the first 5 bytes from the buffer
            data_to_print = buffer[:5]

            inc=inc+1
            if(inc > 6):
                if(status==1):
                    process(data_to_print)
                    buffer = buffer[5:]
                    cpud_d_label.config(text=f"Running")

                else:
                    if(data_to_print[0]==255):
                        process(data_to_print)
                        buffer = buffer[5:]
                        cpud_d_label.config(text=f"Running")
                        status=1
                    else:
                        buffer = buffer[1:]
                        cpud_d_label.config(text=f"Processeing")


            else:
                print("Processor data initilizing")
                cpud_d_label.config(text=f"Connecting")
    return 0

def process(data):
    global R1,R2,R3,R4,R5,M1,M2,M3,M4,M5,R6,R7,R8,R9,R10,PC,INS,CLK_R,JTAG,DATA_L,INS_P,CLK_ROLD,DM,JTW,JTP,PC_OLD


    lower_4_bytes = data[1:5][::-1]
    #lower_4_bytes = data[1:]
    print(data)
    upper1 = data[0]
    # Convert the lower 3 bytes to a 24-bit binary representation
    binary_str = ''.join(
        [format(byte, '08b') for byte in lower_4_bytes])  # Convert bytes to binary strings
    binary_str2 = upper1  # ''.join([format(byte, '08b') for byte in upper1])

    # Convert the binary representation to a decimal value
    decimal_value = int(binary_str, 2)

    if (binary_str2 == 2):
        R1 = decimal_value

    elif (binary_str2 == 3):
        R2 = decimal_value

    elif (binary_str2 == 4):
        R3 = decimal_value

    elif (binary_str2 == 5):
        R4 = decimal_value

    elif (binary_str2 == 6):
        R5 = decimal_value

    elif (binary_str2 == 7):
        R6 = decimal_value

    elif (binary_str2 == 8):
        R7 = decimal_value

    elif (binary_str2 == 9):
        R8 = decimal_value

    elif (binary_str2 == 10):
        R9 = decimal_value

    elif (binary_str2 == 11):
        R10 = decimal_value

    elif (binary_str2 == 12):
        M1 = decimal_value

    elif (binary_str2 == 13):
        M2 = decimal_value

    elif (binary_str2 == 14):
        M3 = decimal_value

    elif (binary_str2 == 15):
        M4 = decimal_value

    elif (binary_str2 == 16):
        M5 = decimal_value

    elif (binary_str2 == 17):
        PC = decimal_value

    elif (binary_str2 == 18):

        if (decimal_value == 19):
            INS = "LOADI"

        elif (decimal_value == 51):
              INS = "ADD"
        elif (decimal_value == 32819):
              INS = "SUB"

        elif (decimal_value == 291):
            INS = "SW"

        elif (decimal_value == 259):
            INS = "LW"

        else:
                INS = "NOP"
                arrow2.config(bg="dodgerblue3")
                arrow3.config(bg="dodgerblue3")
                regenabled.config(bg="blue")

        if(PC > PC_OLD):
            if (len(INS_P) >= 5):
                INS_P = INS_P[1:]
                INS_P.append(INS)

            else:
                INS_P.append(INS)

        CLK_ROLD=CLK_R
        PC_OLD =PC



    elif (binary_str2 == 32):
        CLK_R = decimal_value

    else:
        ER = 1
    #print(buffer)

    #print(binary_str2)

    #print(" ".join(
       # [f"{byte:02X}" for byte in data]))  # Print original bytes in hexadecimal format
    #print(f"Converted to 24-bit binary: {binary_str}")
    #print(f"Decimal Value: {decimal_value}")
    #print(f"BINARY: {binary_str}")


def update_labels():
    global R1, R2, R3, R4, R5, M1, M2, M3, M4, M5, R6, R7, R8, R9, R10, PC, INS, CLK_R,JTAG,DATA_L,d_status,INS_P,CLK_ROLD,INC1,DM,JTW,JTP
    while True:
        if(d_status==1):
            jtag_read()
            d_status =1

        r1_label.config(text=f"R1 :  {R1}")
        r2_label.config(text=f"R2 :  {R2}")
        r3_label.config(text=f"R3 :  {R3}")
        r4_label.config(text=f"R4 :  {R4}")
        r5_label.config(text=f"R5 :  {R5}")
        r6_label.config(text=f"R6 :  {R6}")
        r7_label.config(text=f"R7 :  {R7}")
        r8_label.config(text=f"R8 :  {R8}")
        r9_label.config(text=f"R9 :  {R9}")
        r10_label.config(text=f"R10 :{R10}")
        m1_label.config(text=f"M1 :  {M1}")
        m2_label.config(text=f"M2 :  {M2}")
        m3_label.config(text=f"M3 :  {M3}")
        m4_label.config(text=f"M4 :  {M4}")
        m5_label.config(text=f"M5 :  {M5}")
        pc_label.config(text=f"PC :  {PC}")
        ins_label.config(text=f"INS :  {INS}")
        clk_label.config(text=f"Clock  :  {CLK_R}")


        #CLOCK
        if(CLK_R==0):
            clock.config(bg="blue")
        else:
            clock.config(bg="red")

        #PIPELINE
        if(PC !=0):
            ifd_label.config(text=f"  {INS_P[4]}")
            idd_label.config(text=f"  {INS_P[3]}")
            exd_label.config(text=f"  {INS_P[2]}")
            memd_label.config(text=f"  {INS_P[1]}")
            wbd_label.config(text=f"  {INS_P[0]}")
        else:
            ifd_label.config(text=f"  LOADI")
            idd_label.config(text=f"  NOP")
            exd_label.config(text=f"  NOP")
            memd_label.config(text=f" NOP")
            wbd_label.config(text=f"  NOP")

       #Pipelin boder animation
        INC1=INC1+1
        if(INC1==50):
            pipeline_outer.config(bg="darkgoldenrod1")

        elif(INC1==100):
            pipeline_outer.config(bg="chartreuse1")
            INC1=0
        #DM
        if(DM==1):
            signal1.config(bg="red")
        else:
            signal1.config(bg="blue")

        #REGITER ARROW
        if (INS_P[0] == "LOADI" or INS_P[0] == "ADD" or INS_P[0] == "SUB" or INS_P[0]=="LW"):
            arrow2.config(bg="green")
            arrow3.config(bg="green")
            regenabled.config(bg="red")



        else:
            arrow2.config(bg="dodgerblue3")
            arrow3.config(bg="dodgerblue3")
            regenabled.config(bg="blue")
       #MEM ARRAOW
        if (INS_P[1] == "LW" ):
            arrow4.config(bg="green")
            arrow5.config(bg="green")
            datarsignal.config(bg="red")
            datawsignal.config(bg="blue")


        elif(INS_P[1] == "SW" ):
            arrow4.config(bg="green")
            arrow5.config(bg="green")
            datarsignal.config(bg="blue")
            datawsignal.config(bg="red")


        else:

            arrow4.config(bg="dodgerblue3")
            arrow5.config(bg="dodgerblue3")
            datarsignal.config(bg="blue")
            datawsignal.config(bg="blue")

        root.update()  # Update the GUI


#Main looop----------------------------------------------------------

# Create the main window
root = tk.Tk()
root.title("USB Data GUI")
#root.overrideredirect(True)
root.geometry("900x650+250+70")
root.configure(bg="lightgray")



title_bar = tk.Frame(root, bg="gray30", height=100)  # Change "lightblue" to your desired color
title_bar.pack(fill="x")

register_file = tk.Frame(root, bg="lavenderblush4", height=200 , width=180)  # Change "lightblue" to your desired color
register_file.place(x=700, y=180)

data_file = tk.Frame(root, bg="lavenderblush4", height=200 , width=180)  # Change "lightblue" to your desired color
data_file.place(x=700, y=385)



arrow1 = tk.Frame(root, bg="dodgerblue3", height=10 , width=70)  # Change "lightblue" to your desired color
arrow1.place(x=150, y=370)


arrow2 = tk.Frame(root, bg="dodgerblue3", height=10 , width=110)  # Change "lightblue" to your desired color
arrow2.place(x=590, y=280)

arrow3 = tk.Frame(root, bg="dodgerblue3", height=50 , width=10)  # Change "lightblue" to your desired color
arrow3.place(x=580, y=280)

arrow4 = tk.Frame(root, bg="dodgerblue3", height=50 , width=10)  # Change "lightblue" to your desired color
arrow4.place(x=500, y=430)

arrow5 = tk.Frame(root, bg="dodgerblue3", height=10 , width=200)  # Change "lightblue" to your desired color
arrow5.place(x=500, y=480)

pipeline_outer = tk.Frame(root, bg="limegreen", height=120 , width=430)  # Change "lightblue" to your desired color
pipeline_outer.place(x=210, y=320)


pipeline = tk.Frame(root, bg="lavenderblush4", height=100 , width=410)  # Change "lightblue" to your desired color
pipeline.place(x=220, y=330)

#pipeline stages

if_stage = tk.Frame(pipeline, bg="steelblue4", height=80 , width=70)  # Change "lightblue" to your desired color
if_stage.place(x=10, y=10)

id_stage = tk.Frame(pipeline, bg="steelblue4", height=80 , width=70)  # Change "lightblue" to your desired color
id_stage.place(x=90, y=10)

ex_stage = tk.Frame(pipeline, bg="steelblue4", height=80 , width=70)  # Change "lightblue" to your desired color
ex_stage.place(x=170, y=10)

mem_stage = tk.Frame(pipeline, bg="steelblue4", height=80 , width=70)  # Change "lightblue" to your desired color
mem_stage.place(x=250, y=10)

wb_stage = tk.Frame(pipeline, bg="steelblue4", height=80 , width=70)  # Change "lightblue" to your desired color
wb_stage.place(x=330, y=10)


pc_unit = tk.Frame(root, bg="lavenderblush4", height=180 , width=120)  # Change "lightblue" to your desired color
pc_unit.place(x=30, y=300)

title_label = tk.Label(root, text="CPU Insights", bg="gray30", fg="white", font=("Helvetica", 30, "bold"))
title_label.place(x=35, y=35)

version_label = tk.Label(root, text="Demo version -ME420-Progress evaluation 2023 ", bg="gray30", fg="white", font=("Helvetica", 12))
version_label.place(x=530, y=50)

name = tk.Label(root, text="   R.M.T.N.K Rathnayaka (E/17/286) ", bg="gray30", fg="white", font=("Helvetica", 9))
name.place(x=677, y=70)


signal= tk.Frame(root, bg="lightgray", height=100 , width=100)  # Change "lightblue" to your desired color
signal.place(x=30, y=520)

signal1= tk.Frame(signal, bg="red", height=10 , width=10)  # Change "lightblue" to your desired color
signal1.place(x=90, y=16)

signal2= tk.Frame(signal, bg="red", height=10 , width=10)  # Change "lightblue" to your desired color
signal2.place(x=90, y=46)

signal3= tk.Frame(signal, bg="blue", height=10 , width=10)  # Change "lightblue" to your desired color
signal3.place(x=90, y=76)

datamaster_label = tk.Label(signal, text="Data master : ", bg="lightgray", fg="black", font=("Helvetica", 10))
datamaster_label.place(x=0, y=10)

dp_label = tk.Label(signal, text="Jtag data(P) : ", bg="lightgray", fg="black", font=("Helvetica", 10))
dp_label.place(x=0, y=40)

dw_label = tk.Label(signal, text="Jtag data(w)  : ", bg="lightgray", fg="black", font=("Helvetica", 10))
dw_label.place(x=0, y=70)


#---------------------------------------------------------
cpu_label = tk.Label(root, text="CPU version  : ", bg="lightgray", fg="black", font=("Helvetica", 10))
cpu_label.place(x=30, y=120)

cpu_d_label = tk.Label(root, text="RV32IMF  ", bg="lightgray", fg="blue", font=("Helvetica", 10))
cpu_d_label.place(x=120, y=120)


jtag_label = tk.Label(root, text="Jtag status  : ", bg="lightgray", fg="black", font=("Helvetica", 10))
jtag_label.place(x=30, y=150)

jtag_d_label = tk.Label(root, text="Connected ", bg="lightgray", fg="blue", font=("Helvetica", 10))
jtag_d_label.place(x=120, y=150)


cpud_label = tk.Label(root, text="Data logger  : ", bg="lightgray", fg="black", font=("Helvetica", 10))
cpud_label.place(x=30, y=180)

cpud_d_label = tk.Label(root, text="Connected", bg="lightgray", fg="blue", font=("Helvetica", 10))
cpud_d_label.place(x=120, y=180)

#----------------------------------------------------------
#regfile
reg_title_label = tk.Label(register_file, text="         Register file               ", bg="gray39", fg="white", font=("Helvetica", 13))
reg_title_label.place(x=0, y=0)

r1_label = tk.Label(register_file, text=" R1 :  0", bg="snow3", fg="black", font=("Helvetica", 11))
r1_label.place(x=10, y=40)

r2_label = tk.Label(register_file, text=" R2 :  0", bg="snow3", fg="black", font=("Helvetica", 11))
r2_label.place(x=10, y=70)

r3_label = tk.Label(register_file, text=" R3 :  0", bg="snow3", fg="black", font=("Helvetica", 11))
r3_label.place(x=10, y=100)

r4_label = tk.Label(register_file, text=" R4 :  0", bg="snow3", fg="black", font=("Helvetica", 11))
r4_label.place(x=10, y=130)

r5_label = tk.Label(register_file, text=" R5 :  0", bg="snow3", fg="black", font=("Helvetica", 11))
r5_label.place(x=10, y=160)
#-------------
r6_label = tk.Label(register_file, text=" R6 :  0", bg="snow3", fg="black", font=("Helvetica", 11))
r6_label.place(x=100, y=40)

r7_label = tk.Label(register_file, text=" R7 :  0", bg="snow3", fg="black", font=("Helvetica", 11))
r7_label.place(x=100, y=70)

r8_label = tk.Label(register_file, text=" R8 :  0", bg="snow3", fg="black", font=("Helvetica", 11))
r8_label.place(x=100, y=100)

r9_label = tk.Label(register_file, text=" R9 :  0", bg="snow3", fg="black", font=("Helvetica", 11))
r9_label.place(x=100, y=130)

r10_label = tk.Label(register_file, text=" R10: 0", bg="snow3", fg="black", font=("Helvetica", 11))
r10_label.place(x=100, y=160)

#reg signals

regenble_label = tk.Label(root, text=" Reg write enable ", bg="lightgray", fg="black", font=("Helvetica", 9))
regenble_label.place(x=570, y=250)

regenabled= tk.Frame(root, bg="blue", height=10 , width=10)  # Change "lightblue" to your desired color
regenabled.place(x=675, y=255)

#----------------------------------------------------------
#data mem
reg_title_label = tk.Label(data_file, text="       Data memory             ", bg="gray39", fg="white", font=("Helvetica", 13))
reg_title_label.place(x=0, y=0)

m1_label = tk.Label(data_file, text=" M0 :  0", bg="snow3", fg="black", font=("Helvetica", 11))
m1_label.place(x=10, y=40)

m2_label = tk.Label(data_file, text=" M1 :  0", bg="snow3", fg="black", font=("Helvetica", 11))
m2_label.place(x=10, y=70)

m3_label = tk.Label(data_file, text=" M2 :  0", bg="snow3", fg="black", font=("Helvetica", 11))
m3_label.place(x=10, y=100)

m4_label = tk.Label(data_file, text=" M3 :  0", bg="snow3", fg="black", font=("Helvetica", 11))
m4_label.place(x=10, y=130)

m5_label = tk.Label(data_file, text=" M4 :  0", bg="snow3", fg="black", font=("Helvetica", 11))
m5_label.place(x=10, y=160)
#-------------

m6_label = tk.Label(data_file, text=" M5 :  0", bg="snow3", fg="black", font=("Helvetica", 11))
m6_label.place(x=100, y=40)

m7_label = tk.Label(data_file, text=" M6 :  0", bg="snow3", fg="black", font=("Helvetica", 11))
m7_label.place(x=100, y=70)

m8_label = tk.Label(data_file, text=" M7 :  0", bg="snow3", fg="black", font=("Helvetica", 11))
m8_label.place(x=100, y=100)

m9_label = tk.Label(data_file, text=" M8 :  0", bg="snow3", fg="black", font=("Helvetica", 11))
m9_label.place(x=100, y=130)

m10_label = tk.Label(data_file, text=" M9:   0", bg="snow3", fg="black", font=("Helvetica", 11))
m10_label.place(x=100, y=160)
#dm signals
dataw_label = tk.Label(root, text=" Data mem write ", bg="lightgray", fg="black", font=("Helvetica", 9))
dataw_label.place(x=500, y=495)
datar_label = tk.Label(root, text=" Data mem Read ", bg="lightgray", fg="black", font=("Helvetica", 9))
datar_label.place(x=500, y=515)

datawsignal= tk.Frame(root, bg="blue", height=10 , width=10)  # Change "lightblue" to your desired color
datawsignal.place(x=610, y=500)
datarsignal= tk.Frame(root, bg="blue", height=10 , width=10)  # Change "lightblue" to your desired color
datarsignal.place(x=610, y=520)

#Instructions-------------------------------------------------------------
ins_label = tk.Label(pc_unit, text="      INS        ", bg="snow3", fg="black", font=("Helvetica", 11))
ins_label.place(x=15, y=140)

pc_label = tk.Label(pc_unit, text=" PC :  00", bg="snow3", fg="black", font=("Helvetica", 11))
pc_label.place(x=25, y=100)

clk_label = tk.Label(pc_unit, text="   Clock    ", bg="gray39", fg="white", font=("Helvetica", 11))
clk_label.place(x=25, y=10)
clock = tk.Frame(pc_unit, bg="blue", height=40 , width=71)  # Change "lightblue" to your desired color
clock.place(x=25, y=30)

#pipeline---------------------------
if_label = tk.Label(if_stage, text="       IF        ", bg="gray30", fg="white", font=("Helvetica", 11,"bold"))
if_label.place(x=0, y=0)

id_label = tk.Label(id_stage, text="       ID        ", bg="gray30", fg="white", font=("Helvetica", 11,"bold"))
id_label.place(x=0, y=0)

ex_label = tk.Label(ex_stage, text="      EX        ", bg="gray30", fg="white", font=("Helvetica", 11,"bold"))
ex_label.place(x=0, y=0)

mem_label = tk.Label(mem_stage, text="    MEM        ", bg="gray30", fg="white", font=("Helvetica", 11,"bold"))
mem_label.place(x=0, y=0)

wb_label = tk.Label(wb_stage, text="     WB        ", bg="gray30", fg="white", font=("Helvetica", 11,"bold"))
wb_label.place(x=0, y=0)

ifd_label = tk.Label(if_stage, text="    NOP        ", bg="steelblue4", fg="white", font=("Helvetica", 11))
ifd_label.place(x=0, y=40)

idd_label = tk.Label(id_stage, text="    NOP        ", bg="steelblue4", fg="white", font=("Helvetica", 11))
idd_label.place(x=0, y=40)

exd_label = tk.Label(ex_stage, text="    NOP        ", bg="steelblue4", fg="white", font=("Helvetica", 11))
exd_label.place(x=0, y=40)

memd_label = tk.Label(mem_stage, text="   NOP       ", bg="steelblue4", fg="white", font=("Helvetica", 11))
memd_label.place(x=0, y=40)

wbd_label = tk.Label(wb_stage, text="     NOP        ", bg="steelblue4", fg="white", font=("Helvetica", 11))
wbd_label.place(x=0, y=40)



# Create a custom close button
close_button = tk.Button(root, text="Close", command=close_window, bg="red", fg="white", font=("Arial", 12, "bold"),width=7, height=1)
close_button.place(x=800, y=600)
# Create a custom restart button
close_button = tk.Button(root, text="Restart", command=restart_program, bg="blue", fg="white", font=("Arial", 12, "bold"),width=7, height=1)
close_button.place(x=710, y=600)

#---------------------------------------------



print("Initializing JTAG connection")
try:
    ju = intel_jtag.intel_jtag_uart()
except Exception as e:

    print(e)
    d_status = 0;
    jtag_d_label.config(text=f"{e}")
    d_status = 1;


print("JTAG Connected")
print("Reading Data.... (Press \"Q\" to exit)")



j_thread = threading.Thread(target=jtag_read)
j_thread.daemon = True  # The thread will exit when the main program exits
j_thread.start()

usb_thread = threading.Thread(target=update_labels)
usb_thread.daemon = True  # The thread will exit when the main program exits
usb_thread.start()
root.mainloop()










