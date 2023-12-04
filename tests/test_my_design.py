import cocotb
from cocotb.clock import Clock
from cocotb.queue import Queue
from cocotb.binary import BinaryValue
from cocotb.triggers import Edge, RisingEdge, Timer
from FuncGenerator import *
import matplotlib.pyplot as plt
import numpy as np
    
samples = 10000
fs = 1000
time , sin_signal1= SinFunc(fs,5,amp=(2**7 * 0.75),samples=samples)
# time , sin_signal2= SinFunc(fs,380,amp=(2**7 * 0.125),samples=samples) 
time , sin_signal3= SinFunc(fs,300,amp=(2**7 * 0.125),samples=samples) 

sin_signal = 0.5 * (sin_signal1 + sin_signal3)
# coef = np.array([0.010087266526214677, 0.22034079125542463, 0.5391438844367215, 0.22034079125542463, 0.010087266526214677]) * 2**7
# coef = coef.astype(int)
# for i in range(5):
#     print(f'0x{coef[i]:02X} ')

@cocotb.test()
async def moving_average_order17(dut):
    salida_fir = list()
    fig, (ax1, ax2) = plt.subplots(2, 1, sharex=True)
    ax1.set_title("FIR Media Movil Orden 17")
    ax1.grid(True, which='both', linestyle='--', linewidth=0.5)
    ax2.grid(True, which='both', linestyle='--', linewidth=0.5)
    ax1.plot(time,sin_signal.astype(int)/2**7)
    dut.orden.value = 17
    dut.coeficientes.value = 0x0707070707070707070707070707070707
    
    clock = Clock(dut.clk, 4, "ns")
    cocotb.start_soon(clock.start())
    await Timer(1, units="ns")
    count = 0
    for cycle in range(samples):
        
        dut.entrada.value = int(sin_signal[cycle])
        if(cycle > samples/2):
            dut.rst.value = 1
        else:
            dut.rst.value = 0
        try:
            salida_fir.append(dut.salida.value.signed_integer/127.0)
        except Exception as e:
            count+=1
            print(e)
        await Timer(2, units="ns")
    ax2.plot(time[count:len(time)],salida_fir)
    plt.show()

@cocotb.test()
async def moving_average_order5(dut):
    salida_fir = list()
    fig, (ax1, ax2) = plt.subplots(2, 1, sharex=True)
    ax1.set_title("FIR Media Movil Orden 5")
    ax1.grid(True, which='both', linestyle='--', linewidth=0.5)
    ax2.grid(True, which='both', linestyle='--', linewidth=0.5)
    ax1.plot(time,sin_signal.astype(int)/2**7)
    dut.orden.value = 5
    dut.coeficientes.value = 0x1919191919
    
    clock = Clock(dut.clk, 4, "ns")
    cocotb.start_soon(clock.start())
    await Timer(1, units="ns")
    count = 0
    for cycle in range(samples):
        dut.rst.value = 0
        dut.entrada.value = int(sin_signal[cycle])
        try:
            salida_fir.append(dut.salida.value.signed_integer/127.0)
        except Exception as e:
            count+=1
            print(e)
        await Timer(2, units="ns")
    ax2.plot(time[count:len(time)],salida_fir)
    plt.show()

@cocotb.test()    
async def low_pass(dut):
    salida_fir = list()
    fig, (ax1, ax2) = plt.subplots(2, 1, sharex=True)
    ax1.set_title("FIR PasaBajos")
    ax1.grid(True, which='both', linestyle='--', linewidth=0.5)
    ax2.grid(True, which='both', linestyle='--', linewidth=0.5)
    ax1.plot(time,sin_signal.astype(int)/2**7)
    dut.orden.value = 17
    clock = Clock(dut.clk, 4, "ns")
    cocotb.start_soon(clock.start())
    dut.coeficientes.value = 0x0000FFFDFD03112026201103FDFDFF0000
    await Timer(1, units="ns")
    count = 0
    for cycle in range(samples):
        dut.rst.value = 0
        dut.entrada.value = int(sin_signal[cycle])
        try:
            salida_fir.append(dut.salida.value.signed_integer/127.0)
        except Exception as e:
            count+=1
            print(e)
        await Timer(2, units="ns")
    ax2.plot(time[count:len(time)],salida_fir)
    plt.show()

@cocotb.test()    
async def high_pass(dut):
    salida_fir = list()
    fig, (ax1, ax2) = plt.subplots(2, 1, sharex=True)
    ax1.set_title("FIR Pasa Altos")
    ax1.grid(True, which='both', linestyle='--', linewidth=0.5)
    ax2.grid(True, which='both', linestyle='--', linewidth=0.5)
    ax1.plot(time,sin_signal.astype(int)/2**7)
    dut.orden.value = 17
    clock = Clock(dut.clk, 4, "ns")
    cocotb.start_soon(clock.start())
    dut.coeficientes.value = 0x0000010303FDEFE05AE0EFFD0303010000
    await Timer(1, units="ns")
    count = 0
    for cycle in range(samples):
        dut.rst.value = 0
        dut.entrada.value = int(sin_signal[cycle])
        try:
            salida_fir.append(dut.salida.value.signed_integer/127.0)
        except Exception as e:
            count+=1
            print(e)
        await Timer(2, units="ns")
    ax2.plot(time[count:len(time)],salida_fir)
    plt.show()