%Visual__Tracking_Nback_Experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Visual__Tracking_Nback_Experiment.m   JB     05/10/21

%   This program displays a cross hair that moves both X & Y (Test 3) and a blue
%   oval that the user must control with a mircosoft Force Feedback
%   Sidewinder joystick. The user will feel forces on the joystick to assit
%   the user. Nudges and Shudders.
%   Test 1 the cosshairs move horizontally.
%   Test 2 corsshairs move vertically.
%   Test 3 moves in both directions.
%
%   The user will be required to complete a visual n-back test to find the next
%   pattern in the sequence using a keyboard spacebar response
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% UPDATES
% 12/11/2021 - Tracking task difficulty.
% line55 - WaveSpeed_inc variable to define the increases in Wavespeed
% increments. % Will need to consider what the average velocity is for
% these trials.

% Minute @ WaveSpeed 1.2 = median of 1VA/sec , mean of 1.25VA/sec
% Minute @ WaveSpeed 0.8 = median of 1VA/sec , mean of 1.25VA/sec
% Minute @ WaveSpeed 0.4 = median of 0.48VA/sec , mean of 0.62VA /sec


%16/11/2021 - Nback iterval sequence. Response times need to be changed so
%that participants responses are recorded during the following isi of an
%item

%17/11/2021 - Tracking task difficulty - adapted behaviour of the task in
% the DrawTarget function. We have a preset group of signals of increases
% wavespeed that the function jumps between when ever a level in difficulty
% is required. Drift correction included.

%17/11/2021 - 

%% Screen parameters
% (W x H) 59.79 x 33.63 cm

% Use https://www.sr-research.com/visual-angle-calculator/ to calculate
% viewing distance for drawing stimuli

% Clear the workspace
close all;
clear all;
clc;
sca;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
prompt = 'What is the participant number? ('') ';
participant = input(prompt);
handedness = 'R';
Condition = nominal('Nudge'); % Condition = nominal('NoNudge');
trial = 'Practice';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Manipulating variables

% Include a tranform of the screen pixel positions to Visual Angle (VA)
VAtopix= 46; % Represents the number of screen pixels per visual angle (825mm viewing distance)
TaskVAOffset = 12; % How much visual angle the centre of each task is offset from the screen centre (Must be at least 4.5 VA)

% Nudge signal parameters
Hz = 2; % Frequency of the nudge
Amp = 0.25; % size of the nudge force
NudgeZone = 1; % The Nudge will stay on within 1VA of the target.

% Nback
Nback_Size = 2; % Recall 2nd item previous
Nback_trials = 100; % 100 in sequence (100 is 5 mins) 

%Tracking Task difficulty
WaveSpeedMin = 0.2; % 0.3 VA/sec
WaveSpeedInc = 0.05; % 0.075 VA/sec increment 
WaveSpeedMax = 2; % 3 VA/sec
WaveSpeedLadder = WaveSpeedMin:WaveSpeedInc:WaveSpeedMax;
WaveSpeedDuration_Up = 3; % time on / off target to increase difficulty
WaveSpeedDuration_Dn = 1; % time on / off target to decrease difficulty
InZone = 1.5; % The participant is deemed to be within proximity of target by 2 VA

Demographics = struct;
Demographics.participant = participant;
Demographics.Condition = Condition;
Demographics.trial = trial;
Demographics.VAtopix = VAtopix;
Demographics.TaskVAOffset = TaskVAOffset;
Demographics.Hz = Hz;
Demographics.Amp = Amp;
Demographics.NudgeZone = NudgeZone;
Demographics.Nback_Size = Nback_Size;
Demographics.Nback_trials = Nback_trials;
Demographics.WaveSpeedMin = WaveSpeedMin;
Demographics.WaveSpeedInc = WaveSpeedInc;
Demographics.WaveSpeedMax = WaveSpeedMax;
Demographics.WaveSpeedLadder = WaveSpeedLadder;
Demographics.WaveSpeedDuration_Up = WaveSpeedDuration_Up;
Demographics.WaveSpeedDuration_Dn = WaveSpeedDuration_Dn;
Demographics.InZone = InZone;


%% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
Screen('Preference', 'SkipSyncTests', 1);
% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = 1;

% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
PsychImaging('PrepareConfiguration');
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Set the blend funciton for the screen
Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);


% Shift xcentre of each task to be offset to the left/right of the screen centre by 4.5 VA
LHCenter = xCenter - (VAtopix* TaskVAOffset);
RHCenter = xCenter + (VAtopix* TaskVAOffset);


