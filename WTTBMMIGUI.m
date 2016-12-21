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

% Last Modified by GUIDE v2.5 21-Dec-2016 12:59:52

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
   WarningString = ['Picture is satruated. To reduce the saturation set the exposure time to a lower value.'...
   'The exposure time ranges from 0.0624-99.8667. You can only set the Exposure Time once during MMI'... 
' so try to get the max green pixel value about 200. If the max value is 200 your other pictures should allow for below 255'];
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


% Update handles structure
guidata(hObject, handles);

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
LaserPolarization = StokesVectorOfLaser(handles.FinalPictureOrangeLinear,FinalPictureGreenLinear,...
    FinalPictureBlueLinear,FinalPictureBlueCircular);

%Send the Laser Polarization to the workspace
assignin('base','LaserPolarization', LaserPolarization)

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


% --- Executes on button press in OlCP1.
function OlCP1_Callback(hObject, eventdata, handles)
% hObject    handle to GlCP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%do this if the user does not select a polarization state for polarizer 2
if get(handles.OlCP2,'Value') + get(handles.GlCP2,'Value') + get(handles.BlCP2,'Value')...
        + get(handles.BcCP2,'Value') == 0
    warndlg('please select a polarization state for polarizer 2 and take the picture again')
end

%do this if the user selects more than one state for the second polarizer
if get(handles.OlCP2,'Value') + get(handles.GlCP2,'Value') + get(handles.BlCP2,'Value') ...
        + get(handles.BcCP2,'Value') > 1
    WarningString = ['You have selected more than one setting for polarizer 2 please select only one setting and take the '...
        'picture again'];
    warndlg(WarningString)
end

switch 1
    case get(handles.OlCP2,'Value')
        handles.Cal_OlCP1_OlCP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','Cal_OlCP1_OlCP2', handles.Cal_OlCP1_OlCP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.GlCP2,'Value')
        handles.Cal_OlCP1_GlCP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','Cal_OlCP1_GlCP2', handles.Cal_OlCP1_GlCP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.BlCP2,'Value')
        handles.Cal_OlCP1_BlCP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','Cal_OlCP1_BlCP2', handles.Cal_OlCP1_BlCP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.BcCP2,'Value')
        handles.Cal_OlCP1_BcCP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','Cal_OlCP1_BcCP2', handles.Cal_OlCP1_BcCP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
end


% --- Executes on button press in GlCP1.
function GlCP1_Callback(hObject, eventdata, handles)
% hObject    handle to GlCP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%do this if the user does not select a polarization state for polarizer 2

if get(handles.OlCP2,'Value') + get(handles.GlCP2,'Value') + get(handles.BlCP2,'Value')...
       + get(handles.BcCP2,'Value') == 0
    warndlg('please select a polarization state for polarizer 2')
end

%do this if the user selects more than one state for the second polarizer
if get(handles.OlCP2,'Value') + get(handles.GlCP2,'Value') + get(handles.BlCP2,'Value') ...
        + get(handles.BcCP2,'Value') > 1
    WarningString = ['You have selected more than one setting for polarizer 2 please select only one setting and take the'...
        'picture again'];
    warndlg(WarningString)
end

switch 1
    case get(handles.OlCP2,'Value')
        handles.Cal_GlCP1_OlCP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','Cal_GlCP1_OlCP2', handles.Cal_GlCP1_OlCP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.GlCP2,'Value')
        handles.Cal_GlCP1_GlCP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','Cal_GlCP1_GlCP2', handles.Cal_GlCP1_GlCP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.BlCP2,'Value')
        handles.Cal_GlCP1_BlCP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','Cal_GlCP1_BlCP2', handles.Cal_GlCP1_BlCP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.BcCP2,'Value')
        handles.Cal_GlCP1_BcCP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','Cal_GlCP1_BcCP2', handles.Cal_GlCP1_BcCP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
end

% --- Executes on button press in BlCP1.
function BlCP1_Callback(hObject, eventdata, handles)
% hObject    handle to BlCP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%do this if the user does not select a polarization state for polarizer 2

if get(handles.OlCP2,'Value') + get(handles.GlCP2,'Value') + get(handles.BlCP2,'Value')...
        + get(handles.BcCP2,'Value') == 0
    warndlg('please select a polarization state for polarizer 2')
end

%do this if the user selects more than one state for the second polarizer
if get(handles.OlCP2,'Value') + get(handles.GlCP2,'Value') + get(handles.BlCP2,'Value') ...
        + get(handles.BcCP2,'Value') > 1
    WarningString = ['You have selected more than one setting for polarizer 2 please select only one setting and take the'...
        'picture again'];
    warndlg(WarningString)
end

