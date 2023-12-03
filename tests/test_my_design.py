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
time , sin_signal1= SinFunc(fs,470,amp=0x7,samples=samples) 
time , sin_signal2= SinFunc(fs,5,amp=0x7,samples=samples)

sin_signal = sin_signal2 + sin_signal1 * 0.15
salida_fir = list()
fig, (ax1, ax2) = plt.subplots(2, 1, sharex=True)
ax1.grid(True, which='both', linestyle='--', linewidth=0.5)
ax2.grid(True, which='both', linestyle='--', linewidth=0.5)

ax1.plot(time,sin_signal.astype(int)/127)
@cocotb.test()
async def my_first_test(dut):
    """Try accessing the design."""
    clock = Clock(dut.clk, 4, "ns")
    cocotb.start_soon(clock.start())
    
    
    dut.coeficientes.value = 0x1919191919
    await Timer(1, units="ns")
    for cycle in range(samples):
        dut.rst.value = 0
        dut.entrada.value = int(sin_signal[cycle])
        try:
            salida_fir.append(dut.salida.value.signed_integer/127.0)
        except Exception as e:
            print(e)
        await Timer(2, units="ns")
    ax2.plot(time[1:len(time)],salida_fir)

    plt.show()
    