% We set the text size to be nice and big here
Screen('TextSize', window, 20);

%% Stimuli Generation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nback Task
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Make a base Rect of 2.5 VA by VA
baseRectVA = 2.5 * VAtopix;
baseRect= [0 0 baseRectVA baseRectVA];
rectColor = [0.5 0.5 0.5]; % Squares will change grey when they are active.

% Create the locations of the 9 grid locations. each of these are offset by
% 2.75 VA from the centre of the LH screen
baselocVA = 2.75 * VAtopix;
squareXpos = [LHCenter - baselocVA  , LHCenter , LHCenter + baselocVA ...
    LHCenter - baselocVA  , LHCenter , LHCenter + baselocVA ...
    LHCenter - baselocVA  , LHCenter , LHCenter + baselocVA];
squareYpos = [yCenter - baselocVA  , yCenter - baselocVA, yCenter - baselocVA ...
    yCenter  , yCenter, yCenter ...
    yCenter + baselocVA  , yCenter + baselocVA, yCenter + baselocVA];

numSqaures = length(squareXpos);

allRects = nan(4, numSqaures);
for i = 1:numSqaures
    allRects(:, i) = CenterRectOnPointd(baseRect, squareXpos(i), squareYpos(i));
end

% Pen width for the frames
penWidthPixels = 6;

% Draw the screen partitions
xCoords = [ xCenter + ((-TaskVAOffset-4.5)* VAtopix) ,  xCenter + ((-TaskVAOffset-4.5)* VAtopix)...
    xCenter ,  xCenter...
    xCenter + ((TaskVAOffset+4.5)* VAtopix) ,  xCenter + ((TaskVAOffset+4.5)* VAtopix)];

yCoords = [ yCenter + (-4* VAtopix) ,  yCenter + (+4* VAtopix)...
    yCenter + (-4* VAtopix) ,  yCenter + (+4* VAtopix) ...
    yCenter + (-4* VAtopix) ,  yCenter + (+4* VAtopix)];

allCoords = [xCoords; yCoords];


% Interstimulus interval time in seconds
isiTimeSecs = 2.5;%was origionally 1 ( 2500ms from kane & Conway 2007)
isiTimeFrames = round(isiTimeSecs / ifi);
% How long should the block stay up during a trial in time and frames
imageSecs = 0.5; %was origionally 2 ( 500ms from kane & Conway 2007)
imageFrames = round(imageSecs / ifi);

%% Initise and setup N-back task

% create a dataset to read the n-back task and to log responses

Time_Total = Nback_trials * (isiTimeSecs + imageSecs); % Total time on trial
Frame_Total = Nback_trials * (isiTimeFrames + imageFrames);% Total time on trial


Nback_DS = table;
Nback_DS.N = [1:Nback_trials]';
Nback_DS.Nback_Seq_Pos = randi(9,Nback_trials,1);

% Now make sure that target are placed into the stimuli block. 1/3 of
% trials are targets!
Nback_DS.Nback_Target = zeros(Nback_trials,1);
Nback_DS.Nback_Target(1:round(Nback_trials/3)) = 1;
Nback_DS.Nback_Target = Shuffle(Nback_DS.Nback_Target);
Nback_DS.Nback_Target(1:Nback_Size) = 0;

for i = 1:height(Nback_DS)
    if Nback_DS.Nback_Target(i) == 1
        Nback_DS.Nback_Seq_Pos(i) = Nback_DS.Nback_Seq_Pos(i - Nback_Size);
    end
end

Nback_DS.Resp = nan(Nback_trials,1);
Nback_DS.Correct = nan(Nback_trials,1);
Nback_DS.RT = nan(Nback_trials,1);

% Go through the stimuli again, making sure no targets have been added by
% chance.
for i = 1:height(Nback_DS)-Nback_Size
    while Nback_DS.Nback_Seq_Pos(i) == Nback_DS.Nback_Seq_Pos(i + Nback_Size) && Nback_DS.Nback_Target(i+Nback_Size) == 0
        Nback_DS.Nback_Seq_Pos(i) = randi(9);
    end
end


%% ----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------

% Define the keyboard keys that are listened for. We will be using the left
% and right arrow keys as response keys for the task and the escape key as
% a exit/reset key
escapeKey = KbName('ESCAPE');
SpaceKey = KbName('space');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tracking Task
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Create stimuli for the oval

