function varargout = CharacterizationGUI(varargin)
% CHARACTERIZATIONGUI MATLAB code for CharacterizationGUI.fig
%      CHARACTERIZATIONGUI, by itself, creates a new CHARACTERIZATIONGUI or raises the existing
%      singleton*.
%
%      H = CHARACTERIZATIONGUI returns the handle to a new CHARACTERIZATIONGUI or the handle to
%      the existing singleton*.
%
%      CHARACTERIZATIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHARACTERIZATIONGUI.M with the given input arguments.
%
%      CHARACTERIZATIONGUI('Property','Value',...) creates a new CHARACTERIZATIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CharacterizationGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CharacterizationGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CharacterizationGUI

% Last Modified by GUIDE v2.5 13-Mar-2017 14:10:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CharacterizationGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CharacterizationGUI_OutputFcn, ...
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


% --- Executes just before CharacterizationGUI is made visible.
function CharacterizationGUI_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CharacterizationGUI (see VARARGIN)

% Choose default command line output for CharacterizationGUI
handles.output = hObject;

%get the value of the Exposure Time
handles.ExposureTime = str2double(get(handles.edit2,'String')); 

%Put data in the workspace
assignin('base','ExposureTime', handles.ExposureTime)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CharacterizationGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CharacterizationGUI_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit2_Callback(~, ~, ~)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, ~, ~)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbPreview.
function pbPreview_Callback(~, ~, handles)
% hObject    handle to pbPreview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take a picture and show it in axes 1
Data = TakePicture(handles.ExposureTime);
% Display Image
imshow(Data(:,:,:));

% --- Executes on button press in UpdateExposureTime.
function UpdateExposureTime_Callback(hObject, ~, handles)
% hObject    handle to UpdateExposureTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%get the value of the Exposure Time
handles.ExposureTime = str2double(get(handles.edit2,'String')); 

%Put data in the workspace
assignin('base','ExposureTime', handles.ExposureTime)

% Update handles structure
guidata(hObject, handles);

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
   WarningString = ['Picture is satruated. To reduce the saturation set the exposure time to a lower value.'...
   'The exposure time ranges from 0.0624-99.8667. You can only set the Exposure Time once during MMI'... 
' so try to get the max green pixel value about 200. If the max value is 200 your other pictures should allow for below 255'];
    warndlg(WarningString)
end

 
% --- Executes on button press in Lin0Dgr.
function Lin0Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin0Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;

handles.Lin0DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin0Dgr', handles.Lin0DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowLin0Dgr = Datamaxrow(1,2);

if DatamaxrowLin0Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% --- Executes on button press in Lin20Dgr.
function Lin20Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin20Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;


%subtract noise
handles.Lin20DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin20Dgr', handles.Lin20DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowLin20Dgr = Datamaxrow(1,2);

if DatamaxrowLin20Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% --- Executes on button press in Lin40Dgr.
function Lin40Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin40Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;


%subtract noise
handles.Lin40DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin40Dgr', handles.Lin40DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowLin40Dgr = Datamaxrow(1,2);

if DatamaxrowLin40Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% --- Executes on button press in Lin60Dgr.
function Lin60Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin60Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;

%subtract noise
handles.Lin60DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin60Dgr', handles.Lin60DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowLin60Dgr = Datamaxrow(1,2);

if DatamaxrowLin60Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% --- Executes on button press in Lin80Dgr.
function Lin80Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin80Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;

%subtract noise
handles.Lin80DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin80Dgr', handles.Lin80DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowLin80Dgr = Datamaxrow(1,2);

if DatamaxrowLin80Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% --- Executes on button press in Lin100Dgr.
function Lin100Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin100Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;

%subtract noise
handles.Lin100DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin100Dgr', handles.Lin100DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowLin100Dgr = Datamaxrow(1,2);

if DatamaxrowLin100Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% --- Executes on button press in Lin120Dgr.
function Lin120Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin120Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;


%subtract noise
handles.Lin120DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin120Dgr', handles.Lin120DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowLin120Dgr = Datamaxrow(1,2);

if DatamaxrowLin120Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% --- Executes on button press in Lin140Dgr.
function Lin140Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin140Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;

%subtract noise
handles.Lin140DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin140Dgr', handles.Lin140DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowLin140Dgr = Datamaxrow(1,2);

if DatamaxrowLin140Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% --- Executes on button press in Lin160Dgr.
function Lin160Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin160Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;


%subtract noise
handles.Lin160DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin160Dgr', handles.Lin160DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowLin160Dgr = Datamaxrow(1,2);

if DatamaxrowLin160Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end


% --- Executes on button press in Lin180Dgr.
function Lin180Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin180Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;

%subtract noise
handles.Lin180DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin180Dgr', handles.Lin180DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowLin180Dgr = Datamaxrow(1,2);

if DatamaxrowLin180Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% --- Executes on button press in Cir0Dgr.
function Cir0Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Cir0Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;


%subtract noise
handles.Cir0DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir0Dgr', handles.Cir0DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowCir0Dgr = Datamaxrow(1,2);

if DatamaxrowCir0Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end


% --- Executes on button press in Cir20Dgr.
function Cir20Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Cir20Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;

%subtract noise
handles.Cir20DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir20Dgr', handles.Cir20DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowCir20Dgr = Datamaxrow(1,2);

