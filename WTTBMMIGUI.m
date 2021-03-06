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

% Last Modified by GUIDE v2.5 17-May-2017 07:33:07

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

% UIWAIT makes WTTBMMIGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Choose default command line output for WTTBMMIGUI
handles.output = hObject;

%get the value of the Exposure Time
handles.ExposureTimeSet = str2double(get(handles.ExposureTime,'String')); 

%get the value of the Number of Pictures
handles.NumberOfPicturesSet = str2double(get(handles.NumberOfPictures,'String'));

%set all picture dimensions and sliders
handles.Top = 1;
handles.Bottom = 1024;
handles.Left = 1;
handles.Right = 1280;

%Set the sliders for the pictures
set(handles.PicHieghtBtoT,'Value',1024);
set(handles.PicWidthRtoL,'Value',1280);

%Set the step on the sliders
set(handles.PicHieghtTtoB,'SliderStep', [1/1024,10/1024]);
set(handles.PicHieghtBtoT,'SliderStep', [1/1024,10/1024]);
set(handles.PicWidthLtoR,'SliderStep', [1/1280,10/1280]);
set(handles.PicWidthRtoL,'SliderStep', [1/1280,10/1280]);

%Turn slider Ui Variables into integers
handles.TopSet = get(handles.PicHieghtTtoB,'Value')+1;
handles.BottomSet = get(handles.PicHieghtBtoT,'Value');
handles.RightSet = get(handles.PicWidthRtoL,'Value');
handles.LeftSet = get(handles.PicWidthLtoR,'Value')+1;

%Put data in the workspace
assignin('base','ExposureTime', handles.ExposureTimeSet)
assignin('base','NumberOfPictures',handles.NumberOfPicturesSet);
assignin('base','Top',handles.TopSet);
assignin('base','Bottom',handles.BottomSet);
assignin('base','Left',handles.LeftSet);
assignin('base','Right',handles.RightSet);

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = WTTBMMIGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Get default command line output from handles structure
varargout{1} = handles.output;

function NumberOfPictures_Callback(hObject, eventdata, handles)
% hObject    handle to NumberOfPictures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumberOfPictures as text
%        str2double(get(hObject,'String')) returns contents of NumberOfPictures as a double


% --- Executes during object creation, after setting all properties.
function NumberOfPictures_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumberOfPictures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ExposureTime_Callback(hObject, eventdata, handles)
% hObject    handle to ExposureTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ExposureTime as text
%        str2double(get(hObject,'String')) returns contents of ExposureTime as a double


% --- Executes during object creation, after setting all properties.
function ExposureTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ExposureTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function PicHieghtTtoB_Callback(hObject, eventdata, handles)
% hObject    handle to PicHieghtTtoB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


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
function PicWidthLtoR_Callback(hObject, eventdata, handles)
% hObject    handle to PicWidthLtoR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


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
function PicHieghtBtoT_Callback(hObject, eventdata, handles)
% hObject    handle to PicHieghtBtoT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function PicHieghtBtoT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PicHieghtBtoT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in UpdateAll.
function UpdateAll_Callback(hObject, eventdata, handles)
% hObject    handle to UpdateAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the value of the Exposure Time
handles.ExposureTimeSet = str2double(get(handles.ExposureTime,'String')); 

%get the value of the Number of Pictures
handles.NumberOfPicturesSet = str2double(get(handles.NumberOfPictures,'String'));

%Turn slider Ui Variables into integers
handles.TopSet = get(handles.PicHieghtTtoB,'Value')+1;
handles.BottomSet = get(handles.PicHieghtBtoT,'Value');
handles.RightSet = get(handles.PicWidthRtoL,'Value');
handles.LeftSet = get(handles.PicWidthLtoR,'Value')+1;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','ExposureTime', handles.ExposureTimeSet)
assignin('base','NumberOfPictures', handles.NumberOfPicturesSet)


% --- Executes on button press in PreviewVid.
function PreviewVid_Callback(hObject, eventdata, handles)
% hObject    handle to PreviewVid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Saturation.
function Saturation_Callback(hObject, eventdata, handles)
% hObject    handle to Saturation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take a picture and add it for analysis
Data = TakePicture(handles.ExposureTimeSet,handles.LeftSet,handles.RightSet,handles.TopSet,handles.BottomSet);

%make histogram of saturation
histogram(Data);
Datamaxcol = max(Data);
Datamaxrow = max(Datamaxcol);
Datamaxrowgrn = Datamaxrow;
xlabel('Pixel Values for Green Channel');
title(['          Max Value is ', num2str(Datamaxrowgrn) ,'']);

%warn user of picture saturation
MMIWarning(Data);

% --- Executes on button press in PreviewPic.
function PreviewPic_Callback(hObject, eventdata, handles)
% hObject    handle to PreviewPic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Take a picture and show it in axes 1
Data = TakePicture(handles.ExposureTimeSet,handles.LeftSet,handles.RightSet,handles.TopSet,handles.BottomSet);
Data = flipud(uint8(Data));

% Display Image
imshow(Data(:,:));