% Make a base oval of 200 by 200 pixels
baseOvalVA = VAtopix * 0.5;
baseOval = [0 0 baseOvalVA baseOvalVA];
% maxDiameter = max(baseOval) * .5;

% Set the color of the oval to blue. With red and green used for n-back
% feedback
OvalColor = [0 0 1]; % blue
OvalXpos = RHCenter;
OvalYpos = yCenter;

% Velocity parameters of oval
xpos = 0; ypos = 0;
OvalveloX =  RHCenter;
OvalveloY = yCenter;

% Target Movement specs
% X position
Pos_time = 0:ifi:60; % haptic recording timing based on screen refresh rate

% Tasktimers
Tasktime = 0; % time on circle
OffTasktime = 0; % time off circle
timeshift = 0; % ???


%% Create stimuli for the moving "crosshairs"

time = [ifi:ifi:ifi*Frame_Total]';
Sigtime = [-60:ifi:(ifi*Frame_Total)+60]'; % Need to have a longer time variable (60seconds added each way for generating signals that enables switching between levels
% create the different signals for tracking task based on difficulty

VA_CH_Xlim = 4; % In VA how what is the horizontal radius limit?
VA_CH_Ylim = 4; % In VA how what is the vertical radius limit?

CH_XsigVA = nan(length(Sigtime),length(WaveSpeedLadder));
CH_YsigVA = nan(length(Sigtime),length(WaveSpeedLadder));

for i = 1:length(WaveSpeedLadder)
s1 = 0.6714 *  sin(0.383 * WaveSpeedLadder(i) * (Sigtime)+-0.269);
s2 = 0.5077*  sin(0.844* WaveSpeedLadder(i) * (Sigtime)+ 4.016);
s3 = 0.2531* sin(1.764 * WaveSpeedLadder(i) * (Sigtime)+ -0.806);
s4 = 0.1290* sin(2.838 * WaveSpeedLadder(i) * (Sigtime)+ 4.938);
s5 = 0.0784* sin(3.912 * WaveSpeedLadder(i) * (Sigtime)+ 5.442);
s6 = 0.0476* sin(5.446 * WaveSpeedLadder(i) * (Sigtime)+ 2.274);
s7 = 0.0298* sin(7.747 * WaveSpeedLadder(i) * (Sigtime)+ 1.636);
s8 = 0.0216* sin(10.508 * WaveSpeedLadder(i) * (Sigtime)+ 2.973);
s9 = 0.0180* sin(13.116 * WaveSpeedLadder(i) * (Sigtime)+ 3.429);
s10 = 0.0152 * sin(17.334 * WaveSpeedLadder(i) * (Sigtime)+ 3.486);
CH_XsigVA(:,i) = s1+s2+s3+s4+s5+s6+s7+s8+s9+s10;

s1 = 1.351 * sin(0.377 * WaveSpeedLadder(i) * (Sigtime)+ 0.145);
s2 = 1.007 * sin(0.859 * WaveSpeedLadder(i) * (Sigtime)+ 0.902);
s3 = 0.509 * sin(1.759 * WaveSpeedLadder(i) * (Sigtime)+ 4.306);
s4 = 0.26 * sin(2.827 * WaveSpeedLadder(i) * (Sigtime)+ 6.127);
s5 = 0.157 * sin(3.917 * WaveSpeedLadder(i) * (Sigtime)+ 5.339);
s6 = 0.095 * sin(5.466 * WaveSpeedLadder(i) * (Sigtime)+ 6.155);
s7 = 0.06 * sin(7.749 * WaveSpeedLadder(i) * (Sigtime)+ 1.503);
s8 = 0.043 * sin(10.51 * WaveSpeedLadder(i) * (Sigtime)+ 1.506);
s9 = 0.036 * sin(13.132 * WaveSpeedLadder(i) * (Sigtime)+ 2.368);
s10 = 0.03 * sin(17.363 * WaveSpeedLadder(i) * (Sigtime)+ 2.086);
CH_YsigVA(:,i) = s1+s2+s3+s4+s5+s6+s7+s8+s9+s10;

end


CH_XsigVA = CH_XsigVA ./ max(abs(CH_XsigVA));
CH_XsigVA = CH_XsigVA * VA_CH_Xlim;
CH_XsigPix = (CH_XsigVA * VAtopix) + RHCenter;

CH_YsigVA = CH_YsigVA ./ max(abs(CH_YsigVA));
CH_YsigVA = CH_YsigVA * VA_CH_Ylim;
CH_YsigPix = (CH_YsigVA * VAtopix) + yCenter;

