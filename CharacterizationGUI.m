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

% Last Modified by GUIDE v2.5 08-Mar-2017 12:02:29

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
function CharacterizationGUI_OpeningFcn(hObject, eventdata, handles, varargin)
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
function varargout = CharacterizationGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on button press in Lin0Dgr.
function Lin0Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin0Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Lin10Dgr.
function Lin10Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin10Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Lin20Dgr.
function Lin20Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin20Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Lin30Dgr.
function Lin30Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin30Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Lin40Dgr.
function Lin40Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin40Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Lin50Dgr.
function Lin50Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin50Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Lin70Dgr.
function Lin70Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin70Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Lin80Dgr.
function Lin80Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin80Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Lin90Dgr.
function Lin90Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin90Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in Cir0Dgr.
function Cir0Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Cir0Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Cir10Dgr.
function Cir10Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Cir10Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Cir20Dgr.
function Cir20Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Cir20Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Cir30Dgr.
function Cir30Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Cir30Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Cir40Dgr.
function Cir40Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Cir40Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Cir50Dgr.
function Cir50Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Cir50Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Lin60Dgr.
function Lin60Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Lin60Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Cir70Dgr.
function Cir70Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Cir70Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Cir80Dgr.
function Cir80Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Cir80Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Cir90Dgr.
function Cir90Dgr_Callback(hObject, eventdata, handles)
% hObject    handle to Cir90Dgr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
