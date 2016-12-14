function varargout = WTTBMMIGUI(varargin)
% WTTBMMIGUI MATLAB code for WTTBMMIGUI.fig
%      WTTBMMIGUI, by itself, creates a new WTTBMMIGUI or raises the existing
%      singleton*.
%
%      H = WTTBMMIGUI returns the handle to a new WTTBMMIGUI or the handle to
%      the existing singleton*.
%
%      WTTBMMIGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WTTBMMIGUI.M with the given input arguments.
%
%      WTTBMMIGUI('Property','Value',...) creates a new WTTBMMIGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WTTBMMIGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WTTBMMIGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WTTBMMIGUI

% Last Modified by GUIDE v2.5 13-Dec-2016 20:23:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WTTBMMIGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @WTTBMMIGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before WTTBMMIGUI is made visible.
function WTTBMMIGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WTTBMMIGUI (see VARARGIN)

% Choose default command line output for WTTBMMIGUI
handles.output = hObject;

%get the value of the Exposure Time
handles.ExposureTime = str2double(get(handles.edit2,'String')); 

%Put data in the workspace
assignin('base','ExposureTime', handles.ExposureTime)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes WTTBMMIGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = WTTBMMIGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pbPreview.
function pbPreview_Callback(hObject, eventdata, handles)
% hObject    handle to pbPreview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take a picture and show it in axes 1
Data = TakePicture(handles.ExposureTime);
% Display Image
imshow(Data);



% --- Executes on button press in pbSaturation.
function pbSaturation_Callback(hObject, eventdata, handles)
% hObject    handle to pbSaturation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take a picture and add it for analysis
Data = TakePicture(handles.ExposureTime);

%make histogram of saturation
histogram(Data(:,:,2));
Datamaxcol = max(Data);
Datamaxrow = max(Datamaxcol);
Datamaxrowgrn = Datamaxrow(1,2);
xlabel('Pixel Values for Green Channel');
title(['          Max Value is ', num2str(Datamaxrowgrn) ,'']);

%Tell user that the picture is saturated
if Datamaxrowgrn == 255 
   WarningString = ['Picture is satruated. To reduce the saturation set the pixel clock to a higher value.'...
   'The pixel clock ranges from 5-40 in icrements of 1. You can only set the pixel clock once during MMI'... 
' so try to get the max value about 200. If the max value is 200 your other pictures should allow for below 255'];
    warndlg(WarningString)
end

 
% --- Executes on button press in pbOrangeLinear.
function pbOrangeLinear_Callback(hObject, eventdata, handles)
% hObject    handle to pbOrangeLinear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
AverageData = (Data(:,:,:,1)+Data(:,:,:,2)+Data(:,:,:,3)+Data(:,:,:,4)+Data(:,:,:,5))/5;

%subtract noise
handles.FinalPictureOrangeLinear = AverageData;

%Put data in the workspace
assignin('base','OrangeLinear', handles.FinalPictureOrangeLinear)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowOrangeLinear = Datamaxrow(1,2);

if DatamaxrowOrangeLinear == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pbGreenLinear.
function pbGreenLinear_Callback(hObject, eventdata, handles)
% hObject    handle to pbGreenLinear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
AverageData = (Data(:,:,:,1)+Data(:,:,:,2)+Data(:,:,:,3)+Data(:,:,:,4)+Data(:,:,:,5))/5;

%subtract noise
handles.FinalPictureGreenLinear = AverageData;

%Put data in the workspace
assignin('base','GreenLinear', handles.FinalPictureGreenLinear)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowGreenLinear = Datamaxrow(1,2);

if DatamaxrowGreenLinear == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pbBlueLinear.
function pbBlueLinear_Callback(hObject, eventdata, handles)
% hObject    handle to pbBlueLinear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
AverageData = (Data(:,:,:,1)+Data(:,:,:,2)+Data(:,:,:,3)+Data(:,:,:,4)+Data(:,:,:,5))/5;

%subtract noise
handles.FinalPictureBlueLinear = AverageData;

%Put data in the workspace
assignin('base','BlueLinear', handles.FinalPictureBlueLinear)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowBlueLinear = Datamaxrow(1,2);

if DatamaxrowBlueLinear == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pbBlueCircular.
function pbBlueCircular_Callback(hObject, eventdata, handles)
% hObject    handle to pbBlueCircular (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
AverageData = (Data(:,:,:,1)+Data(:,:,:,2)+Data(:,:,:,3)+Data(:,:,:,4)+Data(:,:,:,5))/5;

%subtract noise
handles.FinalPictureBlueCircular = AverageData;

%Put data in the workspace
assignin('base','BlueCircular', handles.FinalPictureBlueCircular)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowBlueCircular = Datamaxrow(1,2);

if DatamaxrowBlueCircular == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pbStokesVector.
function pbStokesVector_Callback(hObject, eventdata, handles)
% hObject    handle to pbStokesVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%This is to sum the polarization matrices in order to solve the inverse
%multiplication

%Get variable from GUI handles Structure
FinalPictureOrangeLinear = handles.FinalPictureOrangeLinear;
FinalPictureGreenLinear = handles.FinalPictureGreenLinear;
FinalPictureBlueLinear = handles.FinalPictureBlueLinear;
FinalPictureBlueCircular = handles.FinalPictureBlueCircular;

%Call function to get Polarization of laser
handles.LaserPolarization = StokesVectorOfLaser(FinalPictureOrangeLinear,FinalPictureGreenLinear,...
    FinalPictureBlueLinear,FinalPictureBlueCircular);

%Send the Laser Polarization to the workspace
assignin('base','LaserPolarization', handles.LaserPolarization)

%Let user know Polarization is in workspace
warndlg('Check workspace for polarization of laser!');

% Update handles structure
guidata(hObject, handles);



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in UpdateExposureTime.
function UpdateExposureTime_Callback(hObject, eventdata, handles)
% hObject    handle to UpdateExposureTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the value of the Exposure Time
handles.ExposureTime = str2double(get(handles.edit2,'String')); 

%Put data in the workspace
assignin('base','ExposureTime', handles.ExposureTime)

% Update handles structure
guidata(hObject, handles);