% Generate the tracking task window

% To make the size of the grid it will be a 8 x 8 VA grid
TrackingBox = [0 0 8 8];
TrackingBoxPix = TrackingBox * VAtopix;
TrackingBoxLoc = CenterRectOnPointd(TrackingBoxPix,RHCenter,yCenter);

% Create an oval that depicts the 1VA area around the crosshair. This is
% the area in we define as being 'on target'

baseTrackingOvalVA = VAtopix * 2; % Tracking Oval is 2 VA in diameter size
baseTrackingOval = [0 0 baseTrackingOvalVA baseTrackingOvalVA];
TrackingOvalColor = [0 0 1 .5]; % blue with .5 transparency

%% Set up joystick
% Define joystick ID (if only using 1 joystick, this will likely be '1')
% Create joystick variable
ID = 1;
joy=vrjoystick(ID,'forcefeedback');

x1= 0.01;
x2 = 0.4;
y1 = 0.01;
y2 = 0.4;
xscale = 0.5;
yscale = 0.5;

[stick_def, xp, yp] =  setCentreforceProfile(x1, x2 , y1 , y2, xscale , yscale);

force(joy,[1 2], 0 ); % Apply the stick centering forces now?

%% Set up joystick nudge signal

% Define the shape of a single period.
Nudge_Signal_t = 0: ifi : 1 / Hz ;
Nudge_Signal = linspace( Amp , 0 , floor(length(Nudge_Signal_t) * 0.9));

Nudge_Signal = [ Nudge_Signal , zeros(1,(length(Nudge_Signal_t) - length(Nudge_Signal)))];
Nudge_Signal = - Nudge_Signal;
% plot(Nudge_Signal_t , Nudge_Signal)
Nudge_i = 0;

%% create tracking task dataset
%create all the functions that need recording

Pos_DS = table;
Pos_DS.Time = time;
Pos_DS.Frame = [1:Frame_Total]';
Pos_DS.trial = repmat(trial,height(Pos_DS),1);
Pos_DS.Participant = repmat(participant,height(Pos_DS),1);
Pos_DS.Condition = repmat(Condition,height(Pos_DS),1);
Pos_DS.NbackTrial = nan(height(Pos_DS),1);
Pos_DS.TrackingLevel = ones(height(Pos_DS),1);

Pos_DS.InputSignal_Pix_X =  CH_XsigPix(1:length(1:length(time)),1); % CH X signal take a sample from level 1
Pos_DS.InputSignal_Pix_Y =  CH_YsigPix(1:length(1:length(time)),1); % CH Y signal take a sample from level 1
Pos_DS.InputSignal_VA_X =  CH_XsigVA(1:length(1:length(time)),1); % CH X signal take a sample from level 1
Pos_DS.InputSignal_VA_Y =  CH_YsigVA(1:length(1:length(time)),1); % CH Y signal take a sample from level 1

Pos_DS.WaveSpeed = repmat(WaveSpeedMin,height(Pos_DS),1);

Pos_DS.InputSignal_Dist_Pix_X =  zeros(height(Pos_DS),1); % input signal distance travelled in pixels
Pos_DS.InputSignal_Dist_Pix_Y =  zeros(height(Pos_DS),1);
Pos_DS.InputSignal_Dist_VA_X =  zeros(height(Pos_DS),1); % input signal distance travelled in VA
Pos_DS.InputSignal_Dist_VA_Y =  zeros(height(Pos_DS),1);

Pos_DS.InputSignal_Targ_Speed_Pix_X =  zeros(height(Pos_DS),1); % input signal velocity in pixels/second
Pos_DS.InputSignal_Targ_Speed_Pix_Y =  zeros(height(Pos_DS),1);
Pos_DS.InputSignal_Targ_Speed_VA_X =  zeros(height(Pos_DS),1); % input signal velocity in VA/second
Pos_DS.InputSignal_Targ_Speed_VA_Y =  zeros(height(Pos_DS),1);

Pos_DS.InputSignal_Targ_Acc_Pix_X =  zeros(height(Pos_DS),1); % input signal acceleration in pixels/second
Pos_DS.InputSignal_Targ_Acc_Pix_Y =  zeros(height(Pos_DS),1);
Pos_DS.InputSignal_Targ_Acc_VA_X =  zeros(height(Pos_DS),1); % input signal acceleration in VA/second
Pos_DS.InputSignal_Targ_Acc_VA_Y =  zeros(height(Pos_DS),1);