switch 1
    case get(handles.OlCP2,'Value')
        handles.Cal_BlCP1_OlCP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','Cal_BlCP1_OlCP2', handles.Cal_BlCP1_OlCP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.GlCP2,'Value')
        handles.Cal_BlCP1_GlCP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','Cal_BlCP1_GlCP2', handles.Cal_BlCP1_GlCP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.BlCP2,'Value')
        handles.Cal_BlCP1_BlCP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','Cal_BlCP1_BlCP2', handles.Cal_BlCP1_BlCP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.BcCP2,'Value')
        handles.Cal_BlCP1_BcCP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','Cal_BlCP1_BcCP2', handles.Cal_BlCP1_BcCP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
end

% --- Executes on button press in BcCP1.
function BcCP1_Callback(hObject, eventdata, handles)
% hObject    handle to BcCP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%do this if the user does not select a polarization state for polarizer 2

if get(handles.OlCP2,'Value') + get(handles.GlCP2,'Value') + get(handles.BlCP2,'Value')...
       + get(handles.BcCP2,'Value') == 0
    warndlg('please select a polarization state for polarizer 2')
end

%do this if the user selects more than one state for the second polarizer
if get(handles.OlCP2,'Value') + get(handles.GlCP2,'Value') + get(handles.BlCP2,'Value') ...
        + get(handles.BcCP2,'Value') > 1
    WarningString = ['You have selected more than one setting for polarizer 2 please select only one setting and take the'...
        'picture again'];
    warndlg(WarningString)
end

switch 1
    case get(handles.OlCP2,'Value')
        handles.Cal_BcCP1_OlCP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','Cal_BcCP1_OlCP2', handles.Cal_BcCP1_OlCP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.GlCP2,'Value')
        handles.Cal_BcCP1_GlCP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','Cal_BcCP1_GlCP2', handles.Cal_BcCP1_GlCP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.BlCP2,'Value')
        handles.Cal_BcCP1_BlCP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','Cal_BcCP1_BlCP2', handles.Cal_BcCP1_BlCP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.BcCP2,'Value')
        handles.Cal_BcCP1_BcCP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','Cal_BcCP1_BcCP2', handles.Cal_BcCP1_BcCP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
end

% --- Executes on button press in OlCP2.
function OlCP2_Callback(hObject, eventdata, handles)
% hObject    handle to OlCP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OlCP2


% --- Executes on button press in GlCP2.
function GlCP2_Callback(hObject, eventdata, handles)
% hObject    handle to GlCP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GlCP2


% --- Executes on button press in BlCP2.
function BlCP2_Callback(hObject, eventdata, handles)
% hObject    handle to BlCP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BlCP2


% --- Executes on button press in BcCP2.
function BcCP2_Callback(hObject, eventdata, handles)
% hObject    handle to BcCP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BcCP2



% --- Executes on button press in OlMP1.
function OlMP1_Callback(hObject, eventdata, handles)
% hObject    handle to OlMP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%do this if the user does not select a polarization state for polarizer 2
if get(handles.OlMP2,'Value') + get(handles.GlMP2,'Value') + get(handles.BlMP2,'Value')...
        + get(handles.BcMP2,'Value') == 0
    warndlg('please select a polarization state for polarizer 2 and take the picture again')
end

%do this if the user selects more than one state for the second polarizer
if get(handles.OlMP2,'Value') + get(handles.GlMP2,'Value') + get(handles.BlMP2,'Value') ...
        + get(handles.BcMP2,'Value') > 1
    WarningString = ['You have selected more than one setting for polarizer 2 please select only one setting and take the '...
        'picture again'];
    warndlg(WarningString)
end

switch 1
    case get(handles.OlMP2,'Value')
        handles.MMI_OlMP1_OlMP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','MMI_OlMP1_OlMP2', handles.MMI_OlMP1_OlMP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.GlMP2,'Value')
        handles.MMI_OlMP1_GlMP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','MMI_OlMP1_GlMP2', handles.MMI_OlMP1_GlMP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.BlMP2,'Value')
        handles.MMI_OlMP1_BlMP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','MMI_OlMP1_BlMP2', handles.MMI_OlMP1_BlMP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.BcMP2,'Value')
        handles.MMI_OlMP1_BcMP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','MMI_OlMP1_BcMP2', handles.MMI_OlMP1_BcMP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
end

% --- Executes on button press in GlMP1.
function GlMP1_Callback(hObject, eventdata, handles)
% hObject    handle to GlMP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.OlMP2,'Value') + get(handles.GlMP2,'Value') + get(handles.BlMP2,'Value')...
        + get(handles.BcMP2,'Value') == 0
    warndlg('please select a polarization state for polarizer 2 and take the picture again')
end

%do this if the user selects more than one state for the second polarizer
if get(handles.OlMP2,'Value') + get(handles.GlMP2,'Value') + get(handles.BlMP2,'Value') ...
        + get(handles.BcMP2,'Value') > 1
    WarningString = ['You have selected more than one setting for polarizer 2 please select only one setting and take the '...
        'picture again'];
    warndlg(WarningString)
end

