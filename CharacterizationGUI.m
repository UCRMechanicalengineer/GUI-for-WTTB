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

% Last Modified by GUIDE v2.5 30-May-2017 09:57:29

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



function NumberOfPictures_Callback(~, ~, ~)
% hObject    handle to NumberOfPictures (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumberOfPictures as text
%        str2double(get(hObject,'String')) returns contents of NumberOfPictures as a double


% --- Executes during object creation, after setting all properties.
function NumberOfPictures_CreateFcn(hObject, ~, ~)
% hObject    handle to NumberOfPictures (see GCBO)
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
Data = TakePicture(handles.ExposureTimeSet,handles.LeftSet,handles.RightSet,handles.TopSet,handles.BottomSet);
Data = flipud(uint8(Data));

% Display Image
imshow(Data(:,:));


% --- Executes on button press in pbSaturation.
function pbSaturation_Callback(~, ~, handles)
% hObject    handle to pbSaturation (see GCBO)
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

% --- Executes on button press in Lin0Dgr.
function Lin0Dgr_Callback(hObject, ~, handles)
% hObject    handle to Lin0Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Lin0DgrPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin0Dgr', handles.Lin0DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Lin20Dgr.
function Lin20Dgr_Callback(hObject, ~, handles)
% hObject    handle to Lin20Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Lin20DgrPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin20Dgr', handles.Lin20DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Lin40Dgr.
function Lin40Dgr_Callback(hObject, ~, handles)
% hObject    handle to Lin40Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Lin40DgrPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin40Dgr', handles.Lin40DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Lin60Dgr.
function Lin60Dgr_Callback(hObject, ~, handles)
% hObject    handle to Lin60Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Lin60DgrPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin60Dgr', handles.Lin60DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Lin80Dgr.
function Lin80Dgr_Callback(hObject, ~, handles)
% hObject    handle to Lin80Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Lin80DgrPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin80Dgr', handles.Lin80DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Lin100Dgr.
function Lin100Dgr_Callback(hObject, ~, handles)
% hObject    handle to Lin100Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Lin100DgrPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin100Dgr', handles.Lin100DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Lin120Dgr.
function Lin120Dgr_Callback(hObject, ~, handles)
% hObject    handle to Lin120Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Lin120DgrPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin120Dgr', handles.Lin120DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Lin140Dgr.
function Lin140Dgr_Callback(hObject, ~, handles)
% hObject    handle to Lin140Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Lin140DgrPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin140Dgr', handles.Lin140DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Lin160Dgr.
function Lin160Dgr_Callback(hObject, ~, handles)
% hObject    handle to Lin160Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Lin160DgrPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin160Dgr', handles.Lin160DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Lin180Dgr.
function Lin180Dgr_Callback(hObject, ~, handles)
% hObject    handle to Lin180Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Lin180DgrPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Lin180Dgr', handles.Lin180DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Cir0Dgr.
function Cir0Dgr_Callback(hObject, ~, handles)
% hObject    handle to Cir0Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Cir0DgrPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir0Dgr', handles.Cir0DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Cir20Dgr.
function Cir20Dgr_Callback(hObject, ~, handles)
% hObject    handle to Cir20Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Cir20DgrPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir20Dgr', handles.Cir20DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Cir40Dgr.
function Cir40Dgr_Callback(hObject, ~, handles)
% hObject    handle to Cir40Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Cir40DgrPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir40Dgr', handles.Cir40DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Cir60Dgr.
function Cir60Dgr_Callback(hObject, ~, handles)
% hObject    handle to Cir60Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Cir60DgrPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir60Dgr', handles.Cir60DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Cir80Dgr.
function Cir80Dgr_Callback(hObject, ~, handles)
% hObject    handle to Cir80Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Cir80DgrPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir80Dgr', handles.Cir80DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Cir100Dgr.
function Cir100Dgr_Callback(hObject, ~, handles)
% hObject    handle to Cir100Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Cir100DgrPic = AverageData;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir100Dgr', handles.Cir100DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Cir120Dgr.
function Cir120Dgr_Callback(hObject, ~, handles)
% hObject    handle to Cir120Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Cir120DgrPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir120Dgr', handles.Cir120DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Cir140Dgr.
function Cir140Dgr_Callback(hObject, ~, handles)
% hObject    handle to Cir140Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Cir140DgrPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir140Dgr', handles.Cir140DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Cir160Dgr.
function Cir160Dgr_Callback(hObject, ~, handles)
% hObject    handle to Cir160Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Cir160DgrPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir160Dgr', handles.Cir160DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Cir180Dgr.
function Cir180Dgr_Callback(hObject, ~, handles)
% hObject    handle to Cir180Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%make variable in handles structure
handles.Cir180DgrPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Cir180Dgr', handles.Cir180DgrPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in Black.
function Black_Callback(hObject, ~, handles)
% hObject    handle to Black (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%subtract noise
handles.BlackPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','Black', handles.BlackPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in NoPolarizer.
function NoPolarizer_Callback(hObject, ~, handles)
% hObject    handle to NoPolarizer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%subtract noise
handles.NoPolarizerPic = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','NoPolarizer', handles.NoPolarizerPic)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on slider movement.
function PicWidthLtoR_Callback(hObject, ~, handles)
% hObject    handle to PicWidthLtoR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%get the position of the Right slider
handles.Left = get(handles.PicWidthLtoR,'Value');
assignin('base','Left',handles.Left);

% Update handles structure
guidata(hObject, handles);
% --- Executes during object creation, after setting all properties.
function PicWidthLtoR_CreateFcn(hObject, ~, ~)
% hObject    handle to PicWidthLtoR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function PicWidthRtoL_Callback(hObject, ~, handles)
% hObject    handle to PicWidthRtoL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%get the position of the Right slider
handles.Right = get(handles.PicWidthRtoL,'Value');
assignin('base','Right',handles.Right);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PicWidthRtoL_CreateFcn(hObject, ~, ~)
% hObject    handle to PicWidthRtoL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function PicHieghtTtoB_Callback(hObject, ~, handles)
% hObject    handle to PicHieghtTtoB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%get the position of the top slider
handles.Top = get(handles.PicHieghtTtoB,'Value');
assignin('base','Top',handles.Top);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function PicHieghtTtoB_CreateFcn(hObject, ~, ~)
% hObject    handle to PicHieghtTtoB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function PicHieghtBtoT_Callback(hObject, ~, handles)
% hObject    handle to PicHieghtBtoT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%get the position of the bottom slider
handles.Bottom = get(handles.PicHieghtBtoT,'Value');
assignin('base','Bottom',handles.Bottom);

% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PicHieghtBtoT_CreateFcn(hObject, ~, ~)
% hObject    handle to PicHieghtBtoT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in CP1Cir0Dgr.
function CP1Cir0Dgr_Callback(hObject, ~, handles)
% hObject    handle to CP1Cir0Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,...
    handles.Top,handles.Bottom,handles.Left,handles.Right);

%subtract noise
handles.CP1Cir0Dgr = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','CP1Cir0Dgr', handles.CP1Cir0Dgr)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in CP1Lin0Dgr.
function CP1Lin0Dgr_Callback(hObject, ~, handles)
% hObject    handle to CP1Lin0Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Take 5 pictures and average to make one

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%subtract noise
handles.CP1Lin0Dgr = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','CP1Lin0Dgr', handles.CP1Lin0Dgr)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);

% --- Executes on button press in CP1Lin45Dgr.
function CP1Lin45Dgr_Callback(hObject, ~, handles)
% hObject    handle to CP1Lin45Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Take 5 pictures and average to make one
%jj sets # of pictures to take

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%subtract noise
handles.CP1Lin45Dgr = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','CP1Lin45Dgr', handles.CP1Lin45Dgr)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);


% --- Executes on button press in CP1Lin90Dgr.
function CP1Lin90Dgr_Callback(hObject, ~, handles)
% hObject    handle to CP1Lin90Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get the average of the set number of pictures
AverageData = AverageNumberOfPicturesSet(handles.NumberOfPicturesSet,handles.ExposureTimeSet,handles.Top,handles.Bottom,handles.Left,handles.Right);

%subtract noise
handles.CP1Lin90Dgr = AverageData;

% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','CP1Lin90Dgr', handles.CP1Lin90Dgr)

%Inform user camera is done working
warndlg('Capture Finished')

%Tell user that the picture is saturated
MMIWarning(AverageData);




% --- Executes on button press in StokesVector.
function StokesVector_Callback(hObject, ~, handles)
% hObject    handle to StokesVector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

CP1Cir0Dgr = double(handles.CP1Cir0Dgr);
CP1Lin0Dgr = double(handles.CP1Lin0Dgr);
CP1Lin45Dgr = double(handles.CP1Lin45Dgr);
CP1Lin90Dgr = double(handles.CP1Lin90Dgr);
Black = double(handles.BlackPic);

%Subtract the black
CP1Cir0DgrMinusBl = (CP1Cir0Dgr-Black);
CP1Lin0DgrMinusBl = (CP1Lin0Dgr-Black);
CP1Lin45DgrMinusBl = (CP1Lin45Dgr-Black);
CP1Lin90DgrMinusBl = (CP1Lin90Dgr-Black);

%Sum for the total intensity
CP1Cir0DgrMinusBlSumCol = sum(CP1Cir0DgrMinusBl);
CP1Cir0DgrMinusBlSumRow = sum(CP1Cir0DgrMinusBlSumCol);

CP1Lin0DgrMinusBlSumCol = sum(CP1Lin0DgrMinusBl);
CP1Lin0DgrMinusBlSumRow = sum(CP1Lin0DgrMinusBlSumCol);

CP1Lin45DgrMinusBlSumCol = sum(CP1Lin45DgrMinusBl);
CP1Lin45DgrMinusBlSumRow = sum(CP1Lin45DgrMinusBlSumCol);

CP1Lin90DgrMinusBlSumCol = sum(CP1Lin90DgrMinusBl);
CP1Lin90DgrMinusBlSumRow = sum(CP1Lin90DgrMinusBlSumCol);



assignin('base','CP1Cir0DgrMinusBl',CP1Cir0DgrMinusBl)
assignin('base','CP1Lin0DgrMinusBl',CP1Lin0DgrMinusBl)
assignin('base','CP1Lin45DgrMinusBl',CP1Lin45DgrMinusBl)
assignin('base','CP1Lin90DgrMinusBl',CP1Lin90DgrMinusBl)

%Here is the total Intensity Matrix
TotalIntensityMatrix = [CP1Cir0DgrMinusBlSumRow;CP1Lin0DgrMinusBlSumRow;CP1Lin45DgrMinusBlSumRow;CP1Lin90DgrMinusBlSumRow];

%Mueller Matrix of CP1
MMCP1Cir0Dgr = evalin('base', 'MMCSAllDegCS(1,1:4,1)');
MMCP1Lin0Dgr = evalin('base','MMCSAllDegLS(1,1:4,1)');
MMCP1Lin45Dgr = evalin('base','MMCSAllDegLS(1,1:4,46)');
MMCP1Lin90Dgr = evalin('base','MMCSAllDegLS(1,1:4,91)');

%Here is the matrix for the inverse multiplication
CP1Matrix = [MMCP1Cir0Dgr;MMCP1Lin0Dgr;MMCP1Lin45Dgr;MMCP1Lin90Dgr];

%now multiply the sum of the images by the inverse of the polarization
%matrix
S = linsolve(CP1Matrix,TotalIntensityMatrix);

%normalizing the stokes vector
GeneratorPolarization = S/S(1,1)

%subtract noise
handles.GeneratorPolarization = GeneratorPolarization;


% Update handles structure
guidata(hObject, handles);

%Put data in the workspace
assignin('base','GeneratorPolarization', handles.GeneratorPolarization)
%d = GeneratorPolarization(:,1);
%set(handles.uitableStokesVector,'data',d);

function ExposureTime_Callback(~, ~, ~)
% hObject    handle to ExposureTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ExposureTime as text
%        str2double(get(hObject,'String')) returns contents of ExposureTime as a double



% --- Executes during object creation, after setting all properties.
function ExposureTime_CreateFcn(hObject, ~, ~)
% hObject    handle to ExposureTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Update.
function Update_Callback(hObject, ~, handles)
% hObject    handle to Update (see GCBO)
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


% --- Executes on button press in pbVideoPreview.
function pbVideoPreview_Callback(hObject, eventdata, handles)
% hObject    handle to pbVideoPreview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Add NET assembly
% May need to change specific location of library
NET.addAssembly('C:\Program Files\Thorlabs\Scientific Imaging\DCx Camera Support\Develop\DotNet\uc480DotNet.dll');
% Create camera object handle
cam = uc480.Camera;
%Initiate the interface
cam.Init(0)
% Make a video object
[camVideo] = cam.Video;
% Show in the GUI
preview(camVideo);