Pos_DS.StickPos_X = nan(height(Pos_DS),1); % stick posistion X -1 to 1
Pos_DS.StickPos_Y = nan(height(Pos_DS),1); % stick posistion Y -1 to 1

Pos_DS.Oval_Pos_Pix_X = nan(height(Pos_DS),1);
Pos_DS.Oval_Pos_Pix_Y = nan(height(Pos_DS),1);

Pos_DS.Oval_Dist_Pix_X = nan(height(Pos_DS),1);
Pos_DS.Oval_Dist_Pix_Y = nan(height(Pos_DS),1);
Pos_DS.Oval_Dist_VA_X = nan(height(Pos_DS),1);
Pos_DS.Oval_Dist_VA_Y = nan(height(Pos_DS),1);

Pos_DS.Oval_Speed_Pix_X = nan(height(Pos_DS),1);
Pos_DS.Oval_Speed_Pix_Y = nan(height(Pos_DS),1);
Pos_DS.Oval_Speed_VA_X = nan(height(Pos_DS),1);
Pos_DS.Oval_Speed_VA_Y = nan(height(Pos_DS),1);

Pos_DS.Oval_Acc_Pix_X = nan(height(Pos_DS),1);
Pos_DS.Oval_Acc_Pix_Y = nan(height(Pos_DS),1);
Pos_DS.Oval_Acc_VA_X = nan(height(Pos_DS),1);
Pos_DS.Oval_Acc_VA_Y = nan(height(Pos_DS),1);

Pos_DS.Dist_Angle = nan(height(Pos_DS),1); % Degree direction that CH is from Oval
Pos_DS.Dist_Pix_X =  nan(height(Pos_DS),1); %  Target displacement from "Crosshair" in Pixels
Pos_DS.Dist_Pix_Y =  nan(height(Pos_DS),1); %
Pos_DS.Dist_VA_X =  nan(height(Pos_DS),1); %  Target displacement from "Crosshair" in Visual Angle
Pos_DS.Dist_VA_Y =  nan(height(Pos_DS),1); %

Pos_DS.Dist_Dist_Pix_X =  nan(height(Pos_DS),1);
Pos_DS.Dist_Dist_Pix_Y =  nan(height(Pos_DS),1);
Pos_DS.Dist_Dist_VA_X =  nan(height(Pos_DS),1);
Pos_DS.Dist_Dist_VA_Y =  nan(height(Pos_DS),1);

Pos_DS.Dist_Speed_Pix_X =  nan(height(Pos_DS),1);
Pos_DS.Dist_Speed_Pix_Y =  nan(height(Pos_DS),1);
Pos_DS.Dist_Speed_VA_X =  nan(height(Pos_DS),1);
Pos_DS.Dist_Speed_VA_Y =  nan(height(Pos_DS),1);

Pos_DS.Dist_Acc_Pix_X =  nan(height(Pos_DS),1);
Pos_DS.Dist_Acc_Pix_Y =  nan(height(Pos_DS),1);
Pos_DS.Dist_Acc_VA_X =  nan(height(Pos_DS),1);
Pos_DS.Dist_Acc_VA_Y =  nan(height(Pos_DS),1);

Pos_DS.InZone = nan(height(Pos_DS),1); % A check to see if target is in 2VA crosshair zone
Pos_DS.InNudgeZone = nan(height(Pos_DS),1); % A check to see if target is in 1VA crosshair zone
Pos_DS.TimeOnTarget = zeros(height(Pos_DS),1);
Pos_DS.TimeOffTarget = zeros(height(Pos_DS),1);
Pos_DS.TimeOnTargetCum = zeros(height(Pos_DS),1); % Cumalative time on target
Pos_DS.TimeOffTargetCum = zeros(height(Pos_DS),1); % Cumalative time off target


% stick force parameters
Pos_DS.StickCentreForce_X =  nan(height(Pos_DS),1);% force lat -1 to 1
Pos_DS.StickCentreForce_Y =  nan(height(Pos_DS),1); % force long, -1 to 1

Pos_DS.OnNudge = zeros(height(Pos_DS),1);
Pos_DS.TimeOnNudge = zeros(height(Pos_DS),1);

Pos_DS.StickNudge_Direction_Xf =  zeros(height(Pos_DS),1); % Degrees that the nudge needs to be in
Pos_DS.StickNudge_Direction_Yf =  zeros(height(Pos_DS),1); % Degrees that the nudge needs to be in
Pos_DS.StickNudge_Xf =  zeros(height(Pos_DS),1); % Moderated X force component according to position within nudge signal
Pos_DS.StickNudge_Yf=  zeros(height(Pos_DS),1); % ditto