if DatamaxrowCir20Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% --- Executes on button press in Cir40Dgr.
function Cir40Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Cir40Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;

%subtract noise
handles.Cir40DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir40Dgr', handles.Cir40DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowCir40Dgr = Datamaxrow(1,2);

if DatamaxrowCir40Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% --- Executes on button press in Cir60Dgr.
function Cir60Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Cir60Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;

%subtract noise
handles.Cir60DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir60Dgr', handles.Cir60DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowCir60Dgr = Datamaxrow(1,2);

if DatamaxrowCir60Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% --- Executes on button press in Cir80Dgr.
function Cir80Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Cir80Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;

%subtract noise
handles.Cir80DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir80Dgr', handles.Cir80DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowCir80Dgr = Datamaxrow(1,2);

if DatamaxrowCir80Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% --- Executes on button press in Cir100Dgr.
function Cir100Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Cir100Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;

%subtract noise
handles.Cir100DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir100Dgr', handles.Cir100DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowCir100Dgr = Datamaxrow(1,2);

if DatamaxrowCir100Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% --- Executes on button press in Cir120Dgr.
function Cir120Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Cir120Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;

%subtract noise
handles.Cir120DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir120Dgr', handles.Cir120DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowCir120Dgr = Datamaxrow(1,2);

if DatamaxrowCir120Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% --- Executes on button press in Cir140Dgr.
function Cir140Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Cir140Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;


%subtract noise
handles.Cir140DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir140Dgr', handles.Cir140DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowCir140Dgr = Datamaxrow(1,2);

if DatamaxrowCir140Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% --- Executes on button press in Cir160Dgr.
function Cir160Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Cir160Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;

%subtract noise
handles.Cir160DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir160Dgr', handles.Cir160DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowCir160Dgr = Datamaxrow(1,2);

if DatamaxrowCir160Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% --- Executes on button press in Cir180Dgr.
function Cir180Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Cir180Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;

%subtract noise
handles.Cir180DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir180Dgr', handles.Cir180DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(AverageData);
Datamaxrow = max(Datamaxcol);
DatamaxrowCir180Dgr = Datamaxrow(1,2);

if DatamaxrowCir180Dgr == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end


% --- Executes on button press in Black.
function Black_Callback(hObject, eventdata, handles)
% hObject    handle to Black (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;

%subtract noise
handles.BlackPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Black', handles.BlackPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(Data);
Datamaxrow = max(Datamaxcol);
DatamaxrowBlack = Datamaxrow(1,2);

if DatamaxrowBlack == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end

% --- Executes on button press in NoPolarizer.
function NoPolarizer_Callback(hObject, eventdata, handles)
% hObject    handle to NoPolarizer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take 5 pictures and average to make one
for ii = 1:5
Data(:,:,:,ii) = TakePicture(handles.ExposureTime);
end
SumData1 = sum(Data(:,:,2,1));
SumData2 = sum(Data(:,:,2,2));
SumData3 = sum(Data(:,:,2,3));
SumData4 = sum(Data(:,:,2,4));
SumData5 = sum(Data(:,:,2,5));

AvgSumData1 = sum(SumData1);
AvgSumData2 = sum(SumData2);
AvgSumData3 = sum(SumData3);
AvgSumData4 = sum(SumData4);
AvgSumData5 = sum(SumData5);

AverageData = (AvgSumData2 + AvgSumData3 + AvgSumData4 + AvgSumData5 + AvgSumData1)/5;

%subtract noise
handles.NoPolarizerPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','NoPolarizer', handles.NoPolarizerPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated

Datamaxcol = max(Data);
Datamaxrow = max(Datamaxcol);
DatamaxrowNoPolarizer = Datamaxrow(1,2);

if DatamaxrowNoPolarizer == 255 
   WarningString = ['Picture is satruated.You should always start with a picture saturation of about 200'... 
       'with your first picture. You must start over and retake all pictures because the MMI analysis will be affected.'];
    warndlg(WarningString)
end


% --- Executes on slider movement.
function PicWidthLtoR_Callback(hObject, eventdata, handles)
% hObject    handle to PicWidthLtoR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%get the position of the Right slider
handles.Left = get(hObject,'Value');
assignin(base,'Left',handles.Left);

% Update handles structure
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function PicWidthLtoR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PicWidthLtoR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function PicWidthRtoL_Callback(hObject, eventdata, handles)
% hObject    handle to PicWidthRtoL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%get the position of the Right slider
handles.Right = get(hObject,'Value');
assignin(base,'Right',handles.Right);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PicWidthRtoL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PicWidthRtoL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function PicHieghtTtoB_Callback(hObject, eventdata, handles)
% hObject    handle to PicHieghtTtoB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%get the position of the top slider
handles.Top = get(hObject,'Value');
assignin(base,'Top',handles.Top);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function PicHieghtTtoB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PicHieghtTtoB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function PicHieghtBtoT_Callback(hObject, eventdata, handles)
% hObject    handle to PicHieghtBtoT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%get the position of the bottom slider
handles.Bottom = get(hObject,'Value');
assignin(base,'Bottom',handles.Bottom);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PicHieghtBtoT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PicHieghtBtoT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
