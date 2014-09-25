function varargout = imbeautify(varargin)
% IMBEAUTIFY MATLAB code for imbeautify.fig
%      IMBEAUTIFY, by itself, creates a new IMBEAUTIFY or raises the existing
%      singleton*.
%
%      H = IMBEAUTIFY returns the handle to a new IMBEAUTIFY or the handle to
%      the existing singleton*.
%
%      IMBEAUTIFY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMBEAUTIFY.M with the given input arguments.
%
%      IMBEAUTIFY('Property','Value',...) creates a new IMBEAUTIFY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imbeautify_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imbeautify_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imbeautify

% Last Modified by GUIDE v2.5 18-May-2014 18:26:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imbeautify_OpeningFcn, ...
                   'gui_OutputFcn',  @imbeautify_OutputFcn, ...
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


% --- Executes just before imbeautify is made visible.
function imbeautify_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imbeautify (see VARARGIN)

% Choose default command line output for imbeautify
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes imbeautify wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = imbeautify_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
global Img
varargout{1} = handles.output;
movegui(gcf,'center');
Img=[];

% --- Executes on button press in buttonload.
function buttonload_Callback(hObject, eventdata, handles)
% hObject    handle to buttonload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Img;
[filename,pathname]=uigetfile({'*.jpg';'*.bmp';'*.png'},'select image');
if ~isequal(filename,0)
    str=[pathname filename];
    Img = imread(str);
    axes(handles.axes1);
    if ~isempty(Img)
      imshow(Img);
    end
end



% --- Executes on button press in buttonsave.
function buttonsave_Callback(hObject, eventdata, handles)
% hObject    handle to buttonsave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Img;
[filename,pathname]=uiputfile({'*.jpg';},'save image','Undefined.jpg');
if ~isequal(filename,0)
    str = [pathname filename];
    imwrite(Img,str,'jpg');
end



% --- Executes on button press in buttoncs.
function buttoncs_Callback(hObject, eventdata, handles)
% hObject    handle to buttoncs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Img;
Img=contraststretch(Img);
axes(handles.axes1);
if ~isempty(Img)
  imshow(Img);
end

% --- Executes on button press in buttonhe.
function buttonhe_Callback(hObject, eventdata, handles)
% hObject    handle to buttonhe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Img
Img=colorequalization(Img);
axes(handles.axes1);
if ~isempty(Img)
  imshow(Img);
end


% --- Executes on button press in buttonhr.
function buttonhr_Callback(hObject, eventdata, handles)
% hObject    handle to buttonhr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Img
Img=hazsremoval(Img);
axes(handles.axes1);
if ~isempty(Img)
  imshow(Img);
end


% --- Executes on button press in buttonauto.
function buttonauto_Callback(hObject, eventdata, handles)
% hObject    handle to buttonauto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Img
Img=hazsremoval(Img);
Img=colorequalization(Img);
axes(handles.axes1);
if ~isempty(Img)
  imshow(Img);
end