Pos_DS.StickForce_X =  nan(height(Pos_DS),1); % Final Summed force of centring and nudge
Pos_DS.StickForce_Y =  nan(height(Pos_DS),1);



%% Specify timing information for the experiment

% Sync us and get a time stamp
vbl = Screen('Flip', window);
waitframes = 1;

% Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

PixelScrollRate = 5; % This is the number of pixels the image will role each time the screen is refreshed.

%% The EXPERIMENT!!

% Loop the animation for the duration set for the study!
t=1;

% Animation loop: we loop for the total number of trials
for trial = 1:Nback_trials
    
    Pos_DS.NbackTrial(t) = trial;
    % DefineTargetPos
    Targ_Pos = Nback_DS.Nback_Seq_Pos(trial);
    Targ_Rect = CenterRectOnPointd(baseRect, squareXpos(Targ_Pos), squareYpos(Targ_Pos));
    
    % Cue to determine whether a response has been made
    respToBeMade = true;
    response = 0;
    rt = NaN;
    numberString = [num2str(nansum(Nback_DS.Correct)) , ' / ' , num2str(nansum(Nback_DS.Nback_Target))];

    % If this is the first trial we present a start screen and wait for a
    % key-press. Also need to have an isi at the start
    if trial == 1
        DrawFormattedText(window, 'Welcome to the practice for the experiment. \n\n This is the secondary task. \n\n You should try to keep the dot on the crosshairs throughout the task. \n\n The difficulty level will increase when you have been on target for 3 seconds. If you remain off task the difficulty will reduce. \n\n Press Any Key To Begin',...
            'center', 'center', white);
        
        Screen('Flip', window);
        KbStrokeWait;       
               
    end
    
    % Start RT timer
    tstart = GetSecs;
    
    % Flip again to sync us to the vertical retrace at the same time as
    % drawing our empty grid    
%      Screen('FrameRect', window, rectColor, allRects, penWidthPixels);
      Screen('DrawLines', window, allCoords,...
          penWidthPixels, white, [0 0], 2);
     
    
    Screen('FrameRect', window, rectColor, TrackingBoxLoc, penWidthPixels);
    Screen('DrawLine', window, rectColor, Pos_DS.InputSignal_Pix_X(t), TrackingBoxLoc(2), Pos_DS.InputSignal_Pix_X(t), TrackingBoxLoc(4), penWidthPixels);
    Screen('DrawLine', window, rectColor, TrackingBoxLoc(1), Pos_DS.InputSignal_Pix_Y(t), TrackingBoxLoc(3) , Pos_DS.InputSignal_Pix_Y(t), penWidthPixels);
%     centeredOval = CenterRectOnPointd(baseTrackingOval, Pos_DS.InputSignal_Pix_X(t),  Pos_DS.InputSignal_Pix_Y(t));
    
    %     Screen('FillOval',window, TrackingOvalColor, centeredOval);
    
    Screen('FrameRect', window, rectColor, TrackingBoxLoc, penWidthPixels);
%     Screen('FillRect', window, rectColor, Targ_Rect);
    
    [Pos_DS , centeredOval] = DrawTarget(Pos_DS,joy,window,ifi,t,RHCenter,yCenter,VAtopix,baseOval,stick_def,xp,yp,CH_XsigPix,CH_XsigVA,CH_YsigPix,CH_YsigVA,WaveSpeedDuration_Up,WaveSpeedDuration_Dn,InZone,NudgeZone);
    if Pos_DS.InNudgeZone(t) == 0 && Condition == 'Nudge'
        [Pos_DS , Nudge_i]  = StickNudge_8deg(Pos_DS,ifi,t,Nudge_Signal,Nudge_i);
    end

    levelSting = ['LVL: ', num2str(Pos_DS.TrackingLevel(t)) , ' / ' , num2str((length(CH_XsigPix(1,:))))];
