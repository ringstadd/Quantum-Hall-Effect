from numpy import *
import math
import sys
import matplotlib.pyplot as plt
#This python script will generate a graph using the enthought
#ipython distribution's numpy, ipython, and matplotlib.
#For those familiar with matlab, the syntax is very similar.

#Figure 1 for the Report:

fig = plt.figure()
ax = {}
ax[1] = fig.add_subplot(1,2,1)
ax[2] - fig.add_subplot(1,2,2)

#Import data
data = {} #keys will be flux values
data[8] = loadtxt('./eig_N1_Q8_G0_Sz10_real.dat', unpack=True)
data[5] = loadtxt('./eig_N1_Q5_G0_Sz10_real.dat', unpack=True)
#Create figure and tweak so that it looks nice
line = ax[1].scatter(data[5][0], data[5][3], s=4, c ='b', marker = 'o')
line2 = ax[2].scatter(data[8][0], data[8][3], s = 4, c = 'b', marker = 'o')
plt.show()



