function varargout = markerTracking(varargin)
% MARKERTRACKING MATLAB code for markerTracking.fig
%      MARKERTRACKING, by itself, creates a new MARKERTRACKING or raises the existing
%      singleton*.
%
%      H = MARKERTRACKING returns the handle to a new MARKERTRACKING or the handle to
%      the existing singleton*.
%
%      MARKERTRACKING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MARKERTRACKING.M with the given input arguments.
%
%      MARKERTRACKING('Property','Value',...) creates a new MARKERTRACKING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before markerTracking_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to markerTracking_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help markerTracking

% Last Modified by GUIDE v2.5 19-Nov-2012 03:40:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @markerTracking_OpeningFcn, ...
                   'gui_OutputFcn',  @markerTracking_OutputFcn, ...
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
global vid;          % VideoReader struct
global dat;          % results structure
global frame_number; %current frame number
global nPoints;      %current number of points
global curIm;        %current image
global nFrames;    % number of frames, workaround
global dispIm;       % display (scaled) version
global prev;         %prevision from kalman
global rad;          %measured circle radius
global imScale;      % displayed image scale
% --- Executes just before markerTracking is made visible.
function markerTracking_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to markerTracking (see VARARGIN)

% Choose default command line output for markerTracking
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
base=fileparts(which('calib'));
addpath([base '/etc']);
addpath([base '/lib']);
addpath([base '/ModifiedGML']);
addpath([base '/lib/circularHough']);


% UIWAIT makes markerTracking wait for user response (see UIRESUME)
% uiwait(handles.form);


% --- Outputs from this function are returned to the command line.
function varargout = markerTracking_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in pontos.
function pontos_Callback(hObject, eventdata, handles)
% hObject    handle to pontos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns pontos contents as cell array
%        contents{get(hObject,'Value')} returns selected item from pontos
global dat;
global frame_number;
if (get(handles.c_erase,'Value'))
    dat(frame_number).points(get(hObject,'Value')).coord=[-1 -1];
    reDraw(handles);
    set(handles.c_erase,'Value',0);
else
    markNumber(get(hObject,'Value'),handles);
end

function markNumber(curPoint,handles)
global frame_number;
global dat;
global nFrames;
global nPoints;
global curIm;
global rad;
global imScale;

contents = cellstr(get(handles.pontos,'String'));
if (isempty(nPoints))
    nPoints=0;
end
if (nPoints<curPoint)
    for f=1:nFrames
        dat(f).points(curPoint).coord=[-1 -1];
        rad(f).points(curPoint).rad=-1;
    end
end

nPoints=max(nPoints,curPoint);
if (curPoint<=size(contents,1))
    %aka clicked on last item == add marker
    [x y btn]=ginput(1);
    x=imScale*x;
    y=imScale*y;
    if (btn==1) %normal left click
        if ((y<0)||(x<0))
            dat(frame_number).points(curPoint).coord=[-1 -1];
        else
            [xt r]=findCenter(filterImage(curIm,handles),[x y],handles);
            if isnan(xt)
                dat(frame_number).points(curPoint).coord=[x y];
            else
                dat(frame_number).points(curPoint).coord=xt;
                rad(frame_number).points(curPoint).rad=r;
            end
        end
    end
    if (btn==3) %right click, forcing position
        dat(frame_number).points(curPoint).coord=[x y];
    end
    readImage(frame_number,handles);
end

function reDraw(handles)
global dat;
global imScale;
global nPoints;
global frame_number;
deltaDraw=100;
if (~isempty(dat))
    hold on;
    for i=1:nPoints
        x=dat(frame_number).points(i).coord(1);
        y=dat(frame_number).points(i).coord(2);
        if ((x~=-1)&&(y~=-1))
            plot(x/imScale,y/imScale,'o');
            text((x+deltaDraw)/imScale,(y-deltaDraw)/imScale,sprintf('%d',i),'BackgroundColor','white');
        end
        NewCont{i}=sprintf('%d: (%3.3f,%3.3f)',i,x,y); %#ok<AGROW>
    end
    hold off;
    NewCont={NewCont{:} 'New marker'}; %#ok<CCAT>
    set(handles.pontos,'String',NewCont);