%     DrawFormattedText(window, numberString, LHCenter - 20 , yCenter + (5 * VAtopix), white);
     DrawFormattedText(window, levelSting, RHCenter - 20 , yCenter + (5 * VAtopix), white);

    Pos_DS.StickForce_X(t) =  Pos_DS.StickCentreForce_X(t) + Pos_DS.StickNudge_Xf(t);
    Pos_DS.StickForce_Y(t) =  Pos_DS.StickCentreForce_Y(t) + Pos_DS.StickNudge_Yf(t);
    
    force(joy,[1 2],[Pos_DS.StickForce_X(t) Pos_DS.StickForce_Y(t)]);
    
    %
    %     Screen('FillOval',window, OvalColor, centeredOval);
    %
    
    vbl = Screen('Flip', window);
    t = t+1; % Increment the tracking signal
    
    % Now we present the imageframes interval with fixation point minus one frame
    % because we presented a single frame before to get a timestamp
    % time stamp
    for frame = 1:imageFrames-1

        Pos_DS.NbackTrial(t) = trial;
        % Draw the Grid to the screen
%         Screen('FrameRect', window, rectColor, allRects, penWidthPixels);
         Screen('DrawLines', window, allCoords,...
             penWidthPixels, white, [0 0], 2);
         
        Screen('FrameRect', window, rectColor, TrackingBoxLoc, penWidthPixels);
        Screen('DrawLine', window, rectColor, Pos_DS.InputSignal_Pix_X(t), TrackingBoxLoc(2), Pos_DS.InputSignal_Pix_X(t), TrackingBoxLoc(4), penWidthPixels);
        Screen('DrawLine', window, rectColor, TrackingBoxLoc(1), Pos_DS.InputSignal_Pix_Y(t), TrackingBoxLoc(3) , Pos_DS.InputSignal_Pix_Y(t), penWidthPixels);
%         centeredOval = CenterRectOnPointd(baseTrackingOval, Pos_DS.InputSignal_Pix_X(t),  Pos_DS.InputSignal_Pix_Y(t));
        %         Screen('FillOval',window, TrackingOvalColor, centeredOval);
        
        [Pos_DS , centeredOval] = DrawTarget(Pos_DS,joy,window,ifi,t,RHCenter,yCenter,VAtopix,baseOval,stick_def,xp,yp,CH_XsigPix,CH_XsigVA,CH_YsigPix,CH_YsigVA,WaveSpeedDuration_Up,WaveSpeedDuration_Dn,InZone,NudgeZone);
        if Pos_DS.InNudgeZone(t) == 0 && Condition == 'Nudge'
            [Pos_DS , Nudge_i]  = StickNudge_8deg(Pos_DS,ifi,t,Nudge_Signal,Nudge_i);
        end

        levelSting = ['LVL: ', num2str(Pos_DS.TrackingLevel(t)) , ' / ' , num2str((length(CH_XsigPix(1,:))))];
%         DrawFormattedText(window, numberString, LHCenter - 20 , yCenter + (5 * VAtopix), white);
        DrawFormattedText(window, levelSting, RHCenter - 20 , yCenter + (5 * VAtopix), white);

        Pos_DS.StickForce_X(t) =  Pos_DS.StickCentreForce_X(t) + Pos_DS.StickNudge_Xf(t);
        Pos_DS.StickForce_Y(t) =  Pos_DS.StickCentreForce_Y(t) + Pos_DS.StickNudge_Yf(t);
        
        force(joy,[1 2],[Pos_DS.StickForce_X(t) Pos_DS.StickForce_Y(t)]);
        
        %  Screen('FillOval',window, OvalColor, centeredOval);
                
        
        if respToBeMade == true
%             Screen('FillRect', window, rectColor, Targ_Rect);
            
            [keyIsDown,secs, keyCode] = KbCheck;
            if keyCode(escapeKey)
                ShowCursor;
                sca;
                return
            elseif keyCode(SpaceKey)
                
                % Record the trial data into out data matrix
                response = 1;
                Nback_DS.Resp(trial) = response;
                Nback_DS.Correct(trial) = Nback_DS.Resp(trial) == Nback_DS.Nback_Target(trial);
                
                
                tEnd = GetSecs;
                rt = tEnd - tstart;
                Nback_DS.RT(trial) = rt;
                
                respToBeMade = false;
                
            end
            
            % Provide feedback.
        elseif respToBeMade == false && isnan(Nback_DS.Correct(trial))
            Screen('FillRect', window, rectColor, Targ_Rect);
            
        elseif respToBeMade == false && Nback_DS.Correct(trial) == true
            Screen('FillRect', window, [0 1 0], Targ_Rect);
          
        elseif respToBeMade == false && Nback_DS.Correct(trial) == false
            Screen('FillRect', window, [1 0 0], Targ_Rect);
            
        end
        
        % Update the sum of correct responses.