switch 1
    case get(handles.OlMP2,'Value')
        handles.MMI_GlMP1_OlMP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','MMI_GlMP1_OlMP2', handles.MMI_GlMP1_OlMP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.GlMP2,'Value')
        handles.MMI_GlMP1_GlMP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','MMI_GlMP1_GlMP2', handles.MMI_GlMP1_GlMP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.BlMP2,'Value')
        handles.MMI_GlMP1_BlMP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','MMI_GlMP1_BlMP2', handles.MMI_GlMP1_BlMP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.BcMP2,'Value')
        handles.MMI_GlMP1_BcMP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','MMI_GlMP1_BcMP2', handles.MMI_GlMP1_BcMP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
end

% --- Executes on button press in BlMP1.
function BlMP1_Callback(hObject, eventdata, handles)
% hObject    handle to BlMP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.OlMP2,'Value') + get(handles.GlMP2,'Value') + get(handles.BlMP2,'Value')...
        + get(handles.BcMP2,'Value') == 0
    warndlg('please select a polarization state for polarizer 2 and take the picture again')
end

%do this if the user selects more than one state for the second polarizer
if get(handles.OlMP2,'Value') + get(handles.GlMP2,'Value') + get(handles.BlMP2,'Value') ...
        + get(handles.BcMP2,'Value') > 1
    WarningString = ['You have selected more than one setting for polarizer 2 please select only one setting and take the '...
        'picture again'];
    warndlg(WarningString)
end

switch 1
    case get(handles.OlMP2,'Value')
        handles.MMI_BlMP1_OlMP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','MMI_BlMP1_OlMP2', handles.MMI_BlMP1_OlMP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.GlMP2,'Value')
        handles.MMI_BlMP1_GlMP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','MMI_BlMP1_GlMP2', handles.MMI_BlMP1_GlMP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.BlMP2,'Value')
        handles.MMI_BlMP1_BlMP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','MMI_BlMP1_BlMP2', handles.MMI_BlMP1_BlMP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.BcMP2,'Value')
        handles.MMI_BlMP1_BcMP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','MMI_BlMP1_BcMP2', handles.MMI_BlMP1_BcMP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
end


% --- Executes on button press in BcMP1.
function BcMP1_Callback(hObject, eventdata, handles)
% hObject    handle to BcMP1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%do this if the user does not select a polarization state for polarizer 2
if get(handles.OlMP2,'Value') + get(handles.GlMP2,'Value') + get(handles.BlMP2,'Value')...
        + get(handles.BcMP2,'Value') == 0
    warndlg('please select a polarization state for polarizer 2 and take the picture again')
end

%do this if the user selects more than one state for the second polarizer
if get(handles.OlMP2,'Value') + get(handles.GlMP2,'Value') + get(handles.BlMP2,'Value') ...
        + get(handles.BcMP2,'Value') > 1
    WarningString = ['You have selected more than one setting for polarizer 2 please select only one setting and take the '...
        'picture again'];
    warndlg(WarningString)
end

switch 1
    case get(handles.OlMP2,'Value')
        handles.MMI_BcMP1_OlMP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','MMI_BcMP1_OlMP2', handles.MMI_BcMP1_OlMP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.GlMP2,'Value')
        handles.MMI_BcMP1_GlMP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','MMI_BcMP1_GlMP2', handles.MMI_BcMP1_GlMP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.BlMP2,'Value')
        handles.MMI_BcMP1_BlMP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','MMI_BcMP1_BlMP2', handles.MMI_BcMP1_BlMP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
    case get(handles.BcMP2,'Value')
        handles.MMI_BcMP1_BcMP2 = Average5Pics(handles.ExposureTime);
        %Put data in the workspace
        assignin('base','MMI_BcMP1_BcMP2', handles.MMI_BcMP1_BcMP2);
        % Update handles structure
        guidata(hObject, handles);
        %Inform user camera is done working
        warndlg('Capture Finished')
end



% --- Executes on button press in OlMP2.
function OlMP2_Callback(hObject, eventdata, handles)
% hObject    handle to OlMP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OlMP2


% --- Executes on button press in GlMP2.
function GlMP2_Callback(hObject, eventdata, handles)
% hObject    handle to GlMP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GlMP2


% --- Executes on button press in BlMP2.
function BlMP2_Callback(hObject, eventdata, handles)
% hObject    handle to BlMP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BlMP2


% --- Executes on button press in BcMP2.
function BcMP2_Callback(hObject, eventdata, handles)
% hObject    handle to BcMP2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of BcMP2




% --- Executes on button press in SumOfGrn.
function SumOfGrn_Callback(hObject, eventdata, handles)
% hObject    handle to SumOfGrn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%sum the columns
handles.SumOfBlueCircularCol = sum(handles.FinalPictureBlueCircular);

%sum the rows for one integer
handles.SumOfBlueCircular = sum(handles.SumOfBlueCircularCol(:,:,2));


%Put data in the workspace
assignin('base','SumOfBlueCircular', handles.SumOfBlueCircular);

