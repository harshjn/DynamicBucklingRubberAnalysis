# -*- coding: utf-8 -*-
"""
Created on Fri Jul 31 20:39:28 2020

@author: Admin

Image Data Set Contains These 3 Columns:
Lengthmm ClampDistmm timeImage(Seconds)

Electronic Data Set file contains these 6 columns:
timeElectronic' PositionVoltsRaw PositionCalibratedMM StressRawVolts StressRawGrams StressGramsFiltered


"""
%config InlineBackend.figure_format = 'retina'
import os
os.chdir('C:/Users/Admin/OneDrive - tifr.res.in/BB30Lab 2020/BB30Lab_Rubber/PaperAugust/FigWrinkling/Experiment')
import matplotlib.pyplot as plt
import numpy as np
import csv
import pandas as pd

dataElectronic=pd.read_csv('Electronic5mmCData.txt')
dataImage=pd.read_csv('Image5mmCData.txt')
#%%
tStart=0.07
tEnd=0.1

tStart2 =  1 ;
tEnd2   =  1.2 ;
#%
fig1 = plt.figure()

ax1=fig1.add_subplot(221)
ax1.plot(dataElectronic.iloc[:,0],dataElectronic.iloc[:,5]*1e3)
ax1.set_ylabel('Stress ($N/m^2$)')
ax1.set_xlim([tStart,tEnd])
ax1.axhline(y=0.0,color='b',ls='--')
ax1.axvline(x=0.088,color='g',ls='--')
ax1.axvline(x=0.075,color='r',ls='--')
ax1.set_xticks([])
ax1.set_yticks(np.arange(0,2e5,0.5e5))
ax1.set_yticklabels(['0','0.5e5','1e5','1.5e5'])
plt.axvspan(0.075, 0.0785, facecolor='0.5', alpha=0.5)
#%
ax2=fig1.add_subplot(222)
ax2.plot(dataElectronic.iloc[:,0],dataElectronic.iloc[:,5]*1e3)
ax2.set_xlim([tStart2,tEnd2])
ax2.set_yticks([])
ax2.set_xticks([])
ax2.axhline(y=0.0,color='b',ls='--')

#%
ax1.spines['right'].set_visible(False)
ax2.spines['left'].set_visible(False)
ax1.yaxis.tick_left()
ax1.tick_params(labelright='off')  # don't put tick labels at the top
ax2.yaxis.tick_right()
d = .015 # how big to make the diagonal lines in axes coordinates
kwargs = dict(transform=ax1.transAxes, color='k', clip_on=False)
ax1.plot((1-d,1+d), (-d,+d), **kwargs)
ax1.plot((1-d,1+d),(1-d,1+d), **kwargs)
kwargs.update(transform=ax2.transAxes)  # switch to the bottom axes
ax2.plot((-d,+d), (1-d,1+d), **kwargs)
ax2.plot((-d,+d), (-d,+d), **kwargs)


# plt.axvspan(10.001, 10.1, facecolor='0.5', alpha=0.5)

##############################################################################

ax3=fig1.add_subplot(223)
ax3.plot(dataImage.iloc[:,2],dataImage.iloc[:,0],'.',label='contour length');
ax3.plot(dataImage.iloc[:,2],dataImage.iloc[:,1],label='Distance b/w clamps');
ax3.set_xlim([tStart,tEnd])
ax3.set_ylabel('Length(mm)')
ax3.axvline(x=0.088,color='g',ls='--')
ax3.axvline(x=0.075,color='r',ls='--')
ax3.set_ylim([70,100])

ax3.axhline(y=86.5,color='k',ls='-.')

plt.subplots_adjust(wspace=0.02, hspace=0.05)

ax4=fig1.add_subplot(224)
ax4.plot(dataImage.iloc[:,2],dataImage.iloc[:,0],'.',label='contour length');
ax4.plot(dataImage.iloc[:,2],dataImage.iloc[:,1],label='Distance b/w clamps');
ax4.set_xlim([tStart2,tEnd2])
ax4.set_yticks([])
ax4.set_ylim([70,100])
# ax4.axhline(y=0.0,color='b',ls='--')
ax4.legend()
#%
ax3.spines['right'].set_visible(False)
ax4.spines['left'].set_visible(False)
ax3.yaxis.tick_left()
ax3.tick_params(labelright='off')  # don't put tick labels at the top
ax4.yaxis.tick_right()
d = .015 # how big to make the diagonal lines in axes coordinates
kwargs = dict(transform=ax1.transAxes, color='k', clip_on=False)
ax3.plot((1-d,1+d), (-d,+d), **kwargs)
ax3.plot((1-d,1+d),(1-d,1+d), **kwargs)
kwargs.update(transform=ax2.transAxes)  # switch to the bottom axes
ax4.plot((-d,+d), (1-d,1+d), **kwargs)
ax4.plot((-d,+d), (-d,+d), **kwargs)
ax4.axhline(y=86.5,color='k',ls='-.')





plt.suptitle("Stress and Length Vs time", fontsize=14)