%         numberString = [num2str(nansum(Nback_DS.Correct)) , ' / ' , num2str(nansum(Nback_DS.Nback_Target))];
%         DrawFormattedText(window, numberString, LHCenter - 20, yCenter + (5 * VAtopix), white);
         DrawFormattedText(window, levelSting, RHCenter - 20 , yCenter + (5 * VAtopix), white);
        
        % Flip to the screen
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi); t = t + 1;
        
        
        
    end
    
       % Now we present the isi interval
    for frame = 1:isiTimeFrames
        Pos_DS.NbackTrial(t) = trial;
        % Draw the empty grid matrix
%         Screen('FrameRect', window, rectColor, allRects, penWidthPixels);
%         DrawFormattedText(window, numberString, LHCenter - 20, yCenter + (5 * VAtopix), white);
        DrawFormattedText(window, levelSting, RHCenter - 20 , yCenter + (5 * VAtopix), white);
        Screen('DrawLines', window, allCoords,...
            penWidthPixels, white, [0 0], 2);
%         
        Screen('FrameRect', window, rectColor, TrackingBoxLoc, penWidthPixels);
        Screen('DrawLine', window, rectColor, Pos_DS.InputSignal_Pix_X(t), TrackingBoxLoc(2), Pos_DS.InputSignal_Pix_X(t), TrackingBoxLoc(4), penWidthPixels);
        Screen('DrawLine', window, rectColor, TrackingBoxLoc(1), Pos_DS.InputSignal_Pix_Y(t), TrackingBoxLoc(3) , Pos_DS.InputSignal_Pix_Y(t), penWidthPixels);
%         centeredOval = CenterRectOnPointd(baseTrackingOval, Pos_DS.InputSignal_Pix_X(t),  Pos_DS.InputSignal_Pix_Y(t));
        %         Screen('FillOval',window, TrackingOvalColor, centeredOval);
        
        
        [Pos_DS , centeredOval] = DrawTarget(Pos_DS,joy,window,ifi,t,RHCenter,yCenter,VAtopix,baseOval,stick_def,xp,yp,CH_XsigPix,CH_XsigVA,CH_YsigPix,CH_YsigVA,WaveSpeedDuration_Up,WaveSpeedDuration_Dn,InZone,NudgeZone);
        if Pos_DS.InNudgeZone(t) == 0 && Condition == 'Nudge'
            [Pos_DS , Nudge_i]  = StickNudge_8deg(Pos_DS,ifi,t,Nudge_Signal,Nudge_i);
        end
        levelSting = ['LVL: ', num2str(Pos_DS.TrackingLevel(t)) , ' / ' , num2str((length(CH_XsigPix(1,:))))];
        Pos_DS.StickForce_X(t) =  Pos_DS.StickCentreForce_X(t) + Pos_DS.StickNudge_Xf(t);
        Pos_DS.StickForce_Y(t) =  Pos_DS.StickCentreForce_Y(t) + Pos_DS.StickNudge_Yf(t);
        
        force(joy,[1 2],[Pos_DS.StickForce_X(t) Pos_DS.StickForce_Y(t)]);
        %         Screen('FillOval',window, OvalColor, centeredOval);
        
        
        if respToBeMade == true           
            [keyIsDown,secs, keyCode] = KbCheck;
            if keyCode(escapeKey)
                ShowCursor;
                sca;
                return
            elseif keyCode(SpaceKey)
                
                % Record the trial data into out data matrix
                response = 1;
                Nback_DS.Resp(trial) = response;
                Nback_DS.Correct(trial) = Nback_DS.Resp(trial) == Nback_DS.Nback_Target(trial);
                
                
                tEnd = GetSecs;
                rt = tEnd - tstart;
                Nback_DS.RT(trial) = rt;
                
                respToBeMade = false;
                
            end
            

            
        end
        
        
        % Update the sum of correct responses.
%         numberString = [num2str(nansum(Nback_DS.Correct)) , ' / ' , num2str(nansum(Nback_DS.Nback_Target))];
        
        % Flip to the screen
        vbl = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        t = t+1; % Increment the tracking signal
    end
    
    
    
    
end

%  End of experiment screen. We clear the screen once they have made their
%  response
DrawFormattedText(window, 'Experiment Finished \n\n Press Any Key To Exit',...
    'center', 'center', white);
Screen('Flip', window);
KbStrokeWait;
sca;

%%%%%%%%%%%%%%%%%%%%%%%%

save('Participant001_TrackingTaskOnly.mat','Nback_DS','Demographics');


%%%%%%%%%%%%%%%%%%%%%%%







