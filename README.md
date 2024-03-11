# Primary-task-haptic-augmentation-on-secondary-visuospatial-task-performance
Primary task haptic augmentation on secondary visuospatial task performance experiment

This experiment is run in MATLAB with Psychtoolbox visuals and should be used with a Microsoft Sidewinder Force feedback joystick.

The following files are for MATLAB. They must be placed in a folder named toolbox on the C drive. 
Firstly Psychtoolbox must be installed with associated files for your computer type. The instalation method can be found here: http://psychtoolbox.org/download.html.
A copy of the version used is located in this folder. 

To run the experiment file you must first open the files and run in matlab. The following files can be run:

N-Back task only:
Practice_Nback Only.m

Tracking task only without haptics:
Practice_Visual_Tracking_NoHaptics.m

Tracking task only with haptics:
Practice_Visual_Tracking_Haptics.m

Both tasks with haptics:
Visual__Tracking_Nback_Experiment_Haptics.m

Both tasks without haptics:
Visual__Tracking_Nback_Experiment_None.m

Stick Profile codes must sit in the experiment folder:
StickNudge.m
StickNudge_8deg.m
setCentreforceProfile.m
getCenterforce.m
DrawTarget.m