end


% --- Executes during object creation, after setting all properties.
function pontos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pontos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_load.
function btn_load_Callback(hObject, eventdata, handles)
% hObject    handle to btn_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vid;
global nFrames;
global frame_number;
global dat;
global nameVid;
global nPoints;
global range;
global imScale;
range=[];
dat=[];
nPoints=0;
nameVid=pick();
if ~isempty(nameVid)
    %reads the first frame
    vid=VideoReader(nameVid);
    nFrames=vid.NumberOfFrames;
    if (isempty(nFrames))
        nFrames=input('Unable to determine number of frames, please inform:');
    end
    im=read(vid,1);
    if (size(im,1)>480)
        imScale=2;
        im=imresize(im,1/2);
    else
        imScale=1;
    end
    set(handles.tScale,'String',sprintf('Scale: %g',imScale));
    %resizes the window
    pos=get(handles.im,'Position');
    pos(3)=size(im,2);
    pos(4)=size(im,1);
    set(handles.im,'Position',pos);
    janela=get(handles.form,'Position');

    if ( (pos(3)+pos(1))>janela(3) )
        janela(3)=pos(3)+pos(1)+50;
    end
    
    if ((pos(4)+pos(1))>janela(4))
        janela(4)=pos(4)+pos(1)+50;
        %pos(2)=janela(4)-pos(4)-50;
        %set(handles.im,'Position',pos);
    end
    set(handles.form,'Position',janela);
    
    frame_number=-1;
    
    %display the image
    readImage(1,handles);
    
    %sets the slider range
    set(handles.slider,'Min',1);
    set(handles.slider,'Max',nFrames);
end

function readImage(curFrame,handles)
global vid;
global frame_number;
global curIm;
global dispIm;
persistent cache;
global range;
global nFrames;
global imScale;
nCache=50; %loads nCache images
hold off;
curFrame=round(curFrame);

if (isempty(range))
    range=[-1; -1];
end

if ((curFrame>=1)&&(curFrame<=nFrames))
    if (curFrame~=frame_number)
        if (isempty(cache)||((curFrame<range(1))||(curFrame>range(2)))) %frame is *not* on cache
            range(1)=max(1,curFrame);
            range(2)=min(nFrames,curFrame+nCache);
            cache=read(vid,range);
        end
        curIm=squeeze(cache(:,:,:,curFrame-range(1)+1));
        dispIm=imresize(curIm,1/imScale);
        frame_number=curFrame;
        set(handles.slider,'Value',curFrame);
        set(handles.nFrame,'String',sprintf('%g',curFrame));
    end
    if (get(handles.c_gray,'Value'))
        if (length(size(curIm))==3)
            image(repmat(imadjust(rgb2gray(dispIm)),[1 1 3]));
        else
            image(imadjust(dispIm));
        end
    else
        image(dispIm);
    end
    
    reDraw(handles);
end




function nFrame_Callback(hObject, eventdata, handles)
% hObject    handle to nFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nFrame as text
%        str2double(get(hObject,'String')) returns contents of nFrame as a double
readImage(str2double(get(hObject,'String')),handles);


