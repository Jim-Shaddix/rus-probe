# RUS-Probe
(resonant ultrasonic spectroscopy)
* Author: James Shaddix

## Note
The current version of this application is stable, but I am still working 
on its development. 

## Installation
* [mlapp installation file](3-Analysis/tdms_peak_analysis/Data_Analyzer_App.mlappinstall)


## Description:
This repository contains a Matlab Dashboard application that was developed 
for doing data analysis for a Condensed Matter Physics experiment 
involving Resonant Ultransonic Spectroscopy. 

### What is this Dashboard for?

![alt text](images/interface.png "Image of the Application")

#### Functionality 
1. This application reads signal data from .tdms files.
2. The tab menu on the bottom left provides an interface for pre-processing 
   all of the data. Currently, this allows the user to remove linear trends, and
   use a smoothing algorithm on the data.
3. The application than finds all of the peaks in the data, and fits the peaks
   to a lorentzian model. How the program finds and fits the peaks 
   can be configured from menus in the program that accept user inputs.
4. The tab menu in the bottom left provides a section for sorting the files 
   that will be analyzed. The files can sorted based on their temperature or magnetic field. The user is also presented with option of performing two factor 
   sorting of the files.
5. If you would like to analyze the data in program, the export data button 
   provides the user with a menu that can be used to export all of the data 
   generated by my program into a .mat file.
6. The rpr button provides an interface for exporting all of the data 
   into input files for the rpr.exe program.
7. The program also comes with a dashboard interface for tracking a particular 
peak as a function of temperature or magnetic field.
![alt text](images/peak_tracker.png "Image of the Application")
8. This program also provides a bunch of different methods for visualizing the data.

#### Data Visualization
1. On bottom right hand of the program, there is a menu for configuring the plot 
   that is displayed in the main menu. 
2. The 3D plotter tab (bottom left), allows the user to specify parameters to use
   for creating 3-dimensional plots of the data. The user can choose the axis for the plot to represent the temperature / magnetic field / frequency / or any of the fit parameters in the lorentzian model. 
![alt text](images/3d_model.png "Image of the Application")
3. The Analyzed Tracked button provides another dashboard interface for making 2D
   plots of the same data mentioned in the previous bullet.
![alt text](images/peak_analyzer.png "Image of the Application")



# Book
* This book is a good refference for resonant ultrasonic spectroscopy.
[Robert G Leisure. Ultrasonic Spectroscopy](https://www.cambridge.org/core/books/ultrasonic-spectroscopy/D4A1831DE2E596E6EC393A5B85B69E63)

# Directories
* 1-GettingData: Describes how data was acquired.
* 2-FilesToAnalyze: Contains the files that will be analyzed.
* 3-Analysis: Contains the code that is used to perform analysis
* 4-renaming: some python scripts for performing batch renaming of tdms files we are
  analyzing
* web: A directory with scripts I am working on for generating plots with plotly

# Data Collection Setup

## Probe Setup
![alt text](images/probe.jpg "probe")

## Transducer Images
![alt text](images/transducer-rig1.png "transducer1")
![alt text](images/transducer-rig2.png "tranducer2")


