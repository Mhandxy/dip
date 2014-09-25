function varargout = HI(varargin)
% HI MATLAB code for HI.fig
%      HI, by itself, creates a new HI or raises the existing
%      singleton*.
%
%      H = HI returns the handle to a new HI or the handle to
%      the existing singleton*.
%
%      HI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HI.M with the given input arguments.
%
%      HI('Property','Value',...) creates a new HI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HI

% Last Modified by GUIDE v2.5 13-Apr-2014 22:33:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HI_OpeningFcn, ...
                   'gui_OutputFcn',  @HI_OutputFcn, ...
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


% --- Executes just before HI is made visible.
function HI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HI (see VARARGIN)

% Choose default command line output for HI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = HI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Img1;
[filename,pathname]=uigetfile({'*.jpg';'*.bmp';'*.png'},'Ñ¡ÔñÍ¼Æ¬');
if ~isequal(filename,0)
str=[pathname filename];
Img1 = imread(str);
axes(handles.axes1);
imshow(Img1);
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Img2;
[filename,pathname]=uigetfile({'*.jpg';'*.bmp';'*.png'},'Ñ¡ÔñÍ¼Æ¬');
if ~isequal(filename,0)
str=[pathname filename];
Img2 = imread(str);
axes(handles.axes2);
imshow(Img2);
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Img1;
global Img2;
global HImg;
Img1(:,:,1)=Img1(:,:,1)/3+Img1(:,:,2)/3+Img1(:,:,3)/3;
Img1(:,:,2)=Img1(:,:,1);
Img1(:,:,3)=Img1(:,:,1);
Img2(:,:,1)=Img2(:,:,1)/3+Img2(:,:,2)/3+Img2(:,:,3)/3;
Img2(:,:,2)=Img2(:,:,1);
Img2(:,:,3)=Img2(:,:,1);
[m1,n1]=size(Img1(:,:,1));
[m2,n2]=size(Img2(:,:,1));
m=min([m1,m2]);
n=min([n1,n2]);
%Img1=imresize(Img1,[m,n]);
%Img2=imresize(Img2,[m,n]);
LP=fspecial('gaussian',max([m n]),8); 
if m>n
    LP=LP(:,floor((m-n)/2+1):floor((m+n)/2));
else
    LP=LP(floor((n-m)/2+1):floor((n+m)/2),:);
end
LP=(LP-min(min(LP)))/(max(max(LP))-min(min(LP)));

LPImg=zeros(m,n,3);
LPImg(:,:,1)=ifft2(fftshift(fft2(Img1(:,:,1),m,n)).*LP);
LPImg(:,:,2)=ifft2(fftshift(fft2(Img1(:,:,2),m,n)).*LP);
LPImg(:,:,3)=ifft2(fftshift(fft2(Img1(:,:,3),m,n)).*LP);
LPImg=uint8(abs(LPImg));

HP=ones(size(LP))-LP*0.6;
%HP=LP;
HPImg=zeros(m,n,3);
HPImg(:,:,1)=ifft2(fftshift(fft2(Img2(:,:,1),m,n)).*HP);
HPImg(:,:,2)=ifft2(fftshift(fft2(Img2(:,:,2),m,n)).*HP);
HPImg(:,:,3)=ifft2(fftshift(fft2(Img2(:,:,3),m,n)).*HP);
HPImg=uint8(abs(HPImg));

HImg=uint8(abs(ifft2(fft2(LPImg,m,n)+fft2(HPImg,m,n))/1.5));
axes(handles.axes3);
imshow(HImg);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global HImg;
[filename,pathname]=uiputfile({'*.jpg';},'±£´æÍ¼Æ¬','Undefined.jpg');
if ~isequal(filename,0)
    str = [pathname filename];
    imwrite(HImg,str,'jpg');
end;