% --- Executes during object creation, after setting all properties.
function nFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider_Callback(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
readImage(get(hObject,'Value'),handles);

% --- Executes during object creation, after setting all properties.
function slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in btn_forward.
function btn_forward_Callback(hObject, eventdata, handles)
% hObject    handle to btn_forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global frame_number;
readImage(frame_number+1,handles);


% --- Executes on button press in btn_back.
function btn_back_Callback(hObject, eventdata, handles)
% hObject    handle to btn_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global frame_number;
readImage(frame_number-1,handles);


% --- Executes on button press in btn_save.
function btn_save_Callback(hObject, eventdata, handles)
% hObject    handle to btn_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nameVid;
global nFrames;
global dat;
global nPoints;
global rad;
tempName=strrep(nameVid, nameVid((size(nameVid,2)-2):(size(nameVid,2))),'dat');
saveName=input(sprintf('Prefix for the .dat file: ([]=%s)',tempName),'s');
if (isempty(saveName))
    saveName=tempName;
end

f=fopen(saveName,'w');
fr=fopen(strrep(saveName,'dat','rad'),'w'); %file with the circle radius
for frame=1:nFrames
    fprintf(f ,'%d ',frame);
    fprintf(fr,'%d ',frame);
    for point=1:nPoints
        fprintf(f ,'%f %f ',dat(frame).points(point).coord(1),dat(frame).points(point).coord(2));
        fprintf(fr,'%f ',rad(frame).points(point).rad);
    end
    fprintf(f ,'\n');
    fprintf(fr,'\n');
end
fclose(f);
fclose(fr);


% --- Executes on button press in btn_start.
function btn_start_Callback(hObject, eventdata, handles)
% hObject    handle to btn_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dat;
global nPoints;
global frame_number;
global curIm;
global keepTracking;
global nFrames;
global prev;
global rad;

maxFrame=input('Track until frame number: ([]=whole video) ');
if (isempty(maxFrame))
    maxFrame=nFrames;
end

keepTracking=1;
curFrame=frame_number;

%time to set up the kalman filters - resets every time auto tracking
%restarts
if (frame_number<10) %to make sure the filter initializes properly
    nIter=100;
else
    nIter=1;
end
for p=1:nPoints
    for ni=1:nIter
        for i=1:frame_number
            prev(i+1).point(p).coord=kalmanfilter(dat(i).points(p).coord',p)';
        end
    end
end


while ((keepTracking==1)&&(curFrame<=nFrames)&&(curFrame<=maxFrame))
    curFrame=curFrame+1;
    readImage(curFrame,handles);
    
    %some workarounds to make the parfor possible
    xp=zeros(nPoints,2);
    for p=1:nPoints
        xp(p,:)=kalmanfilter(dat(curFrame-1).points(p).coord',p)';
    end
    tIm=filterImage(curIm,handles);
    
    %the heavy processing
    xt=zeros(nPoints,2);
    r=zeros(nPoints,1);
    parfor p=1:nPoints
        [xt(p,:) r(p)]=findCenter(tIm,xp(p,:),handles);
    end

%        figure,imshow(tIm);hold on;
%        plot(xt(:,1), xt(:,2),'o');figure

    
    %gathering results
    for p=1:nPoints
        if (~isnan(xt(p,:)))
            dat(curFrame).points(p).coord=xt(p,:);
            rad(curFrame).points(p).rad=r(p);
        else
            keepTracking=0;
        end
    end
    reDraw(handles);
end

function rIm=filterImage(im,handles)
%image pre-processing - underwater images often have a low frequency noise
%t=tic;
%if (length(size(im))==3)
%    im=rgb2gray(im);
%end

% wee bit of small noise removal
if (get(handles.markColor,'Value')==1) %black marker
    if (length(size(im))==3)
        im=max(im,[],3);
    end
    im=imopen(imclose(im,strel('disk',2)),strel('disk',2));
    backIm=imclose(im,strel('disk',10));
end
if (get(handles.markColor,'Value')==2) %white marker
    if (length(size(im))==3)
        im=min(im,[],3);
    end
    im=imclose(imopen(im,strel('disk',2)),strel('disk',2));
    backIm=imopen(im,strel('disk',10));
end
rIm=imabsdiff(im,backIm);
%sprintf('filterimg')
%toc(t)
    
function [xc r]=findCenter(im,xp,handles)
global frame_number;
delta=16; %>=16

%
%t=tic;
b=[[0 1/2 1 1/2 0];[1/2 1 1 1 1/2];[1 1 3/2 1 1];[1/2 1 1 1 1/2];[0 1/2 1 1/2 0]];
im=conv2(double(im),double(b),'same');

% searching box
xp=round(xp);
xmin=max([1 1],xp - delta);
xmax=min([size(im,2) size(im,1)],xp+delta);%verify size>32
imPatch=im(xmin(2):xmax(2),xmin(1):xmax(1));
%imwrite(imPatch,sprintf('%da.png',frame_number));
imPatch(imPatch<0.5*max(max(imPatch))*graythresh(imPatch))=0;
%imwrite(imPatch,sprintf('%db.png',frame_number));
%find the circle
[~, circen, temprad] = CircularHough_Grd(imPatch,[1 20]);
if (isempty(circen))
    %figure,imshow(imPatch,[]);
    %figure,surf(double(imPatch));
    %xc=climbSearch(imPatch,xp);
    [a b]=find(imPatch==max(max(imPatch)));
    xc=[a(1) b(1)]+xmin;
    r=-1;
else
    %if we find multiple, try the one closest to the old center - BAD
    % Get the one with the highest img value
    if (any(size(temprad)>1))
        mVal=zeros(1,size(temprad,1));
        for i=1:size(temprad,1)
            mVal(i)=imPatch(round(circen(i,2)),round(circen(i,1)));
        end
        [~, ind]=max(mVal);
        %[~, ind]=min(sum(((circen+repmat(xmin,[size(temprad,1) 1]))-repmat(xp,[size(temprad,1) 1])).^2,2));
    else
        ind=1;
    end
    %figure,imshow(imPatch,[]),hold on,plot(circen(ind,1),circen(ind,2),'+','MarkerSize',1),figure
    xc=circen(ind,:)+xmin-[1 1];
    r=temprad(ind);
end
%sprintf('findCenter'),toc(t)


% --- Executes on button press in btn_stop.
function btn_stop_Callback(hObject, eventdata, handles)
% hObject    handle to btn_stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global keepTracking;
keepTracking=0;

% --- Executes on key press with focus on form and none of its controls.
function form_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to form (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
global keepTracking;
global nPoints;
global frame_number;
if strcmp(eventdata.Key,'rightarrow')
   btn_forward_Callback(handles.btn_forward, eventdata, handles);
end
if strcmp(eventdata.Key,'leftarrow')
   btn_back_Callback(handles.btn_back, eventdata, handles);
end
if strcmp(eventdata.Key,'spacebar')
    keepTracking=~keepTracking;
end
if (strcmp(eventdata.Key,'add'))
    markNumber(nPoints+1,handles);
end
if (strcmp(eventdata.Key,'r'))
    readImage(frame_number,handles);
end
key=strrep(eventdata.Key,'numpad','');
if (size(key,2)==1)
    if ((key<='9')&&(key>='0'))
        if (str2double(key)<=nPoints)
            markNumber(str2double(key),handles);
        end
    end
end


% --- Executes on button press in btn_loadDat.
function btn_loadDat_Callback(hObject, eventdata, handles)
% hObject    handle to btn_loadDat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dat;
global nPoints;
dat=[];
nPoints=0;
nameDat=pick('dat');
if (~isempty(nameDat))
   tDat=textread(nameDat); %#ok<*REMFF1>
   nP=floor((size(tDat,2)-1)/2);
   for i=1:size(tDat,1)
       for j=1:nP
          dat(i).points(j).coord=squeeze(tDat(i,(2*j):(2*j)+1)); %#ok<AGROW>
       end
   end
   nPoints=nP;
   reDraw(handles);
end


% --- Executes during object creation, after setting all properties.
function markColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to markColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pontos.
function pontos_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pontos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in c_erase.
function c_erase_Callback(hObject, eventdata, handles)
% hObject    handle to c_erase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c_erase


% --- Executes on button press in c_gray.
function c_gray_Callback(hObject, eventdata, handles)
% hObject    handle to c_gray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of c_gray
global frame_number;
readImage(frame_number,handles);
