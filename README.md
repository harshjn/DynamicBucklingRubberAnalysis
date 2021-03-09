# Buckling Analysis via Electronic data and Images for Threads/rods/membranes
In this project, I'm measuring certain electronic data amplified with INA110KP Integrated Circuit chip via NI-SCB-68 and PXI-1033 at intervals of 20μs.The entire process is recorded with a Fast camera (Phantom Miro M310) at intervals of∼66μs. The images are analysed with MATLAB Image Processing Toolbox. These codes can be used to measure lengths with sub-pixel resolution. 
I am using these for Dynamic Buckling Analysis of experiments performed in Soft Matter Lab at TIFR.

### Input
We take an image that looks as below:
<p align="center">
  <img src="https://github.com/harshjn/DynamicBucklingRubberAnalysis.m/blob/master/image_fixed_width-2">  
</p>

### Output
And we get detected points in blue and red as I've labeled on the above black and white image:
<p align="center">
  <img src="https://github.com/harshjn/DynamicBucklingRubberAnalysis.m/blob/master/image_fixed_width">  
</p>


# Numerical Solution for Euler Bernoulli fourth order differential equation
We present a solution using Method of Lines.
