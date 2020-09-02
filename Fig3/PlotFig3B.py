# -*- coding: utf-8 -*-
"""
Created on Fri Jul 31 17:24:00 2020

@author: Admin
"""

%config InlineBackend.figure_format = 'retina'
import os
os.chdir('F:/OneDrive - tifr.res.in/BB30Lab 2020/BB30Lab_Rubber/PaperAugust/FigWrinkling/')

import matplotlib.pyplot as plt
import numpy as np
import csv
import pandas as pd

dataEps=pd.read_csv('EpsThoretical.csv')
dataStress=pd.read_csv('StressThoretical.csv')
#%%

timeStart=9.96
timeEnd=10.30

#%%
fig1 = plt.figure()

ax2=fig1.add_subplot(211)
ax2.plot(dataStress.iloc[:,0],dataStress.iloc[:,1])
ax2.set_xlim([timeStart,timeEnd])
# ax2.set_xticks([1,30])
ax2.set_ylabel('Stress ($N/m^2$)')
ax2.set_xticks([])
ax2.set_ylim([-1e5,1e5])
ax2.set_yticks(np.arange(-1e5,2.5e5,0.5e5))
ax2.set_yticklabels(['-1e5','-0.5e5','0','0.5e5','1e5','1.5e5','2e5'])
ax2.axhline(y=0.0,color='b',ls='--')
ax2.axvline(x=9.9993,color='r',ls='--')

plt.axvspan(9.9993, 10.007, facecolor='0.5', alpha=0.5)


ax1=fig1.add_subplot(212)
ax1.plot(dataEps.iloc[:,0],(dataEps.iloc[:,1]))
ax1.set_xlim([timeStart,timeEnd])
# 
ax1.set_ylabel('Strain\n')
ax1.set_xlabel('time (s)')
ax1.axvline(x=9.9993,color='r',ls='--')



plt.subplots_adjust(wspace=0.02, hspace=0.05)

plt.suptitle("Stress and Strain Vs time", fontsize=14)

#%%
ax1.set_ylabel('Strain')



ax1 = fig1.subplots(1,2,sharey=True)

