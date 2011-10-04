%**************************************************************************
%
%             MetroVisionLab
%
%             Generador de puntos sintéticos por el método de Tsai.
%             Calibraciones: Tsai 2D y 3D; DLT 2D y 3D; Faugeras;....
%
%             David Samper
%             Proyecto Vitra
%             12/11/2008
%
%**************************************************************************

function varargout = metrovisionlab(varargin)
% METROVISIONLAB M-file for metrovisionlab.fig
%      METROVISIONLAB, by itself, creates a new METROVISIONLAB or raises the existing
%      singleton*.
%
%      H = METROVISIONLAB returns the handle to a new METROVISIONLAB or the handle to
%      the existing singleton*.
%
%      METROVISIONLAB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in METROVISIONLAB.M with the given input arguments.
%
%      METROVISIONLAB('Property','Value',...) creates a new METROVISIONLAB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before metrovisionlab_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to metrovisionlab_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help metrovisionlab

% Last Modified by GUIDE v2.5 12-Dec-2008 13:15:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @metrovisionlab_OpeningFcn, ...
                   'gui_OutputFcn',  @metrovisionlab_OutputFcn, ...
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


% --- Executes just before metrovisionlab is made visible.
function metrovisionlab_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to metrovisionlab (see VARARGIN)

% Choose default command line output for metrovisionlab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes metrovisionlab wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = metrovisionlab_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.

function dx_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dx_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% GENERA EL ENSAYO QUE SE MUESTRA AL EJECUTAR EL PROGRAMA
% Lee los parámetros de los controles originales y genera el ensayo
% correspondiente
%--------------------------------------------------------------------------
    global cargaXYZ;
    
    handles = guihandles();
    cargaXYZ = 0;
    warning off all; %<- ELIMINA MENSAJES DE AVISO (NO SON CRITICOS) NO ELIMINA MENSAJES DE ERROR
    generador;
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


function dx_T_Callback(hObject, eventdata, handles)
% hObject    handle to dx_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dx_T as text
%        str2double(get(hObject,'String')) returns contents of dx_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE dx INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    dx_valor = str2double(get(hObject,'String'));
    % Comprueba que el valor introducido en el cuadro de texto es correcto
    if dx_valor<0
        set(hObject,'String','0.005');
        generador;
        dibuja_ptos(Cu,Cv);
        errordlg('dx must be positive.','Points error');
        return;
    end
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function dy_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dy_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function dy_T_Callback(hObject, eventdata, handles)
% hObject    handle to dy_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dy_T as text
%        str2double(get(hObject,'String')) returns contents of dy_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE dy INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    dy_valor = str2double(get(hObject,'String'));
    % Comprueba que el valor introducido en el cuadro de texto es correcto
    if dy_valor<0
        set(hObject,'String','0.005');
        generador;
        dibuja_ptos(Cu,Cv);
        errordlg('dy must be positive.','Points error');
        return;
    end
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function Cu_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cu_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Cu_T_Callback(hObject, eventdata, handles)
% hObject    handle to Cu_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cu_T as text
%        str2double(get(hObject,'String')) returns contents of Cu_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Cu INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    Cu_dim = str2double(get(hObject,'String'));
    % Comprueba que el valor introducido en el cuadro de texto es correcto
    if Cu_dim<0
        set(hObject,'String','2000');
        estado = get(handles.iguales_T,'Value');
        if estado == 1
            set(handles.Ncx_T,'String','2000');
            set(handles.Nfx_T,'String','2000');
        end
        generador;
        Cu = str2double(get(handles.Cu_T,'String'));
        dibuja_ptos(Cu,Cv);
        errordlg('Cu must be positive.','Points error');
        return;
    end
    %Comprueba si Ncx y Nfx han de ser iguales (estos valores dependen de Cu)
    estado = get(handles.iguales_T,'Value');
    if estado == 1
        set(handles.Ncx_T,'String',get(hObject,'String'));
        set(handles.Nfx_T,'String',get(hObject,'String'));
    end
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function Cv_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cv_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Cv_T_Callback(hObject, eventdata, handles)
% hObject    handle to Cv_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cv_T as text
%        str2double(get(hObject,'String')) returns contents of Cv_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Cv INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    % Comprueba que el valor introducido en el cuadro de texto es correcto
    Cv_dim = str2double(get(hObject,'String'));
    if Cv_dim<0
        set(hObject,'String','2000');
        generador;
        Cv = str2double(get(handles.Cv_T,'String'));
        dibuja_ptos(Cu,Cv);
        errordlg('Cv must be positive.','Points error');
        return;
    end
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function Ncx_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ncx_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Ncx_T_Callback(hObject, eventdata, handles)
% hObject    handle to Ncx_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ncx_T as text
%        str2double(get(hObject,'String')) returns contents of Ncx_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Ncx INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    % Comprueba que el valor introducido en el cuadro de texto es correcto
    Ncx_dim = str2double(get(hObject,'String'));
    if Ncx_dim<0
        set(hObject,'String',get(handles.Cu_T,'String'));
        generador;
        dibuja_ptos(Cu,Cv);
        errordlg('Ncx must be positive.','Points error');
        return;
    end
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function Nfx_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nfx_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Nfx_T_Callback(hObject, eventdata, handles)
% hObject    handle to Nfx_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nfx_T as text
%        str2double(get(hObject,'String')) returns contents of Nfx_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Nfx INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    % Comprueba que el valor introducido en el cuadro de texto es correcto
    Nfx_dim = str2double(get(hObject,'String'));
    if Nfx_dim<0
        set(hObject,'String',get(handles.Cu_T,'String'));
        generador;
        dibuja_ptos(Cu,Cv);
        errordlg('Nfx must be positive.','Points error');
        return;
    end
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function f_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function f_T_Callback(hObject, eventdata, handles)
% hObject    handle to f_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of f_T as text
%        str2double(get(hObject,'String')) returns contents of f_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE f INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    % Comprueba que el valor introducido en el cuadro de texto es correcto
    f_valor = str2double(get(hObject,'String'));
    if f_valor<0
        set(hObject,'String','10');
        generador;
        dibuja_ptos(Cu,Cv);
        errordlg('f must be positive.','Points error');
        return;
    end
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function k1_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k1_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function k1_T_Callback(hObject, eventdata, handles)
% hObject    handle to k1_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of k1_T as text
%        str2double(get(hObject,'String')) returns contents of k1_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE k1 INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function sx_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sx_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function sx_T_Callback(hObject, eventdata, handles)
% hObject    handle to sx_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sx_T as text
%        str2double(get(hObject,'String')) returns contents of sx_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE sx INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function offu_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offu_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function offu_T_Callback(hObject, eventdata, handles)
% hObject    handle to offu_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offu_T as text
%        str2double(get(hObject,'String')) returns contents of offu_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE offset Cu INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function offv_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offv_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function offv_T_Callback(hObject, eventdata, handles)
% hObject    handle to offv_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offv_T as text
%        str2double(get(hObject,'String')) returns contents of offv_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE offset Cv INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function noisesens_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noisesens_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function noisesens_T_Callback(hObject, eventdata, handles)
% hObject    handle to noisesens_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noisesens_T as text
%        str2double(get(hObject,'String')) returns contents of noisesens_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE sensor noise INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    set(handles.fix_noise_sensor_T,'Value',0);
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function noisecali_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noisecali_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function noisecali_T_Callback(hObject, eventdata, handles)
% hObject    handle to noisecali_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noisecali_T as text
%        str2double(get(hObject,'String')) returns contents of noisecali_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE calibrator noise INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    set(handles.fix_noise_calib_T,'Value',0);
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function Tx_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tx_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Tx_T_Callback(hObject, eventdata, handles)
% hObject    handle to Tx_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tx_T as text
%        str2double(get(hObject,'String')) returns contents of Tx_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Tx INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function Ty_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ty_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Ty_T_Callback(hObject, eventdata, handles)
% hObject    handle to Ty_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ty_T as text
%        str2double(get(hObject,'String')) returns contents of Ty_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Ty INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    % Comprueba que el valor introducido en el cuadro de texto es correcto
    Ty_valor = str2double(get(hObject,'String'));
    if Ty_valor<10 && Ty_valor>-10
        if Ty_valor>0
            set(hObject,'String','11');
        else
            set(hObject,'String','-11');
        end
        generador;
        dibuja_ptos(Cu,Cv);
        errordlg('There may be problems with Tsai method if Ty is zero or near zero.','Points error');
        return;
    end
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function Tz_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tz_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Tz_T_Callback(hObject, eventdata, handles)
% hObject    handle to Tz_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Tz_T as text
%        str2double(get(hObject,'String')) returns contents of Tz_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Tz INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    dist_Tz = str2double(get(hObject,'String'));
    % Comprueba que el valor introducido en el cuadro de texto es correcto
    if dist_Tz<0
        set(hObject,'String',abs(dist_Tz));
        generador;
        dibuja_ptos(Cu,Cv);
        errordlg('Distance Tx must be positive.','Points error');
        return;
    end
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function Rx_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rx_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Rx_T_Callback(hObject, eventdata, handles)
% hObject    handle to Rx_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rx_T as text
%        str2double(get(hObject,'String')) returns contents of Rx_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Rx INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    angulo_Rx = str2double(get(hObject,'String'));
    % Comprueba que el valor introducido en el cuadro de texto es correcto
    if angulo_Rx>90 || angulo_Rx<-90
        set(hObject,'String','0');
        set(handles.Rx_slider_T,'Value',0);
        generador;
        dibuja_ptos(Cu,Cv);
        errordlg('Angle Rx must be between 90 and -90.','Points error');
        return;
    end
    % Situa el marcador del slider Rx en la posición correcta
    set(handles.Rx_slider_T,'Value',str2double(get(hObject,'String')));
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function Ry_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ry_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Ry_T_Callback(hObject, eventdata, handles)
% hObject    handle to Ry_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ry_T as text
%        str2double(get(hObject,'String')) returns contents of Ry_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Ry INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    angulo_Ry = str2double(get(hObject,'String'));
    % Comprueba que el valor introducido en el cuadro de texto es correcto
    if angulo_Ry>90 || angulo_Ry<-90
        set(hObject,'String','0');
        set(handles.Ry_slider_T,'Value',0);
        generador;
        dibuja_ptos(Cu,Cv);
        errordlg('Angle Ry must be between 90 and -90.','Points error');
        return;
    end
    % Situa el marcador del slider Ry en la posición correcta
    set(handles.Ry_slider_T,'Value',str2double(get(hObject,'String')));
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function Rz_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rz_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function Rz_T_Callback(hObject, eventdata, handles)
% hObject    handle to Rz_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rz_T as text
%        str2double(get(hObject,'String')) returns contents of Rz_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Rz INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    angulo_Rz = str2double(get(hObject,'String'));
    % Comprueba que el valor introducido en el cuadro de texto es correcto
    if angulo_Rz>180 || angulo_Rz<-180
        set(hObject,'String','0');
        set(handles.Rz_slider_T,'Value',0);
        generador;
        dibuja_ptos(Cu,Cv);
        errordlg('Angle Rz must be between 180 and -180.','Points error');
        return;
    end
    % Situa el marcador del slider Rz en la posición correcta
    set(handles.Rz_slider_T,'Value',str2double(get(hObject,'String')));
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function Rx_slider_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rx_slider_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function Rx_slider_T_Callback(hObject, eventdata, handles)
% hObject    handle to Rx_slider_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Rx MARCADO POR EL SLIDER Y
% ACTUALIZA EL CUADRO DE TEXTO DE Rx
%--------------------------------------------------------------------------
    set(handles.Rx_T,'String',fix(get(hObject,'Value')));
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function Ry_slider_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ry_slider_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function Ry_slider_T_Callback(hObject, eventdata, handles)
% hObject    handle to Ry_slider_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Ry MARCADO POR EL SLIDER Y
% ACTUALIZA EL CUADRO DE TEXTO DE Ry
%--------------------------------------------------------------------------
    set(handles.Ry_T,'String',fix(get(hObject,'Value')));
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function Rz_slider_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rz_slider_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function Rz_slider_T_Callback(hObject, eventdata, handles)
% hObject    handl Re toz_slider_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Rz MARCADO POR EL SLIDER Y
% ACTUALIZA EL CUADRO DE TEXTO DE Rz
%--------------------------------------------------------------------------
    set(handles.Rz_T,'String',fix(get(hObject,'Value')));
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function O_X_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to O_X_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function O_X_T_Callback(hObject, eventdata, handles)
% hObject    handle to O_X_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of O_X_T as text
%        str2double(get(hObject,'String')) returns contents of O_X_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Origen X INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function O_Y_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to O_Y_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function O_Y_T_Callback(hObject, eventdata, handles)
% hObject    handle to O_Y_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of O_Y_T as text
%        str2double(get(hObject,'String')) returns contents of O_Y_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Origen Y INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function O_Z_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to O_Z_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function O_Z_T_Callback(hObject, eventdata, handles)
% hObject    handle to O_Z_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of O_Z_T as text
%        str2double(get(hObject,'String')) returns contents of O_Z_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Origen Z INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function P_X_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to P_X_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function P_X_T_Callback(hObject, eventdata, handles)
% hObject    handle to P_X_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of P_X_T as text
%        str2double(get(hObject,'String')) returns contents of P_X_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Columnas en X INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    set(handles.fix_noise_calib_T,'Value',0);
    set(handles.fix_noise_sensor_T,'Value',0);
    numero_columnas = str2double(get(hObject,'String'));
    % Comprueba que el valor introducido en el cuadro de texto es correcto
    if numero_columnas<1
        set(hObject,'String','1');
        generador;
        dibuja_ptos(Cu,Cv);
        errordlg('Number of columns on X axis must be major or equal to 1.','Points error');
        return;
    end
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function P_Y_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to P_Y_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function P_Y_T_Callback(hObject, eventdata, handles)
% hObject    handle to P_Y_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of P_Y_T as text
%        str2double(get(hObject,'String')) returns contents of P_Y_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Filas en Y INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    set(handles.fix_noise_calib_T,'Value',0);
    set(handles.fix_noise_sensor_T,'Value',0);
    numero_filas = str2double(get(hObject,'String'));
    % Comprueba que el valor introducido en el cuadro de texto es correcto
    if numero_filas<1
        set(hObject,'String','1');
        generador;
        dibuja_ptos(Cu,Cv);
        errordlg('Number of rows on Y axis must be major or equal to 1.','Points error');
        return;
    end
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function P_Z_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to P_Z_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function P_Z_T_Callback(hObject, eventdata, handles)
% hObject    handle to P_Z_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of P_Z_T as text
%        str2double(get(hObject,'String')) returns contents of P_Z_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Planos en Z INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    set(handles.fix_noise_calib_T,'Value',0);
    set(handles.fix_noise_sensor_T,'Value',0);
    numero_planos = str2double(get(hObject,'String'));
    % Comprueba que el valor introducido en el cuadro de texto es correcto
    if numero_planos<1
        set(hObject,'String','1');
        generador;
        dibuja_ptos(Cu,Cv);
        errordlg('Number of planes on Z axis must be major or equal to 1.','Points error');
        return;
    end
    if numero_planos==1
        set(handles.O_Z_T,'Enable','off');
    else  
        set(handles.O_Z_T,'Enable','on');
    end
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function E_X_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to E_X_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function E_X_T_Callback(hObject, eventdata, handles)
% hObject    handle to E_X_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of E_X_T as text
%        str2double(get(hObject,'String')) returns contents of E_X_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Separación en X INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function E_Y_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to E_Y_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function E_Y_T_Callback(hObject, eventdata, handles)
% hObject    handle to E_Y_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of E_Y_T as text
%        str2double(get(hObject,'String')) returns contents of E_Y_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Separación en Y INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function E_Z_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to E_Z_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function E_Z_T_Callback(hObject, eventdata, handles)
% hObject    handle to E_Z_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of E_Z_T as text
%        str2double(get(hObject,'String')) returns contents of E_Z_T as a double
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA EL ENSAYO EN FUNCIÓN DEL VALOR DE Separación en Z INTRODUCIDO
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes on button press in actualiza_T.
function actualiza_T_Callback(hObject, eventdata, handles)
% hObject    handle to actualiza_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% REINICIALIZA EL ENTORNO CON LOS VALORES DEL ENSAYO INICIAL (RESET)
%--------------------------------------------------------------------------
    inicializa_sesion;
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------

%--------------------------------- INICIO ---------------------------------
function ensayo_ant(func)
%--------------------------------------------------------------------------
% Función para almacenar y recuperar los parámetros del último ensayo libre
% de errores.
%             ensayo_ant(0) -> Almacena los parámetros
%             ensayo_ant(1) -> Recupera los parámetros
%--------------------------------------------------------------------------
    global param_ant;

    if func == 0
        param_ant = zeros(28,1);
        handles = guihandles();
        param_ant(1) = str2double(get(handles.noisesens_T,'String'));
        param_ant(2) = str2double(get(handles.noisecali_T,'String'));
        param_ant(3) = str2double(get(handles.offu_T,'String'));
        param_ant(4) = str2double(get(handles.offv_T,'String'));
        param_ant(5) = str2double(get(handles.dx_T,'String'));
        param_ant(6) = str2double(get(handles.dy_T,'String'));
        param_ant(7) = (str2double(get(handles.Cu_T,'String')));
        param_ant(8) = (str2double(get(handles.Cv_T,'String')));
        param_ant(9) = str2double(get(handles.Ncx_T,'String'));
        param_ant(10) = str2double(get(handles.Nfx_T,'String'));
        param_ant(11) = str2double(get(handles.f_T,'String'));
        param_ant(12) = str2double(get(handles.k1_T,'String'));
        param_ant(13) = str2double(get(handles.sx_T,'String'));
        param_ant(14) = str2double(get(handles.Tx_T,'String'));
        param_ant(15) = str2double(get(handles.Ty_T,'String'));
        param_ant(16) = str2double(get(handles.Tz_T,'String'));
        param_ant(17) = str2double(get(handles.Rx_T,'String'));
        param_ant(18) = str2double(get(handles.Ry_T,'String'));
        param_ant(19) = str2double(get(handles.Rz_T,'String'));
        param_ant(20) = str2double(get(handles.P_X_T,'String'));
        param_ant(21) = str2double(get(handles.P_Y_T,'String'));
        param_ant(22) = str2double(get(handles.P_Z_T,'String'));
        param_ant(23) = str2double(get(handles.O_X_T,'String'));
        param_ant(24) = str2double(get(handles.O_Y_T,'String'));
        param_ant(25) = str2double(get(handles.O_Z_T,'String'));
        param_ant(26) = str2double(get(handles.E_X_T,'String'));
        param_ant(27) = str2double(get(handles.E_Y_T,'String'));
        param_ant(28) = str2double(get(handles.E_Z_T,'String'));
    else
        handles = guihandles();
        set(handles.noisesens_T,'String',param_ant(1));
        set(handles.noisecali_T,'String',param_ant(2));
        set(handles.offu_T,'String',param_ant(3));
        set(handles.offv_T,'String',param_ant(4));
        set(handles.dx_T,'String',param_ant(5));
        set(handles.dy_T,'String',param_ant(6));
        set(handles.Cu_T,'String',param_ant(7));
        set(handles.Cv_T,'String',param_ant(8));
        set(handles.Ncx_T,'String',param_ant(9));
        set(handles.Nfx_T,'String',param_ant(10));
        set(handles.f_T,'String',param_ant(11));
        set(handles.k1_T,'String',param_ant(12));
        set(handles.sx_T,'String',param_ant(13));
        set(handles.Tx_T,'String',param_ant(14));
        set(handles.Ty_T,'String',param_ant(15));
        set(handles.Tz_T,'String',param_ant(16));
        set(handles.Rx_T,'String',param_ant(17));
        set(handles.Ry_T,'String',param_ant(18));
        set(handles.Rz_T,'String',param_ant(19));
        set(handles.Rx_slider_T,'Value',param_ant(17));
        set(handles.Ry_slider_T,'Value',param_ant(18));
        set(handles.Rz_slider_T,'Value',param_ant(19));
        set(handles.P_X_T,'String',param_ant(20));
        set(handles.P_Y_T,'String',param_ant(21));
        set(handles.P_Z_T,'String',param_ant(22));
        set(handles.O_X_T,'String',param_ant(23));
        set(handles.O_Y_T,'String',param_ant(24));
        set(handles.O_Z_T,'String',param_ant(25));
        set(handles.E_X_T,'String',param_ant(26));
        set(handles.E_Y_T,'String',param_ant(27));
        set(handles.E_Z_T,'String',param_ant(28));
    end
%----------------------------------- FIN ----------------------------------

%--------------------------------- INICIO ---------------------------------
function generador
%--------------------------------------------------------------------------
% LEE LOS PARÁMETROS DE TODOS LOS CONTROLES Y LOS PASA A LA FUNCION DE
% GENERACIÓN DE PUNTOS SINTÉTICOS
%--------------------------------------------------------------------------
    global XwYwZw_load;
    global MatrizPtos;
    global ruido_calib;
    global ruido_sensor;
    global tipo_ruido;

    handles = guihandles(); %<-IMPORTANTE sino no funcionan los handles
    Sensor_STDEV = str2double(get(handles.noisesens_T,'String'));
    Objetivo_STDEV = str2double(get(handles.noisecali_T,'String'));
    Cu_Offset = str2double(get(handles.offu_T,'String'));
    Cv_Offset = str2double(get(handles.offv_T,'String'));
    dx = str2double(get(handles.dx_T,'String'));
    dy = str2double(get(handles.dy_T,'String'));
    Cu = (str2double(get(handles.Cu_T,'String')))/2;
    Cv = (str2double(get(handles.Cv_T,'String')))/2;
    Ncx = str2double(get(handles.Ncx_T,'String'));
    Nfx = str2double(get(handles.Nfx_T,'String'));
    f = str2double(get(handles.f_T,'String'));
    k1 = str2double(get(handles.k1_T,'String')); %<- OJO TSAI HACE UN CAMBIO DE SIGNO EN EL FACTOR DE DISTORSION
    sx = str2double(get(handles.sx_T,'String'));
    Tx = str2double(get(handles.Tx_T,'String'));
    Ty = str2double(get(handles.Ty_T,'String'));
    Tz = str2double(get(handles.Tz_T,'String'));
    Rx = str2double(get(handles.Rx_T,'String'));
    Ry = str2double(get(handles.Ry_T,'String'));
    Rz = str2double(get(handles.Rz_T,'String'));
    SizeX = str2double(get(handles.P_X_T,'String'));
    SizeY = str2double(get(handles.P_Y_T,'String'));
    SizeZ = str2double(get(handles.P_Z_T,'String'));
    OrigenX = str2double(get(handles.O_X_T,'String'));
    OrigenY = str2double(get(handles.O_Y_T,'String'));
    OrigenZ = str2double(get(handles.O_Z_T,'String'));
    EspacioX = str2double(get(handles.E_X_T,'String'));
    EspacioY = str2double(get(handles.E_Y_T,'String'));
    EspacioZ = str2double(get(handles.E_Z_T,'String'));
    ruidoZ = get(handles.Z_noise_T,'Value');
    mantener_sensor = get(handles.fix_noise_sensor_T,'Value');
    mantener_calib = get(handles.fix_noise_calib_T,'Value');
    estado_gen_ptos = get(handles.menu_puntos_genera_T,'Checked');
    estado_board = get(handles.menu_board_T,'Checked');

    Rx = Rx * pi / 180;
    Ry = Ry * pi / 180;
    Rz = Rz * pi / 180;

    d1x = dx * (Ncx/Nfx);

    [r11,r12,r13,r21,r22,r23,r31,r32,r33] = R_grad2mat(Rx,Ry,Rz);

    if strcmp(estado_gen_ptos,'on') || strcmp(estado_board,'on')
        ptos_calib = SizeX*SizeY*SizeZ;
        indice_matriz = 0;
        XwYwZw = zeros(ptos_calib,3);

        for k=0:(SizeZ - 1)
            for j=0:(SizeY - 1)
                for i=0:(SizeX - 1)
                    indice_matriz = indice_matriz+1;
                    XwYwZw(indice_matriz,:) = [(i*EspacioX+OrigenX) ...
                                               (j*EspacioY+OrigenY) ...
                                               (k*EspacioZ+OrigenZ)];
                end
            end
        end
    else
        XwYwZw = XwYwZw_load;
    end

    nPtos = size(XwYwZw,1);

    if ruidoZ == 0
        contador = 2;
    else
        contador = 3;
    end

    if mantener_calib == 0
        if tipo_ruido == 1
            ruido_calib = random('norm',0,Objetivo_STDEV,nPtos,contador);
    %         ruido_calib = zeros(nPtos,3);
    %         for i=1:nPtos
    %             for j=1:contador
    %                 ruido_calib(i,j) = normrnd(0,Objetivo_STDEV);
    %             end
    %         end
        else
            ruido_calib = random('unif',-Objetivo_STDEV,Objetivo_STDEV,nPtos,contador);
        end
        if size(ruido_calib,2) < 3
            ruido_calib = [ruido_calib zeros(nPtos,1)];
        end
    end

    XwYwZw = XwYwZw + ruido_calib;

%     XcYcZc = zeros(nPtos,3);
%     for i=1:nPtos
%         XcYcZc(i,:) = [r11*XwYwZw(i,1)+r12*XwYwZw(i,2)+r13*XwYwZw(i,3)+Tx ...
%                            r21*XwYwZw(i,1)+r22*XwYwZw(i,2)+r23*XwYwZw(i,3)+Ty ...
%                            r31*XwYwZw(i,1)+r32*XwYwZw(i,2)+r33*XwYwZw(i,3)+Tz];
%     end
    XcYcZc = [r11*XwYwZw(:,1)+r12*XwYwZw(:,2)+r13*XwYwZw(:,3)+Tx*ones(nPtos,1) ...
              r21*XwYwZw(:,1)+r22*XwYwZw(:,2)+r23*XwYwZw(:,3)+Ty*ones(nPtos,1) ...
              r31*XwYwZw(:,1)+r32*XwYwZw(:,2)+r33*XwYwZw(:,3)+Tz*ones(nPtos,1)];

%     XpYp = zeros(nPtos,2);
%     for i=1:nPtos
%         XpYp(i,:) = [(f*(XcYcZc(i,1)/XcYcZc(i,3))) (f*(XcYcZc(i,2)/XcYcZc(i,3)))];
%     end
    XpYp = [(f*(XcYcZc(:,1)./XcYcZc(:,3))) (f*(XcYcZc(:,2)./XcYcZc(:,3)))];

    XpdYpd = zeros(nPtos,2);
    for i=1:nPtos
        rp = sqrt ((XpYp(i,1)^2)+(XpYp(i,2)^2));

        rpd_poly = [k1 0 1 -rp];
        rpd_sol = roots(rpd_poly);

        if (imag(rpd_sol(1,1))==0 && imag(rpd_sol(2,1))==0 && imag(rpd_sol(3,1))==0) 
            if rpd_sol(1,1)<0
                if rpd_sol(2,1)<rpd_sol(3,1)
                    rpd = rpd_sol(2,1);
                else
                    rpd = rpd_sol(3,1);
                end
            elseif rpd_sol(2,1)<0
                if rpd_sol(1,1)<rpd_sol(3,1)
                    rpd = rpd_sol(1,1);
                else
                    rpd = rpd_sol(3,1);
                end
            else
                if rpd_sol(1,1)<rpd_sol(2,1)
                    rpd = rpd_sol(1,1);
                else
                    rpd = rpd_sol(2,1);
                end
            end
        else 
            if imag(rpd_sol(1,1))==0
                rpd = rpd_sol(1,1);
            elseif imag(rpd_sol(2,1))==0
                rpd = rpd_sol(2,1);
            else
                rpd = rpd_sol(3,1);
            end
        end

        coeficiente = rpd/rp;
        XpdYpd(i,:) = [(XpYp(i,1)*coeficiente) (XpYp(i,2)*coeficiente)];
    end      

    Cu_tot = Cu + Cu_Offset;
    Cv_tot = Cv + Cv_Offset;

%     UV = zeros(nPtos,2);
%     for i=1:nPtos
%         UV(i,:) = [(sx*(1/d1x)*XpdYpd(i,1)+Cu_tot) ((1/dy)*XpdYpd(i,2)+Cv_tot)];
%         if isnan(UV(i,1))
%             UV(i,1) = Cu;
%         end
%         if isnan(UV(i,2))
%             UV(i,2) = Cv;
%         end
%     end
    UV1 = ([1 0 Cu_tot; 0 1 Cv_tot; 0 0 1]*[XpdYpd(:,1).*(sx*(1/d1x)) XpdYpd(:,2).*(1/dy) ones(nPtos,1)]')';
    UV = UV1(:,1:2);
    NaN_pos = find(isnan(UV));
    if not(isempty(NaN_pos))
        n_NaN = size(NaN_pos,1)/2;
        for i=1:n_NaN
            UV(NaN_pos(i)) = Cu;
            UV(NaN_pos(i+n_NaN)) = Cv;
        end
    end
    
    if mantener_sensor == 0
        if tipo_ruido == 1
            ruido_sensor = random('norm',0,Sensor_STDEV,nPtos,2);
    %         ruido_sensor = zeros(nPtos,2);
    %         for i=1:nPtos
    %             for j=1:2
    %                 ruido_sensor(i,j) = normrnd(0,Sensor_STDEV);
    %             end
    %         end
        else
            ruido_sensor = random('unif',-Sensor_STDEV,Sensor_STDEV,nPtos,2);
        end
    end

    UV = UV + ruido_sensor;

    MatrizPtos = [XwYwZw UV];
%----------------------------------- FIN ----------------------------------
       

%--------------------------------- INICIO ---------------------------------
function dibuja_ptos(Cu_org,Cv_org)
%--------------------------------------------------------------------------
% FUNCIÓN PARA DIBUJAR LOS PUNTOS EN EL ÁREA DE LA IMAGEN
%--------------------------------------------------------------------------
global MatrizPtos;
global cargaXYZ;
    
    datacursormode on;
    handles = guihandles();
    %Impide que los puntos se salgan fuera del campo de visión de la cámara
    if (max(MatrizPtos(:,4))>(Cu_org))||(max(MatrizPtos(:,5))>(Cv_org))||(min(MatrizPtos(:,4))<0)||(min(MatrizPtos(:,5))<0)
        %Recupera parámetros del último ensayo útil y genera los puntos
        ensayo_ant(1);
        %Comprueba si se están cargando las coordenadas (XYZ) desde un archivo y reinicializa el ensayo
        if cargaXYZ
            set(handles.menu_puntos_genera_T,'Checked','on');
            inicializa_sesion;
        end
        generador;
        Cu_org = str2double(get(handles.Cu_T,'String'));
        Cv_org = str2double(get(handles.Cv_T,'String'));
        %Comprueba el menu del generador de puntos para ver si dibuja puntos o cuadros
        estado_board = get(handles.menu_board_T,'Checked');
        if strcmp(estado_board,'off')
            %Genera la imagen de los ptos sintéticos tomada por la cámara virtual.
            aspecto = Cu_org/Cv_org;
            newplot;
            set(gca,'XAxisLocation','Top',...
                    'YDir','reverse',...
                    'PlotBoxAspectRatio',[aspecto 1 1],...
                    'XLim',[0 Cu_org],...
                    'YLim',[0 Cv_org],...
                    'Box','on');
            hold on;
            grid off;
            plot(MatrizPtos(:,4),MatrizPtos(:,5),'black.','MarkerSize',6);
            hold off;
            cursor_obj = datacursormode(gcf);
            set(cursor_obj,'UpdateFcn',@busca_coord);
        else
            u = MatrizPtos(:,4);
            v = MatrizPtos(:,5);
            nX = str2double(get(handles.P_X_T,'String'));
            nY = str2double(get(handles.P_Y_T,'String'));
            U = reshape(u,nX,nY)';
            V = reshape(v,nX,nY)';

            aspecto = Cu_org/Cv_org;
            newplot;
            set(gca,'XAxisLocation','Top',...
                    'YDir','reverse',...
                    'PlotBoxAspectRatio',[aspecto 1 1],...
                    'XLim',[0 Cu_org],...
                    'YLim',[0 Cv_org],...
                    'Box','on');
            hold on;
            grid off;
            line([U(1,:)'; U(2:nY-1,nX); fliplr(U(nY,2:nX-1))'; flipud(U(:,1))],[V(1,:)'; V(2:nY-1,nX); fliplr(V(nY,2:nX-1))'; flipud(V(:,1))],'Color','k')
            for i=1:nY-1
                for j=1:nX-1
                    if rem(i,2)
                        if rem(j,2)
                            fill([U(i,j);U(i+1,j);U(i+1,j+1);U(i,j+1)],[V(i,j);V(i+1,j);V(i+1,j+1);V(i,j+1)],'k');
                        end
                    else
                        if not(rem(j,2))
                            fill([U(i,j);U(i+1,j);U(i+1,j+1);U(i,j+1)],[V(i,j);V(i+1,j);V(i+1,j+1);V(i,j+1)],'k');
                        end
                    end
                end
            end
            hold off;
        end
        %Pongo char(39) para evitar problemas con el apostrofe -> "cameras's"
        errordlg(['Points out of the camera' char(39) 's field of view.'],'Points error','modal');
        return
    end

    %Almacena los parámateros como anteiores (para recuperarlos en caso de error)
    ensayo_ant(0); 

    %Comprueba el menu del generador de puntos para ver si dibuja puntos o cuadros
    estado_board = get(handles.menu_board_T,'Checked');
    if strcmp(estado_board,'off')
        %Genera la imagen de los ptos sintéticos tomada por la cámara virtual.
        aspecto = Cu_org/Cv_org;
        newplot;
        set(gca,'XAxisLocation','Top',...
                'YDir','reverse',...
                'PlotBoxAspectRatio',[aspecto 1 1],...
                'XLim',[0 Cu_org],...
                'YLim',[0 Cv_org],...
                'Box','on');
        hold on;
        grid off;
        plot(MatrizPtos(:,4),MatrizPtos(:,5),'black.','MarkerSize',6);
        hold off;
        cursor_obj = datacursormode(gcf);
        set(cursor_obj,'UpdateFcn',@busca_coord);
    else
        u = MatrizPtos(:,4);
        v = MatrizPtos(:,5);
        nX = str2double(get(handles.P_X_T,'String'));
        nY = str2double(get(handles.P_Y_T,'String'));
        U = reshape(u,nX,nY)';
        V = reshape(v,nX,nY)';
        
        aspecto = Cu_org/Cv_org;
        newplot;
        set(gca,'XAxisLocation','Top',...
                'YDir','reverse',...
                'PlotBoxAspectRatio',[aspecto 1 1],...
                'XLim',[0 Cu_org],...
                'YLim',[0 Cv_org],...
                'Box','on');
        hold on;
        grid off;
        line([U(1,:)'; U(2:nY-1,nX); fliplr(U(nY,2:nX-1))'; flipud(U(:,1))],[V(1,:)'; V(2:nY-1,nX); fliplr(V(nY,2:nX-1))'; flipud(V(:,1))],'Color','k')
        for i=1:nY-1
            for j=1:nX-1
                if rem(i,2)
                    if rem(j,2)
                        fill([U(i,j);U(i+1,j);U(i+1,j+1);U(i,j+1)],[V(i,j);V(i+1,j);V(i+1,j+1);V(i,j+1)],'k');
                    end
                else
                    if not(rem(j,2))
                        fill([U(i,j);U(i+1,j);U(i+1,j+1);U(i,j+1)],[V(i,j);V(i+1,j);V(i+1,j+1);V(i,j+1)],'k');
                    end
                end
            end
        end
        hold off;
    end
%----------------------------------- FIN ----------------------------------


%--------------------------------- INICIO ---------------------------------
function txt=busca_coord(empt,event_obj)
%--------------------------------------------------------------------------
% FUNCIÓN PARA MOSTRAR COORDENADAS EN EL CURSOR
%--------------------------------------------------------------------------
global MatrizPtos;
    
    i = 0;
    ptos = size(MatrizPtos,1);
    pos = get(event_obj,'Position');
    while i<ptos
        if pos(1) == MatrizPtos(i+1,4) && pos(2) == MatrizPtos(i+1,5)
            x = MatrizPtos(i+1,1);
            y = MatrizPtos(i+1,2);
            z = MatrizPtos(i+1,3);
            pto_indice = i+1;
            i = ptos;
        end
        i=i+1;
    end
    txt = {['Point = ' num2str(pto_indice)],...
           ['(u,v) = (' num2str(pos(1)) ',' num2str(pos(2)) ')'],...
           ['(X,Y,Z) = (' num2str(x) ',' num2str(y) ',' num2str(z) ')']};
%----------------------------------- FIN ----------------------------------


%--------------------------------- INICIO ---------------------------------
function captura_ptos(Cu_org,Cv_org,estado)
%--------------------------------------------------------------------------
% FUNCIÓN PARA DIBUJAR LOS PUNTOS EN EL ÁREA DE LA IMAGEN
%--------------------------------------------------------------------------
    global MatrizPtos;
        
    %Comprueba el menu del generador de puntos para ver si dibuja puntos o cuadros
    if strcmp(estado,'off')
        %Genera la imagen de los ptos sintéticos tomada por la cámara virtual.
        aspecto = Cu_org/Cv_org;
        newplot;
        set(gca,'XAxisLocation','Top',...
                'YDir','reverse',...
                'PlotBoxAspectRatio',[aspecto 1 1],...
                'XLim',[0 Cu_org],...
                'YLim',[0 Cv_org],...
                'Box','on');
        hold on;
        grid off;
        plot(MatrizPtos(:,4),MatrizPtos(:,5),'black.','MarkerSize',6);
        hold off;
    else
        u = MatrizPtos(:,4);
        v = MatrizPtos(:,5);
        nX = 9;
        nY = 9;
        U = reshape(u,nX,nY)';
        V = reshape(v,nX,nY)';
        
        aspecto = Cu_org/Cv_org;
        newplot;
        set(gca,'XAxisLocation','Top',...
                'YDir','reverse',...
                'PlotBoxAspectRatio',[aspecto 1 1],...
                'XLim',[0 Cu_org],...
                'YLim',[0 Cv_org],...
                'Box','on');
        hold on;
        grid off;
        line([U(1,:)'; U(2:nY-1,nX); fliplr(U(nY,2:nX-1))'; flipud(U(:,1))],[V(1,:)'; V(2:nY-1,nX); fliplr(V(nY,2:nX-1))'; flipud(V(:,1))],'Color','k')
        for i=1:nY-1
            for j=1:nX-1
                if rem(i,2)
                    if rem(j,2)
                        fill([U(i,j);U(i+1,j);U(i+1,j+1);U(i,j+1)],[V(i,j);V(i+1,j);V(i+1,j+1);V(i,j+1)],'k');
                    end
                else
                    if not(rem(j,2))
                        fill([U(i,j);U(i+1,j);U(i+1,j+1);U(i,j+1)],[V(i,j);V(i+1,j);V(i+1,j+1);V(i,j+1)],'k');
                    end
                end
            end
        end
        hold off;
    end
%----------------------------------- FIN ----------------------------------

% --- Executes on button press in Tx_s_T.
function Tx_s_T_Callback(hObject, eventdata, handles)
% hObject    handle to Tx_s_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% AUMENTA EL VALOR DE Tx EN FUNCIÓN DEL VALOR DEL CUADRO DE TEXTO (+)
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    Tx_valor = str2double(get(handles.Tx_T,'String'));
    desp_x = str2double(get(handles.desplazx_T,'String'));
    Tx_valor = Tx_valor + desp_x;
    set(handles.Tx_T,'String',int2str(Tx_valor));
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes on button press in Tx_b_T.
function Tx_b_T_Callback(hObject, eventdata, handles)
% hObject    handle to Tx_b_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% DISMINUYE EL VALOR DE Tx EN FUNCIÓN DEL VALOR DEL CUADRO DE TEXTO (-)
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    Tx_valor = str2double(get(handles.Tx_T,'String'));
    desp_x = str2double(get(handles.desplazx_T,'String'));
    Tx_valor = Tx_valor - desp_x;
    set(handles.Tx_T,'String',int2str(Tx_valor));
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes on button press in Ty_s_T.
function Ty_s_T_Callback(hObject, eventdata, handles)
% hObject    handle to Ty_s_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% AUMENTA EL VALOR DE Ty EN FUNCIÓN DEL VALOR DEL CUADRO DE TEXTO (+)
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    Ty_valor = str2double(get(handles.Ty_T,'String'));
    desp_y = str2double(get(handles.desplazy_T,'String'));
    Ty_valor = Ty_valor + desp_y;
    set(handles.Ty_T,'String',int2str(Ty_valor));
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes on button press in Ty_b_T.
function Ty_b_T_Callback(hObject, eventdata, handles)
% hObject    handle to Ty_b_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% DISMINUYE EL VALOR DE Ty EN FUNCIÓN DEL VALOR DEL CUADRO DE TEXTO (-)
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    Ty_valor = str2double(get(handles.Ty_T,'String'));
    desp_y = str2double(get(handles.desplazy_T,'String'));
    Ty_valor = Ty_valor - desp_y;
    set(handles.Ty_T,'String',int2str(Ty_valor));
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes on button press in Tz_s_T.
function Tz_s_T_Callback(hObject, eventdata, handles)
% hObject    handle to Tz_s_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% AUMENTA EL VALOR DE Tz EN FUNCIÓN DEL VALOR DEL CUADRO DE TEXTO (+)
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    Tz_valor = str2double(get(handles.Tz_T,'String'));
    desp_z = str2double(get(handles.desplazz_T,'String'));
    Tz_valor = Tz_valor + desp_z;
    set(handles.Tz_T,'String',int2str(Tz_valor));
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes on button press in Tz_b_T.
function Tz_b_T_Callback(hObject, eventdata, handles)
% hObject    handle to Tz_b_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% DISMINUYE EL VALOR DE Tz EN FUNCIÓN DEL VALOR DEL CUADRO DE TEXTO (-)
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    Tz_valor = str2double(get(handles.Tz_T,'String'));
    desp_z = str2double(get(handles.desplazz_T,'String'));
    Tz_valor = Tz_valor - desp_z;
    set(handles.Tz_T,'String',int2str(Tz_valor));
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


function desplazx_T_Callback(hObject, eventdata, handles)
% hObject    handle to desplazx_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of desplazx_T as text
%        str2double(get(hObject,'String')) returns contents of desplazx_T as a double


% --- Executes during object creation, after setting all properties.
function desplazx_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to desplazx_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function desplazy_T_Callback(hObject, eventdata, handles)
% hObject    handle to desplazy_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of desplazy_T as text
%        str2double(get(hObject,'String')) returns contents of desplazy_T as a double


% --- Executes during object creation, after setting all properties.
function desplazy_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to desplazy_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function desplazz_T_Callback(hObject, eventdata, handles)
% hObject    handle to desplazz_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of desplazz_T as text
%        str2double(get(hObject,'String')) returns contents of desplazz_T as a double


% --- Executes during object creation, after setting all properties.
function desplazz_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to desplazz_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in iguales_T.
function iguales_T_Callback(hObject, eventdata, handles)
% hObject    handle to iguales_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of iguales_T
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% SIRVE PARA SABER SI Ncx = Nfx. SI ESTÁ MARCADO Ncx = Nfx.
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    estado = get(hObject,'Value');
    valor_Cu = get(handles.Cu_T,'String');
    if estado == 1
        set(handles.Ncx_T,'Enable','off');
        set(handles.Ncx_T,'String',valor_Cu);
        set(handles.Nfx_T,'Enable','off');
        set(handles.Nfx_T,'String',valor_Cu);
    else
        set(handles.Ncx_T,'Enable','on');
        set(handles.Nfx_T,'Enable','on');
    end
    % Lee los parámetros de los controles y genera el ensayo correspondiente-
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function menu_archivos_T_Callback(hObject, eventdata, handles)
% hObject    handle to menu_archivos_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_camara_T_Callback(hObject, eventdata, handles)
% hObject    handle to menu_camara_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_puntos_T_Callback(hObject, eventdata, handles)
% hObject    handle to menu_puntos_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% GUARDA LOS PUNTOS SINTETICOS GENERADOS EN UN ARCHIVO
%--------------------------------------------------------------------------
    global MatrizPtos
    [filename_ptos, pathname_ptos, filterindex_ptos] = uiputfile( ...
               {  '*.pto','Points file (*.pto)'; ...
                  '*.*',  'All files (*.*)'}, ...
                  'Save synthetic points to file');
    if filterindex_ptos ~= 0
        save([pathname_ptos filename_ptos],'MatrizPtos','-ASCII');
    end
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function menu_tsai_T_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tsai_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CARGA LOS PARÁMETROS DE CALIBRACIÓN DESDE UN ARCHIVO
%--------------------------------------------------------------------------
    [filename_tsai, pathname_tsai, filterindex_tsai] = uigetfile( ...
               {  '*.cal','Tsai calibration (*.cal)'; ...
                  '*.*',  'All files (*.*)'}, ...
                  'Load Tsai calibration data');
    if filterindex_tsai ~= 0
        Param = load([pathname_tsai filename_tsai]);

        r11 = Param(1);
        r12 = Param(2);
        r13 = Param(3);
        r21 = Param(4);
        r22 = Param(5);
        r23 = Param(6);
        r31 = Param(7);
        Tx = Param(10);
        Ty = Param(11);
        Tz = Param(12);
        f = Param(13);
        k1 = Param(14);
        sx = Param(15);

        [Rx_g,Ry_g,Rz_g,Rx,Ry,Rz] = R_mat2grad(r11,r12,r13,r21,r22,r23,r31);

        set(handles.f_T,'String',f);
        set(handles.k1_T,'String',k1);
        set(handles.sx_T,'String',sx);
        set(handles.Tx_T,'String',Tx);
        set(handles.Ty_T,'String',Ty);
        set(handles.Tz_T,'String',Tz);
        set(handles.Rx_T,'String',Rx_g);
        set(handles.Ry_T,'String',Ry_g);
        set(handles.Rz_T,'String',Rz_g);
        set(handles.Rx_slider_T,'Value',Rx_g);
        set(handles.Ry_slider_T,'Value',Ry_g);
        set(handles.Rz_slider_T,'Value',Rz_g);

        % Lee los parámetros de los controles y genera el ensayo correspondiente
        Cu = str2double(get(handles.Cu_T,'String'));
        Cv = str2double(get(handles.Cv_T,'String'));
        generador;
        dibuja_ptos(Cu,Cv);
    end
%------------------------------------ FIN ---------------------------------


% --------------------------------------------------------------------
function menu_camara_1_T_Callback(hObject, eventdata, handles)
% hObject    handle to menu_camara_1_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CARGA LOS DATOS DE LA CAMARA PIXELINK 1280x1024
%--------------------------------------------------------------------------
    dx = 6.7e-3;
    dy = 6.7e-3;
    Cu = 1280/2;
    Cv = 1024/2;
    Ncx = 1280;
    Nfx = 1280;
    set(handles.dx_T,'String',dx);
    set(handles.dy_T,'String',dy);
    set(handles.Cu_T,'String',Cu*2);
    set(handles.Cv_T,'String',Cv*2);
    set(handles.Ncx_T,'String',Ncx);
    set(handles.Nfx_T,'String',Nfx);
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function menu_camara_2_T_Callback(hObject, eventdata, handles)
% hObject    handle to menu_camara_2_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CARGA LOS DATOS DE LA CAMARA PIXELINK 2208x3000
%--------------------------------------------------------------------------
    dx = 3.5e-3;
    dy = 3.5e-3;
    Cu = 2208/2;
    Cv = 3000/2;
    Ncx = 2208;
    Nfx = 2208;
    set(handles.dx_T,'String',dx);
    set(handles.dy_T,'String',dy);
    set(handles.Cu_T,'String',Cu*2);
    set(handles.Cv_T,'String',Cv*2);
    set(handles.Ncx_T,'String',Ncx);
    set(handles.Nfx_T,'String',Nfx);
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function menu_camara_4_T_Callback(hObject, eventdata, handles)
% hObject    handle to menu_camara_2_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CARGA LOS DATOS DE LA CAMARA PIXELINK 2208x3000
%--------------------------------------------------------------------------
    dx = 5.2e-3;
    dy = 5.2e-3;
    Cu = 1280/2;
    Cv = 1024/2;
    Ncx = 1280;
    Nfx = 1280;
    set(handles.dx_T,'String',dx);
    set(handles.dy_T,'String',dy);
    set(handles.Cu_T,'String',Cu*2);
    set(handles.Cv_T,'String',Cv*2);
    set(handles.Ncx_T,'String',Ncx);
    set(handles.Nfx_T,'String',Nfx);
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function menu_camara_3_T_Callback(hObject, eventdata, handles)
% hObject    handle to menu_camara_3_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CARGA LOS DATOS DE LA CAMARA PIXELINK 752x480
%--------------------------------------------------------------------------
    dx = 6e-3;
    dy = 6e-3;
    Cu = 752/2;
    Cv = 480/2;
    Ncx = 752;
    Nfx = 752;
    set(handles.dx_T,'String',dx);
    set(handles.dy_T,'String',dy);
    set(handles.Cu_T,'String',Cu*2);
    set(handles.Cv_T,'String',Cv*2);
    set(handles.Ncx_T,'String',Ncx);
    set(handles.Nfx_T,'String',Nfx);
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function menu_captura_T_Callback(hObject, eventdata, handles)
% hObject    handle to menu_captura_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% GUARDA LA IMAGEN CAPTURADA POR LA CÁMARA VIRTUAL DE LOS PUNTOS SINTETICOS
% Es necesario crear un formulario (figure) nuevo para poder capturar
% únicamente la imágen (axes)
%--------------------------------------------------------------------------
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    estado_board = get(handles.menu_board_T,'Checked');
    % Avisa de que puede tardar un tiempo
    mensaje = ['Do you want to save this image at real resolution (' num2str(Cu) 'x' num2str(Cv) ')? Depending on the image size this may take a few moments.'];
    button_DLT3Dcom = questdlg(mensaje, ...
                      'Warning!','Yes','No','No');
    uiwait(gcf,1);
    figure(1);
    set(1,'Visible','on','Position',[20 10 1200 850]);
    axes;
    % Captura el frame que pasará a ser la imagen definitiva
    captura_ptos(Cu,Cv,estado_board);
    set(gca,'Box','off','Xcolor','white','Ycolor','white','Units','pixels','Position',[60 20 1100 800],'FontSize',8);
    F = getframe(gca);
    [F_imagen,F_map] = frame2im(F);
    if strcmp(button_DLT3Dcom,'No')
        %Guarda la imagen a la resolución que se ve en pantalla
        F_resize = F_imagen;
    else
        %Guarda la imagen en resolución real
        Cu = str2double(get(handles.Cu_T,'String'));
        Cv = str2double(get(handles.Cv_T,'String'));
        F_resize = imresize(F_imagen,[Cv Cu],'bicubic');
    end
    % Guarda la imagen en un archivo BMP
    [filename_img, pathname_img, filterindex_img] = uiputfile( ...
               {  '*.bmp','BMP (*.bmp)'; ...
                  '*.*',  'All files (*.*)'}, ...
                  'Save synthetic image');
    if filterindex_img ~= 0
        imwrite(F_resize, [pathname_img filename_img]);
    end
    close(1);
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function menu_puntos_load_T_Callback(hObject, eventdata, handles)
% hObject    handle to menu_puntos_load_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CARGA LAS COORDENADAS MUNDO DE LOS PTOS DE CALIBRACION DESDE UN ARCHIVO
%--------------------------------------------------------------------------
    global XwYwZw_load;
    global cargaXYZ;
    
    cargaXYZ = 1;
    [filename_cali, pathname_cali, filterindex_cali] = uigetfile( ...
               {  '*.pto','Calibration points (*.pto)'; ...
                  '*.*',  'All files (*.*)'}, ...
                  'Load points of gauge object', ...
                  'MultiSelect', 'on');

    if filterindex_cali ~= 0
        [i,n_archivos] = size(filename_cali);
        if iscellstr(filename_cali) == 1
            XwYwZw_celda = cell(n_archivos,1);
            for i=1:n_archivos
                XwYwZw_celda{i} = load([pathname_cali char(filename_cali(1,i))]);
            end
            XwYwZw_carga = cell2mat(XwYwZw_celda);
        else
            XwYwZw_carga = load([pathname_cali filename_cali]);
        end
        XwYwZw_load = XwYwZw_carga(:,1:3);

        num_pto = size(XwYwZw_load,1);
        set(handles.num_puntos_T,'String',int2str(num_pto));
        if iscellstr(filename_cali) == 1
            archivos_celda = cell(1,n_archivos);
            for i=1:n_archivos
                archivos_celda{i} = [char(filename_cali(1,i)) ' '];
            end
            archivos = cell2mat(archivos_celda);
            set(handles.nombre_cali_T,'String',archivos);
        else
            set(handles.nombre_cali_T,'String',filename_cali);
        end
        set(handles.num_puntos_T,'Visible','on');
        set(handles.nombre_cali_T,'Visible','on');
        set(handles.text50,'Visible','on');
        set(handles.text51,'Visible','on');
        estado_generador('off');
        set(handles.menu_puntos_load_T,'Checked','on');
        set(handles.menu_puntosXu_load_T,'Checked','off');
        set(handles.menu_puntos_genera_T,'Checked','off');
        set(handles.menu_board_T,'Checked','off');
        set(handles.menu_guarda_sesion_T,'Enable','off');
    end
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function menu_puntos_genera_T_Callback(hObject, eventdata, handles)
% hObject    handle to menu_puntos_genera_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% REINICIALIZA EL ENTORNO CON LOS VALORES DEL ENSAYO INICIAL
%--------------------------------------------------------------------------
    estado_generador('on');
    set(handles.menu_puntos_load_T,'Checked','off');
    set(handles.menu_puntosXu_load_T,'Checked','off');
    set(handles.menu_puntos_genera_T,'Checked','on');
    set(handles.menu_board_T,'Checked','off');
    set(handles.num_puntos_T,'Visible','off');
    set(handles.nombre_cali_T,'Visible','off');
    set(handles.text50,'Visible','off');
    set(handles.text51,'Visible','off');
    set(handles.menu_guarda_sesion_T,'Enable','on');
    %--------------------------------------------------------------------------
    % GENERA EL ENSAYO AL CAMBIAR EL VALOR DEL CUADRO DE TEXTO
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    %--------------------------------------------------------------------------
    generador;
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function menu_calibrador_T_Callback(hObject, eventdata, handles)
% hObject    handle to menu_calibrador_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function nombre_cali_T_Callback(hObject, eventdata, handles)
% hObject    handle to nombre_cali_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nombre_cali_T as text
%        str2double(get(hObject,'String')) returns contents of nombre_cali_T as a double


% --- Executes during object creation, after setting all properties.
function nombre_cali_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nombre_cali_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function num_puntos_T_Callback(hObject, eventdata, handles)
% hObject    handle to num_puntos_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_puntos_T as text
%        str2double(get(hObject,'String')) returns contents of num_puntos_T as a double


% --- Executes during object creation, after setting all properties.
function num_puntos_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_puntos_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --------------------------------------------------------------------
function menu_tsai_guarda_T_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tsai_guarda_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% GUARDA LOS PARAMETOS DE TSAI EN UN ARCHIVO
%--------------------------------------------------------------------------
    P_tsai = [];

    Rx = str2double(get(handles.Rx_T,'String'));
    Ry = str2double(get(handles.Ry_T,'String'));
    Rz = str2double(get(handles.Rz_T,'String'));

    Rx = Rx * pi / 180;
    Ry = Ry * pi / 180;
    Rz = Rz * pi / 180;

    [r11,r12,r13,r21,r22,r23,r31,r32,r33] = R_grad2mat(Rx,Ry,Rz);

    P_tsai(1,1) = r11;
    P_tsai(1,2) = r12;
    P_tsai(1,3) = r13;
    P_tsai(1,4) = r21;
    P_tsai(1,5) = r22;
    P_tsai(1,6) = r23;
    P_tsai(1,7) = r31;
    P_tsai(1,8) = r32;
    P_tsai(1,9) = r33;
    P_tsai(1,10) = str2double(get(handles.Tx_T,'String'));
    P_tsai(1,11) = str2double(get(handles.Ty_T,'String'));
    P_tsai(1,12) = str2double(get(handles.Tz_T,'String'));
    P_tsai(1,13) = str2double(get(handles.f_T,'String'));
    P_tsai(1,14) = str2double(get(handles.k1_T,'String'));
    P_tsai(1,15) = str2double(get(handles.sx_T,'String'));
    [filename_tsaig, pathname_tsaig, filterindex_tsaig] = uiputfile( ...
               {  '*.cal','Calibration file (*.cal)'}, ...
                  'Save synthetic points to file');
    if filterindex_tsaig ~= 0
        save([pathname_tsaig filename_tsaig],'P_tsai','-ASCII');
    end
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function menu_guarda_sesion_T_Callback(hObject, eventdata, handles)
% hObject    handle to menu_guarda_sesion_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% GUARDA LOS PARAMETROS DE LA SESION EN UN ARCHIVO
%--------------------------------------------------------------------------
    Rx = str2double(get(handles.Rx_T,'String'));
    Ry = str2double(get(handles.Ry_T,'String'));
    Rz = str2double(get(handles.Rz_T,'String'));
    Tx = str2double(get(handles.Tx_T,'String'));
    Ty = str2double(get(handles.Ty_T,'String'));
    Tz = str2double(get(handles.Tz_T,'String'));
    f = str2double(get(handles.f_T,'String'));
    sx = str2double(get(handles.sx_T,'String'));
    k1 = str2double(get(handles.k1_T,'String'));
    dx = str2double(get(handles.dx_T,'String'));
    dy = str2double(get(handles.dy_T,'String'));
    Ncx = str2double(get(handles.Ncx_T,'String'));
    Nfx = str2double(get(handles.Nfx_T,'String'));
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    Cu_Offset = str2double(get(handles.offu_T,'String'));
    Cv_Offset = str2double(get(handles.offv_T,'String'));
    Sensor_STDEV = str2double(get(handles.noisesens_T,'String'));
    Objetivo_STDEV = str2double(get(handles.noisecali_T,'String'));
    OrigenX = str2double(get(handles.O_X_T,'String'));
    OrigenY = str2double(get(handles.O_Y_T,'String'));
    OrigenZ = str2double(get(handles.O_Z_T,'String'));
    SizeX = str2double(get(handles.P_X_T,'String'));
    SizeY = str2double(get(handles.P_Y_T,'String'));
    SizeZ = str2double(get(handles.P_Z_T,'String'));
    EspacioX = str2double(get(handles.E_X_T,'String'));
    EspacioY = str2double(get(handles.E_Y_T,'String'));
    EspacioZ = str2double(get(handles.E_Z_T,'String'));
    if Ncx == Nfx
        N_iguales = 1;
    else
        N_iguales = 0;
    end

    Sesion_g = [Rx Ry Rz Tx Ty Tz f sx k1 dx dy Ncx Nfx Cu Cv Cu_Offset ...
                Cv_Offset Sensor_STDEV Objetivo_STDEV OrigenX OrigenY ...
                OrigenZ SizeX SizeY SizeZ EspacioX EspacioY EspacioZ N_iguales];

    [filename_sesg, pathname_sesg, filterindex_sesg] = uiputfile( ...
               {  '*.gen','MetroVisionLab file (*.gen)'; ...
                  '*.*',  'All files (*.*)'}, ...
                  'Save a test to file');
    if filterindex_sesg ~= 0
        save([pathname_sesg filename_sesg],'Sesion_g','-ASCII');
    end
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function menu_abre_sesion_T_Callback(hObject, eventdata, handles)
% hObject    handle to menu_abre_sesion_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% CARGA LOS PARAMETROS DE UN ENSAYO DESDE UN ARCHIVO
%--------------------------------------------------------------------------
    [filename_ensayo, pathname_ensayo, filterindex_ensayo] = uigetfile( ...
               {  '*.gen','MetroVisionLab file (*.gen)'; ...
                  '*.*',  'All files (*.*)'}, ...
                  'Load a test from file');

    if filterindex_ensayo ~= 0
        Sesion_c = load([pathname_ensayo filename_ensayo]);
        Objetivo_STDEV =  Sesion_c(19);
        Sensor_STDEV =  Sesion_c(18);
        Cu_Offset =  Sesion_c(16);
        Cv_Offset =  Sesion_c(17);
        dx =  Sesion_c(10);
        dy =  Sesion_c(11);
        Cu =  Sesion_c(14);
        Cv =  Sesion_c(15);
        Ncx =  Sesion_c(12);
        Nfx =  Sesion_c(13);
        f =  Sesion_c(7);
        k1 =  Sesion_c(9);
        sx =  Sesion_c(8);
        Tx =  Sesion_c(4);
        Ty =  Sesion_c(5);
        Tz =  Sesion_c(6);
        Rx = Sesion_c(1);
        Ry = Sesion_c(2);
        Rz = Sesion_c(3);
        SizeX = Sesion_c(23);
        SizeY = Sesion_c(24);
        SizeZ = Sesion_c(25);
        OrigenX =  Sesion_c(20);  
        OrigenY =  Sesion_c(21);
        OrigenZ =  Sesion_c(22);
        EspacioX = Sesion_c(26);  
        EspacioY = Sesion_c(27);   
        EspacioZ = Sesion_c(28);   
        desplaz_x = 10;
        desplaz_y = 10;
        desplaz_z = 10;
        estado_generador('on');
        set(handles.noisesens_T,'String',Sensor_STDEV);
        set(handles.noisecali_T,'String',Objetivo_STDEV);
        set(handles.offu_T,'String',Cu_Offset);
        set(handles.offv_T,'String',Cv_Offset);
        set(handles.dx_T,'String',dx);
        set(handles.dy_T,'String',dy);
        set(handles.Cu_T,'String',Cu);
        set(handles.Cv_T,'String',Cv);
        set(handles.Ncx_T,'String',Ncx);
        set(handles.Nfx_T,'String',Nfx);
        set(handles.f_T,'String',f);
        set(handles.k1_T,'String',k1);
        set(handles.sx_T,'String',sx);
        set(handles.Tx_T,'String',Tx);
        set(handles.Ty_T,'String',Ty);
        set(handles.Tz_T,'String',Tz);
        set(handles.Rx_T,'String',Rx);
        set(handles.Ry_T,'String',Ry);
        set(handles.Rz_T,'String',Rz);
        set(handles.Rx_slider_T,'Value',Rx);
        set(handles.Ry_slider_T,'Value',Ry);
        set(handles.Rz_slider_T,'Value',Rz);
        set(handles.P_X_T,'String',SizeX);
        set(handles.P_Y_T,'String',SizeY);
        set(handles.P_Z_T,'String',SizeZ);
        set(handles.O_X_T,'String',OrigenX);
        set(handles.O_Y_T,'String',OrigenY);
        set(handles.O_Z_T,'String',OrigenZ);
        set(handles.E_X_T,'String',EspacioX);
        set(handles.E_Y_T,'String',EspacioY);
        set(handles.E_Z_T,'String',EspacioZ);
        set(handles.desplazx_T,'String',desplaz_x);
        set(handles.desplazy_T,'String',desplaz_y);
        set(handles.desplazz_T,'String',desplaz_z);
        set(handles.menu_puntos_load_T,'Checked','off');
        set(handles.menu_puntosXu_load_T,'Checked','off');
        set(handles.menu_puntos_genera_T,'Checked','on');
        set(handles.menu_board_T,'Checked','off');
        set(handles.num_puntos_T,'Visible','off');
        set(handles.nombre_cali_T,'Visible','off');
        set(handles.text50,'Visible','off');
        set(handles.text51,'Visible','off');
        set(handles.menu_guarda_sesion_T,'Enable','on');
        if Sesion_c(29) == 1
            set(handles.iguales_T,'Value',1);
            set(handles.Ncx_T,'Enable','off');
            set(handles.Nfx_T,'Enable','off');
        else
            set(handles.iguales_T,'Value',0);
            set(handles.Ncx_T,'Enable','on');
            set(handles.Nfx_T,'Enable','on');
        end
        %----------------------------------------------------------------------
        % GENERA EL ENSAYO AL CAMBIAR EL VALOR DEL CUADRO DE TEXTO
        % Lee los parámetros de los controles y genera el ensayo
        % correspondiente
        %----------------------------------------------------------------------
        generador;
        Cu = str2double(get(handles.Cu_T,'String'));
        Cv = str2double(get(handles.Cv_T,'String'));
        dibuja_ptos(Cu,Cv);
    end
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function menu_nuevo_sesion_T_Callback(hObject, eventdata, handles)
% hObject    handle to menu_nuevo_sesion_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% REINICIALIZA EL ENTORNO CON LOS VALORES DEL ENSAYO INICIAL
%--------------------------------------------------------------------------
    inicializa_sesion;
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    generador;
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function menu_tsai2d_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tsai2d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% HACE LA CALIBRACION 2D DE TSAI EN FUNCION DE LOS PUNTOS Y LOS PARAMETROS
%--------------------------------------------------------------------------
global MatrizPtos;
global uv_res;
global uv_recons_res;
global Cu_org_res;
global Cv_org_res;
global calib_res;
    
% global PtosOptimizacion;

    %Comprueba si todos los puntos están en Z=0
    coord_Z = MatrizPtos(:,3);
    if ((max(coord_Z)<0.25)&&(min(coord_Z)>-0.25)) %pongo 0.25 y mo 0 por si hay ruido

        %Matrices de coordenadas mundo y coordenadas imagen
        XYZ=MatrizPtos(:,1:3);
        uv=MatrizPtos(:,4:5);

        %Caracteristicas de la camara
        dx = str2double(get(handles.dx_T,'String'));
        dy = str2double(get(handles.dy_T,'String'));
        Ncx = str2double(get(handles.Ncx_T,'String'));
        Nfx = str2double(get(handles.Nfx_T,'String'));
        Cu = str2double(get(handles.Cu_T,'String'))/2;
        Cv = str2double(get(handles.Cv_T,'String'))/2;
        Cu_org_res = Cu*2;
        Cv_org_res = Cv*2;

        %Llama a la función que hace la calibración
        tic;
        [r11f r12f r13f r21f r22f r23f r31f r32f r33f Tx Ty Tz f k1 sx] = calib_Tsai_2D(dx,dy,Ncx,Nfx,Cu,Cv);
        tiempo_f = toc;

        %Llama a la función de reconstrucción de las coord. imagen (u,v)
        uv_recons = TSAI_XYZ2UV(XYZ,r11f,r12f,r13f,r21f,r22f,r23f,r31f,r32f,r33f,Tx,Ty,Tz,f,k1,sx,dx,dy,Ncx,Nfx,Cu,Cv);

        %Llama a la función de reconstrucción de las coord. mundo (X,Y,Z=0)
        xy0_recons = TSAI_UV2XYZ(uv,r11f,r12f,r13f,r21f,r22f,r23f,r31f,r32f,r33f,Tx,Ty,Tz,f,k1,sx,dx,dy,Ncx,Nfx,Cu,Cv,0);


        %Reconstruye las coord. mundo (X,Y,Z)
        estado_gen_ptos = get(handles.menu_puntos_genera_T,'Checked');
        estado_board = get(handles.menu_board_T,'Checked');

        if strcmp(estado_gen_ptos,'on') || strcmp(estado_board,'on')
            numero_planos = str2double(get(handles.P_Z_T,'String'));
            cota_inicial = str2double(get(handles.O_Z_T,'String'));
            separacion_planos = str2double(get(handles.E_Z_T,'String'));
            puntos_plano = str2double(get(handles.P_X_T,'String'))*str2double(get(handles.P_Y_T,'String'));   
        end

        %Calcula el coeficiente NCE
        if strcmp(estado_gen_ptos,'on') || strcmp(estado_board,'on')
            NCE = NCE_coef(XYZ,xy0_recons,f,Tz,dx,dy,numero_planos,cota_inicial,separacion_planos,puntos_plano);
        end

        %Paso de [R] -> Rx,Ry,Rz
        [Rxo,Ryo,Rzo,Rx,Ry,Rz] = R_mat2grad(r11f,r12f,r13f,r21f,r22f,r23f,r31f);

        dif_uv = uv-uv_recons;
        error_uv = sqrt(dif_uv(:,1).^2+dif_uv(:,2).^2);
        dif_xyz = XYZ(:,1:2)-xy0_recons(:,1:2);
        error_xyz = sqrt(dif_xyz(:,1).^2+dif_xyz(:,2).^2);

        uv_res = uv;
        uv_recons_res = uv_recons;
        
        calib_res = [r11f r12f r13f r21f r22f r23f r31f r32f r33f Tx Ty Tz f k1 sx];
        if strcmp(estado_gen_ptos,'on') || strcmp(estado_board,'on')
            %Muestra en pantalla los resultados
            msg0='';
            msg1=['  f = ' num2str(f) ' (mm)     ' 'k1 = ' num2str(k1) '       ' 'sx = ' num2str(sx)];
            msg2=['  Tx = ' num2str(Tx) ' (mm)     ' 'Ty = ' num2str(Ty) ' (mm)     ' 'Tz = ' num2str(Tz) ' (mm)'];
            msg3=['  r11 = ' num2str(r11f) '       ' 'r12 = ' num2str(r12f) '       ' 'r13 = ' num2str(r13f)];
            msg4=['  r21 = ' num2str(r21f) '       ' 'r22 = ' num2str(r22f) '       ' 'r23 = ' num2str(r23f)];
            msg5=['  r31 = ' num2str(r31f) '       ' 'r32 = ' num2str(r32f) '       ' 'r33 = ' num2str(r33f)];
            msg6=['  Rx = ' num2str(Rx) ' (rad)     ' 'Ry = ' num2str(Ry) ' (rad)     ' 'Rz = ' num2str(Rz) ' (rad)'];
            msg7=['  Rx = ' num2str(Rxo) 'º       ' 'Ry = ' num2str(Ryo) 'º       ' 'Rz = ' num2str(Rzo) 'º'];
            msg8=['  Recon. Mean uv (pixel) -> ' num2str(mean(abs(dif_uv))) '    (' num2str(mean(error_uv)) ')'];
            msg9=['  Recon. Max uv (pixel) -> ' num2str(max(abs(dif_uv))) '    (' num2str(max(error_uv)) ')'];
            msg10=['  Recon. STD uv (pixel) -> ' num2str(std(abs(dif_uv))) '    (' num2str(std(error_uv)) ')'];
            msg11=['  Recon. Mean XYZ (mm) -> ' num2str(mean(abs(dif_xyz))) '    (' num2str(mean(error_xyz)) ')'];
            msg12=['  Recon. Max XYZ (mm) ->  ' num2str(max(abs(dif_xyz))) '    (' num2str(max(error_xyz)) ')'];
            msg13=['  Recon. STD XYZ (mm) ->  ' num2str(std(abs(dif_xyz))) '    (' num2str(std(error_xyz)) ')'];
            msg14=['  NCE = ' num2str(NCE)];
            msg15=['  CPU time (s) ->  ' num2str(tiempo_f)];
            msg_resultados = struct('resultados',{msg0;msg0;msg1;...
                                                  msg0;msg2;...
                                                  msg0;msg3;msg4;msg5;...
                                                  msg0;msg6;...
                                                  msg0;msg7;...
                                                  msg0;msg8;msg9;msg10;...
                                                  msg0;msg11;msg12;msg13;...
                                                  msg0;msg14;...
                                                  msg0;msg15;msg0});
            str = {msg_resultados.resultados};
            tipo_calib = 'Tsai 2D';
            muestra_resultados(str,tipo_calib,dif_uv,dif_xyz);
        else
            %Muestra en pantalla los resultados
            msg0='';
            msg1=['  f = ' num2str(f) ' (mm)     ' 'k1 = ' num2str(k1) '       ' 'sx = ' num2str(sx)];
            msg2=['  Tx = ' num2str(Tx) ' (mm)     ' 'Ty = ' num2str(Ty) ' (mm)     ' 'Tz = ' num2str(Tz) ' (mm)'];
            msg3=['  r11 = ' num2str(r11f) '       ' 'r12 = ' num2str(r12f) '       ' 'r13 = ' num2str(r13f)];
            msg4=['  r21 = ' num2str(r21f) '       ' 'r22 = ' num2str(r22f) '       ' 'r23 = ' num2str(r23f)];
            msg5=['  r31 = ' num2str(r31f) '       ' 'r32 = ' num2str(r32f) '       ' 'r33 = ' num2str(r33f)];
            msg6=['  Rx = ' num2str(Rx) ' (rad)     ' 'Ry = ' num2str(Ry) ' (rad)     ' 'Rz = ' num2str(Rz) ' (rad)'];
            msg7=['  Rx = ' num2str(Rxo) 'º       ' 'Ry = ' num2str(Ryo) 'º       ' 'Rz = ' num2str(Rzo) 'º'];
            msg8=['  Recon. Mean uv (pixel) -> ' num2str(mean(abs(dif_uv))) '    (' num2str(mean(error_uv)) ')'];
            msg9=['  Recon. Max uv (pixel) -> ' num2str(max(abs(dif_uv))) '    (' num2str(max(error_uv)) ')'];
            msg10=['  Recon. STD uv (pixel) -> ' num2str(std(abs(dif_uv))) '    (' num2str(std(error_uv)) ')'];
            msg11=['  Recon. Mean XYZ (mm) -> ' num2str(mean(abs(dif_xyz))) '    (' num2str(mean(error_xyz)) ')'];
            msg12=['  Recon. Max XYZ (mm) ->  ' num2str(max(abs(dif_xyz))) '    (' num2str(max(error_xyz)) ')'];
            msg13=['  Recon. STD XYZ (mm) ->  ' num2str(std(abs(dif_xyz))) '    (' num2str(std(error_xyz)) ')'];
            msg15=['  CPU time (s) ->  ' num2str(tiempo_f)];
            msg_resultados = struct('resultados',{msg0;msg0;msg1;...
                                                  msg0;msg2;...
                                                  msg0;msg3;msg4;msg5;...
                                                  msg0;msg6;...
                                                  msg0;msg7;...
                                                  msg0;msg8;msg9;msg10;...
                                                  msg0;msg11;msg12;msg13;...
                                                  msg0;msg15;msg0});
            str = {msg_resultados.resultados};
            tipo_calib = 'Tsai 2D';
            muestra_resultados(str,tipo_calib,0,0);
        end
    else
        errordlg('To perform the coplanar Tsai calibration is necessary that all points have Z = 0 in the world reference system.','Points error');
    end;
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function menu_tsai3d_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tsai3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% HACE LA CALIBRACION 3D DE TSAI EN FUNCION DE LOS PUNTOS Y LOS PARAMETROS
%--------------------------------------------------------------------------
global MatrizPtos;
global uv_res;
global uv_recons_res;
global Cu_org_res;
global Cv_org_res;
global calib_res;
% global PtosOptimizacion;

    %Comprueba si todos los puntos están en Z=0
    coord_Z = MatrizPtos(:,3);
    if ((max(coord_Z)~=min(coord_Z))&&((sqrt((max(coord_Z)^2)+(min(coord_Z)^2)))>0.5))

        %Matrices de coordenadas mundo y coordenadas imagen
        XYZ=MatrizPtos(:,1:3);
        uv=MatrizPtos(:,4:5);

        %Caracteristicas de la camara
        dx = str2double(get(handles.dx_T,'String'));
        dy = str2double(get(handles.dy_T,'String'));
        Ncx = str2double(get(handles.Ncx_T,'String'));
        Nfx = str2double(get(handles.Nfx_T,'String'));
        Cu = str2double(get(handles.Cu_T,'String'))/2;
        Cv = str2double(get(handles.Cv_T,'String'))/2;
        Cu_org_res = Cu*2;
        Cv_org_res = Cv*2;

        %Llama a la función que hace la calibración
        tic;
        [r11f r12f r13f r21f r22f r23f r31f r32f r33f Tx Ty Tz f k1 sx] = calib_Tsai_3D(dx,dy,Ncx,Nfx,Cu,Cv);
        tiempo_f = toc;

        %Llama a la función de reconstrucción de las coord. imagen (u,v)
        uv_recons = TSAI_XYZ2UV(XYZ,r11f,r12f,r13f,r21f,r22f,r23f,r31f,r32f,r33f,Tx,Ty,Tz,f,k1,sx,dx,dy,Ncx,Nfx,Cu,Cv);

        %Reconstruye las coord. mundo (X,Y,Z)
        estado_gen_ptos = get(handles.menu_puntos_genera_T,'Checked');
        estado_board = get(handles.menu_board_T,'Checked');

        if strcmp(estado_gen_ptos,'on') || strcmp(estado_board,'on')
            numero_planos = str2double(get(handles.P_Z_T,'String'));
            cota_inicial = str2double(get(handles.O_Z_T,'String'));
            separacion_planos = str2double(get(handles.E_Z_T,'String'));
            puntos_plano = str2double(get(handles.P_X_T,'String'))*str2double(get(handles.P_Y_T,'String'));
            xyz_recons = zeros(numero_planos*puntos_plano,3);
            for n_plano=1:numero_planos
                zw = ((n_plano*separacion_planos)-separacion_planos)+cota_inicial;
                %Llama a la función de reconstrucción de las coord. mundo (X,Y,Z)
                i = (n_plano*puntos_plano)-(puntos_plano-1);
                j = (n_plano*puntos_plano);
                xyz_recons(i:j,:) = TSAI_UV2XYZ(uv(i:j,:),r11f,r12f,r13f,r21f,r22f,r23f,r31f,r32f,r33f,Tx,Ty,Tz,f,k1,sx,dx,dy,Ncx,Nfx,Cu,Cv,zw);
            end
        end

        %Paso de [R] -> Rx,Ry,Rz
        [Rxo,Ryo,Rzo,Rx,Ry,Rz] = R_mat2grad(r11f,r12f,r13f,r21f,r22f,r23f,r31f);

        %Calcula el coeficiente NCE
        if strcmp(estado_gen_ptos,'on') || strcmp(estado_board,'on')
            NCE = NCE_coef(XYZ,xyz_recons,f,Tz,dx,dy,numero_planos,cota_inicial,separacion_planos,puntos_plano);
            dif_xyz = XYZ-xyz_recons;
            error_xyz = sqrt(dif_xyz(:,1).^2+dif_xyz(:,2).^2+dif_xyz(:,3).^2);
        end

        dif_uv = uv-uv_recons;
        error_uv = sqrt(dif_uv(:,1).^2+dif_uv(:,2).^2);

        uv_res = uv;
        uv_recons_res = uv_recons;
        
        calib_res = [r11f r12f r13f r21f r22f r23f r31f r32f r33f Tx Ty Tz f k1 sx];
        if strcmp(estado_gen_ptos,'on') || strcmp(estado_board,'on')
            %Muestra en pantalla los resultados
            msg0='';
            msg1=['  f = ' num2str(f) ' (mm)     ' 'k1 = ' num2str(k1) '       ' 'sx = ' num2str(sx)];
            msg2=['  Tx = ' num2str(Tx) ' (mm)     ' 'Ty = ' num2str(Ty) ' (mm)     ' 'Tz = ' num2str(Tz) ' (mm)'];
            msg3=['  r11 = ' num2str(r11f) '       ' 'r12 = ' num2str(r12f) '       ' 'r13 = ' num2str(r13f)];
            msg4=['  r21 = ' num2str(r21f) '       ' 'r22 = ' num2str(r22f) '       ' 'r23 = ' num2str(r23f)];
            msg5=['  r31 = ' num2str(r31f) '       ' 'r32 = ' num2str(r32f) '       ' 'r33 = ' num2str(r33f)];
            msg6=['  Rx = ' num2str(Rx) ' (rad)     ' 'Ry = ' num2str(Ry) ' (rad)     ' 'Rz = ' num2str(Rz) ' (rad)'];
            msg7=['  Rx = ' num2str(Rxo) 'º       ' 'Ry = ' num2str(Ryo) 'º       ' 'Rz = ' num2str(Rzo) 'º'];
            msg8=['  Recon. Mean uv (pixel) -> ' num2str(mean(abs(dif_uv))) '    (' num2str(mean(error_uv)) ')'];
            msg9=['  Recon. Max uv (pixel) -> ' num2str(max(abs(dif_uv))) '    (' num2str(max(error_uv)) ')'];
            msg10=['  Recon. STD uv (pixel) -> ' num2str(std(abs(dif_uv))) '    (' num2str(std(error_uv)) ')'];
            msg11=['  Recon. Mean XYZ (mm) -> ' num2str(mean(abs(dif_xyz))) '    (' num2str(mean(error_xyz)) ')'];
            msg12=['  Recon. Max XYZ (mm) ->  ' num2str(max(abs(dif_xyz))) '    (' num2str(max(error_xyz)) ')'];
            msg13=['  Recon. STD XYZ (mm) ->  ' num2str(std(abs(dif_xyz))) '    (' num2str(std(error_xyz)) ')'];
            msg14=['  NCE = ' num2str(NCE)];
            msg15=['  CPU time (s) ->  ' num2str(tiempo_f)];
            msg_resultados = struct('resultados',{msg0;msg0;msg1;...
                                                  msg0;msg2;...
                                                  msg0;msg3;msg4;msg5;...
                                                  msg0;msg6;...
                                                  msg0;msg7;...
                                                  msg0;msg8;msg9;msg10;...
                                                  msg0;msg11;msg12;msg13;...
                                                  msg0;msg14;...
                                                  msg0;msg15;msg0});
            str = {msg_resultados.resultados};
            tipo_calib = 'Tsai 3D';
            muestra_resultados(str,tipo_calib,dif_uv,dif_xyz);
        else
            %Muestra en pantalla los resultados
            msg0='';
            msg1=['  f = ' num2str(f) ' (mm)     ' 'k1 = ' num2str(k1) '       ' 'sx = ' num2str(sx)];
            msg2=['  Tx = ' num2str(Tx) ' (mm)     ' 'Ty = ' num2str(Ty) ' (mm)     ' 'Tz = ' num2str(Tz) ' (mm)'];
            msg3=['  r11 = ' num2str(r11f) '       ' 'r12 = ' num2str(r12f) '       ' 'r13 = ' num2str(r13f)];
            msg4=['  r21 = ' num2str(r21f) '       ' 'r22 = ' num2str(r22f) '       ' 'r23 = ' num2str(r23f)];
            msg5=['  r31 = ' num2str(r31f) '       ' 'r32 = ' num2str(r32f) '       ' 'r33 = ' num2str(r33f)];
            msg6=['  Rx = ' num2str(Rx) ' (rad)     ' 'Ry = ' num2str(Ry) ' (rad)     ' 'Rz = ' num2str(Rz) ' (rad)'];
            msg7=['  Rx = ' num2str(Rxo) 'º       ' 'Ry = ' num2str(Ryo) 'º       ' 'Rz = ' num2str(Rzo) 'º'];
            msg8=['  Recon. Mean uv (pixel) -> ' num2str(mean(abs(dif_uv))) '    (' num2str(mean(error_uv)) ')'];
            msg9=['  Recon. Max uv (pixel) -> ' num2str(max(abs(dif_uv))) '    (' num2str(max(error_uv)) ')'];
            msg10=['  Recon. STD uv (pixel) -> ' num2str(std(abs(dif_uv))) '    (' num2str(std(error_uv)) ')'];
            msg11=['  CPU time (s) ->  ' num2str(tiempo_f)];
            msg_resultados = struct('resultados',{msg0;msg0;msg1;...
                                                  msg0;msg2;...
                                                  msg0;msg3;msg4;msg5;...
                                                  msg0;msg6;...
                                                  msg0;msg7;...
                                                  msg0;msg8;msg9;msg10;...
                                                  msg0;msg11;msg0});
            str = {msg_resultados.resultados};
            tipo_calib = 'Tsai 3D';
            muestra_resultados(str,tipo_calib,0,0);
        end
    else
        errordlg('To perform the non coplanar Tsai calibration is necessary to have points in two different Z coordinates in the world reference system.','Points error');
    end;
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function menu_faugeras_Callback(hObject, eventdata, handles)
% hObject    handle to menu_faugeras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% HACE LA CALIBRACION 3D DE FAUGERAS SIN DISTORSION EN FUNCION DE LOS PUNTOS
%--------------------------------------------------------------------------
global MatrizPtos;
global uv_res;
global uv_recons_res;
global Cu_org_res;
global Cv_org_res;
global calib_res;

    Cu_i_T = findobj(gcbf,'Tag','Cu_T');
    Cu = str2double(get(Cu_i_T,'String'));
    Cv_i_T = findobj(gcbf,'Tag','Cv_T');
    Cv = str2double(get(Cv_i_T,'String'));
    Cu_org_res = Cu;
    Cv_org_res = Cv;
    
    %Comprueba si todos los puntos están en Z=0
    coord_Z = MatrizPtos(:,3);
    if ((max(coord_Z)~=min(coord_Z))&&((sqrt((max(coord_Z)^2)+(min(coord_Z)^2)))>0.5))
        dx_i_T = findobj(gcbf,'Tag','dx_T');
        dx = str2double(get(dx_i_T,'String'));
        dy_i_T = findobj(gcbf,'Tag','dy_T');
        dy = str2double(get(dy_i_T,'String'));
        XYZ = MatrizPtos(:,1:3);
        uv = MatrizPtos(:,4:5);
        m = size(XYZ,1);  
        %Llama a la función que hace la calibración
        tic;
        P_SVD = calib_Faugeras_3D_sin(MatrizPtos);
        tiempo_f = toc;
        L = [P_SVD(1,:) P_SVD(2,:) P_SVD(3,:)];
        uv_recons = zeros(m,2);
        for i=1:m
            u_i = (L(1)*XYZ(i,1)+L(2)*XYZ(i,2)+L(3)*XYZ(i,3)+L(4))/(L(9)*XYZ(i,1)+L(10)*XYZ(i,2)+L(11)*XYZ(i,3)+L(12));
            v_i = (L(5)*XYZ(i,1)+L(6)*XYZ(i,2)+L(7)*XYZ(i,3)+L(8))/(L(9)*XYZ(i,1)+L(10)*XYZ(i,2)+L(11)*XYZ(i,3)+L(12));
            uv_recons(i,:) = [u_i v_i];
        end

        %[X,Y]=solve('u=(L(1)*X+L(2)*Y+L(3)*Z+L(4))/(L(9)*X+L(10)*Y+L(11)*Z+L(12))','v=(L(5)*X+L(6)*Y+L(7)*Z+L(8))/(L(9)*X+L(10)*Y+L(11)*Z+L(12))','X,Y')
        %X=(u*L(10)*L(8)-u*L(12)*L(6)+u*L(10)*L(7)*Z-u*L(11)*Z*L(6)-L(3)*Z*v*L(10)+L(2)*v*L(12)-L(2)*L(8)+L(4)*L(6)+L(2)*v*L(11)*Z-L(2)*L(7)*Z-L(4)*v*L(10)+L(3)*Z*L(6))/(-v*L(9)*L(2)-L(5)*u*L(10)+L(5)*L(2)+v*L(10)*L(1)+L(6)*u*L(9)-L(6)*L(1))
        %Y=-1/(-v*L(9)*L(2)-L(5)*u*L(10)+L(5)*L(2)+v*L(10)*L(1)+L(6)*u*L(9)-L(6)*L(1))*(v*L(11)*Z*L(1)+v*L(12)*L(1)+L(7)*Z*u*L(9)-L(7)*Z*L(1)+L(8)*u*L(9)-L(8)*L(1)-v*L(9)*L(3)*Z-v*L(9)*L(4)-L(5)*u*L(11)*Z-L(5)*u*L(12)+L(5)*L(3)*Z+L(5)*L(4))
        %Reconstruye las coord. mundo (X,Y,Z)
        estado_gen_ptos = get(handles.menu_puntos_genera_T,'Checked');
        estado_board = get(handles.menu_board_T,'Checked');

        if strcmp(estado_gen_ptos,'on') || strcmp(estado_board,'on')
            numero_planos = str2double(get(handles.P_Z_T,'String'));
            cota_inicial = str2double(get(handles.O_Z_T,'String'));
            separacion_planos = str2double(get(handles.E_Z_T,'String'));
            puntos_plano = str2double(get(handles.P_X_T,'String'))*str2double(get(handles.P_Y_T,'String'));
            xyz_recons = zeros(puntos_plano*numero_planos,3);
            for n_plano=1:numero_planos
                Z = ((n_plano*separacion_planos)-separacion_planos)+cota_inicial;
                %Llama a la función de reconstrucción de las coord. mundo (X,Y,Z)
                i = (n_plano*puntos_plano)-(puntos_plano-1);
                j = (n_plano*puntos_plano);
                for in=i:j
                    u = uv(in,1);
                    v = uv(in,2);
                    xyz_recons(in,1) = (u*L(10)*L(8)-u*L(12)*L(6)+u*L(10)*L(7)*Z-u*L(11)*Z*L(6)-L(3)*Z*v*L(10)+L(2)*v*L(12)-L(2)*L(8)+L(4)*L(6)+L(2)*v*L(11)*Z-L(2)*L(7)*Z-L(4)*v*L(10)+L(3)*Z*L(6))/(-v*L(9)*L(2)-L(5)*u*L(10)+L(5)*L(2)+v*L(10)*L(1)+L(6)*u*L(9)-L(6)*L(1));
                    xyz_recons(in,2) = -1/(-v*L(9)*L(2)-L(5)*u*L(10)+L(5)*L(2)+v*L(10)*L(1)+L(6)*u*L(9)-L(6)*L(1))*(v*L(11)*Z*L(1)+v*L(12)*L(1)+L(7)*Z*u*L(9)-L(7)*Z*L(1)+L(8)*u*L(9)-L(8)*L(1)-v*L(9)*L(3)*Z-v*L(9)*L(4)-L(5)*u*L(11)*Z-L(5)*u*L(12)+L(5)*L(3)*Z+L(5)*L(4));
                    xyz_recons(in,3) = Z;
                end 
            end
        end

        %Llama a la función que extrae los parámetros int. y ext. de la matriz de proyección
        [r1,r2,r3,tx,ty,tz,f,u0,v0] = extraccion_param_faugeras(L,dx,dy);
        %Calcula los ángulos de giro de la cámara en grados y radianes
        R = [r1;r2;r3];
        [Rxo,Ryo,Rzo,Rx,Ry,Rz] = R_mat2grad(R(1,1),R(1,2),R(1,3),R(2,1),R(2,2),R(2,3),R(3,1));

        %Calcula el coeficiente NCE
        if strcmp(estado_gen_ptos,'on') || strcmp(estado_board,'on')
            NCE = NCE_coef(XYZ,xyz_recons,f,tz,dx,dy,numero_planos,cota_inicial,separacion_planos,puntos_plano);
            dif_xyz = XYZ-xyz_recons;
            error_xyz = sqrt(dif_xyz(:,1).^2+dif_xyz(:,2).^2+dif_xyz(:,3).^2);
        end

        dif_uv = uv-uv_recons;
        error_uv = sqrt(dif_uv(:,1).^2+dif_uv(:,2).^2);
        
        uv_res = uv;
        uv_recons_res = uv_recons;
        
        calib_res = [L(1) L(2) L(3) L(4) L(5) L(6) L(7) L(8) L(9) L(10) L(11) L(12) 0 0 u0 v0];
        if strcmp(estado_gen_ptos,'on') || strcmp(estado_board,'on')
            %Muestra en pantalla los resultados
            msg0='';
            msg1=['  p11 = ' num2str(L(1)) '     p12 = ' num2str(L(2)) '     p13 = ' num2str(L(3)) '     p14 = ' num2str(L(4))];
            msg2=['  p21 = ' num2str(L(5)) '     p22 = ' num2str(L(6)) '     p23 = ' num2str(L(7)) '     p24 = ' num2str(L(8))];
            msg3=['  p31 = ' num2str(L(9)) '     p32 = ' num2str(L(10)) '     p33 = ' num2str(L(11)) '     p34 = ' num2str(L(12))];
            msg4=['  f = ' num2str(f) ' (mm)     '];
            msg5=['  u0 = ' num2str(u0) ' (mm)     ' 'v0 = ' num2str(v0) ' (mm)'];
            msg6=['  Tx = ' num2str(tx) ' (mm)     ' 'Ty = ' num2str(ty) ' (mm)     ' 'Tz = ' num2str(tz) ' (mm)'];
            msg7=['  r11 = ' num2str(R(1,1)) '       ' 'r12 = ' num2str(R(1,2)) '       ' 'r13 = ' num2str(R(1,3))];
            msg8=['  r21 = ' num2str(R(2,1)) '       ' 'r22 = ' num2str(R(2,2)) '       ' 'r23 = ' num2str(R(2,3))];
            msg9=['  r31 = ' num2str(R(3,1)) '       ' 'r32 = ' num2str(R(3,2)) '       ' 'r33 = ' num2str(R(3,3))];
            msg10=['  Rx = ' num2str(Rx) ' (rad)     ' 'Ry = ' num2str(Ry) ' (rad)     ' 'Rz = ' num2str(Rz) ' (rad)'];
            msg11=['  Rx = ' num2str(Rxo) 'º       ' 'Ry = ' num2str(Ryo) 'º       ' 'Rz = ' num2str(Rzo) 'º'];
            msg12=['  Recon. Mean uv (pixel) -> ' num2str(mean(abs(dif_uv))) '    (' num2str(mean(error_uv)) ')'];
            msg13=['  Recon. Max uv (pixel) -> ' num2str(max(abs(dif_uv))) '    (' num2str(max(error_uv)) ')'];
            msg14=['  Recon. STD uv (pixel) -> ' num2str(std(abs(dif_uv))) '    (' num2str(std(error_uv)) ')'];
            msg15=['  Recon. Mean XYZ (mm) -> ' num2str(mean(abs(dif_xyz))) '    (' num2str(mean(error_xyz)) ')'];
            msg16=['  Recon. Max XYZ (mm) ->  ' num2str(max(abs(dif_xyz))) '    (' num2str(max(error_xyz)) ')'];
            msg17=['  Recon. STD XYZ (mm) ->  ' num2str(std(abs(dif_xyz))) '    (' num2str(std(error_xyz)) ')'];
            msg18=['  NCE = ' num2str(NCE)];
            msg19=['  CPU time (s) ->  ' num2str(tiempo_f)];
            msg_resultados = struct('resultados',{msg0;msg0;msg1;msg2;msg3;...
                                                  msg0;msg4;...
                                                  msg0;msg5;...
                                                  msg0;msg6;...
                                                  msg0;msg7;msg8;msg9;...
                                                  msg0;msg10;...
                                                  msg0;msg11;...
                                                  msg0;msg12;msg13;msg14;...
                                                  msg0;msg15;msg16;msg17;...
                                                  msg0;msg18;...
                                                  msg0;msg19;msg0});
            str = {msg_resultados.resultados};
            tipo_calib = 'Faugeras without distortion';
            muestra_resultados(str,tipo_calib,dif_uv,dif_xyz);
        else
            %Muestra en pantalla los resultados
            msg0='';
            msg1=['  p11 = ' num2str(L(1)) '     p12 = ' num2str(L(2)) '     p13 = ' num2str(L(3)) '     p14 = ' num2str(L(4))];
            msg2=['  p21 = ' num2str(L(5)) '     p22 = ' num2str(L(6)) '     p23 = ' num2str(L(7)) '     p24 = ' num2str(L(8))];
            msg3=['  p31 = ' num2str(L(9)) '     p32 = ' num2str(L(10)) '     p33 = ' num2str(L(11)) '     p34 = ' num2str(L(12))];
            msg4=['  f = ' num2str(f) ' (mm)     '];
            msg5=['  u0 = ' num2str(u0) ' (mm)     ' 'v0 = ' num2str(v0) ' (mm)'];
            msg6=['  Tx = ' num2str(tx) ' (mm)     ' 'Ty = ' num2str(ty) ' (mm)     ' 'Tz = ' num2str(tz) ' (mm)'];
            msg7=['  r11 = ' num2str(R(1,1)) '       ' 'r12 = ' num2str(R(1,2)) '       ' 'r13 = ' num2str(R(1,3))];
            msg8=['  r21 = ' num2str(R(2,1)) '       ' 'r22 = ' num2str(R(2,2)) '       ' 'r23 = ' num2str(R(2,3))];
            msg9=['  r31 = ' num2str(R(3,1)) '       ' 'r32 = ' num2str(R(3,2)) '       ' 'r33 = ' num2str(R(3,3))];
            msg10=['  Rx = ' num2str(Rx) ' (rad)     ' 'Ry = ' num2str(Ry) ' (rad)     ' 'Rz = ' num2str(Rz) ' (rad)'];
            msg11=['  Rx = ' num2str(Rxo) 'º       ' 'Ry = ' num2str(Ryo) 'º       ' 'Rz = ' num2str(Rzo) 'º'];
            msg12=['  Recon. Mean uv (pixel) -> ' num2str(mean(abs(dif_uv))) '    (' num2str(mean(error_uv)) ')'];
            msg13=['  Recon. Max uv (pixel) -> ' num2str(max(abs(dif_uv))) '    (' num2str(max(error_uv)) ')'];
            msg14=['  Recon. STD uv (pixel) -> ' num2str(std(abs(dif_uv))) '    (' num2str(std(error_uv)) ')'];
            msg15=['  CPU time (s) ->  ' num2str(tiempo_f)];
            msg_resultados = struct('resultados',{msg0;msg0;msg1;msg2;msg3;...
                                                  msg0;msg4;...
                                                  msg0;msg5;...
                                                  msg0;msg6;...
                                                  msg0;msg7;msg8;msg9;...
                                                  msg0;msg10;...
                                                  msg0;msg11;...
                                                  msg0;msg12;msg13;msg14;...
                                                  msg0;msg15;msg0});
            str = {msg_resultados.resultados};
            tipo_calib = 'Faugeras without distortion';
            muestra_resultados(str,tipo_calib,0,0);
        end 
    else
        errordlg('To perform the non coplanar Faugeras calibration is necessary to have points in two different Z coordinates in the world reference system.','Points error');
    end;
%----------------------------------- FIN ----------------------------------

% -------------------------------------------------------------------------
function menu_modelos_Callback(hObject, eventdata, handles)
% hObject    handle to menu_modelos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% ------------------------------------------------------------------------
function menu_acerca_Callback(hObject, eventdata, handles)
% hObject    handle to menu_acerca (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% -------------------------------------------------------------------------
function F = FuncionObjetivo_TSAI(ParametrosIniciales, ParametrosEcuacion, Xw, Yw, Zw, Xf, Yf)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% FUNCIÓN DE OPTIMIZACIÓN PARA LOS MODELOS DE TSAI 2D Y 3D
%--------------------------------------------------------------------------
    %Valores Iniciales
    f = ParametrosIniciales(1);
    Tz = ParametrosIniciales(2);
    k1 = ParametrosIniciales(3);

    %Parametros de la Ecuacion
    dx = ParametrosEcuacion(1);
    dy = ParametrosEcuacion(2);
    sx = ParametrosEcuacion(3);
    Ty = ParametrosEcuacion(4);
    r21 = ParametrosEcuacion(5);
    r22 = ParametrosEcuacion(6);
    r23 = ParametrosEcuacion(7);
    r31 = ParametrosEcuacion(8);
    r32 = ParametrosEcuacion(9);
    r33 = ParametrosEcuacion(10);

    residuo = (dy*Yf).*(1+k1*((dx*Xf).^2 + (dy*Yf).^2)).*(r31*Xw + r32*Yw + r33*Zw+ Tz) - f*(r21*Xw + r22*Yw + r23*Zw + Ty);
    F = norm(residuo, 2);  
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function menu_dlt3dsin_Callback(hObject, eventdata, handles)
% hObject    handle to menu_dlt3dsin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% HACE LA CALIBRACION 3D DLT SIN DISTORSION EN FUNCION DE LOS PUNTOS
%--------------------------------------------------------------------------
    global MatrizPtos;

    %Comprueba si todos los puntos están en Z=0
    coord_Z = MatrizPtos(:,3);

    if ((max(coord_Z)~=min(coord_Z))&&((sqrt((max(coord_Z)^2)+(min(coord_Z)^2)))>0.5))

        %Llama a la función que hace la calibración
        tic;
        L_DLT_3D = calib_DLT_3D_sin(MatrizPtos);
        tiempo_f = toc;

        XYZ = MatrizPtos(:,1:3);
        uv = MatrizPtos(:,4:5);
        m = size(XYZ,1);
        L = L_DLT_3D;

        uv_recons = zeros(m,2);
        for i=1:m
            u_i = (L(1)*XYZ(i,1)+L(2)*XYZ(i,2)+L(3)*XYZ(i,3)+L(4))/(L(9)*XYZ(i,1)+L(10)*XYZ(i,2)+L(11)*XYZ(i,3)+1);
            v_i = (L(5)*XYZ(i,1)+L(6)*XYZ(i,2)+L(7)*XYZ(i,3)+L(8))/(L(9)*XYZ(i,1)+L(10)*XYZ(i,2)+L(11)*XYZ(i,3)+1);
            uv_recons(i,:) = [u_i v_i];
        end

        %[X,Y]=solve('u=(L1*X+L2*Y+L3*Z+L4)/(L9*X+L10*Y+L11*Z+1)','v=(L5*X+L6*Y+L7*Z+L8)/(L9*X+L10*Y+L11*Z+1)','X,Y')
        %X=(-v*L10*L3*Z+v*L2+v*L11*Z*L2-v*L10*L4+L6*L4-L8*L2+L8*u*L10+L6*L3*Z-L7*Z*L2-u*L6+L7*Z*u*L10-L6*u*L11*Z)/(-v*L9*L2-L5*u*L10+L5*L2+u*L9*L6+L1*v*L10-L1*L6)
        %Y=-1/(-v*L9*L2-L5*u*L10+L5*L2+u*L9*L6+L1*v*L10-L1*L6)*(L1*v*L11*Z-v*L9*L3*Z-v*L9*L4-L1*L7*Z-L5*u*L11*Z-L5*u+u*L9*L7*Z+L5*L3*Z+L5*L4-L1*L8+L1*v+u*L9*L8)
        %Reconstruye las coord. mundo (X,Y,Z)
        estado_gen_ptos = get(handles.menu_puntos_genera_T,'Checked');
        estado_board = get(handles.menu_board_T,'Checked');

        if strcmp(estado_gen_ptos,'on') || strcmp(estado_board,'on')
            numero_planos = str2double(get(handles.P_Z_T,'String'));
            cota_inicial = str2double(get(handles.O_Z_T,'String'));
            separacion_planos = str2double(get(handles.E_Z_T,'String'));
            puntos_plano = str2double(get(handles.P_X_T,'String'))*str2double(get(handles.P_Y_T,'String'));
            xyz_recons = zeros(numero_planos*puntos_plano,3);
            for n_plano=1:numero_planos
                Z = ((n_plano*separacion_planos)-separacion_planos)+cota_inicial;
                %Llama a la función de reconstrucción de las coord. mundo (X,Y,Z)
                i = (n_plano*puntos_plano)-(puntos_plano-1);
                j = (n_plano*puntos_plano);
                for in=i:j
                    u = uv(in,1);
                    v = uv(in,2);
                    xyz_recons(in,1) = (-v*L(10)*L(3)*Z+v*L(2)+v*L(11)*Z*L(2)-v*L(10)*L(4)+L(6)*L(4)-L(8)*L(2)+L(8)*u*L(10)+L(6)*L(3)*Z-L(7)*Z*L(2)-u*L(6)+L(7)*Z*u*L(10)-L(6)*u*L(11)*Z)/(-v*L(9)*L(2)-L(5)*u*L(10)+L(5)*L(2)+u*L(9)*L(6)+L(1)*v*L(10)-L(1)*L(6));
                    xyz_recons(in,2) = -1/(-v*L(9)*L(2)-L(5)*u*L(10)+L(5)*L(2)+u*L(9)*L(6)+L(1)*v*L(10)-L(1)*L(6))*(L(1)*v*L(11)*Z-v*L(9)*L(3)*Z-v*L(9)*L(4)-L(1)*L(7)*Z-L(5)*u*L(11)*Z-L(5)*u+u*L(9)*L(7)*Z+L(5)*L(3)*Z+L(5)*L(4)-L(1)*L(8)+L(1)*v+u*L(9)*L(8));
                    xyz_recons(in,3) = Z;
                end 
            end
        end

        %Calcula los parámetros intrínsecos y extrínsecos de la cámara
        D2 = 1/(L(9)^2+L(10)^2+L(11)^2);
        D = sqrt(D2);

        P_1 = D*L(1:3)';
        P_2 = D*L(5:7)';
        P_3 = D*L(9:11)';

        u0 = P_1*P_3';
        v0 = P_2*P_3';

        fx = sqrt(P_1*P_1' - u0^2);
        fy = sqrt(P_2*P_2' - v0^2);

        dx_i_T = findobj(gcbf,'Tag','dx_T');
        dx = str2double(get(dx_i_T,'String'));
        dy_i_T = findobj(gcbf,'Tag','dy_T');
        dy = str2double(get(dy_i_T,'String'));

        f = ((fx*dx)+(fy*dy))/2;

        r1 = (1/fx)*(P_1 - u0*P_3);
        r2 = (1/fy)*(P_2 - v0*P_3);
        r3 = P_3;

        R = [r1;r2;r3];

        %Asegura la ortogonalidad de R
        [UU,DD,VV] = svd(R);
        R = UU*eye(3)*VV';

        [Rxo,Ryo,Rzo,Rx,Ry,Rz] = R_mat2grad(R(1,1),R(1,2),R(1,3),R(2,1),R(2,2),R(2,3),R(3,1));

        tz = D;
        tx = (D*L(4)-u0*tz)/fx;
        ty = (D*L(8)-v0*tz)/fy;

        %Calcula el coeficiente NCE
        if strcmp(estado_gen_ptos,'on') || strcmp(estado_board,'on')
            NCE = NCE_coef(XYZ,xyz_recons,f,tz,dx,dy,numero_planos,cota_inicial,separacion_planos,puntos_plano);
            dif_xyz = XYZ-xyz_recons;
            error_xyz = sqrt(dif_xyz(:,1).^2+dif_xyz(:,2).^2+dif_xyz(:,3).^2);
        end

        dif_uv = uv-uv_recons;
        error_uv = sqrt(dif_uv(:,1).^2+dif_uv(:,2).^2);

        if strcmp(estado_gen_ptos,'on') || strcmp(estado_board,'on')
            %Muestra en pantalla los resultados
            msg0='';
            msg1=['  L1 = ' num2str(L_DLT_3D(1)) '        L2 = ' num2str(L_DLT_3D(2))];
            msg2=['  L3 = ' num2str(L_DLT_3D(3)) '        L4 = ' num2str(L_DLT_3D(4))];
            msg3=['  L5 = ' num2str(L_DLT_3D(5)) '        L6 = ' num2str(L_DLT_3D(6))];
            msg4=['  L7 = ' num2str(L_DLT_3D(7)) '        L8 = ' num2str(L_DLT_3D(8))];
            msg5=['  L9 = ' num2str(L_DLT_3D(9)) '        L10 = ' num2str(L_DLT_3D(10))];
            msg6=['  L11 = ' num2str(L_DLT_3D(11))];
            msg7=['  f = ' num2str(f) ' (mm)     '];
            msg8=['  Tx = ' num2str(tx) ' (mm)     ' 'Ty = ' num2str(ty) ' (mm)     ' 'Tz = ' num2str(tz) ' (mm)'];
            msg9=['  r11 = ' num2str(R(1,1)) '       ' 'r12 = ' num2str(R(1,2)) '       ' 'r13 = ' num2str(R(1,3))];
            msg10=['  r21 = ' num2str(R(2,1)) '       ' 'r22 = ' num2str(R(2,2)) '       ' 'r23 = ' num2str(R(2,3))];
            msg11=['  r31 = ' num2str(R(3,1)) '       ' 'r32 = ' num2str(R(3,2)) '       ' 'r33 = ' num2str(R(3,3))];
            msg12=['  Rx = ' num2str(Rx) ' (rad)     ' 'Ry = ' num2str(Ry) ' (rad)     ' 'Rz = ' num2str(Rz) ' (rad)'];
            msg13=['  Rx = ' num2str(Rxo) 'º       ' 'Ry = ' num2str(Ryo) 'º       ' 'Rz = ' num2str(Rzo) 'º'];
            msg14=['  Recon. Mean uv (pixel) -> ' num2str(mean(abs(dif_uv))) '    (' num2str(mean(error_uv)) ')'];
            msg15=['  Recon. Max uv (pixel) -> ' num2str(max(abs(dif_uv))) '    (' num2str(max(error_uv)) ')'];
            msg16=['  Recon. STD uv (pixel) -> ' num2str(std(abs(dif_uv))) '    (' num2str(std(error_uv)) ')'];
            msg17=['  Recon. Mean XYZ (mm) -> ' num2str(mean(abs(dif_xyz))) '    (' num2str(mean(error_xyz)) ')'];
            msg18=['  Recon. Max XYZ (mm) ->  ' num2str(max(abs(dif_xyz))) '    (' num2str(max(error_xyz)) ')'];
            msg19=['  Recon. STD XYZ (mm) ->  ' num2str(std(abs(dif_xyz))) '    (' num2str(std(error_xyz)) ')'];
            msg20=['  NCE = ' num2str(NCE)];
            msg21=['  CPU time (s) ->  ' num2str(tiempo_f)];
            msg_resultados = struct('resultados',{msg0;msg0;msg1;msg2;msg3;msg4;msg5;msg6;...
                                                  msg0;msg7;...
                                                  msg0;msg8;...
                                                  msg0;msg9;msg10;msg11;...
                                                  msg0;msg12;...
                                                  msg0;msg13;...
                                                  msg0;msg14;msg15;msg16;...
                                                  msg0;msg17;msg18;msg19;...
                                                  msg0;msg20;...
                                                  msg0;msg21;msg0});
            str = {msg_resultados.resultados};
            tipo_calib = 'DLT 3D without distortion';
            muestra_resultados(str,tipo_calib,dif_uv,dif_xyz);
        else
            %Muestra en pantalla los resultados
            msg0='';
            msg1=['  L1 = ' num2str(L_DLT_3D(1)) '        L2 = ' num2str(L_DLT_3D(2))];
            msg2=['  L3 = ' num2str(L_DLT_3D(3)) '        L4 = ' num2str(L_DLT_3D(4))];
            msg3=['  L5 = ' num2str(L_DLT_3D(5)) '        L6 = ' num2str(L_DLT_3D(6))];
            msg4=['  L7 = ' num2str(L_DLT_3D(7)) '        L8 = ' num2str(L_DLT_3D(8))];
            msg5=['  L9 = ' num2str(L_DLT_3D(9)) '        L10 = ' num2str(L_DLT_3D(10))];
            msg6=['  L11 = ' num2str(L_DLT_3D(11))];
            msg7=['  f = ' num2str(f) ' (mm)     '];
            msg8=['  Tx = ' num2str(tx) ' (mm)     ' 'Ty = ' num2str(ty) ' (mm)     ' 'Tz = ' num2str(tz) ' (mm)'];
            msg9=['  r11 = ' num2str(R(1,1)) '       ' 'r12 = ' num2str(R(1,2)) '       ' 'r13 = ' num2str(R(1,3))];
            msg10=['  r21 = ' num2str(R(2,1)) '       ' 'r22 = ' num2str(R(2,2)) '       ' 'r23 = ' num2str(R(2,3))];
            msg11=['  r31 = ' num2str(R(3,1)) '       ' 'r32 = ' num2str(R(3,2)) '       ' 'r33 = ' num2str(R(3,3))];
            msg12=['  Rx = ' num2str(Rx) ' (rad)     ' 'Ry = ' num2str(Ry) ' (rad)     ' 'Rz = ' num2str(Rz) ' (rad)'];
            msg13=['  Rx = ' num2str(Rxo) 'º       ' 'Ry = ' num2str(Ryo) 'º       ' 'Rz = ' num2str(Rzo) 'º'];
            msg14=['  Recon. Mean uv (pixel) -> ' num2str(mean(abs(dif_uv))) '    (' num2str(mean(error_uv)) ')'];
            msg15=['  Recon. Max uv (pixel) -> ' num2str(max(abs(dif_uv))) '    (' num2str(max(error_uv)) ')'];
            msg16=['  Recon. STD uv (pixel) -> ' num2str(std(abs(dif_uv))) '    (' num2str(std(error_uv)) ')'];
            msg17=['  CPU time (s) ->  ' num2str(tiempo_f)];
            msg_resultados = struct('resultados',{msg0;msg0;msg1;msg2;msg3;msg4;msg5;msg6;...
                                                  msg0;msg7;...
                                                  msg0;msg8;...
                                                  msg0;msg9;msg10;msg11;...
                                                  msg0;msg12;...
                                                  msg0;msg13;...
                                                  msg0;msg14;msg15;msg16;...
                                                  msg0;msg17;msg0});
            str = {msg_resultados.resultados};
            tipo_calib = 'DLT 3D without distortion';
            muestra_resultados(str,tipo_calib,0,0);
        end
    else
        errordlg('To perform the non coplanar Tsai calibration is necessary to have points in two different Z coordinates in the world reference system.','Points error');
    end;
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function menu_dlt3dcon_Callback(hObject, eventdata, handles)
% hObject    handle to menu_dlt3dcon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% HACE LA CALIBRACION 3D DLT CON DISTORSION EN FUNCION DE LOS PUNTOS
%--------------------------------------------------------------------------
    global MatrizPtos;

    % Avisa de que puede tardar un tiempo
    button_DLT3Dcom = questdlg('It will take a few minutes. Do you want to continue this operation?', ...
                      'Warning!','Yes','No','No');

    uiwait(gcf,1)
    if strcmp(button_DLT3Dcom,'Yes')
        %Comprueba si todos los puntos están en Z=0
        coord_Z = MatrizPtos(:,3);
        if ((max(coord_Z)~=min(coord_Z))&&((sqrt((max(coord_Z)^2)+(min(coord_Z)^2)))>0.5))

            %Llama a la función que hace la calibración
            tic;
            L_DLT_3D = calib_DLT_3D_con(MatrizPtos);
            tiempo_f = toc;

            XYZ = MatrizPtos(:,1:3);
            uv = MatrizPtos(:,4:5);
            m = size(XYZ,1);

            Cu_i_T = findobj(gcbf,'Tag','Cu_T');
            u0 = (str2double(get(Cu_i_T,'String')))/2;
            Cv_i_T = findobj(gcbf,'Tag','Cv_T');
            v0 = (str2double(get(Cv_i_T,'String')))/2;

            ME = zeros(m,1);
            Mn = zeros(m,1);
            Mr = zeros(m,1);
            for i=1:m
                E = uv(i,1)-u0;
                ME(i,:) = E;
                n = uv(i,2)-v0;
                Mn(i,:) = n;
                r = sqrt(E^2+n^2);
                Mr(i,:) = r;
            end

            L = L_DLT_3D(1:16);
            E = ME;
            n = Mn;
            r = Mr;

            uv_recons = zeros(m,2);
            error_optico_uv = zeros(m,2);
            for i=1:m
                u_i_sindist = (L(1)*XYZ(i,1)+L(2)*XYZ(i,2)+L(3)*XYZ(i,3)+L(4))/(L(9)*XYZ(i,1)+L(10)*XYZ(i,2)+L(11)*XYZ(i,3)+1);
                v_i_sindist = (L(5)*XYZ(i,1)+L(6)*XYZ(i,2)+L(7)*XYZ(i,3)+L(8))/(L(9)*XYZ(i,1)+L(10)*XYZ(i,2)+L(11)*XYZ(i,3)+1);
                err_optico_u = E(i)*(L(12)*r(i)^2+L(13)*r(i)^4+L(14)*r(i)^6)+L(15)*(r(i)^2+2*E(i)^2)+L(16)*E(i)*n(i);
                err_optico_v = n(i)*(L(12)*r(i)^2+L(13)*r(i)^4+L(14)*r(i)^6)+L(16)*(r(i)^2+2*n(i)^2)+L(15)*E(i)*n(i);
                u_i = u_i_sindist + err_optico_u;
                v_i = v_i_sindist + err_optico_v;
                error_optico_uv(i,:) = [err_optico_u err_optico_v];
                uv_recons(i,:) = [u_i v_i];
            end

            %[X,Y]=solve('u=(L1*X+L2*Y+L3*Z+L4)/(L9*X+L10*Y+L11*Z+1)','v=(L5*X+L6*Y+L7*Z+L8)/(L9*X+L10*Y+L11*Z+1)','X,Y')
            %X=(-v*L10*L3*Z+v*L2+v*L11*Z*L2-v*L10*L4+L6*L4-L8*L2+L8*u*L10+L6*L3*Z-L7*Z*L2-u*L6+L7*Z*u*L10-L6*u*L11*Z)/(-v*L9*L2-L5*u*L10+L5*L2+u*L9*L6+L1*v*L10-L1*L6)
            %Y=-1/(-v*L9*L2-L5*u*L10+L5*L2+u*L9*L6+L1*v*L10-L1*L6)*(L1*v*L11*Z-v*L9*L3*Z-v*L9*L4-L1*L7*Z-L5*u*L11*Z-L5*u+u*L9*L7*Z+L5*L3*Z+L5*L4-L1*L8+L1*v+u*L9*L8)
            %Reconstruye las coord. mundo (X,Y,Z)
            estado_gen_ptos = get(handles.menu_puntos_genera_T,'Checked');
            estado_board = get(handles.menu_board_T,'Checked');

            if strcmp(estado_gen_ptos,'on') || strcmp(estado_board,'on')
                numero_planos = str2double(get(handles.P_Z_T,'String'));
                cota_inicial = str2double(get(handles.O_Z_T,'String'));
                separacion_planos = str2double(get(handles.E_Z_T,'String'));
                puntos_plano = str2double(get(handles.P_X_T,'String'))*str2double(get(handles.P_Y_T,'String'));
                xyz_recons = zeros(numero_planos*puntos_plano,3);
                for n_plano=1:numero_planos
                    Z = ((n_plano*separacion_planos)-separacion_planos)+cota_inicial;
                    %Llama a la función de reconstrucción de las coord. mundo (X,Y,Z)
                    i = (n_plano*puntos_plano)-(puntos_plano-1);
                    j = (n_plano*puntos_plano);
                    for in=i:j
                        u = uv(in,1)-error_optico_uv(in,1);
                        v = uv(in,2)-error_optico_uv(in,2);
                        xyz_recons(in,1) = (-v*L(10)*L(3)*Z+v*L(2)+v*L(11)*Z*L(2)-v*L(10)*L(4)+L(6)*L(4)-L(8)*L(2)+L(8)*u*L(10)+L(6)*L(3)*Z-L(7)*Z*L(2)-u*L(6)+L(7)*Z*u*L(10)-L(6)*u*L(11)*Z)/(-v*L(9)*L(2)-L(5)*u*L(10)+L(5)*L(2)+u*L(9)*L(6)+L(1)*v*L(10)-L(1)*L(6));
                        xyz_recons(in,2) = -1/(-v*L(9)*L(2)-L(5)*u*L(10)+L(5)*L(2)+u*L(9)*L(6)+L(1)*v*L(10)-L(1)*L(6))*(L(1)*v*L(11)*Z-v*L(9)*L(3)*Z-v*L(9)*L(4)-L(1)*L(7)*Z-L(5)*u*L(11)*Z-L(5)*u+u*L(9)*L(7)*Z+L(5)*L(3)*Z+L(5)*L(4)-L(1)*L(8)+L(1)*v+u*L(9)*L(8));
                        xyz_recons(in,3) = Z;
                    end 
                end
            end

            %Calcula los parámetros intrínsecos y extrínsecos de la cámara
            L = L_DLT_3D;
            D2 = 1/(L(9)^2+L(10)^2+L(11)^2);
            D = sqrt(D2);

            P_1 = D*L(1:3)';
            P_2 = D*L(5:7)';
            P_3 = D*L(9:11)';

            u0 = P_1*P_3';
            v0 = P_2*P_3';

            fx = sqrt(P_1*P_1' - u0^2);
            fy = sqrt(P_2*P_2' - v0^2);

            dx_i_T = findobj(gcbf,'Tag','dx_T');
            dx = str2double(get(dx_i_T,'String'));
            dy_i_T = findobj(gcbf,'Tag','dy_T');
            dy = str2double(get(dy_i_T,'String'));

            f = ((fx*dx)+(fy*dy))/2;

            r1 = (1/fx)*(P_1 - u0*P_3);
            r2 = (1/fy)*(P_2 - v0*P_3);
            r3 = P_3;

            R = [r1;r2;r3];

            %Asegura la ortogonalidad de R
            [UU,DD,VV] = svd(R);
            R = UU*eye(3)*VV';

            [Rxo,Ryo,Rzo,Rx,Ry,Rz] = R_mat2grad(R(1,1),R(1,2),R(1,3),R(2,1),R(2,2),R(2,3),R(3,1));

            tz = D;
            tx = (D*L(4)-u0*tz)/fx;
            ty = (D*L(8)-v0*tz)/fy;

            %Calcula el coeficiente NCE
            if strcmp(estado_gen_ptos,'on') || strcmp(estado_board,'on')
                NCE = NCE_coef(XYZ,xyz_recons,f,tz,dx,dy,numero_planos,cota_inicial,separacion_planos,puntos_plano);
                dif_xyz = XYZ-xyz_recons;
                error_xyz = sqrt(dif_xyz(:,1).^2+dif_xyz(:,2).^2+dif_xyz(:,3).^2);
            end

            dif_uv = uv-uv_recons;
            error_uv = sqrt(dif_uv(:,1).^2+dif_uv(:,2).^2);

            if strcmp(estado_gen_ptos,'on') || strcmp(estado_board,'on')
                %Muestra en pantalla los resultados
                msg0='';
                msg1=['  L1 = ' num2str(L_DLT_3D(1))    '        L2 = ' num2str(L_DLT_3D(2))];
                msg2=['  L3 = ' num2str(L_DLT_3D(3))    '        L4 = ' num2str(L_DLT_3D(4))];
                msg3=['  L5 = ' num2str(L_DLT_3D(5))    '        L6 = ' num2str(L_DLT_3D(6))];
                msg4=['  L7 = ' num2str(L_DLT_3D(7))   '        L8 = ' num2str(L_DLT_3D(8))];
                msg5=['  L9 = ' num2str(L_DLT_3D(9))   '        L10 = ' num2str(L_DLT_3D(10))];
                msg6=['  L11 = ' num2str(L_DLT_3D(11)) '        L12 = ' num2str(L_DLT_3D(12))];
                msg7=['  L13 = ' num2str(L_DLT_3D(13)) '        L14 = ' num2str(L_DLT_3D(14))];
                msg8=['  L15 = ' num2str(L_DLT_3D(15)) '        L16 = ' num2str(L_DLT_3D(16))];
                msg9=['  f = ' num2str(f) ' (mm)     '];
                msg10=['  Tx = ' num2str(tx) ' (mm)     ' 'Ty = ' num2str(ty) ' (mm)     ' 'Tz = ' num2str(tz) ' (mm)'];
                msg11=['  r11 = ' num2str(R(1,1)) '       ' 'r12 = ' num2str(R(1,2)) '       ' 'r13 = ' num2str(R(1,3))];
                msg12=['  r21 = ' num2str(R(2,1)) '       ' 'r22 = ' num2str(R(2,2)) '       ' 'r23 = ' num2str(R(2,3))];
                msg13=['  r31 = ' num2str(R(3,1)) '       ' 'r32 = ' num2str(R(3,2)) '       ' 'r33 = ' num2str(R(3,3))];
                msg14=['  Rx = ' num2str(Rx) ' (rad)     ' 'Ry = ' num2str(Ry) ' (rad)     ' 'Rz = ' num2str(Rz) ' (rad)'];
                msg15=['  Rx = ' num2str(Rxo) 'º       ' 'Ry = ' num2str(Ryo) 'º       ' 'Rz = ' num2str(Rzo) 'º'];
                msg16=['  Recon. Mean uv (pixel) -> ' num2str(mean(abs(dif_uv))) '    (' num2str(mean(error_uv)) ')'];
                msg17=['  Recon. Max uv (pixel) -> ' num2str(max(abs(dif_uv))) '    (' num2str(max(error_uv)) ')'];
                msg18=['  Recon. STD uv (pixel) -> ' num2str(std(abs(dif_uv))) '    (' num2str(std(error_uv)) ')'];
                msg19=['  Recon. Mean XYZ (mm) -> ' num2str(mean(abs(dif_xyz))) '    (' num2str(mean(error_xyz)) ')'];
                msg20=['  Recon. Max XYZ (mm) ->  ' num2str(max(abs(dif_xyz))) '    (' num2str(max(error_xyz)) ')'];
                msg21=['  Recon. STD XYZ (mm) ->  ' num2str(std(abs(dif_xyz))) '    (' num2str(std(error_xyz)) ')'];
                msg22=['  NCE = ' num2str(NCE)];
                msg23=['  CPU time (s) ->  ' num2str(tiempo_f)];
                msg_resultados = struct('resultados',{msg0;msg0;msg1;msg2;msg3;msg4;msg5;msg6;msg7;msg8;...
                                                      msg0;msg9;...
                                                      msg0;msg10;...
                                                      msg0;msg11;msg12;msg13;...
                                                      msg0;msg14;...
                                                      msg0;msg15;...
                                                      msg0;msg16;msg17;msg18;...
                                                      msg0;msg19;msg20;msg21;...
                                                      msg0;msg22;...
                                                      msg0;msg23;msg0});
                str = {msg_resultados.resultados};
                tipo_calib = 'DLT 3D with distortion';
                muestra_resultados(str,tipo_calib,dif_uv,dif_xyz);
            else
                %Muestra en pantalla los resultados
                msg0='';
                msg1=['  L1 = ' num2str(L_DLT_3D(1))    '        L2 = ' num2str(L_DLT_3D(2))];
                msg2=['  L3 = ' num2str(L_DLT_3D(3))    '        L4 = ' num2str(L_DLT_3D(4))];
                msg3=['  L5 = ' num2str(L_DLT_3D(5))    '        L6 = ' num2str(L_DLT_3D(6))];
                msg4=['  L7 = ' num2str(L_DLT_3D(7))   '        L8 = ' num2str(L_DLT_3D(8))];
                msg5=['  L9 = ' num2str(L_DLT_3D(9))   '        L10 = ' num2str(L_DLT_3D(10))];
                msg6=['  L11 = ' num2str(L_DLT_3D(11)) '        L12 = ' num2str(L_DLT_3D(12))];
                msg7=['  L13 = ' num2str(L_DLT_3D(13)) '        L14 = ' num2str(L_DLT_3D(14))];
                msg8=['  L15 = ' num2str(L_DLT_3D(15)) '        L16 = ' num2str(L_DLT_3D(16))];
                msg9=['  f = ' num2str(f) ' (mm)     '];
                msg10=['  Tx = ' num2str(tx) ' (mm)     ' 'Ty = ' num2str(ty) ' (mm)     ' 'Tz = ' num2str(tz) ' (mm)'];
                msg11=['  r11 = ' num2str(R(1,1)) '       ' 'r12 = ' num2str(R(1,2)) '       ' 'r13 = ' num2str(R(1,3))];
                msg12=['  r21 = ' num2str(R(2,1)) '       ' 'r22 = ' num2str(R(2,2)) '       ' 'r23 = ' num2str(R(2,3))];
                msg13=['  r31 = ' num2str(R(3,1)) '       ' 'r32 = ' num2str(R(3,2)) '       ' 'r33 = ' num2str(R(3,3))];
                msg14=['  Rx = ' num2str(Rx) ' (rad)     ' 'Ry = ' num2str(Ry) ' (rad)     ' 'Rz = ' num2str(Rz) ' (rad)'];
                msg15=['  Rx = ' num2str(Rxo) 'º       ' 'Ry = ' num2str(Ryo) 'º       ' 'Rz = ' num2str(Rzo) 'º'];
                msg16=['  Recon. Mean uv (pixel) -> ' num2str(mean(abs(dif_uv))) '    (' num2str(mean(error_uv)) ')'];
                msg17=['  Recon. Max uv (pixel) -> ' num2str(max(abs(dif_uv))) '    (' num2str(max(error_uv)) ')'];
                msg18=['  Recon. STD uv (pixel) -> ' num2str(std(abs(dif_uv))) '    (' num2str(std(error_uv)) ')'];
                msg29=['  CPU time (s) ->  ' num2str(tiempo_f)];
                msg_resultados = struct('resultados',{msg0;msg0;msg1;msg2;msg3;msg4;msg5;msg6;msg7;msg8;...
                                                      msg0;msg9;...
                                                      msg0;msg10;...
                                                      msg0;msg11;msg12;msg13;...
                                                      msg0;msg14;...
                                                      msg0;msg15;...
                                                      msg0;msg16;msg17;msg18;...
                                                      msg0;msg29;msg0});
                str = {msg_resultados.resultados};
                tipo_calib = 'DLT 3D with distortion';
                muestra_resultados(str,tipo_calib,0,0);
            end
        else
            errordlg('To perform the non coplanar DLT calibration is necessary to have points in two different Z coordinates in the world reference system.','Points error');
        end
    end
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function menu_puntosXu_load_T_Callback(hObject, eventdata, handles)
% hObject    handle to menu_puntosXu_load_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% FUNCIÓN QUE CARGA PUNTOS (X,Y,Z) Y (u,v). Carga un fichero con las
% coordenadas mundo e imagen de los puntos, que usa para hacer una
% calibración Tsai (2D o 3D) para calcular los parámetros intrínsecos y
% extrínsecos corresponientes.HABRÁ PROBLEMAS SI LOS PUNTOS NO SON VALIDOS
% PARA UNA CALIBRACIÓN DE TSAI
%--------------------------------------------------------------------------
    global XwYwZw_load;
    global MatrizPtos;
    global PtosOptimizacion;

    filterindex_cali = 0;
    [filename_cali, pathname_cali, filterindex_cali] = uigetfile( ...
               {  '*.pto','Tsai calibration (*.pto)'; ...
                  '*.*',  'All files (*.*)'}, ...
                  'Load calibration points', ...
                  'MultiSelect', 'on');

    if filterindex_cali ~= 0
        [i,n_archivos] = size(filename_cali);
        if iscellstr(filename_cali) == 1
            XwYwZwUV_celda = cell(n_archivos,1);
            for i=1:n_archivos
                XwYwZwUV_celda{i} = load([pathname_cali char(filename_cali(1,i))]);
            end
            XwYwZwUV_carga = cell2mat(XwYwZwUV_celda);
        else
            XwYwZwUV_carga = load([pathname_cali filename_cali]);
        end
        MatrizPtos = [XwYwZwUV_carga(:,1:5)];
        XwYwZw_load = MatrizPtos(:,1:3);
        
        %Comprueba si hay coordenadas U o V negativas
        if (min(MatrizPtos(:,4))<0) || (min(MatrizPtos(:,5))<0)
            %Reinicializa el ensayo
            inicializa_sesion;
            generador;
            Cu = str2double(get(handles.Cu_T,'String'));
            Cv = str2double(get(handles.Cv_T,'String'));
            dibuja_ptos(Cu,Cv);
            errordlg('There are negative values in the (u,v) coordinates.','Points error','modal');
            return
        end
        num_pto = size(MatrizPtos,1);
        set(handles.num_puntos_T,'String',int2str(num_pto));
        if iscellstr(filename_cali) == 1
            archivos_celda = cell(1,n_archivos);
            for i=1:n_archivos
                archivos_celda{i} = [char(filename_cali(1,i)) ' '];
            end
            archivos = cell2mat(archivos_celda);
            set(handles.nombre_cali_T,'String',archivos);
        else
            set(handles.nombre_cali_T,'String',filename_cali);
        end
        set(handles.num_puntos_T,'Visible','on');
        set(handles.nombre_cali_T,'Visible','on');
        set(handles.text50,'Visible','on');
        set(handles.text51,'Visible','on');
        estado_generador('off');
        set(handles.menu_puntosXu_load_T,'Checked','on');
        set(handles.menu_puntos_genera_T,'Checked','off');
        set(handles.menu_puntos_load_T,'Checked','off');
        set(handles.menu_board_T,'Checked','off');
        set(handles.menu_guarda_sesion_T,'Enable','off');
    else
        return;
    end

    %Caracteristicas de la camara
    dx = str2double(get(handles.dx_T,'String'));
    dy = str2double(get(handles.dy_T,'String'));
    Ncx = str2double(get(handles.Ncx_T,'String'));
    Nfx = str2double(get(handles.Nfx_T,'String'));
    Cu = str2double(get(handles.Cu_T,'String'))/2;
    Cv = str2double(get(handles.Cv_T,'String'))/2;

    %Comprueba si son puntos complanares o no coplanares
    coord_Z = MatrizPtos(:,3);
    if ((max(coord_Z)<0.25)&&(min(coord_Z)>-0.25)) %pongo 0.25 y no 0 por si hay ruido
        %Hace calibración Tsai 2D
        [r11 r12 r13 r21 r22 r23 r31 r32 r33 Tx Ty Tz f k1 sx] = calib_Tsai_2D(dx,dy,Ncx,Nfx,Cu,Cv);
    elseif ((max(coord_Z)~=min(coord_Z))&&((sqrt((max(coord_Z)^2)+(min(coord_Z)^2)))>0.5))
        %Hace calibración Tsai 3D
        [r11 r12 r13 r21 r22 r23 r31 r32 r33 Tx Ty Tz f k1 sx] = calib_Tsai_3D(dx,dy,Ncx,Nfx,Cu,Cv);
    else
        errordlg('Points error.','Points error');
    end

    [Rx_g,Ry_g,Rz_g,Rx,Ry,Rz] = R_mat2grad(r11,r12,r13,r21,r22,r23,r31);

    set(handles.f_T,'String',f);
    set(handles.k1_T,'String',k1);
    set(handles.sx_T,'String',sx);
    set(handles.Tx_T,'String',Tx);
    set(handles.Ty_T,'String',Ty);
    set(handles.Tz_T,'String',Tz);
    set(handles.Rx_T,'String',Rx_g);
    set(handles.Ry_T,'String',Ry_g);
    set(handles.Rz_T,'String',Rz_g);
    set(handles.Rx_slider_T,'Value',Rx_g);
    set(handles.Ry_slider_T,'Value',Ry_g);
    set(handles.Rz_slider_T,'Value',Rz_g);
%--------------------------------------------------------------------------
% DIBUJA LOS PUNTOS
%--------------------------------------------------------------------------
    % generador;
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function [r11f r12f r13f r21f r22f r23f r31f r32f r33f Tx Ty Tz f k1 sx] = calib_Tsai_2D(dx,dy,Ncx,Nfx,Cu,Cv)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% FUNCIÓN QUE HACE LA CALIBRACION 2D DE TSAI
%--------------------------------------------------------------------------

    global MatrizPtos;
    global PtosOptimizacion;
    %----------------------------------------------------------------------
    % COMIENZA LA CALIBRACIÓN TSAI 2D
    %----------------------------------------------------------------------  
    d1x = dx * (Ncx/Nfx);

    %Crea la matiz XYZuv a partir del fichero de puntos indicado
    XYZuv = MatrizPtos;

    %Obtiene las dimensiones de XYZuv (mMatriz = filas | nMatriz = columnas)
    mMatriz = size(XYZuv,1);

    %Crea dos matrices independientes XYZ y UV a partir de la matriz XYZuv
    XYZ = [XYZuv(:,1) XYZuv(:,2) XYZuv(:,3)];
    UV = [XYZuv(:,4) XYZuv(:,5)];

    %**********************************************************************
    %   ETAPA 1 a)Calculo de (Xpd,Ypd) tomando sx=1
    %**********************************************************************
    %Aproximacion de sx
    sx = 1;

    %Crea la matriz XpdYpd
%     XpdYpd = zeros(mMatriz,2);
%     for i=1:mMatriz
%         XpdYpd(i,:) = [((d1x/sx)*(UV(i,1) - Cu)) (dy*(UV(i,2) - Cv))];
%     end
    uv_cent = ([1 0 -Cu; 0 1 -Cv; 0 0 1]*[UV ones(mMatriz,1)]')';
    XpdYpd = [uv_cent(:,1).*(d1x/sx) uv_cent(:,2).*dy];
   
    %**********************************************************************
    %   ETAPA 1 b)Calculo matriz L
    %**********************************************************************
    %Crea matriz (x,y)pd(X,Y,Z)
%     XpdX = zeros(mMatriz,5);
%     for i=1:mMatriz
%         XpdX(i,:) = [(XpdYpd(i,2)*XYZ(i,1)) (XpdYpd(i,2)*XYZ(i,2)) (XpdYpd(i,2)) (-XpdYpd(i,1)*XYZ(i,1)) (-XpdYpd(i,1)*XYZ(i,2))];
%     end
    XpdX = [(XpdYpd(:,2).*XYZ(:,1)) (XpdYpd(:,2).*XYZ(:,2)) (XpdYpd(:,2)) (-XpdYpd(:,1).*XYZ(:,1)) (-XpdYpd(:,1).*XYZ(:,2))];
    
    %Calcula matriz L
    L=XpdX\XpdYpd(:,1);

    %**********************************************************************
    %   ETAPA 1 c)Calculo r11,r12,r13... y Tx, Ty
    %**********************************************************************
    %Calcula modulo Ty
    epsilon = 1.0e-8;
    if ((abs(L(1,1)) < epsilon) && (abs(L(2,1)) < epsilon))
        Tymod = sqrt(1/((L(4,1)^2) + (L(5,1)^2)));
    elseif ((abs(L(4,1)) < epsilon) && (abs(L(5,1)) < epsilon))
        Tymod = sqrt(1/((L(1,1)^2) + (L(2,1)^2)));
    elseif ((abs(L(1,1)) < epsilon) && (abs(L(4,1)) < epsilon))
        Tymod = sqrt(1/((L(2,1)^2) + (L(5,1)^2)));
    elseif ((abs(L(2,1)) < epsilon) && (abs(L(5,1)) < epsilon))
        Tymod = sqrt(1/((L(1,1)^2) + (L(4,1)^2)));
    else
        sr = (L(1,1)^2) + (L(2,1)^2) + (L(4,1)^2) + (L(5,1)^2);
        sa = ((L(1,1)*L(5,1)) - (L(4,1)*L(2,1)))^2;
        Tymod = sqrt((sr - sqrt((sr^2) - 4*sa))/(2*sa));
    end

    %---------------------------
    %   Calcula Ty
    %---------------------------
        %Calcula r11,r12,.....
        r11 = L(1,1)*Tymod;
        r12 = L(2,1)*Tymod;
        Tx = L(3,1)*Tymod;
        r21 = L(4,1)*Tymod;
        r22 = L(5,1)*Tymod;

        %---------------------------
        %   Determina signo de Ty
        %---------------------------
        %Busca el pto (Xpd,Ypd) mas alejado del centro de la imagen
        distanciaMAX = 0;
        for i=1:mMatriz
            distancia = sqrt((XpdYpd(i,1)^2)+(XpdYpd(i,2)^2));
            if distancia > distanciaMAX
                ptolejano = i;
                distanciaMAX = distancia;
            end
        end

        %Calcula X1 e Y1 tomando el pto mas lejano del centro (Cu,Cv).
        X1 = r11*XYZ(ptolejano,1) + r12*XYZ(ptolejano,2) + Tx;
        Y1 = r21*XYZ(ptolejano,1) + r22*XYZ(ptolejano,2) + Tymod;

        %Calcula u1 y v1
        u1 = XpdYpd(ptolejano,1);
        v1 = XpdYpd(ptolejano,2);

        %Determina el signo de Ty en funcion de X1,Y1,u1,v1
        if ((sign(X1) == sign(u1)) && (sign(Y1) == sign(v1)))
            Ty = Tymod;
        else
            Ty = Tymod * (-1);
        end

    %----------------------------------
    %   Calcula matriz de rotacion R
    %----------------------------------
    r11 = L(1,1)*Ty;
    r12 = L(2,1)*Ty;
    r13 = sqrt(1 - r11^2 - r12^2);
    Tx = L(3,1)*Ty;
    r21 = L(4,1)*Ty;
    r22 = L(5,1)*Ty;
    r23 = sqrt(1 - r21^2 - r22^2);
    if (r11*r21 + r12*r22) < 0
        r23 = r23;
    else
        r23 = -r23;
    end

    r31 = (r12*r23) - (r13*r22);
    r32 = (r13*r21) - (r11*r23);
    r33 = (r11*r22) - (r12*r21);
    R = [r11 r12 r13;r21 r22 r23;r31 r32 r33];

    %-----------------------------------------------------------
    %   Mejora la "ortonormalidad" de R -> Segun Reg Willson
    %-----------------------------------------------------------
    %Paso de [R]tsai -> Rx,Ry,Rz.
    [Rx_g,Ry_g,Rz_g,Rx,Ry,Rz] = R_mat2grad(r11,r12,r13,r21,r22,r23,r31);

    %Paso de Rx,Ry,Rz -> [R]corregida.
    [r11f,r12f,r13f,r21f,r22f,r23f,r31f,r32f,r33f] = R_grad2mat(Rx,Ry,Rz);

    %************************************************************************************
    %   ETAPA 2 a)Calculo de una aproximacion de f y Tz sin tener en cuenta la distorsion
    %************************************************************************************
    %Calcula la aprox. de f y Tz
        %Crea matriz Y1
%         Y1 = zeros(mMatriz,1);
%         for i=1:mMatriz
%             Y1(i,:) = r21f*XYZ(i,1) + r22f*XYZ(i,2) + r23f*XYZ(i,3) + Ty;
%         end
        Y1 = r21f*XYZ(:,1) + r22f*XYZ(:,2) + r23f*XYZ(:,3) + Ty*ones(mMatriz,1);
        
        %Crea matriz dyyi
        dyyi = XpdYpd(:,2);

        %Crea matriz W
%         W = zeros(mMatriz,1);
%         for i=1:mMatriz
%             W(i,:) = r31f*XYZ(i,1) + r32f*XYZ(i,2) + r33f*XYZ(i,3);
%         end
        W = r31f*XYZ(:,1) + r32f*XYZ(:,2) + r33f*XYZ(:,3);
        
        %Crea matriz dyyiWi
%         dyyiWi = zeros(mMatriz,1);
%         for i=1:mMatriz
%             dyyiWi(i,:) = XpdYpd(i,2)*W(i,1);
%         end
        dyyiWi = XpdYpd(:,2).*W(:,1);

    %Define la aprox. de f y Tz
    fTz = [Y1 -dyyi]\dyyiWi;
    f = fTz(1,1);
    Tz = fTz(2,1);
    k1 = 0;

    %---------------------------------------------------------------------------------
    %   Cambia la matriz R si f<0 y vuelve a calcular las aproximaciones de f y Tz
    %---------------------------------------------------------------------------------
    if f < 0
        r13f = -r13f;
        r23f = -r23f;
        r31f = -r31f;
        r32f = -r32f;

%         Y1 = zeros(mMatriz,1);
%         for i=1:mMatriz
%             Y1(i,:) = r21f*XYZ(i,1) + r22f*XYZ(i,2) + r23f*XYZ(i,3) + Ty;
%         end
        Y1 = r21f*XYZ(:,1) + r22f*XYZ(:,2) + r23f*XYZ(:,3) + Ty*ones(mMatriz,1);
        
        dyyi = XpdYpd(:,2);

%         W = zeros(mMatriz,1);
%         for i=1:mMatriz
%             W(i,:) = r31f*XYZ(i,1) + r32f*XYZ(i,2) + r33f*XYZ(i,3);
%         end
        W = r31f*XYZ(:,1) + r32f*XYZ(:,2) + r33f*XYZ(:,3);

%         dyyiWi = zeros(mMatriz,1);
%         for i=1:mMatriz
%             dyyiWi(i,:) = XpdYpd(i,2)*W(i,1);
%         end
        dyyiWi = XpdYpd(:,2).*W(:,1);

        fTz=[Y1 -dyyi]\dyyiWi;
        f=fTz(1,1);
        Tz=fTz(2,1);
        k1=0;
    end

    %************************************************************************************
    %   ETAPA 2 b)Calculo exacto de f, Tz y k1
    %************************************************************************************
    %Optimizacion de los parametros T,k,f que minimizan el error de la FOjetivo

        ParametrosEcuacion = [dx dy sx Ty r21f r22f r23f r31f r32f r33f];
        ParametrosIniciales = [f; Tz; k1];
        ValoresFinales = fminsearch(@FuncionObjetivo_TSAI, ParametrosIniciales, [], ParametrosEcuacion, XYZ(:,1), XYZ(:,2), XYZ(:,3), UV(:,1)-Cu, UV(:,2)-Cv);
        f = ValoresFinales(1);
        Tz = ValoresFinales(2);
        k1 = ValoresFinales(3); %<- OJO TSAI CAMBIA EL SIGNO AL FACTOR DE DISTORSION
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function [r11f r12f r13f r21f r22f r23f r31f r32f r33f Tx Ty Tz f k1 sx] = calib_Tsai_3D(dx,dy,Ncx,Nfx,Cu,Cv)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% FUNCIÓN QUE HACE LA CALIBRACION 3D DE TSAI
%--------------------------------------------------------------------------

    global MatrizPtos;
    global PtosOptimizacion;
    %----------------------------------------------------------------------
    % COMIENZA LA CALIBRACIÓN TSAI 3D
    %----------------------------------------------------------------------  
    d1x = dx * (Ncx/Nfx);

    %Crea la matiz XYZuv a partir del fichero de puntos indicado
    XYZuv = MatrizPtos;

    %Obtiene las dimensiones de XYZuv (mMatriz = filas | nMatriz = columnas)
    mMatriz = size(XYZuv,1);

    %Crea dos matrices independientes XYZ y UV a partir de la matriz XYZuv
    XYZ = [XYZuv(:,1) XYZuv(:,2) XYZuv(:,3)];
    UV = [XYZuv(:,4) XYZuv(:,5)];

    %**********************************************************************
    %   ETAPA 1 a)Calculo de (Xpd,Ypd) tomando sx=1
    %**********************************************************************
    %Aproximacion de sx
    sx = 1;

    %Crea la matriz XpdYpd
%     XpdYpd = zeros(mMatriz,2);
%     for i=1:mMatriz
%         XpdYpd(i,:) = [((d1x/sx)*(UV(i,1) - Cu)) (dy*(UV(i,2) - Cv))];
%     end
    uv_cent = ([1 0 -Cu; 0 1 -Cv; 0 0 1]*[UV ones(mMatriz,1)]')';
    XpdYpd = [uv_cent(:,1).*(d1x/sx) uv_cent(:,2).*dy];

    %**********************************************************************
    %   ETAPA 1 b)Calculo matriz L
    %**********************************************************************
    %Crea matriz (x,y)pd(X,Y,Z)
%     XpdX = zeros(mMatriz,7);
%     for i=1:mMatriz
%         XpdX(i,:) = [XpdYpd(i,2)*XYZ(i,1) XpdYpd(i,2)*XYZ(i,2) XpdYpd(i,2)*XYZ(i,3) XpdYpd(i,2) -XpdYpd(i,1)*XYZ(i,1) -XpdYpd(i,1)*XYZ(i,2) -XpdYpd(i,1)*XYZ(i,3)];
%     end
    XpdX = [XpdYpd(:,2).*XYZ(:,1) XpdYpd(:,2).*XYZ(:,2) XpdYpd(:,2).*XYZ(:,3) XpdYpd(:,2) -XpdYpd(:,1).*XYZ(:,1) -XpdYpd(:,1).*XYZ(:,2) -XpdYpd(:,1).*XYZ(:,3)];

    %Calcula matriz L
    L = XpdX\XpdYpd(:,1);

    %**********************************************************************
    %   ETAPA 1 c)Calculo r11,r12,r13... y Tx, Ty
    %**********************************************************************
    %Calcula modulo Ty
    Tymod = 1/(sqrt(L(5,1)^2 + L(6,1)^2 + L(7,1)^2));

    %---------------------------
    %   Calcula Ty
    %---------------------------
        %Calcula r11,r12,.....
        r11 = L(1,1)*Tymod;
        r12 = L(2,1)*Tymod;
        r13 = L(3,1)*Tymod;
        Tx = L(4,1)*Tymod;
        r21 = L(5,1)*Tymod;
        r22 = L(6,1)*Tymod;
        r23 = L(7,1)*Tymod;

        %---------------------------
        %   Determina signo de Ty
        %---------------------------
        %Busca el pto mas alejado del origen
        distanciaMAX = 0;
        for i=1:mMatriz
            distancia = sqrt((XpdYpd(i,1)^2)+(XpdYpd(i,2)^2));
            if distancia > distanciaMAX
                ptolejano = i;
                distanciaMAX = distancia;
            end
        end

        %Calcula X1 e Y1 tomando el pto mas lejano del centro (Cu,Cv).
        X1 = r11*XYZ(ptolejano,1) + r12*XYZ(ptolejano,2) + r13*XYZ(ptolejano,3) + Tx;
        Y1 = r21*XYZ(ptolejano,1) + r22*XYZ(ptolejano,2) + r23*XYZ(ptolejano,3) + Tymod;

        %Calcula u1 y v1
        u1 = XpdYpd(ptolejano,1);
        v1 = XpdYpd(ptolejano,2);

        %Determina signo de Ty
        if ((sign(X1) == sign(u1)) && (sign(Y1) == sign(v1)))
            Ty = Tymod;
        else
            Ty = Tymod * (-1);
        end

    %---------------------------
    %   Calcula sx
    %---------------------------
    sx = (sqrt(L(1,1)^2 + L(2,1)^2 + L(3,1)^2)) * Tymod;

    %----------------------------------
    %   Calcula matriz de rotacion R
    %----------------------------------
    r11 = L(1,1)*(Ty/sx);
    r12 = L(2,1)*(Ty/sx);
    r13 = L(3,1)*(Ty/sx);
    Tx = L(4,1)*Ty;
    r21 = L(5,1)*Ty;
    r22 = L(6,1)*Ty;
    r23 = L(7,1)*Ty;
    r31 = (r12*r23) - (r13*r22);
    r32 = (r13*r21) - (r11*r23);
    r33 = (r11*r22) - (r12*r21);

    %-----------------------------------------------------------
    %   Mejora la "ortonormalidad" de R -> Segun Reg Willson
    %-----------------------------------------------------------
    %Paso de [R]tsai -> Rx,Ry,Rz.
    [Rx_g,Ry_g,Rz_g,Rx,Ry,Rz] = R_mat2grad(r11,r12,r13,r21,r22,r23,r31);

    %Paso de Rx,Ry,Rz -> [R]corregida.
    [r11f,r12f,r13f,r21f,r22f,r23f,r31f,r32f,r33f] = R_grad2mat(Rx,Ry,Rz);

    %************************************************************************************
    %   ETAPA 2 a)Calculo de una aproximacion de f y Tz sin tener cuenta de la distorsion
    %************************************************************************************
    %Calcula aprox f y Tz
        %Crea matriz Y1
%         Y1 = zeros(mMatriz,1);
%         for i=1:mMatriz
%             Y1(i,:) = r21f*XYZ(i,1) + r22f*XYZ(i,2) + r23f*XYZ(i,3) + Ty;
%         end
        Y1 = r21f*XYZ(:,1) + r22f*XYZ(:,2) + r23f*XYZ(:,3) + Ty*ones(mMatriz,1);

        %Crea matriz dyyi
        dyyi = XpdYpd(:,2);

        %Crea matriz W
%         W = zeros(mMatriz,1);
%         for i=1:mMatriz
%             W(i,:) = r31f*XYZ(i,1) + r32f*XYZ(i,2) + r33f*XYZ(i,3);
%         end
        W = r31f*XYZ(:,1) + r32f*XYZ(:,2) + r33f*XYZ(:,3);

        %Crea matriz dyyiWi
%         dyyiWi = zeros(mMatriz,1);
%         for i=1:mMatriz
%             dyyiWi(i,:) = XpdYpd(i,2)*W(i,1);
%         end
        dyyiWi = XpdYpd(:,2).*W(:,1);

        %Calcula matriz f Tz
        fTz = [Y1 -dyyi]\dyyiWi;
        f = fTz(1,1);
        Tz = fTz(2,1);
        k1 = 0;

    %---------------------------------------------------------------------------------
    %   Cambia la matriz R si f<0 y vuelve a calcular las aproximaciones de f y Tz
    %---------------------------------------------------------------------------------
    if f < 0
        r13f = -r13f;
        r23f = -r23f;
        r31f = -r31f;
        r32f = -r32f;

%         Y1 = zeros(mMatriz,1);
%         for i=1:mMatriz
%             Y1(i,:) = r21f*XYZ(i,1) + r22f*XYZ(i,2) + r23f*XYZ(i,3) + Ty;
%         end
        Y1 = r21f*XYZ(:,1) + r22f*XYZ(:,2) + r23f*XYZ(:,3) + Ty*ones(mMatriz,1);

        dyyi = XpdYpd(:,2);

%         W = zeros(mMatriz,1);
%         for i=1:mMatriz
%             W(i,:) = r31f*XYZ(i,1) + r32f*XYZ(i,2) + r33f*XYZ(i,3);
%         end
        W = r31f*XYZ(:,1) + r32f*XYZ(:,2) + r33f*XYZ(:,3);

%         dyyiWi = zeros(mMatriz,1);
%         for i=1:mMatriz
%             dyyiWi(i,:) = XpdYpd(i,2)*W(i,1);
%         end
        dyyiWi = XpdYpd(:,2).*W(:,1);

        fTz=[Y1 -dyyi]\dyyiWi;
        f=fTz(1,1);
        Tz=fTz(2,1);
        k1=0;
    end

    %************************************************************************************
    %   ETAPA 2 b)Calculo exacto de f, Tz y k1
    %************************************************************************************
    %Optimizacion de los parametros T,k,f que minimizan el error de la FOjetivo

        ParametrosEcuacion = [dx dy sx Ty r21f r22f r23f r31f r32f r33f];
        ParametrosIniciales = [f; Tz; k1];
        ValoresFinales = fminsearch(@FuncionObjetivo_TSAI, ParametrosIniciales, [], ParametrosEcuacion, XYZ(:,1), XYZ(:,2), XYZ(:,3), UV(:,1)-Cu, UV(:,2)-Cv);
        f = ValoresFinales(1);
        Tz = ValoresFinales(2);
        k1 = ValoresFinales(3); %<- OJO TSAI CAMBIA EL SIGNO AL FACTOR DE DISTORSION
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function menu_dlt2d_Callback(hObject, eventdata, handles)
% hObject    handle to menu_dlt2d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% HACE LA CALIBRACION 2D DLT EN FUNCION DE LOS PUNTOS
%--------------------------------------------------------------------------
    global MatrizPtos;

    %Comprueba si todos los puntos están en Z=0
    coord_Z = MatrizPtos(:,3);
    if ((max(coord_Z)<0.25)&&(min(coord_Z)>-0.25)) %pongo 0.25 y no 0 por si hay ruido

        %Llama a la función que hace la calibración
        tic;
        L_DLT_2D = calib_DLT_2D_sin(MatrizPtos);
        tiempo_f = toc;

        XYZ = MatrizPtos(:,1:3);
        uv = MatrizPtos(:,4:5);
        m = size(XYZ,1);
        L = L_DLT_2D;

        XYZ_recons = zeros(m,3);
        uv_recons = zeros(m,2);
        for i=1:m
            u = uv(i,1);
            v = uv(i,2);
            u_i = (L(1)*XYZ(i,1)+L(2)*XYZ(i,2)+L(3))/(L(7)*XYZ(i,1)+L(8)*XYZ(i,2)+1);
            v_i = (L(4)*XYZ(i,1)+L(5)*XYZ(i,2)+L(6))/(L(7)*XYZ(i,1)+L(8)*XYZ(i,2)+1);
            X_i = (-v*L(8)*L(3)+v*L(2)+L(5)*L(3)+L(6)*u*L(8)-L(6)*L(2)-u*L(5))/(-u*L(8)*L(4)-L(2)*v*L(7)+L(2)*L(4)+u*L(7)*L(5)+L(1)*v*L(8)-L(1)*L(5));
            Y_i = -1/(-u*L(8)*L(4)-L(2)*v*L(7)+L(2)*L(4)+u*L(7)*L(5)+L(1)*v*L(8)-L(1)*L(5))*(-L(3)*v*L(7)-u*L(4)+u*L(7)*L(6)+L(3)*L(4)-L(1)*L(6)+L(1)*v);
            uv_recons(i,:) = [u_i v_i];
            XYZ_recons(i,:) = [X_i Y_i 0];
        end

        dif_uv = uv-uv_recons;
        error_uv = sqrt(dif_uv(:,1).^2+dif_uv(:,2).^2);
        dif_xyz = XYZ(:,1:2)-XYZ_recons(:,1:2);
        error_xyz = sqrt(dif_xyz(:,1).^2+dif_xyz(:,2).^2);

        %Muestra en pantalla los resultados
        msg0='';
        msg1=['  L1 = ' num2str(L_DLT_2D(1))];
        msg2=['  L2 = ' num2str(L_DLT_2D(2))];
        msg3=['  L3 = ' num2str(L_DLT_2D(3))];
        msg4=['  L4 = ' num2str(L_DLT_2D(4))];
        msg5=['  L5 = ' num2str(L_DLT_2D(5))];
        msg6=['  L6 = ' num2str(L_DLT_2D(6))];
        msg7=['  L7 = ' num2str(L_DLT_2D(7))];
        msg8=['  L8 = ' num2str(L_DLT_2D(8))];
        msg9=['  Recon. Mean uv (pixel) -> ' num2str(mean(abs(dif_uv))) '    (' num2str(mean(error_uv)) ')'];
        msg10=['  Recon. Max uv (pixel) -> ' num2str(max(abs(dif_uv))) '    (' num2str(max(error_uv)) ')'];
        msg11=['  Recon. STD uv (pixel) -> ' num2str(std(abs(dif_uv))) '    (' num2str(std(error_uv)) ')'];
        msg12=['  Recon. Mean XYZ (mm) -> ' num2str(mean(abs(dif_xyz))) '    (' num2str(mean(error_xyz)) ')'];
        msg13=['  Recon. Max XYZ (mm) ->  ' num2str(max(abs(dif_xyz))) '    (' num2str(max(error_xyz)) ')'];
        msg14=['  Recon. STD XYZ (mm) ->  ' num2str(std(abs(dif_xyz))) '    (' num2str(std(error_xyz)) ')'];
        msg15=['  CPU time (s) ->  ' num2str(tiempo_f)];
        msg_resultados = struct('resultados',{msg0;msg0;msg1;msg2;msg3;msg4;msg5;msg6;msg7;msg8;...
                                              msg0;msg9;msg10;msg11;...
                                              msg0;msg12;msg13;msg14;...
                                              msg0;msg15;msg0});
        str = {msg_resultados.resultados};
        tipo_calib = 'DLT 2D without distortion';
        muestra_resultados(str,tipo_calib,dif_uv,dif_xyz);
    else
        errordlg('To perform the coplanar DLT calibration is necessary that all points have Z = 0 in the world reference system.','Points error');
    end;
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function L = calib_DLT_2D_sin(XYZuv)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% FUNCIÓN QUE HACE LA CALIBRACION 2D DLT
%--------------------------------------------------------------------------

    XYZ = XYZuv(:,1:3);
    uv = XYZuv(:,4:5);

    m = size(XYZ,1);

    A = zeros(m*2,8);
    b = zeros(m*2,1);
    for i=1:m
        A(((i*2)-1),:) = [XYZ(i,1) XYZ(i,2) 1 0 0 0 -XYZ(i,1)*uv(i,1) -XYZ(i,2)*uv(i,1)];
        A((i*2),:) = [0 0 0 XYZ(i,1) XYZ(i,2) 1 -XYZ(i,1)*uv(i,2) -XYZ(i,2)*uv(i,2)];
        b(((i*2)-1),:) = uv(i,1);
        b((i*2),:) = uv(i,2);
    end

    L = A\b;
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function L = calib_DLT_3D_con(XYZuv)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% FUNCIÓN QUE HACE LA CALIBRACION 3D DLT SIN CORRECCIONES OPTICAS
%--------------------------------------------------------------------------

    XYZ = XYZuv(:,1:3);
    uv = XYZuv(:,4:5);

    m = size(XYZ,1);

    A = zeros(m*2,11);
    b = zeros(m*2,1);
    for i=1:m
        A(((i*2)-1),:) = [XYZ(i,1) XYZ(i,2) XYZ(i,3) 1 0 0 0 0 -XYZ(i,1)*uv(i,1) -XYZ(i,2)*uv(i,1) -XYZ(i,3)*uv(i,1)];
        A((i*2),:) = [0 0 0 0 XYZ(i,1) XYZ(i,2) XYZ(i,3) 1 -XYZ(i,1)*uv(i,2) -XYZ(i,2)*uv(i,2) -XYZ(i,3)*uv(i,2)];
        b(((i*2)-1),:) = uv(i,1);
        b((i*2),:) = uv(i,2);
    end

    L_ini = A\b;
    
    ParametrosIniciales = [L_ini; 0; 0; 0; 0; 0]; % <-------- VALORES INICIALES DE L12 L13 L14 L15 L16
    Cu_i_T = findobj(gcbf,'Tag','Cu_T');
    u0 = (str2double(get(Cu_i_T,'String')))/2;
    Cv_i_T = findobj(gcbf,'Tag','Cv_T');
    v0 = (str2double(get(Cv_i_T,'String')))/2;
    options = optimset('MaxFunEvals',Inf, 'MaxIter', Inf);
    ValoresFinales = fminsearch(@FuncionObjetivo_DLT3D, ParametrosIniciales, options, XYZ(:,1), XYZ(:,2), XYZ(:,3), uv(:,1), uv(:,2), u0, v0);
    L = ValoresFinales;
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function L = calib_DLT_3D_sin(XYZuv)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% FUNCIÓN QUE HACE LA CALIBRACION 3D DLT CON CORRECCIONES OPTICAS
%--------------------------------------------------------------------------

    XYZ = XYZuv(:,1:3);
    uv = XYZuv(:,4:5);

    m = size(XYZ,1);

    A = zeros(m*2,11);
    b = zeros(m*2,1);
    for i=1:m
        A(((i*2)-1),:) = [XYZ(i,1) XYZ(i,2) XYZ(i,3) 1 0 0 0 0 -XYZ(i,1)*uv(i,1) -XYZ(i,2)*uv(i,1) -XYZ(i,3)*uv(i,1)];
        A((i*2),:) = [0 0 0 0 XYZ(i,1) XYZ(i,2) XYZ(i,3) 1 -XYZ(i,1)*uv(i,2) -XYZ(i,2)*uv(i,2) -XYZ(i,3)*uv(i,2)];
        b(((i*2)-1),:) = uv(i,1);
        b((i*2),:) = uv(i,2);
    end

    L = A\b;
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function F = FuncionObjetivo_DLT3D(Param_Ini, X, Y, Z, U, V, Uo, Vo)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% FUNCIÓN DE OPTIMIZACIÓN PARA LOS MODELOS DLT 3D CON DISTORSION
%--------------------------------------------------------------------------
    m = size(X,1);

    var_x = (std(X))^2;
    var_y = (std(Y))^2;
    var_z = (std(Z))^2;
    var_u = (std(U))^2;
    var_v = (std(V))^2;

    L = Param_Ini(1:16);
    ME = zeros(m,1);
    Mn = zeros(m,1);
    Mr = zeros(m,1);
    MR = zeros(m,1);
    MX = zeros(m*2,16);
    MY = zeros(m*2,1);
    MW = zeros(m*2,m*2);
    for i=1:m
        E = U(i)-Uo;
        ME(i,:) = E;
        n = V(i)-Vo;
        Mn(i,:) = n;
        r = sqrt(E^2+n^2);
        Mr(i,:) = r;
        R = L(9)*X(i)+L(10)*Y(i)+L(11)*Z(i)+1;
        MR(i,:) = R;
        MX(((i*2)-1),:) = [X(i) Y(i) Z(i) 1 0 0 0 0 -U(i)*X(i) -U(i)*Y(i) -U(i)*Z(i) E*r^2*R E*r^4*R E*r^6*R R*(r^2+2*E^2) E*n*R];...
        MX((i*2),:) = [0 0 0 0 X(i) Y(i) Z(i) 1 -V(i)*X(i) -V(i)*Y(i) -V(i)*Z(i) n*r^2*R n*r^4*R n*r^6*R E*n*R R*(r^2+2*n^2)];
        MY(((i*2)-1),:) = U(i);
        MY((i*2),:) = V(i);
        sigma2_u = (((U(i)*L(9))-L(1))/R)^2*var_x+(((U(i)*L(10))-L(2))/R)^2*var_y+(((U(i)*L(11))-L(3))/R)^2*var_z+var_u;
        sigma2_v = (((U(i)*L(9))-L(5))/R)^2*var_x+(((U(i)*L(10))-L(6))/R)^2*var_y+(((U(i)*L(11))-L(7))/R)^2*var_z+var_v;
        MW(((i*2)-1),((i*2)-1)) = sigma2_u;
        MW((i*2),(i*2)) = sigma2_v;
    end
    ML = L;

    residuo = MW*MX*ML - MW*MY;

    F = norm(residuo, 2);
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function P = calib_Faugeras_3D_sin(XYZuv)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% FUNCIÓN QUE HACE LA CALIBRACION 3D DE FAUGERAS SIN CORRECCIONES OPTICAS
% PROPORCIONA LA MATRIZ DE PROYECCION P YA NORMALIZADA (1/lambda)
%--------------------------------------------------------------------------

    XYZ = XYZuv(:,1:3);
    uv = XYZuv(:,4:5);

    m = size(XYZ,1);

    A = zeros(m*2,12);
    for i=1:m
        A(((i*2)-1),:) = [XYZ(i,1) XYZ(i,2) XYZ(i,3) 1 0 0 0 0 -XYZ(i,1)*uv(i,1) -XYZ(i,2)*uv(i,1) -XYZ(i,3)*uv(i,1) -uv(i,1)];
        A((i*2),:) = [0 0 0 0 XYZ(i,1) XYZ(i,2) XYZ(i,3) 1 -XYZ(i,1)*uv(i,2) -XYZ(i,2)*uv(i,2) -XYZ(i,3)*uv(i,2) -uv(i,2)];
    end

    [V,D,U] = svd(A'*A);
    L = V(:,12);

    P_SVD = [L(1:4)';L(5:8)';L(9:12)'];
    lambda = sqrt(P_SVD(3,1)^2+P_SVD(3,2)^2+P_SVD(3,3)^2);
    P = (1/lambda)*P_SVD;
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function muestra_resultados(str,tipo_calib,uv_mean,xyz_mean)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% MUESTRA EN UN CUADRO DE DIALOGO LOS RESULTADOS DE LA CALIBRACION
%-------------------------------------------------------------------------
global resultado_handler;

    dim_uv_mean = size(uv_mean,1);
    dim_xyz_mean = size(xyz_mean,1);
        
    [existe] = figflag('Results');
    if existe
        return;
    else
        main_sz = get(gcf,'Position');
        figure('Position',[(main_sz(1)+(main_sz(3)-540)/2)...
                           (main_sz(2)+(main_sz(4)-550)/2)...
                           540 550],...
               'Resize','off',...
               'NumberTitle','off',...
               'Name','Results',...
               'Color', [0.925 0.914 0.847],...
               'MenuBar','none',...
               'ToolBar','none',...
               'Tag','dlg_resultados');
        resultado_handler = figure(gcf);
        dlg_sz = get(gcf,'Position');
        txt_res = uicontrol('Style', 'listbox',...
                            'SelectionHighlight', 'off',...
                            'BackgroundColor', [1 1 1],...
                            'Position', [10 50 dlg_sz(3)-20 dlg_sz(4)-60],...
                            'String',str,...
                            'HorizontalAlignment','left');
        OK_res_callback = 'global resultado_handler;close(resultado_handler);';               
        OK_res = uicontrol('Style', 'pushbutton',...
                           'String','OK',...
                           'Position', [15 10 120 30],...
                           'Callback', OK_res_callback);
        if dim_uv_mean>1 && dim_xyz_mean>1                        
            GRAF_res = uicontrol('Style', 'pushbutton',...
                                 'String','Graphical Results',...
                                 'Position', [145 10 120 30],...
                                 'Callback', {@GRAF_res_callback,uv_mean,xyz_mean});   
        end                    
        UV_res = uicontrol('Style', 'pushbutton',...
                           'String','UV Recons. Results',...
                           'Position', [275 10 120 30],...
                           'Callback', {@GRAF_UV_res_callback,uv_mean,xyz_mean}); 
        SAVE_res = uicontrol('Style', 'pushbutton',...
                             'String','Save Results',...
                             'Position', [405 10 120 30],...
                             'Callback', {@SAVE_res_callback,str,tipo_calib});
    end
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function SAVE_res_callback(hObject,eventdata,str,tipo_calib)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% FUNCION QUE GUARDA LOS RESULTADOS DE LA CALIBRACION EN UN TXT
%--------------------------------------------------------------------------
    global resultado_handler;
    global MatrizPtos; %<- Para contar el número de puntos de calibración
    global calib_res;
    
    m = size(MatrizPtos,1);
    n_ptos = ['Calibration points: ' num2str(m)];
    [filename_resg, pathname_resg, filterindex_resg] = uiputfile( ...
               {  '*.txt','Text file (*.txt)'; ...
                  '*.*',  'All files (*.*)'}, ...
                  'Save results to file');
    if filterindex_resg ~= 0
        file_res = fopen([pathname_resg filename_resg],'w');
        fprintf(file_res,'%s ',date);
        fprintf(file_res,'\n');
        fprintf(file_res,'%s ',tipo_calib);
        fprintf(file_res,'\n');
        fprintf(file_res,'%s ','');
        fprintf(file_res,'\n');
        fprintf(file_res,'%s ',n_ptos);
        for i=1:length(str)
            fprintf(file_res,'%s ',str{i});
            fprintf(file_res,'\n');
        end
        fclose(file_res);
        nombre_archivo = [pathname_resg filename_resg '.cal'];
        save(nombre_archivo,'calib_res','-ASCII');
    end
    close(resultado_handler);
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function GRAF_res_callback(hObject,eventdata,uv_mean,xyz_mean)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% FUNCION QUE MUESTRA GRAFICAS CON LOS RESULTADOS
%--------------------------------------------------------------------------
%     global resultado_handler;
    global grafica_handler;

    if size(xyz_mean,2)<3
        xyz_mean = [xyz_mean zeros(size(xyz_mean,1),1)];
    end
    error_xyz = sqrt(xyz_mean(:,1).^2+xyz_mean(:,2).^2+xyz_mean(:,3).^2);
    error_uv = sqrt(uv_mean(:,1).^2+uv_mean(:,2).^2);
    media_xyz = mean(error_xyz);
    media_uv = mean(error_uv);
    nPtos = size(error_xyz,1);
    
    [existe] = figflag('Graphical Results');
    if existe
        return;
    else
        main_sz = get(gcf,'Position');
        figure('Position',[(main_sz(1)+(main_sz(3)-950)/2)...
                           (main_sz(2)+(main_sz(4)-700)/2)...
                           950 700],...
               'Resize','off',...
               'NumberTitle','off',...
               'Name','Graphical Results',...
               'Color', [0.925 0.914 0.847],...
               'MenuBar','none',...
               'ToolBar','none',...
               'Tag','dlg_graficas');
        grafica_handler = figure(gcf);
        dlg_sz = get(gcf,'Position');
        OK_res_callback = 'global grafica_handler;close(grafica_handler);';               
        OK_res = uicontrol('Style', 'pushbutton',...
                           'String','OK',...
                           'Position', [10 5 120 25],...
                           'Callback', OK_res_callback);    
        SAVE_err = uicontrol('Style', 'pushbutton',...
                             'String','Save Reconstruction Errors',...
                             'Position', [140 5 160 25],...
                             'Callback', {@SAVE_err_callback,xyz_mean,uv_mean}); 
        hold on;
        subplot(2,2,1);
        plot(error_uv,'LineStyle','none','Marker','.','MarkerEdgeColor',[0.4 0.4 1]);
        line([0 nPtos],[media_uv media_uv],'Color','k','LineStyle',':');
        set(gca,'Position',[0.075 0.575 0.4 0.38],'FontSize',8);
        xlabel('Point','FontSize',10);
        ylabel('|Error| (pixel)','FontSize',10);
        title('(u,v) coordinate error','FontSize',12,'FontWeight','bold');
        subplot(2,2,2);
        plot(error_xyz,'LineStyle','none','Marker','.','MarkerEdgeColor',[1 0.4 0.4]);
        line([0 nPtos],[media_xyz media_xyz],'Color','k','LineStyle',':');
        set(gca,'Position',[0.55 0.575 0.4 0.38],'FontSize',8);
        xlabel('Point','FontSize',10);
        ylabel('|Error| (mm)','FontSize',10);
        title('(X,Y,Z) coordinate error','FontSize',12,'FontWeight','bold');
        subplot(2,2,3); 
        histfit(error_uv,16);
        set(gca,'Position',[0.075 0.1 0.4 0.38],'FontSize',8);
        h = get(gca,'Children');
        set(h(1),'Color','k','LineStyle',':');
        set(h(2),'FaceColor',[0.8 0.8 1])
        xlabel('|Error| (pixel)','FontSize',10);
        ylabel('nº points','FontSize',10);
        title('(u,v) coordinate error','FontSize',12,'FontWeight','bold');
        subplot(2,2,4);
        histfit(error_xyz,16);
        set(gca,'Position',[0.55 0.1 0.4 0.38],'FontSize',8);
        h = get(gca,'Children');
        set(h(1),'Color','k','LineStyle',':');
        set(h(2),'FaceColor',[1 0.8 0.8])
        xlabel('|Error| (mm)','FontSize',10);
        ylabel('nº points','FontSize',10);
        title('(X,Y,Z) coordinate error','FontSize',12,'FontWeight','bold');
    end
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function SAVE_err_callback(hObject,eventdata,xyz_mean,uv_mean)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% FUNCION QUE GUARDA LOS RESULTADOS DE LA CALIBRACION EN UN TXT
%--------------------------------------------------------------------------
    global grafica_handler;
    
    Recon_err = [xyz_mean uv_mean];
    [filename_err, pathname_err, filterindex_err] = uiputfile( ...
               {  '*.txt','Text file (*.txt)'; ...
                  '*.*',  'All files (*.*)'}, ...
                  'Save reconstruction errors to file');
    if filterindex_err ~= 0
        save([pathname_err filename_err],'Recon_err','-ASCII');
    end
    close(grafica_handler);
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function menu_about_Callback(hObject, eventdata, handles)
% hObject    handle to menu_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% MUESTRA EL CUADRO DE DIALOGO ACERCA DE...
%--------------------------------------------------------------------------

    %Genera el texto del cuadro
    msg0='';
    msg1='       METROVISIONLAB 1.5 (1/2009)';
    msg2='            David Samper, Jorge Santolaria, Jorge Juan Pastor, Juan José Aguilar';
    msg3='            Manufacturing Engineering and Advanced Metrology Group (GIFMA)';
    msg4='            Aragón Institute of Engineering Research (I3A)';
    msg5='            gifma@unizar.es';
    msg6='            http://metrovisionlab.unizar.es';
    msg_resultados = struct('resultados',{msg0;msg1;msg0;msg2;msg0;msg3;msg4;msg5;msg0;msg6;});
    str = {msg_resultados.resultados};

    [existe] = figflag('About');
    if existe
        return;
    else
        main_sz = get(gcf,'Position');
        figure('Position',[(main_sz(1)+(main_sz(3)-540)/2)...
                           (main_sz(2)+(main_sz(4)-215)/2)...
                           540 215],...
               'Name','About',...
               'Color', [0.925 0.914 0.847],...
               'MenuBar','none',...
               'ToolBar','none',...
               'Tag','dlg_about');
        dlg_sz = get(gcf,'Position');
        txt_res = uicontrol('Style', 'text',...
                            'FontSize',10,...
                            'FontWeight','bold',...
                            'BackgroundColor', [0.925 0.914 0.847],...
                            'Position', [5 5 dlg_sz(3)-10 dlg_sz(4)-10],...
                            'String',str,...
                            'HorizontalAlignment','left');
    end
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function UV = TSAI_XYZ2UV(XYZ,r1,r2,r3,r4,r5,r6,r7,r8,r9,Tx,Ty,Tz,f,k1,sx,dx,dy,Ncx,Nfx,Cu,Cv)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% PASA COORD. MUNDO A COORD. IMAGEN USANDO CALIBRACION DE TSAI
%-------------------------------------------------------------------------

    d1x = dx * (Ncx/Nfx);

    %Obtiene el numero de puntos a convertir (filas)
    filas = size(XYZ,1);

    %Comvierte coordenadas mundo a coordenadas camara
%     XcYcZc = zeros(filas,3);
%     for i=1:filas
%         XcYcZc(i,:) = [r1*XYZ(i,1)+r2*XYZ(i,2)+r3*XYZ(i,3)+Tx r4*XYZ(i,1)+r5*XYZ(i,2)+r6*XYZ(i,3)+Ty r7*XYZ(i,1)+r8*XYZ(i,2)+r9*XYZ(i,3)+Tz];
%     end
    RT = [r1 r2 r3 Tx; r4 r5 r6 Ty; r7 r8 r9 Tz; 0 0 0 1];
    XcYcZc = (RT*[XYZ ones(filas,1)]')';
    
    %Convierte coordenadas camara a coordenadas sensor sin distorsion
%     XuYu = zeros(filas,2);
%     for i=1:filas
%         XuYu(i,:) = [(f*(XcYcZc(i,1)/XcYcZc(i,3))) (f*(XcYcZc(i,2)/XcYcZc(i,3)))];
%     end
    XuYu = f*[XcYcZc(:,1)./XcYcZc(:,3) XcYcZc(:,2)./XcYcZc(:,3)];
    
    %Convierte coordenadas sensor sin distorsion a coordenas sensor con distorsion
    XdYd = zeros(filas,2);
    for i=1:filas
        if (((XuYu(i,1) == 0)&&(XuYu(i,2) == 0))||(k1 == 0))
            %Si Xu=0 e Yu=0 o k1=0 no existe distorsion
            XdYd(i,:) = XuYu(i,:);
        else
            %-----------------------------------------------------------------------------------------
            %
            %   Resolver el PROBLEMA Xu=Xd(1+k1*rd^2) e Yu=Yd(1+k1*rd^2) con rd^2=Xd^2+Yd^2, es
            %   equivalente a resolver el siguiente PROBLEMA:
            %       ru=rd(1+k1*rd^2) -> k1*rd^3 + rd - ru = 0 -> RESOLVER en MATLAB con roots()
            %       Xd = Xu*(rd/ru)
            %       Yd = Yu*(rd/ru)
            %
            %-----------------------------------------------------------------------------------------
            ru = sqrt ((XuYu(i,1)^2)+(XuYu(i,2)^2));
            %Resolucion de la ecuacion k1*rd^3 + rd - ru = 0
            rd_poly = [k1 0 1 -ru];
            rd_sol = roots(rd_poly);
            %Determinacion de la solucion valida
            %-------------------------------------------------------------------
            %
            %   Si la solucion son 3 raices reales tomamos la menor positiva
            %       Segun Reg Willson dos raices seran positivas y una negativa
            %       hay que quedarse con la menor positiva
            %   Si son 2 raices complejas y una real nos quedamos con la real
            %
            %-------------------------------------------------------------------
            if (imag(rd_sol(1,1))==0&&imag(rd_sol(2,1))==0&&imag(rd_sol(3,1))==0) %Comprueba si son las 3 raices reales
                %Busca la raiz real menor positiva y la toma como solucion para rd
                if rd_sol(1,1)<0
                    if rd_sol(2,1)<rd_sol(3,1)
                        rd = rd_sol(2,1);
                    else
                        rd = rd_sol(3,1);
                    end
                elseif rd_sol(2,1)<0
                    if rd_sol(1,1)<rd_sol(3,1)
                        rd = rd_sol(1,1);
                    else
                        rd = rd_sol(3,1);
                    end
                else
                    if rd_sol(1,1)<rd_sol(2,1)
                        rd = rd_sol(1,1);
                    else
                        rd = rd_sol(2,1);
                    end
                end
            else %Hay 2 soluciones complejas y una real
                %Busca la raiz real y la toma como solucion para rd
                if imag(rd_sol(1,1))==0
                    rd = rd_sol(1,1);
                elseif imag(rd_sol(2,1))==0
                    rd = rd_sol(2,1);
                else
                    rd = rd_sol(3,1);
                end
            end
            %Calculo del coeficiente de distorsion
            coeficiente = rd/ru;
            XdYd(i,:) = XuYu(i,:)*coeficiente;
        end
    end

    %Convierte coordenadas sensor con distorsion a coordenadas imagen con distorsion
%     UV = zeros(filas,2);
%     for i=1:filas
%         UV(i,:) = [((XdYd(i,1)*sx/d1x)+Cu) ((XdYd(i,2)/dy)+Cv)];
%     end
    UV1 = ([1 0 Cu; 0 1 Cv; 0 0 1]*[XdYd(:,1).*(sx/d1x) XdYd(:,2)./dy ones(filas,1)]')';
    UV = UV1(:,1:2);
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function XYZ = TSAI_UV2XYZ(uv,r1,r2,r3,r4,r5,r6,r7,r8,r9,Tx,Ty,Tz,f,k1,sx,dx,dy,Ncx,Nfx,Cu,Cv,zw)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% PASA COORD. MUNDO A COORD. IMAGEN USANDO CALIBRACION DE TSAI (SOLO 2D Z=0)
%--------------------------------------------------------------------------

    d1x = dx * (Ncx/Nfx);

    %Obtiene el numero de puntos a convertir (filas)
    filas = size(uv,1);

    %Comvierte coordenadas mundo a coordenadas camara
    %Convierte coordnadas imagen con distorsion en coordenadas sensor con distorsion
%     XdYd = zeros(filas,2);
%     for i=1:filas
%         XdYd(i,:) = [(d1x*(uv(i,1)-Cu)/sx) (dy*(uv(i,2)-Cv))];
%     end
    uv_cent = ([1 0 -Cu; 0 1 -Cv; 0 0 1]*[uv ones(filas,1)]')';
    XdYd = [uv_cent(:,1).*(d1x/sx) uv_cent(:,2).*dy];
    
    %Cambio de coordenadas sensor distorsionadas a coordenadas sensor no distorsionadas
%     XuYu = zeros(filas,2);
%     for i=1:filas
%         f_dist = 1+(k1*((XdYd(i,1)^2)+(XdYd(i,2)^2)));
%         XuYu(i,:) = [(XdYd(i,1)*f_dist) (XdYd(i,2)*f_dist)];
%     end
    f_dist = ones(filas,1)+(k1.*(XdYd(:,1).^2+XdYd(:,2).^2));
    XuYu = [XdYd(:,1).*f_dist XdYd(:,2).*f_dist];

    %Cambio de coordenadas sensor no distorsionadas a coordenadas mundo
    XwYwZw = zeros(filas,3);
    for i=1:filas
        den = ((r1*r8-r2*r7)*XuYu(i,2) + (r5*r7-r4*r8)*XuYu(i,1) - f*r1*r5 + f*r2*r4);
        xw = (((r2*r9-r3*r8)*XuYu(i,2) + (r6*r8-r5*r9)*XuYu(i,1) - f*r2*r6 + f*r3*r5)*zw + (r2*Tz-r8*Tx)*XuYu(i,2) + (r8*Ty-r5*Tz)*XuYu(i,1) - f*r2*Ty + f*r5*Tx)/den;
        yw = -(((r1*r9-r3*r7)*XuYu(i,2) + (r6*r7-r4*r9)*XuYu(i,1) - f*r1*r6 + f*r3*r4)*zw + (r1*Tz-r7*Tx)*XuYu(i,2) + (r7*Ty-r4*Tz)*XuYu(i,1) - f*r1*Ty + f*r4*Tx)/den;
        XwYwZw(i,:) = [xw yw zw];
    end

    XYZ = XwYwZw;
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function resul_NCE = NCE_coef(XYZ,xyz_recons,f,Tz,dx,dy,numero_planos,cota_inicial,separacion_planos,puntos_plano)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CALCULA EL COEFICIENTE NCE (Normalized Calibration Error)
%--------------------------------------------------------------------------
    num = ((xyz_recons(:,1)-XYZ(:,1)).^2)+((xyz_recons(:,2)-XYZ(:,2)).^2);
    NCE_fin = zeros(numero_planos*puntos_plano,1);
    for n_plano=1:numero_planos
        Z = ((n_plano*separacion_planos)-separacion_planos)+cota_inicial;
        dist = Tz+Z;
        a = dx*dist/f;
        b = dy*dist/f;
        i = (n_plano*puntos_plano)-(puntos_plano-1);
        j = (n_plano*puntos_plano);
        NCE_i = (num(i:j)./((a^2+b^2)/12)).^0.5;
        NCE_fin(((n_plano*puntos_plano)-(puntos_plano-1)):(n_plano*puntos_plano),:) = NCE_i;
    end
    resul_NCE = (1/(numero_planos*puntos_plano))*sum(NCE_fin);
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function resul_NCE = NCE_coef_zhang(XY,xy_recons,f,Tz,dx,dy,ptos)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CALCULA EL COEFICIENTE NCE (Normalized Calibration Error) (ZHANG)
%--------------------------------------------------------------------------
    num = ((xy_recons(:,1)-XY(:,1)).^2)+((xy_recons(:,2)-XY(:,2)).^2);
    dist = Tz;
    a = dx*dist/f;
    b = dy*dist/f;
    NCE_i = (num./((a^2+b^2)/12)).^0.5;
    resul_NCE = (1/ptos)*sum(NCE_i);
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function error = faugeras_dist(ParametrosIniciales,dx,dy,XYZ,uv)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% OPTIMIZA FAUGERAS TENIENDO EN CUANTA LA DISTORSION
%--------------------------------------------------------------------------
    global uv_d;
    global d;

    n = size(XYZ,1);
    L = ParametrosIniciales(1:12);
    k1 = ParametrosIniciales(13);
    k2 = ParametrosIniciales(14);
    P_1 = L(1:3);
    P_2 = L(5:7);
    P_3 = L(9:11);
    u0 = P_1*P_3';
    v0 = P_2*P_3';
    %Cálculo de las coordenadas imagen sin distor.
    uv_sd = zeros(n,2);
    for i=1:n
        u_i = (L(1)*XYZ(i,1)+L(2)*XYZ(i,2)+L(3)*XYZ(i,3)+L(4))/...
              (L(9)*XYZ(i,1)+L(10)*XYZ(i,2)+L(11)*XYZ(i,3)+L(12));
        v_i = (L(5)*XYZ(i,1)+L(6)*XYZ(i,2)+L(7)*XYZ(i,3)+L(8))/...
              (L(9)*XYZ(i,1)+L(10)*XYZ(i,2)+L(11)*XYZ(i,3)+L(12));
        uv_sd(i,:) = [u_i v_i];
    end
    %Cálculo de las coordenadas pantalla con distor.
    x_d = dx*(uv(:,1)-u0);
    y_d = dy*(uv(:,2)-v0);
    %Creación de la matriz D (D·k=d donde k=[k1 k2]')
    r = sqrt((x_d.^2)+(y_d.^2));
    D = [dx*((uv_sd(:,1)-u0).*r.^2) dx*((uv_sd(:,1)-u0).*r.^4);...
         dy*((uv_sd(:,2)-v0).*r.^2) dy*((uv_sd(:,2)-v0).*r.^4)];
    %Creación de la matriz d con la corrección de cada pto (D·k=d donde k=[k1 k2]') 
    d = D*[k1;k2]; 
    %Cálculo de las coordenadas imagen con distor.
    uv_d = [(uv_sd(:,1)+d(1:n)) (uv_sd(:,2)+d((n+1):(2*n)))];
    %Función a minimizar
    error = uv - uv_d;
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function menu_faugeras_dist_Callback(hObject, eventdata, handles)
% hObject    handle to menu_faugeras_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% HACE LA CALIBRACION 3D DE FAUGERAS CON DISTORSION EN FUNCION DE LOS PUNTOS
%--------------------------------------------------------------------------
global MatrizPtos;
global uv_d;
global d;
global uv_res;
global uv_recons_res;
global Cu_org_res;
global Cv_org_res;
global calib_res;

    Cu_i_T = findobj(gcbf,'Tag','Cu_T');
    Cu = str2double(get(Cu_i_T,'String'));
    Cv_i_T = findobj(gcbf,'Tag','Cv_T');
    Cv = str2double(get(Cv_i_T,'String'));
    Cu_org_res = Cu;
    Cv_org_res = Cv;

    %Comprueba si todos los puntos están en Z=0
    coord_Z = MatrizPtos(:,3);
    if ((max(coord_Z)~=min(coord_Z))&&((sqrt((max(coord_Z)^2)+(min(coord_Z)^2)))>0.5))
        XYZ = MatrizPtos(:,1:3);
        n = size(XYZ,1);
        uv = MatrizPtos(:,4:5);
        dx_i_T = findobj(gcbf,'Tag','dx_T');
        dx = str2double(get(dx_i_T,'String'));
        dy_i_T = findobj(gcbf,'Tag','dy_T');
        dy = str2double(get(dy_i_T,'String'));
        %Llama a la función que hace la calibración para tener una primera aproximación de L
        tic;
        P_SVD = calib_Faugeras_3D_sin(MatrizPtos);
        L = [P_SVD(1,:) P_SVD(2,:) P_SVD(3,:)];
        %Llama a la función que extrae los parámetros int. y ext. de la matriz de proyección
        [r1,r2,r3,tx,ty,tz,f,u0,v0] = extraccion_param_faugeras(L,dx,dy);

        %****************CORRECCION ERROR*********************
        %Cálculo de las coordenadas pantalla con distor.
        x_d = dx*(uv(:,1)-u0);
        y_d = dy*(uv(:,2)-v0);
        %Cálculo de las coordebadas imagen sin distor.
        uv_sd = zeros(n,2);
        for i=1:n
            u_i = (L(1)*XYZ(i,1)+L(2)*XYZ(i,2)+L(3)*XYZ(i,3)+L(4))/...
                  (L(9)*XYZ(i,1)+L(10)*XYZ(i,2)+L(11)*XYZ(i,3)+L(12));
            v_i = (L(5)*XYZ(i,1)+L(6)*XYZ(i,2)+L(7)*XYZ(i,3)+L(8))/...
                  (L(9)*XYZ(i,1)+L(10)*XYZ(i,2)+L(11)*XYZ(i,3)+L(12));
            uv_sd(i,:) = [u_i v_i];
        end
        %Creación de la matriz d (D·k=d donde k=[k1 k2]')
        d = [(uv(:,1)-uv_sd(:,1));...
             (uv(:,2)-uv_sd(:,2))]; 
        %Creación de la matriz D (D·k=d donde k=[k1 k2]')
        r = sqrt((x_d.^2)+(y_d.^2));
        D = [dx*((uv_sd(:,1)-u0).*r.^2) dx*((uv_sd(:,1)-u0).*r.^4);...
             dy*((uv_sd(:,2)-v0).*r.^2) dy*((uv_sd(:,2)-v0).*r.^4)];
        %Cálculo de una primera aproximación de k (k=[k1 k2]')
        k = D\d;
        k1 = k(1);
        k2 = k(2);

        %Otimiza todos los parámetros teniendo en cuenta la distrosión
        ParametrosIniciales = [L k1 k2];
        options = optimset('lsqnonlin');
        options.LargeScale = 'off';
        options.MaxFunEvals = Inf;
        options.MaxIter = Inf;
        options.TolFun = 0.0001;
        options.TolX = 0.0001;
        ParametrosFinales = lsqnonlin(@faugeras_dist, ParametrosIniciales, [], [], options, dx, dy, XYZ, uv);
        tiempo_f = toc;
        correcion_optica = [d(1:n) d(n+1:2*n)];
        uv_recons = uv_d;
        L = ParametrosFinales(1:12);
        k1 = ParametrosFinales(13);
        k2 = ParametrosFinales(14);
    
        %Llama a la función que extrae los parámetros int. y ext. de la matriz de proyección
        [r1,r2,r3,tx,ty,tz,f,u0,v0] = extraccion_param_faugeras(L,dx,dy);
        %Calcula los ángulos de giro de la cámara en grados y radianes
        R = [r1;r2;r3];
        [Rxo,Ryo,Rzo,Rx,Ry,Rz] = R_mat2grad(R(1,1),R(1,2),R(1,3),R(2,1),R(2,2),R(2,3),R(3,1));
        %****************CORRECCION ERROR*********************

        %[X,Y]=solve('u=(L(1)*X+L(2)*Y+L(3)*Z+L(4))/(L(9)*X+L(10)*Y+L(11)*Z+L(12))','v=(L(5)*X+L(6)*Y+L(7)*Z+L(8))/(L(9)*X+L(10)*Y+L(11)*Z+L(12))','X,Y')
        %X=(u*L(10)*L(8)-u*L(12)*L(6)+u*L(10)*L(7)*Z-u*L(11)*Z*L(6)-L(3)*Z*v*L(10)+L(2)*v*L(12)-L(2)*L(8)+L(4)*L(6)+L(2)*v*L(11)*Z-L(2)*L(7)*Z-L(4)*v*L(10)+L(3)*Z*L(6))/(-v*L(9)*L(2)-L(5)*u*L(10)+L(5)*L(2)+v*L(10)*L(1)+L(6)*u*L(9)-L(6)*L(1))
        %Y=-1/(-v*L(9)*L(2)-L(5)*u*L(10)+L(5)*L(2)+v*L(10)*L(1)+L(6)*u*L(9)-L(6)*L(1))*(v*L(11)*Z*L(1)+v*L(12)*L(1)+L(7)*Z*u*L(9)-L(7)*Z*L(1)+L(8)*u*L(9)-L(8)*L(1)-v*L(9)*L(3)*Z-v*L(9)*L(4)-L(5)*u*L(11)*Z-L(5)*u*L(12)+L(5)*L(3)*Z+L(5)*L(4))
        %Reconstruye las coord. mundo (X,Y,Z)
        estado_gen_ptos = get(handles.menu_puntos_genera_T,'Checked');
        estado_board = get(handles.menu_board_T,'Checked');

        if strcmp(estado_gen_ptos,'on') || strcmp(estado_board,'on')
            numero_planos = str2double(get(handles.P_Z_T,'String'));
            cota_inicial = str2double(get(handles.O_Z_T,'String'));
            separacion_planos = str2double(get(handles.E_Z_T,'String'));
            puntos_plano = str2double(get(handles.P_X_T,'String'))*str2double(get(handles.P_Y_T,'String'));
            xyz_recons = zeros(numero_planos*puntos_plano,3);
            for n_plano=1:numero_planos
                Z = ((n_plano*separacion_planos)-separacion_planos)+cota_inicial;
                %Llama a la función de reconstrucción de las coord. mundo (X,Y,Z)
                i = (n_plano*puntos_plano)-(puntos_plano-1);
                j = (n_plano*puntos_plano);
                for in=i:j
                    u = uv(in,1)-correcion_optica(in,1);
                    v = uv(in,2)-correcion_optica(in,2);
                    xyz_recons(in,1) = (u*L(10)*L(8)-u*L(12)*L(6)+u*L(10)*L(7)*Z-u*L(11)*Z*L(6)-L(3)*Z*v*L(10)+L(2)*v*L(12)-L(2)*L(8)+L(4)*L(6)+L(2)*v*L(11)*Z-L(2)*L(7)*Z-L(4)*v*L(10)+L(3)*Z*L(6))/(-v*L(9)*L(2)-L(5)*u*L(10)+L(5)*L(2)+v*L(10)*L(1)+L(6)*u*L(9)-L(6)*L(1));
                    xyz_recons(in,2) = -1/(-v*L(9)*L(2)-L(5)*u*L(10)+L(5)*L(2)+v*L(10)*L(1)+L(6)*u*L(9)-L(6)*L(1))*(v*L(11)*Z*L(1)+v*L(12)*L(1)+L(7)*Z*u*L(9)-L(7)*Z*L(1)+L(8)*u*L(9)-L(8)*L(1)-v*L(9)*L(3)*Z-v*L(9)*L(4)-L(5)*u*L(11)*Z-L(5)*u*L(12)+L(5)*L(3)*Z+L(5)*L(4));
                    xyz_recons(in,3) = Z;
                end 
            end
        end
        
        %Calcula el coeficiente NCE
        if strcmp(estado_gen_ptos,'on') || strcmp(estado_board,'on')
            NCE = NCE_coef(XYZ,xyz_recons,f,tz,dx,dy,numero_planos,cota_inicial,separacion_planos,puntos_plano);
            dif_xyz = XYZ-xyz_recons;
            error_xyz = sqrt(dif_xyz(:,1).^2+dif_xyz(:,2).^2+dif_xyz(:,3).^2);
        end

        dif_uv = uv-uv_recons;
        error_uv = sqrt(dif_uv(:,1).^2+dif_uv(:,2).^2);

        uv_res = uv;
        uv_recons_res = uv_recons;
        
        calib_res = [L(1) L(2) L(3) L(4) L(5) L(6) L(7) L(8) L(9) L(10) L(11) L(12) k1 k2 u0 v0];
        if strcmp(estado_gen_ptos,'on') || strcmp(estado_board,'on')
            %Muestra en pantalla los resultados
            msg0='';
            msg1=['  p11 = ' num2str(L(1)) '     p12 = ' num2str(L(2)) '     p13 = ' num2str(L(3)) '     p14 = ' num2str(L(4))];
            msg2=['  p21 = ' num2str(L(5)) '     p22 = ' num2str(L(6)) '     p23 = ' num2str(L(7)) '     p24 = ' num2str(L(8))];
            msg3=['  p31 = ' num2str(L(9)) '     p32 = ' num2str(L(10)) '     p33 = ' num2str(L(11)) '     p34 = ' num2str(L(12))];
            msg4=['  f = ' num2str(f) ' (mm)     ' 'Distortion: k1 = ' num2str(k1) '     ' 'k2 = ' num2str(k2)];
            msg5=['  u0 = ' num2str(u0) ' (mm)     ' 'v0 = ' num2str(v0) ' (mm)'];
            msg6=['  Tx = ' num2str(tx) ' (mm)     ' 'Ty = ' num2str(ty) ' (mm)     ' 'Tz = ' num2str(tz) ' (mm)'];
            msg7=['  r11 = ' num2str(R(1,1)) '       ' 'r12 = ' num2str(R(1,2)) '       ' 'r13 = ' num2str(R(1,3))];
            msg8=['  r21 = ' num2str(R(2,1)) '       ' 'r22 = ' num2str(R(2,2)) '       ' 'r23 = ' num2str(R(2,3))];
            msg9=['  r31 = ' num2str(R(3,1)) '       ' 'r32 = ' num2str(R(3,2)) '       ' 'r33 = ' num2str(R(3,3))];
            msg10=['  Rx = ' num2str(Rx) ' (rad)     ' 'Ry = ' num2str(Ry) ' (rad)     ' 'Rz = ' num2str(Rz) ' (rad)'];
            msg11=['  Rx = ' num2str(Rxo) 'º       ' 'Ry = ' num2str(Ryo) 'º       ' 'Rz = ' num2str(Rzo) 'º'];
            msg12=['  Recon. Mean uv (pixel) -> ' num2str(mean(abs(dif_uv))) '    (' num2str(mean(error_uv)) ')'];
            msg13=['  Recon. Max uv (pixel) -> ' num2str(max(abs(dif_uv))) '    (' num2str(max(error_uv)) ')'];
            msg14=['  Recon. STD uv (pixel) -> ' num2str(std(abs(dif_uv))) '    (' num2str(std(error_uv)) ')'];
            msg15=['  Recon. Mean XYZ (mm) -> ' num2str(mean(abs(dif_xyz))) '    (' num2str(mean(error_xyz)) ')'];
            msg16=['  Recon. Max XYZ (mm) ->  ' num2str(max(abs(dif_xyz))) '    (' num2str(max(error_xyz)) ')'];
            msg17=['  Recon. STD XYZ (mm) ->  ' num2str(std(abs(dif_xyz))) '    (' num2str(std(error_xyz)) ')'];
            msg18=['  NCE = ' num2str(NCE)];
            msg19=['  CPU time (s) ->  ' num2str(tiempo_f)];
            msg_resultados = struct('resultados',{msg0;msg0;msg1;msg2;msg3;...
                                                  msg0;msg4;...
                                                  msg0;msg5;...
                                                  msg0;msg6;...
                                                  msg0;msg7;msg8;msg9;...
                                                  msg0;msg10;...
                                                  msg0;msg11;...
                                                  msg0;msg12;msg13;msg14;...
                                                  msg0;msg15;msg16;msg17;...
                                                  msg0;msg18;...
                                                  msg0;msg19;msg0});
            str = {msg_resultados.resultados};
            tipo_calib = 'Faugeras with distortion';
            muestra_resultados(str,tipo_calib,dif_uv,dif_xyz);
        else
            %Muestra en pantalla los resultados
            msg0='';
            msg1=['  p11 = ' num2str(L(1)) '     p12 = ' num2str(L(2)) '     p13 = ' num2str(L(3)) '     p14 = ' num2str(L(4))];
            msg2=['  p21 = ' num2str(L(5)) '     p22 = ' num2str(L(6)) '     p23 = ' num2str(L(7)) '     p24 = ' num2str(L(8))];
            msg3=['  p31 = ' num2str(L(9)) '     p32 = ' num2str(L(10)) '     p33 = ' num2str(L(11)) '     p34 = ' num2str(L(12))];
            msg4=['  f = ' num2str(f) ' (mm)     ' 'Distortion: k1 = ' num2str(k1) '     ' 'k2 = ' num2str(k2)];
            msg5=['  u0 = ' num2str(u0) ' (mm)     ' 'v0 = ' num2str(v0) ' (mm)'];
            msg6=['  Tx = ' num2str(tx) ' (mm)     ' 'Ty = ' num2str(ty) ' (mm)     ' 'Tz = ' num2str(tz) ' (mm)'];
            msg7=['  r11 = ' num2str(R(1,1)) '       ' 'r12 = ' num2str(R(1,2)) '       ' 'r13 = ' num2str(R(1,3))];
            msg8=['  r21 = ' num2str(R(2,1)) '       ' 'r22 = ' num2str(R(2,2)) '       ' 'r23 = ' num2str(R(2,3))];
            msg9=['  r31 = ' num2str(R(3,1)) '       ' 'r32 = ' num2str(R(3,2)) '       ' 'r33 = ' num2str(R(3,3))];
            msg10=['  Rx = ' num2str(Rx) ' (rad)     ' 'Ry = ' num2str(Ry) ' (rad)     ' 'Rz = ' num2str(Rz) ' (rad)'];
            msg11=['  Rx = ' num2str(Rxo) 'º       ' 'Ry = ' num2str(Ryo) 'º       ' 'Rz = ' num2str(Rzo) 'º'];
            msg12=['  Recon. Mean uv (pixel) -> ' num2str(mean(abs(dif_uv))) '    (' num2str(mean(error_uv)) ')'];
            msg13=['  Recon. Max uv (pixel) -> ' num2str(max(abs(dif_uv))) '    (' num2str(max(error_uv)) ')'];
            msg14=['  Recon. STD uv (pixel) -> ' num2str(std(abs(dif_uv))) '    (' num2str(std(error_uv)) ')'];
            msg15=['  CPU time (s) ->  ' num2str(tiempo_f)];
            msg_resultados = struct('resultados',{msg0;msg0;msg1;msg2;msg3;...
                                                  msg0;msg4;...
                                                  msg0;msg5;...
                                                  msg0;msg6;...
                                                  msg0;msg7;msg8;msg9;...
                                                  msg0;msg10;...
                                                  msg0;msg11;...
                                                  msg0;msg12;msg13;msg14;...
                                                  msg0;msg15;msg0});
            str = {msg_resultados.resultados};
            tipo_calib = 'Faugeras with distortion';
            muestra_resultados(str,tipo_calib,0,0);
        end 
    else
        errordlg('To perform the non coplanar Faugeras calibration is necessary to have points in two different Z coordinates in the world reference system.','Points error');
    end;
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function [r1,r2,r3,tx,ty,tz,f,u0,v0] = extraccion_param_faugeras(L,dx,dy)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CALCULA LOS PARAMETROS INTRINSECOS Y EXTRINSECOS A PARTIR DE LA MATRIZ DE
% PROYECCION DE FAUGERAS
%--------------------------------------------------------------------------
    P_1 = L(1:3);
    P_2 = L(5:7);
    P_3 = L(9:11);
    %Cálculo del centro óptico
    u0 = P_1*P_3';
    v0 = P_2*P_3';
    %Cálculo de la distancia focal
    fx = sqrt(P_1*P_1' - u0^2);
    fy = sqrt(P_2*P_2' - v0^2);
    f = ((fx*dx)+(fy*dy))/2;
    %Cálculo de la matriz de rotación
    r1 = (1/fx)*(P_1 - u0*P_3);
    r2 = (1/fy)*(P_2 - v0*P_3);
    r3 = P_3;
    R = [r1;r2;r3];
    %Asegura la ortogonalidad de R
    [U,D,V] = svd(R);
    R = U*eye(3)*V';
    r1 = R(1,:);
    r2 = R(2,:);
    r3 = R(3,:);
    %Cálculo del vector de traslación
    tz = L(12);
    tx = (L(4)-u0*tz)/fx;
    ty = (L(8)-v0*tz)/fy;
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function [Rx,Ry,Rz,Rx_rad,Ry_rad,Rz_rad] = R_mat2grad(r11,r12,r13,r21,r22,r23,r31)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% PASA LOS PARÁMETROS EXTRÍNSECOS DE LA MATRIZ DE ROTACIÓN A ÁNGULOS
% DE EULER (º) Y (rad)
%--------------------------------------------------------------------------
    Rz_rad = atan2(r21,r11);
    Ry_rad = atan2(-r31,(r11*cos(Rz_rad)+r21*sin(Rz_rad)));
    Rx_rad = atan2((r13*sin(Rz_rad)-r23*cos(Rz_rad)),(r22*cos(Rz_rad)-r12*sin(Rz_rad)));

    Rx = Rx_rad * 180 / pi;
    Ry = Ry_rad * 180 / pi;
    Rz = Rz_rad * 180 / pi;
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function [r11,r12,r13,r21,r22,r23,r31,r32,r33] = R_grad2mat(Rx,Ry,Rz)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% PASA LOS ÁNGULOS DE EULER (rad) A PARÁMETROS EXTRÍNSECOS DE LA MATRIZ DE
% ROTACIÓN
%--------------------------------------------------------------------------
    r11 = cos(Ry) * cos(Rz);
    r12 = cos(Rz) * sin(Rx) * sin(Ry) - cos(Rx) * sin(Rz);
    r13 = sin(Rx) * sin(Rz) + cos(Rx) * cos(Rz) * sin(Ry);
    r21 = cos(Ry) * sin(Rz);
    r22 = sin(Rx) * sin(Ry) * sin(Rz) + cos(Rx) * cos(Rz);
    r23 = cos(Rx) * sin(Ry) * sin(Rz) - cos(Rz) * sin(Rx);
    r31 = -sin(Ry);
    r32 = cos(Ry) * sin(Rx);
    r33 = cos(Rx) * cos(Ry);
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function estado_generador(estado)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% DETERMINA EL FORMATO DEL GENERADOR DE PUNTOS (Ptos Generados o Cargados)
%--------------------------------------------------------------------------
    handles = guihandles();
    set(handles.O_X_T,'Enable',estado);
    set(handles.O_Y_T,'Enable',estado);
    set(handles.O_Z_T,'Enable',estado);
    set(handles.P_X_T,'Enable',estado);
    set(handles.P_Y_T,'Enable',estado);
    set(handles.P_Z_T,'Enable',estado);
    set(handles.E_X_T,'Enable',estado);
    set(handles.E_Y_T,'Enable',estado);
    set(handles.E_Z_T,'Enable',estado);
    set(handles.O_X_T,'Visible',estado);
    set(handles.O_Y_T,'Visible',estado);
    set(handles.O_Z_T,'Visible',estado);
    set(handles.P_X_T,'Visible',estado);
    set(handles.P_Y_T,'Visible',estado);
    set(handles.P_Z_T,'Visible',estado);
    set(handles.E_X_T,'Visible',estado);
    set(handles.E_Y_T,'Visible',estado);
    set(handles.E_Z_T,'Visible',estado);
    set(handles.frame5,'Visible',estado);
    set(handles.frame6,'Visible',estado);
    set(handles.frame7,'Visible',estado);
    set(handles.text24,'Visible',estado);
    set(handles.text25,'Visible',estado);
    set(handles.text38,'Visible',estado);
    set(handles.text39,'Visible',estado);
    set(handles.text40,'Visible',estado);
    set(handles.text41,'Visible',estado);
    set(handles.text42,'Visible',estado);
    set(handles.text43,'Visible',estado);
    set(handles.text44,'Visible',estado);
    set(handles.text45,'Visible',estado);
    set(handles.text46,'Visible',estado);
    set(handles.text47,'Visible',estado);
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function inicializa_sesion
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% INICIALIZA LA SESIÓN CON LOS PARÁMETROS DETERMINADOS
%--------------------------------------------------------------------------
    handles = guihandles();
    tipo_calibrador = get(handles.menu_board_T,'Checked');

    Objetivo_STDEV = 0;
    Sensor_STDEV = 0;
    Cu_Offset = 0;
    Cv_Offset = 0;
    dx = 3.5e-3;
    dy = 3.5e-3;
    Cu = 2208/2;
    Cv = 3000/2;
    Ncx = 2208;
    Nfx = 2208;
    f = 15.0;
    k1 = -0.0006;
    sx = 1.0;
    Rx = 0;
    Ry = 0;
    Rz = 0;
        
    if strcmp(tipo_calibrador, 'off')
        Tx = -130.0;
        Ty = -130.0;
        Tz = 1200.0;
        SizeX = 15;
        SizeY = 15;
        SizeZ = 1;
        OrigenX = 0;   
        OrigenY = 0;
        OrigenZ = 0;  
        EspacioX = 20;  
        EspacioY = 20;   
        EspacioZ = 20;   
        desplaz_x = 10;
        desplaz_y = 10;
        desplaz_z = 10;
        estado_generador('on');
        set(handles.noisesens_T,'String',Sensor_STDEV);
        set(handles.noisecali_T,'String',Objetivo_STDEV);
        set(handles.offu_T,'String',Cu_Offset);
        set(handles.offv_T,'String',Cv_Offset);
        set(handles.dx_T,'String',dx);
        set(handles.dy_T,'String',dy);
        set(handles.Cu_T,'String',Cu*2);
        set(handles.Cv_T,'String',Cv*2);
        set(handles.Ncx_T,'String',Ncx);
        set(handles.Nfx_T,'String',Nfx);
        set(handles.f_T,'String',f);
        set(handles.k1_T,'String',k1);
        set(handles.sx_T,'String',sx);
        set(handles.Tx_T,'String',Tx);
        set(handles.Ty_T,'String',Ty);
        set(handles.Tz_T,'String',Tz);
        set(handles.Rx_T,'String',Rx);
        set(handles.Ry_T,'String',Ry);
        set(handles.Rz_T,'String',Rz);
        set(handles.Rx_slider_T,'Value',Rx);
        set(handles.Ry_slider_T,'Value',Ry);
        set(handles.Rz_slider_T,'Value',Rz);
        set(handles.P_X_T,'String',SizeX);
        set(handles.P_Y_T,'String',SizeY);
        set(handles.P_Z_T,'String',SizeZ);
        set(handles.O_Z_T,'Enable','off');
        set(handles.O_X_T,'String',OrigenX);
        set(handles.O_Y_T,'String',OrigenY);
        set(handles.O_Z_T,'String',OrigenZ);
        set(handles.E_X_T,'String',EspacioX);
        set(handles.E_Y_T,'String',EspacioY);
        set(handles.E_Z_T,'String',EspacioZ);
        set(handles.desplazx_T,'String',desplaz_x);
        set(handles.desplazy_T,'String',desplaz_y);
        set(handles.desplazz_T,'String',desplaz_z);
        set(handles.menu_puntos_load_T,'Checked','off');
        set(handles.menu_puntos_genera_T,'Checked','on');
        set(handles.menu_puntosXu_load_T,'Checked','off');
        set(handles.menu_board_T,'Checked','off');
        set(handles.num_puntos_T,'Visible','off');
        set(handles.nombre_cali_T,'Visible','off');
        set(handles.text50,'Visible','off');
        set(handles.text51,'Visible','off');
        set(handles.menu_guarda_sesion_T,'Enable','on');
        set(handles.iguales_T,'Value',1);
        set(handles.Ncx_T,'Enable','off');
        set(handles.Nfx_T,'Enable','off');
        set(handles.fix_noise_sensor_T,'Value',0);
        set(handles.fix_noise_calib_T,'Value',0);
    else
        Tx = -160.0;
        Ty = -160.0;
        Tz = 1000.0;
        SizeX = 9;
        SizeY = 9;
        SizeZ = 1;
        OrigenX = 0;   
        OrigenY = 0;
        OrigenZ = 0;  
        EspacioX = 40;  
        EspacioY = 40;   
        EspacioZ = 20;   
        desplaz_x = 10;
        desplaz_y = 10;
        desplaz_z = 10;
        set(handles.P_X_T,'Enable','off');
        set(handles.P_Y_T,'Enable','off');
        set(handles.P_Z_T,'Enable','off');
        set(handles.O_Z_T,'Enable','off');
        set(handles.E_Z_T,'Enable','off');
        set(handles.menu_puntos_load_T,'Checked','off');
        set(handles.menu_puntosXu_load_T,'Checked','off');
        set(handles.menu_puntos_genera_T,'Checked','off');
        set(handles.menu_board_T,'Checked','on');
        set(handles.num_puntos_T,'Visible','off');
        set(handles.nombre_cali_T,'Visible','off');
        set(handles.text50,'Visible','off');
        set(handles.text51,'Visible','off');
        set(handles.menu_guarda_sesion_T,'Enable','on');
        estado_generador('on');
        set(handles.noisesens_T,'String',Sensor_STDEV);
        set(handles.noisecali_T,'String',Objetivo_STDEV);
        set(handles.offu_T,'String',Cu_Offset);
        set(handles.offv_T,'String',Cv_Offset);
        set(handles.dx_T,'String',dx);
        set(handles.dy_T,'String',dy);
        set(handles.Cu_T,'String',Cu*2);
        set(handles.Cv_T,'String',Cv*2);
        set(handles.Ncx_T,'String',Ncx);
        set(handles.Nfx_T,'String',Nfx);
        set(handles.f_T,'String',f);
        set(handles.k1_T,'String',k1);
        set(handles.sx_T,'String',sx);
        set(handles.Tx_T,'String',Tx);
        set(handles.Ty_T,'String',Ty);
        set(handles.Tz_T,'String',Tz);
        set(handles.Rx_T,'String',Rx);
        set(handles.Ry_T,'String',Ry);
        set(handles.Rz_T,'String',Rz);
        set(handles.Rx_slider_T,'Value',Rx);
        set(handles.Ry_slider_T,'Value',Ry);
        set(handles.Rz_slider_T,'Value',Rz);
        set(handles.P_X_T,'String',SizeX);
        set(handles.P_Y_T,'String',SizeY);
        set(handles.P_Z_T,'String',SizeZ);
        set(handles.O_Z_T,'Enable','off');
        set(handles.O_X_T,'String',OrigenX);
        set(handles.O_Y_T,'String',OrigenY);
        set(handles.O_Z_T,'String',OrigenZ);
        set(handles.E_X_T,'String',EspacioX);
        set(handles.E_Y_T,'String',EspacioY);
        set(handles.E_Z_T,'String',EspacioZ);
        set(handles.desplazx_T,'String',desplaz_x);
        set(handles.desplazy_T,'String',desplaz_y);
        set(handles.desplazz_T,'String',desplaz_z);
        set(handles.menu_puntos_load_T,'Checked','off');
        set(handles.menu_puntos_genera_T,'Checked','off');
        set(handles.menu_puntosXu_load_T,'Checked','off');
        set(handles.menu_board_T,'Checked','on');
        set(handles.num_puntos_T,'Visible','off');
        set(handles.nombre_cali_T,'Visible','off');
        set(handles.text50,'Visible','off');
        set(handles.text51,'Visible','off');
        set(handles.menu_guarda_sesion_T,'Enable','on');
        set(handles.iguales_T,'Value',1);
        set(handles.Ncx_T,'Enable','off');
        set(handles.Nfx_T,'Enable','off');
        set(handles.fix_noise_sensor_T,'Value',0);
        set(handles.fix_noise_calib_T,'Value',0);
    end           
%----------------------------------- FIN ----------------------------------


% --- Executes on button press in fix_noise_sensor_T.
function fix_noise_sensor_T_Callback(hObject, eventdata, handles)
% hObject    handle to fix_noise_sensor_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fix_noise_sensor_T


% --- Executes on button press in fix_noise_calib_T.
function fix_noise_calib_T_Callback(hObject, eventdata, handles)
% hObject    handle to fix_noise_calib_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fix_noise_calib_T


% --- Executes on button press in visual_T.
function visual_T_Callback(hObject, eventdata, handles)
% hObject    handle to visual_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% ABRE UNA NUEVA VENTANA MOSTRANADO LA POSICION DE LOS PTOS Y DE LA CAMARA
%--------------------------------------------------------------------------
    Tx = str2double(get(handles.Tx_T,'String'));
    Ty = str2double(get(handles.Ty_T,'String'));
    Tz = str2double(get(handles.Tz_T,'String'));
    Rx = str2double(get(handles.Rx_T,'String'));
    Ry = str2double(get(handles.Ry_T,'String'));
    Rz = str2double(get(handles.Rz_T,'String'));
    estado_board = get(handles.menu_board_T,'Checked');
    Rx = Rx * pi / 180;
    Ry = Ry * pi / 180;
    Rz = Rz * pi / 180;
    [r11,r12,r13,r21,r22,r23,r31,r32,r33] = R_grad2mat(Rx,Ry,Rz);
    parametros = [r11,r12,r13,r21,r22,r23,r31,r32,r33,Tx,Ty,Tz];
    muestra_posicion(parametros,estado_board);
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function muestra_posicion(param,estado)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CREA UNA VENTANA CON UNA FIGURA CON LA POSICION DE LOS PTOS Y LA CAMARA
%--------------------------------------------------------------------------

    global MatrizPtos;
    global camera_handler;
    handles = guihandles();
    
    R = reshape(param(1:9),3,3)'; %Parámetros intrínsecos
    T = param(10:12)'; %Parametros extrínsecos
    cent_opt = inv(R)*(-T); %Posición del centro óptico de la cámara
    dist = sqrt((abs(T(1))-cent_opt(1))^2+...
                (abs(T(2))-cent_opt(2))^2+...
                (cent_opt(3))^2); %Longitud de la línea de visión
    axis_l = (abs(T(3))/10); %Ajusta la longitud de los ejes a la escala de la figura
    axis_w = 2; %Grosor de los ejes
    lab_dist = 10; %Separación entre el eje y su etiqueta
    
    [existe] = figflag('Camera');
    if existe
        return;
    else
        %Crea la ventana que contendrá a la figura
        main_sz = get(gcf,'Position');
        figure('Position',[(main_sz(1)+(main_sz(3)-650)/2)...
                           (main_sz(2)+(main_sz(4)-650)/2)...
                           650 650],...
               'Name','Camera',...
               'NumberTitle','off',...
               'Color', [0.925 0.914 0.847],...
               'MenuBar','none',...
               'ToolBar','none',...
               'Tag','fig_position');
        camera_handler = figure(gcf);
        fig_sz = get(gcf,'Position');
        %Crea la figura con las propiedades de los ejes
        axes
        set(gca,'DataAspectRatio',[1 1 1],...
                'YDir','reverse',...
                'ZDir','reverse',...
                'XColor',[0.5 0.5 0.5],...
                'YColor',[0.5 0.5 0.5],...
                'ZColor',[0.5 0.5 0.5],...
                'GridLineStyle',':',...
                'FontSize',8);
        %Permite el giro de la figura
        rotate3d(gca);
        hold on;
        grid on;     
        
        if strcmp(estado,'off')
            %Dibuja los puntos de calibración
            plot3(MatrizPtos(:,1),MatrizPtos(:,2),MatrizPtos(:,3),'black.','MarkerSize',6);
        else
            u = MatrizPtos(:,1);
            v = MatrizPtos(:,2);
            nX = str2double(get(handles.P_X_T,'String'));
            nY = str2double(get(handles.P_Y_T,'String'));
            U = reshape(u,nX,nY)';
            V = reshape(v,nX,nY)';
            line([U(1,:)'; U(2:nY-1,nX); fliplr(U(nY,2:nX-1))'; flipud(U(:,1))],[V(1,:)'; V(2:nY-1,nX); fliplr(V(nY,2:nX-1))'; flipud(V(:,1))],'Color','k')
            for i=1:nY-1
                for j=1:nX-1
                    if rem(i,2)
                        if rem(j,2)
                            fill([U(i,j);U(i+1,j);U(i+1,j+1);U(i,j+1)],[V(i,j);V(i+1,j);V(i+1,j+1);V(i,j+1)],'k');
                        end
                    else
                        if not(rem(j,2))
                            fill([U(i,j);U(i+1,j);U(i+1,j+1);U(i,j+1)],[V(i,j);V(i+1,j);V(i+1,j+1);V(i,j+1)],'k');
                        end
                    end
                end
            end
        end
                
        %Dibuja una + en la posición de la cámara
        plot3(cent_opt(1),cent_opt(2),cent_opt(3),'black+','MarkerSize',6);
        %Dibuja la línea de visión de la cámara
        line([cent_opt(1,1); cent_opt(1,1)+dist*R(3,1)],[cent_opt(2,1);cent_opt(2,1)+dist*R(3,2)],[cent_opt(3,1);cent_opt(3,1)+dist*R(3,3)],'LineStyle',':','Color',[0.5 0 0]);
        %Dibuja los ejes del sistema cámara
        line([cent_opt(1) cent_opt(1)+axis_l*R(3,1)],[cent_opt(2) cent_opt(2)+axis_l*R(3,2)],[cent_opt(3) cent_opt(3)+axis_l*R(3,3)],'Color',[0.8 0 0],'LineWidth',axis_w);
        text(cent_opt(1)+(axis_l+lab_dist)*R(3,1),cent_opt(2)+(axis_l+lab_dist)*R(3,2),cent_opt(3)+(axis_l+lab_dist)*R(3,3),'Zc','Color',[0.8 0 0]);
        line([cent_opt(1) cent_opt(1)+axis_l*R(2,1)],[cent_opt(2) cent_opt(2)+axis_l*R(2,2)],[cent_opt(3) cent_opt(3)+axis_l*R(2,3)],'Color',[0 0.6 0],'LineWidth',axis_w);
        text(cent_opt(1)+(axis_l+lab_dist)*R(2,1),cent_opt(2)+(axis_l+lab_dist)*R(2,2),cent_opt(3)+(axis_l+lab_dist)*R(2,3),'Yc','Color',[0 0.6 0]);
        line([cent_opt(1) cent_opt(1)+axis_l*R(1,1)],[cent_opt(2) cent_opt(2)+axis_l*R(1,2)],[cent_opt(3) cent_opt(3)+axis_l*R(1,3)],'Color',[0 0 0.7],'LineWidth',axis_w);
        text(cent_opt(1)+(axis_l+lab_dist)*R(1,1),cent_opt(2)+(axis_l+lab_dist)*R(1,2),cent_opt(3)+(axis_l+lab_dist)*R(1,3),'Xc','Color',[0 0 0.7]);
        %Dibuja los ejes del sistema mundo
        line([0 0],[0 0],[0 axis_l],'Color',[0.8 0 0],'LineWidth',axis_w);
        text(-2*lab_dist,-lab_dist,axis_l,'Zw','Color',[0.8 0 0]);
        line([0 0],[0 axis_l],[0 0],'Color',[0 0.6 0],'LineWidth',axis_w);
        text(-2*lab_dist,axis_l,0,'Yw','Color',[0 0.6 0]);
        line([0 axis_l],[0 0],[0 0],'Color',[0 0 0.7],'LineWidth',axis_w);
        text(axis_l,-lab_dist,0,'Xw','Color',[0 0 0.7]);
        hold off;
        %Botón para cerrar la ventana
        OK_fig_callback = 'global camera_handler;close(camera_handler);';               
        OK_fig = uicontrol('Style', 'pushbutton',...
                           'String','OK',...
                           'Position', [((fig_sz(3)-120)/2) 10 120 30],...
                           'Callback', OK_fig_callback);
    end
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function menu_board_T_Callback(hObject, eventdata, handles)
% hObject    handle to menu_board_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------------------------------------------------
% REINICIALIZA EL ENTORNO CON LOS VALORES DEL ENSAYO INICIAL
%--------------------------------------------------------------------------
    estado_generador('on');
    set(handles.fix_noise_sensor_T,'Value',0);
    set(handles.fix_noise_calib_T,'Value',0);
    set(handles.Z_noise_T,'Value',0);
    set(handles.P_X_T,'String','9');
    set(handles.P_Y_T,'String','9');
    set(handles.P_Z_T,'String','1');
    set(handles.E_X_T,'String','40');
    set(handles.E_Y_T,'String','40');
    set(handles.Tx_T,'String','-160');
    set(handles.Ty_T,'String','-160');
    set(handles.Tz_T,'String','1000');
    set(handles.P_X_T,'Enable','off');
    set(handles.P_Y_T,'Enable','off');
    set(handles.P_Z_T,'Enable','off');
    set(handles.O_Z_T,'Enable','off');
    set(handles.E_Z_T,'Enable','off');
    set(handles.menu_puntos_load_T,'Checked','off');
    set(handles.menu_puntosXu_load_T,'Checked','off');
    set(handles.menu_puntos_genera_T,'Checked','off');
    set(handles.menu_board_T,'Checked','on');
    set(handles.num_puntos_T,'Visible','off');
    set(handles.nombre_cali_T,'Visible','off');
    set(handles.text50,'Visible','off');
    set(handles.text51,'Visible','off');
    set(handles.menu_guarda_sesion_T,'Enable','on');
    %--------------------------------------------------------------------------
    % GENERA EL ENSAYO AL CAMBIAR EL VALOR DEL CUADRO DE TEXTO
    % Lee los parámetros de los controles y genera el ensayo correspondiente
    %--------------------------------------------------------------------------
    generador;
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    dibuja_ptos(Cu,Cv);

    
% --- Executes on button press in Z_noise_T.
function Z_noise_T_Callback(hObject, eventdata, handles)
% hObject    handle to Z_noise_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Z_noise_T
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% GENERA EL ENSAYO AL CAMBIAR EL VALOR DEL CUADRO DE TEXTO
% Lee los parámetros de los controles y genera el ensayo correspondiente
%--------------------------------------------------------------------------
    generador;
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes when selected object is changed in noise_panel_T.
function noise_panel_T_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in noise_panel_T 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% DETECTA EL CAMBIO DE TIPO DE RUIDO Gaussiano->tipo_ruido = 1
%                                    Normal->tipo_ruido = 0
%--------------------------------------------------------------------------
    global tipo_ruido;

    radio_selecc = get(handles.noise_panel_T,'SelectedObject');
    nombre_radio_selecc = get(radio_selecc,'String');

    if strcmp(nombre_radio_selecc,'Gaussian Noise');
        tipo_ruido = 1;
    else
        tipo_ruido = 0;
    end
    Cu = str2double(get(handles.Cu_T,'String'));
    Cv = str2double(get(handles.Cv_T,'String'));
    set(handles.fix_noise_sensor_T,'Value',0);
    set(handles.fix_noise_calib_T,'Value',0);
    generador;
    dibuja_ptos(Cu,Cv);
%----------------------------------- FIN ----------------------------------


% --- Executes during object creation, after setting all properties.
function is_gaussian_T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to is_gaussian_T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% INICIALIZA EL TIPO DE RUIDO EN GAUSSIANO
%--------------------------------------------------------------------------
    global tipo_ruido;

    tipo_ruido = 1;
%----------------------------------- FIN ----------------------------------


% --------------------------------------------------------------------
function menu_zhang_dist_Callback(hObject, eventdata, handles)
% hObject    handle to menu_zhang_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%---------------------------------------------------------------------------
% HACE LA CALIBRACION DE ZHANG CON DISTORSION A PARTIR DE N IMAGENES (N=3:5)
%---------------------------------------------------------------------------
global M;
global m;
global nombres_zhang;
global param_finales;

    filterindex_cali = 0;
    [filename_cali, pathname_cali, filterindex_cali] = uigetfile( ...
               {  '*.pto','Tsai calibration (*.pto)'; ...
                  '*.*',  'All files (*.*)'}, ...
                  'Load calibration points', ...
                  'MultiSelect', 'on');

    nombres_zhang = filename_cali;
    if filterindex_cali ~= 0
        % Comprueba que se cargan de 3 a 5 archivos.
        [i,n_archivos] = size(filename_cali);
        if n_archivos<3
             errordlg('At least three image data files are necessary for the camera calibration.','Points error','modal');
             return;
        end
        if n_archivos>5
             errordlg('The maximum of allowed image data files is five.','Points error','modal');
             return;
        end
        % Comprueba que todos los archivos tienen el mismo número de ptos.
        n_ptos_ini = 0;
        for i=1:n_archivos
            XYZuv = load([pathname_cali char(filename_cali(1,i))]);
            n_ptos = size(XYZuv,1);
            if n_ptos_ini == 0
                n_ptos_ant = n_ptos;
                n_ptos_ini = n_ptos;
            else
                if n_ptos ~= n_ptos_ant
                    errordlg('All the image data files must have the same numbers of points.','Points error','modal');
                    return;
                end
            end
        end
        % Comprueba que todos los ptos están en Z=0 y que no haya coordenadas (U,V) negativas
        XYZuv = zeros(n_ptos,5,n_archivos);
        for i=1:n_archivos
            XYZuv(:,:,i) = load([pathname_cali char(filename_cali(1,i))]);
            if max(XYZuv(:,3,i))>0
                errordlg('To perform the Zhang calibration it is necessary that all the points are in Z=0.','Points error');
                return;
            end
            if min(XYZuv(:,4:5,i))<0
                errordlg('There are negative values in the (u,v) coordinates.','Points error','modal');
                return;
            end
        end
        
        % Hace la calibración de Zhang
        tic;
        param_def = calib_zhang(XYZuv);
        param_finales = param_def;
        tiempo_z = toc;
        
        % Reconstruye las matrices definitivas (A, R(i), T(i), i=3...5)
        R = zeros(3,3,n_archivos);
        T = zeros(3,1,n_archivos);
        Rgrad = zeros(1,3,n_archivos);
        Rrad = zeros(1,3,n_archivos);
        for i=1:n_archivos 
            param_i = param_def(((i-1)*6+1):((i-1)*6+6)); 
            A1_i = param_i(1); 
            A2_i = param_i(2); 
            A3_i = param_i(3); 
            T_i = param_i(4:6)'; 
            R_i = [(cos(A2_i)*cos(A1_i))                                 (sin(A2_i)*cos(A1_i))                                 (-sin(A1_i));...
                   (-sin(A2_i)*cos(A3_i)+cos(A2_i)*sin(A1_i)*sin(A3_i))  (cos(A2_i)*cos(A3_i)+sin(A2_i)*sin(A1_i)*sin(A3_i))   (cos(A1_i)*sin(A3_i));...
                   (sin(A2_i)*sin(A3_i)+cos(A2_i)*sin(A1_i)*cos(A3_i))   (-cos(A2_i)*sin(A3_i)+sin(A2_i)*sin(A1_i)*cos(A3_i))  (cos(A1_i)*cos(A3_i))]; 
            %Matriz de rotación
            R(:,:,i) = R_i; 
            %Vector de traslación
            T(:,:,i) = T_i; 
            %Ángulos de rotación en grados
            [Rx_i,Ry_i,Rz_i,Rx_rad_i,Ry_rad_i,Rz_rad_i] = R_mat2grad(R_i(1,1),R_i(1,2),R_i(1,3),R_i(2,1),R_i(2,2),R_i(2,3),R_i(3,1));
            Rgrad(:,:,i) = [Rx_i Ry_i Rz_i];
            Rrad(:,:,i) = [Rx_rad_i Ry_rad_i Rz_rad_i];
        end 
        %Matriz de parámetros intrínsecos
        k1 = param_def((n_archivos*6)+1); 
        k2 = param_def((n_archivos*6)+2); 
        a = param_def((n_archivos*6)+3);
        b = param_def((n_archivos*6)+6);
        c = param_def((n_archivos*6)+4);
        u0 = param_def((n_archivos*6)+5); 
        v0 = param_def((n_archivos*6)+7); 
        A = [a c u0; 0 b v0; 0 0 1];
        %Cálculo de la distancia focal
        dx_i_T = findobj(gcbf,'Tag','dx_T');
        dx = str2double(get(dx_i_T,'String'));
        dy_i_T = findobj(gcbf,'Tag','dy_T');
        dy = str2double(get(dy_i_T,'String'));
        f = (a*dx+b*dy)/2;
        
        %Cálculo de la reconstrucción de los puntos (u,v) y (X,Y,Z)
        ptos = size(M,2);
        D = zeros(n_archivos*2,ptos); 
        D_sd = zeros(n_archivos*2,ptos); 
        d = zeros(n_archivos*2,ptos);    
        XY = zeros(n_archivos*2,ptos); 
        for i=1:n_archivos 
            RT_i = [R(:,1:2,i) T(:,:,i)]; 
            XYs = RT_i*M; 
            UVs = A*XYs; 
            XY1_i=[XYs(1,:)./XYs(3,:); XYs(2,:)./XYs(3,:); XYs(3,:)./XYs(3,:)]; 
            r_i = ((XY1_i(1,:)).^2+(XY1_i(2,:)).^2);
            UV1_i=[UVs(1,:)./UVs(3,:); UVs(2,:)./UVs(3,:); UVs(3,:)./UVs(3,:)]; 
            
            D(((i-1)*2)+1,:) = (UV1_i(1,:)+(UV1_i(1,:)-u0).*r_i*k1+(UV1_i(1,:)-u0).*r_i.^2*k2);
            D(((i-1)*2)+2,:) = (UV1_i(2,:)+(UV1_i(2,:)-v0).*r_i*k1+(UV1_i(2,:)-v0).*r_i.^2*k2); 
            d(((i-1)*2)+1,:) = m(1,:,i);
            d(((i-1)*2)+2,:) = m(2,:,i); 
            
            D_sd(((i-1)*2)+1,:) = (d(((i-1)*2)+1,:)-(d(((i-1)*2)+1,:)-u0).*r_i*k1-(d(((i-1)*2)+1,:)-u0).*r_i.^2*k2);
            D_sd(((i-1)*2)+2,:) = (d(((i-1)*2)+2,:)-(d(((i-1)*2)+2,:)-v0).*r_i*k1-(d(((i-1)*2)+2,:)-v0).*r_i.^2*k2); 
            P_i = A*RT_i;
            for j=1:ptos
                AA = (P_i(1,1)-D_sd(((i-1)*2)+1,j)*P_i(3,1));
                BB = (P_i(1,2)-D_sd(((i-1)*2)+1,j)*P_i(3,2));
                DD = -(P_i(1,3)-D_sd(((i-1)*2)+1,j)*P_i(3,3));
                EE = (P_i(2,1)-D_sd(((i-1)*2)+2,j)*P_i(3,1));
                FF = (P_i(2,2)-D_sd(((i-1)*2)+2,j)*P_i(3,2));
                HH = -(P_i(2,3)-D_sd(((i-1)*2)+2,j)*P_i(3,3));
                XY(((i-1)*2)+1,j) = (DD/AA)-((BB/AA)*((AA*HH-EE*DD)/(AA*FF-EE*BB)));
                XY(((i-1)*2)+2,j) = ((AA*HH-EE*DD)/(AA*FF-EE*BB));
            end
        end
        dif_uv = d'-D';
        error_uv = zeros(ptos,n_archivos);
        error_xyz = zeros(ptos,n_archivos);
        dif_xyz = zeros(ptos,n_archivos*3); 
        for i=1:n_archivos
            error_uv(:,i) = sqrt(dif_uv(:,((i-1)*2)+1).^2+dif_uv(:,((i-1)*2)+2).^2);
            dif_xyz(:,((i-1)*3)+1:((i-1)*3)+3) = [(M(1:2,:))'-(XY(((i-1)*2)+1:((i-1)*2)+2,:))' zeros(ptos,1)];
            error_xyz(:,i) = sqrt(dif_xyz(:,((i-1)*2)+1).^2+dif_xyz(:,((i-1)*2)+2).^2+dif_xyz(:,((i-1)*2)+3).^2);
        end
        
        %Muestra en pantalla los resultados
        msg0 = '';
        msg00 = '-------------------------------------------------------------------------------------------';
        msg1 = ['   a11 = ' num2str(a) '     a12 = ' num2str(c) '     a13 = ' num2str(u0)];
        msg2 = ['   a21 = ' num2str(0) '     a22 = ' num2str(b) '     a23 = ' num2str(v0)];
        msg3 = ['   a31 = ' num2str(0) '     a32 = ' num2str(0) '     a33 = ' num2str(1)];
        msg4 = ['   f = ' num2str(f) ' (mm)     ' 'u0 = ' num2str(u0) '     ' 'v0 = ' num2str(v0)];
        msg5 = ['   K1 = ' num2str(k1) '     ' 'k2 = ' num2str(k2)];
        for i=1:n_archivos
            NCE_i = NCE_coef_zhang((M(1:2,:))',XY(((i-1)*2)+1:((i-1)*2)+2,:)',f,T(3,1,i),dx,dy,ptos);
            dif_uv_i = dif_uv(:,((i-1)*2)+1:((i-1)*2)+2);
            error_uv_i = error_uv(:,i);
            dif_xyz_i = dif_xyz(:,((i-1)*3)+1:((i-1)*3)+3);
            error_xyz_i = error_xyz(:,i);
            nombre_img = [' (' num2str(i) ')  File: ' filename_cali{i}];
            img{i} = {'';...
                      '-------------------------------------------------------------------------------------------';...
                      nombre_img;...
                      '';...
                      ['    Tx = ' num2str(T(1,1,i)) ' (mm)     ' 'Ty = ' num2str(T(2,1,i)) ' (mm)     ' 'Tz = ' num2str(T(3,1,i)) ' (mm)'];...
                      '';...
                      ['    r11 = ' num2str(R(1,1,i)) '       ' 'r12 = ' num2str(R(1,2,i)) '       ' 'r13 = ' num2str(R(1,3,i))];...
                      ['    r21 = ' num2str(R(2,1,i)) '       ' 'r22 = ' num2str(R(2,2,i)) '       ' 'r23 = ' num2str(R(2,3,i))];...
                      ['    r31 = ' num2str(R(3,1,i)) '       ' 'r32 = ' num2str(R(3,2,i)) '       ' 'r33 = ' num2str(R(3,3,i))];...
                      '';...
                      ['    Rx = ' num2str(Rrad(1,1,i)) ' (rad)     ' 'Ry = ' num2str(Rrad(1,2,i)) ' (rad)     ' 'Rz = ' num2str(Rrad(1,3,i)) ' (rad)'];...
                      '';...
                      ['    Rx = ' num2str(Rgrad(1,1,i)) 'º       ' 'Ry = ' num2str(Rgrad(1,2,i)) 'º       ' 'Rz = ' num2str(Rgrad(1,3,i)) 'º'];...
                      '';...
                      ['    Recon. Mean uv (pixel) -> ' num2str(mean(abs(dif_uv_i))) '    (' num2str(mean(error_uv_i)) ')'];...
                      ['    Recon. Max uv (pixel) -> ' num2str(max(abs(dif_uv_i))) '    (' num2str(max(error_uv_i)) ')'];...
                      ['    Recon. STD uv (pixel) -> ' num2str(std(abs(dif_uv_i))) '    (' num2str(std(error_uv_i)) ')'];...
                      '';...
                      ['    Recon. Mean XYZ (mm) -> ' num2str(mean(abs(dif_xyz_i))) '    (' num2str(mean(error_xyz_i)) ')'];...
                      ['    Recon. Max XYZ (mm) ->  ' num2str(max(abs(dif_xyz_i))) '    (' num2str(max(error_xyz_i)) ')'];...
                      ['    Recon. STD XYZ (mm) ->  ' num2str(std(abs(dif_xyz_i))) '    (' num2str(std(error_xyz_i)) ')'];...
                      '';...
                      ['  NCE = ' num2str(NCE_i)]};...
        end
        msg_tot = {msg0;msg0;msg1;msg2;msg3;msg0;msg4;msg0;msg5};
        for i=1:n_archivos
            n_lin = 23;
            for j=1:n_lin
                msg_tot{((i-1)*n_lin)+(j+9),1} = img{i}{j,1};
            end
        end
        msg8 = ['   CPU time (s) ->  ' num2str(tiempo_z)];
                  
        size_msg = size(msg_tot,1);
        msg_tot{size_msg+1,1} = msg0;
        msg_tot{size_msg+2,1} = msg00;
        msg_tot{size_msg+3,1} = msg0;
        msg_tot{size_msg+4,1} = msg0;
        msg_tot{size_msg+5,1} = msg8;
        msg_tot{size_msg+6,1} = msg0;
                                          
        msg_resultados = struct('resultados',msg_tot);
        str = {msg_resultados.resultados};
        tipo_calib = 'Zhang with distortion';
        muestra_resultados_zhang(str,tipo_calib,dif_uv,dif_xyz);
    end

% --------------------------------------------------------------------------
function menu_zhang_Callback(hObject, eventdata, handles)
% hObject    handle to menu_zhang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%--------------------------------- INICIO ----------------------------------
%---------------------------------------------------------------------------
% HACE LA CALIBRACION DE ZHANG SIN DISTORSION A PARTIR DE N IMAGENES (N=3:5)
%---------------------------------------------------------------------------
global M;
global m;
global nombres_zhang;
global param_finales;

    filterindex_cali = 0;
    [filename_cali, pathname_cali, filterindex_cali] = uigetfile( ...
               {  '*.pto','Tsai calibration (*.pto)'; ...
                  '*.*',  'All files (*.*)'}, ...
                  'Load calibration points', ...
                  'MultiSelect', 'on');

    nombres_zhang = filename_cali;
    if filterindex_cali ~= 0
        % Comprueba que se cargan de 3 a 5 archivos.
        [i,n_archivos] = size(filename_cali);
        if n_archivos<3
             errordlg('At least three image data files are necessary for the camera calibration.','Points error','modal');
             return;
        end
        if n_archivos>5
             errordlg('The maximum of allowed image data files is five.','Points error','modal');
             return;
        end
        % Comprueba que todos los archivos tienen el mismo número de ptos.
        n_ptos_ini = 0;
        for i=1:n_archivos
            XYZuv = load([pathname_cali char(filename_cali(1,i))]);
            n_ptos = size(XYZuv,1);
            if n_ptos_ini == 0
                n_ptos_ant = n_ptos;
                n_ptos_ini = n_ptos;
            else
                if n_ptos ~= n_ptos_ant
                    errordlg('All the image data files must have the same numbers of points.','Points error','modal');
                    return;
                end
            end
        end
        % Comprueba que todos los ptos están en Z=0 y que no haya coordenadas (U,V) negativas
        XYZuv = zeros(n_ptos,5,n_archivos);
        for i=1:n_archivos
            XYZuv(:,:,i) = load([pathname_cali char(filename_cali(1,i))]);
            if max(XYZuv(:,3,i))>0
                errordlg('To perform the Zhang calibration it is necessary that all the points are in Z=0.','Points error');
                return;
            end
            if min(XYZuv(:,4:5,i))<0
                errordlg('There are negative values in the (u,v) coordinates.','Points error','modal');
                return;
            end
        end
        
        % Hace la calibración de Zhang
        tic;
        param_def = calib_zhang_sin(XYZuv);
        param_finales = param_def;
        tiempo_z = toc;
        
        % Reconstruye las matrices definitivas (A, R(i), T(i), i=3...5)
        R = zeros(3,3,n_archivos);
        T = zeros(3,1,n_archivos);
        Rgrad = zeros(1,3,n_archivos);
        Rrad = zeros(1,3,n_archivos);
        for i=1:n_archivos 
            param_i = param_def(((i-1)*6+1):((i-1)*6+6)); 
            A1_i = param_i(1); 
            A2_i = param_i(2); 
            A3_i = param_i(3); 
            T_i = param_i(4:6)'; 
            R_i = [(cos(A2_i)*cos(A1_i))                                 (sin(A2_i)*cos(A1_i))                                 (-sin(A1_i));...
                   (-sin(A2_i)*cos(A3_i)+cos(A2_i)*sin(A1_i)*sin(A3_i))  (cos(A2_i)*cos(A3_i)+sin(A2_i)*sin(A1_i)*sin(A3_i))   (cos(A1_i)*sin(A3_i));...
                   (sin(A2_i)*sin(A3_i)+cos(A2_i)*sin(A1_i)*cos(A3_i))   (-cos(A2_i)*sin(A3_i)+sin(A2_i)*sin(A1_i)*cos(A3_i))  (cos(A1_i)*cos(A3_i))]; 
            %Matriz de rotación
            R(:,:,i) = R_i; 
            %Vector de traslación
            T(:,:,i) = T_i; 
            %Ángulos de rotación en grados
            [Rx_i,Ry_i,Rz_i,Rx_rad_i,Ry_rad_i,Rz_rad_i] = R_mat2grad(R_i(1,1),R_i(1,2),R_i(1,3),R_i(2,1),R_i(2,2),R_i(2,3),R_i(3,1));
            Rgrad(:,:,i) = [Rx_i Ry_i Rz_i];
            Rrad(:,:,i) = [Rx_rad_i Ry_rad_i Rz_rad_i];
        end 
        %Matriz de parámetros intrínsecos
        a = param_def((n_archivos*6)+1);
        b = param_def((n_archivos*6)+4);
        c = param_def((n_archivos*6)+2);
        u0 = param_def((n_archivos*6)+3); 
        v0 = param_def((n_archivos*6)+5); 
        A = [a c u0; 0 b v0; 0 0 1];
        %Cálculo de la distancia focal
        dx_i_T = findobj(gcbf,'Tag','dx_T');
        dx = str2double(get(dx_i_T,'String'));
        dy_i_T = findobj(gcbf,'Tag','dy_T');
        dy = str2double(get(dy_i_T,'String'));
        f = (a*dx+b*dy)/2;
        
        %Cálculo de la reconstrucción de los puntos (u,v) y (X,Y,Z)
        ptos = size(M,2);
        D = zeros(n_archivos*2,ptos); 
        d = zeros(n_archivos*2,ptos); 
        XY = zeros(n_archivos*2,ptos);     
        for i=1:n_archivos 
            RT_i = [R(:,1:2,i) T(:,:,i)]; 
            XYs = RT_i*M; 
            UVs = A*XYs; 
            UV1_i=[UVs(1,:)./UVs(3,:); UVs(2,:)./UVs(3,:); UVs(3,:)./UVs(3,:)]; 
            D(((i-1)*2)+1,:) = UV1_i(1,:);
            D(((i-1)*2)+2,:) = UV1_i(2,:); 
            d(((i-1)*2)+1,:) = m(1,:,i);
            d(((i-1)*2)+2,:) = m(2,:,i); 
                        
            P_i = A*RT_i;
            for j=1:ptos
                AA = (P_i(1,1)-d(((i-1)*2)+1,j)*P_i(3,1));
                BB = (P_i(1,2)-d(((i-1)*2)+1,j)*P_i(3,2));
                DD = -(P_i(1,3)-d(((i-1)*2)+1,j)*P_i(3,3));
                EE = (P_i(2,1)-d(((i-1)*2)+2,j)*P_i(3,1));
                FF = (P_i(2,2)-d(((i-1)*2)+2,j)*P_i(3,2));
                HH = -(P_i(2,3)-d(((i-1)*2)+2,j)*P_i(3,3));
                XY(((i-1)*2)+1,j) = (DD/AA)-((BB/AA)*((AA*HH-EE*DD)/(AA*FF-EE*BB)));
                XY(((i-1)*2)+2,j) = ((AA*HH-EE*DD)/(AA*FF-EE*BB));
            end
        end
        dif_uv = d'-D';
        error_uv = zeros(ptos,n_archivos);
        error_xyz = zeros(ptos,n_archivos);
        dif_xyz = zeros(ptos,n_archivos*3); 
        for i=1:n_archivos
            error_uv(:,i) = sqrt(dif_uv(:,((i-1)*2)+1).^2+dif_uv(:,((i-1)*2)+2).^2);
            dif_xyz(:,((i-1)*3)+1:((i-1)*3)+3) = [(M(1:2,:))'-(XY(((i-1)*2)+1:((i-1)*2)+2,:))' zeros(ptos,1)];
            error_xyz(:,i) = sqrt(dif_xyz(:,((i-1)*2)+1).^2+dif_xyz(:,((i-1)*2)+2).^2+dif_xyz(:,((i-1)*2)+3).^2);
        end
        
        %Muestra en pantalla los resultados
        msg0 = '';
        msg00 = '-------------------------------------------------------------------------------------------';
        msg1 = ['   a11 = ' num2str(a) '     a12 = ' num2str(c) '     a13 = ' num2str(u0)];
        msg2 = ['   a21 = ' num2str(0) '     a22 = ' num2str(b) '     a23 = ' num2str(v0)];
        msg3 = ['   a31 = ' num2str(0) '     a32 = ' num2str(0) '     a33 = ' num2str(1)];
        msg4 = ['   f = ' num2str(f) ' (mm)     ' 'u0 = ' num2str(u0) '     ' 'v0 = ' num2str(v0)];
        for i=1:n_archivos
            NCE_i = NCE_coef_zhang((M(1:2,:))',XY(((i-1)*2)+1:((i-1)*2)+2,:)',f,T(3,1,i),dx,dy,ptos);
            dif_uv_i = dif_uv(:,((i-1)*2)+1:((i-1)*2)+2);
            error_uv_i = error_uv(:,i);
            dif_xyz_i = dif_xyz(:,((i-1)*3)+1:((i-1)*3)+3);
            error_xyz_i = error_xyz(:,i);
            nombre_img = [' (' num2str(i) ')  File: ' filename_cali{i}];
            img{i} = {'';...
                      '-------------------------------------------------------------------------------------------';...
                      nombre_img;...
                      '';...
                      ['    Tx = ' num2str(T(1,1,i)) ' (mm)     ' 'Ty = ' num2str(T(2,1,i)) ' (mm)     ' 'Tz = ' num2str(T(3,1,i)) ' (mm)'];...
                      '';...
                      ['    r11 = ' num2str(R(1,1,i)) '       ' 'r12 = ' num2str(R(1,2,i)) '       ' 'r13 = ' num2str(R(1,3,i))];...
                      ['    r21 = ' num2str(R(2,1,i)) '       ' 'r22 = ' num2str(R(2,2,i)) '       ' 'r23 = ' num2str(R(2,3,i))];...
                      ['    r31 = ' num2str(R(3,1,i)) '       ' 'r32 = ' num2str(R(3,2,i)) '       ' 'r33 = ' num2str(R(3,3,i))];...
                      '';...
                      ['    Rx = ' num2str(Rrad(1,1,i)) ' (rad)     ' 'Ry = ' num2str(Rrad(1,2,i)) ' (rad)     ' 'Rz = ' num2str(Rrad(1,3,i)) ' (rad)'];...
                      '';...
                      ['    Rx = ' num2str(Rgrad(1,1,i)) 'º       ' 'Ry = ' num2str(Rgrad(1,2,i)) 'º       ' 'Rz = ' num2str(Rgrad(1,3,i)) 'º'];...
                      '';...
                      ['    Recon. Mean uv (pixel) -> ' num2str(mean(abs(dif_uv_i))) '    (' num2str(mean(error_uv_i)) ')'];...
                      ['    Recon. Max uv (pixel) -> ' num2str(max(abs(dif_uv_i))) '    (' num2str(max(error_uv_i)) ')'];...
                      ['    Recon. STD uv (pixel) -> ' num2str(std(abs(dif_uv_i))) '    (' num2str(std(error_uv_i)) ')'];...
                      '';...
                      ['    Recon. Mean XYZ (mm) -> ' num2str(mean(abs(dif_xyz_i))) '    (' num2str(mean(error_xyz_i)) ')'];...
                      ['    Recon. Max XYZ (mm) ->  ' num2str(max(abs(dif_xyz_i))) '    (' num2str(max(error_xyz_i)) ')'];...
                      ['    Recon. STD XYZ (mm) ->  ' num2str(std(abs(dif_xyz_i))) '    (' num2str(std(error_xyz_i)) ')'];...
                      '';...
                      ['  NCE = ' num2str(NCE_i)]};...
        end
        msg_tot = {msg0;msg0;msg1;msg2;msg3;msg0;msg4};
        for i=1:n_archivos
            n_lin = 23;
            for j=1:n_lin
                msg_tot{((i-1)*n_lin)+(j+7),1} = img{i}{j,1};
            end
        end
        msg8 = ['   CPU time (s) ->  ' num2str(tiempo_z)];
                  
        size_msg = size(msg_tot,1);
        msg_tot{size_msg+1,1} = msg0;
        msg_tot{size_msg+2,1} = msg00;
        msg_tot{size_msg+3,1} = msg0;
        msg_tot{size_msg+4,1} = msg0;
        msg_tot{size_msg+5,1} = msg8;
        msg_tot{size_msg+6,1} = msg0;
                                          
        msg_resultados = struct('resultados',msg_tot);
        str = {msg_resultados.resultados};
        tipo_calib = 'Zhang without distortion';
        muestra_resultados_zhang(str,tipo_calib,dif_uv,dif_xyz);
    end
%----------------------------------- FIN -----------------------------------


% -------------------------------------------------------------------------
function param_def = calib_zhang_sin(XYZuv)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% FUNCIÓN QUE HACE LA CALIBRACION DE ZHANG SIN CORRECCIONES OPTICAS
% PROPORCIONA PARÁMETROS INTRÍNSECOS Y EXTRÍNSECOS DE TODAS LAS IMÁGENES EN
% FORMA MATRICIAL
%--------------------------------------------------------------------------
global M;
global m;

    %Prepara las matrices M y m M(3xN) m(3xNx5)
    ptos = size(XYZuv(:,1),1);
    imgs = size(XYZuv,3);
    M = [XYZuv(:,1:2)'; ones(1,ptos)];
    m = zeros(3,ptos,imgs);
    for i=1:imgs
        m(:,:,i) = [XYZuv(:,4:5,i)'; ones(1,ptos)];
    end
    
    %-----------------------------------------------
    %Primer cálculo aproximado de las homgrafías (H)
    %-----------------------------------------------
    H = zeros(3,3,imgs);
    for i = 1:imgs
        H(:,:,i) = homografia(M,m(:,:,i))';
    end
    
    %----------------------------------------
    %Cálculo de los parámetros de calibración
    %----------------------------------------
    %Cálculo de la matriz V (V·b=0 -> b -> cónica absoluta B)
    V = zeros(2*imgs,6);
    for i=1:imgs
        v11_i = v_ecu(H(:,:,i),1,1);
        v12_i = v_ecu(H(:,:,i),1,2);
        v22_i = v_ecu(H(:,:,i),2,2);
        V((((i-1)*2)+1),:) = v12_i';
        V((((i-1)*2)+2),:) = v11_i'-v22_i';
    end
    %Cálculo de b
    [Ub,Db,Vb] = svd(V'*V);
    b = Vb(:,6);
    %Cálculo de la matriz cónica absoluta B (simétrica)
    B11 = b(1);
    B12 = b(2);
    B22 = b(3);
    B13 = b(4);
    B23 = b(5);
    B33 = b(6);
    %Cálculo de los parámetros intrínsecos
    v0 = (B12*B13-B11*B23)/(B11*B22-B12^2);
    cte = B33-(B13^2+v0*(B12*B13-B11*B23))/B11;
    a = sqrt(cte/B11);
    b = sqrt(cte*B11/(B11*B22-B12^2));
    c = -B12*a*a*b/cte;
    u0 = c*v0/a-B13*a*a/cte;
    %Cálculo aprox. de la matriz de parámetros intrínsecos (A)
    A = [a c u0; ...
         0 b v0; ...
         0 0 1];
    %Cálculo de los parámetros extrínsecos (R y T) para cada cámara (o posición)
    param_ext = zeros(1,6,imgs);
    for i=1:imgs
        h1_i = H(1,:,i)';        
        h2_i = H(2,:,i)';     
        h3_i = H(3,:,i)';
        lambda = ((1/norm(inv(A)*h1_i))+(1/norm(inv(A)*h2_i)))/2;
        r1_i = lambda*inv(A)*h1_i;
        r2_i = lambda*inv(A)*h2_i;
        r3_i = cross(r1_i,r2_i);
        R_i = [r1_i r2_i r3_i];
        %Garantiza la ortonormalidad de R
        [U,D,V] = svd(R_i);
        R_i = U*V';
        %Calculo de las matrices R y T
        T_i = lambda*inv(A)*h3_i;
        %Cálculo de los ángulos asociados a la matriz R (OJO NO SON PRY)
        A1 = -asin(R_i(1,3)); 
        A2 = asin(R_i(1,2)/cos(A1));
        A3 = asin(R_i(2,3)/cos(A1));
        %Vector con los parámetros extrínsecos
        param_ext(:,:,i) = [A1 A2 A3 T_i'];
    end
        
    %------------------------------------
    %Optimización de todos los parámetros
    %------------------------------------
    %Crea un vector con todos los parámetros a optimizar
    param_optim = zeros(1,imgs*6);
    for i=1:imgs
        param_optim(:,(((i-1)*6)+1):(((i-1)*6)+6)) = param_ext(:,:,i);
    end
    param_optim = [param_optim A(1,1) A(1,2) A(1,3) A(2,2) A(2,3)];
    %Optimización de todos los parámetros
    options = optimset('LargeScale','off','LevenbergMarquardt','on');
    param_def  = lsqnonlin(@optimizaParam_zhang,param_optim,[],[],options,M,m);
%----------------------------------- FIN ----------------------------------
    
    
% -------------------------------------------------------------------------
function param_def = calib_zhang(XYZuv)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% FUNCIÓN QUE HACE LA CALIBRACION DE ZHANG CON CORRECCIONES OPTICAS
% PROPORCIONA PARÁMETROS INTRÍNSECOS Y EXTRÍNSECOS DE TODAS LAS IMÁGENES EN
% FORMA MATRICIAL
%--------------------------------------------------------------------------
global M;
global m;

    %Prepara las matrices M y m M(3xN) m(3xNx5)
    ptos = size(XYZuv(:,1),1);
    imgs = size(XYZuv,3);
    M = [XYZuv(:,1:2)'; ones(1,ptos)];
    m = zeros(3,ptos,imgs);
    for i=1:imgs
        m(:,:,i) = [XYZuv(:,4:5,i)'; ones(1,ptos)];
    end
    
    %-----------------------------------------------
    %Primer cálculo aproximado de las homgrafías (H)
    %-----------------------------------------------
    H = zeros(3,3,imgs);
    for i = 1:imgs
        H(:,:,i) = homografia(M,m(:,:,i))';
    end
    
    %----------------------------------------
    %Cálculo de los parámetros de calibración
    %----------------------------------------
    %Cálculo de la matriz V (V·b=0 -> b -> cónica absoluta B)
    V = zeros(2*imgs,6);
    for i=1:imgs
        v11_i = v_ecu(H(:,:,i),1,1);
        v12_i = v_ecu(H(:,:,i),1,2);
        v22_i = v_ecu(H(:,:,i),2,2);
        V((((i-1)*2)+1),:) = v12_i';
        V((((i-1)*2)+2),:) = v11_i'-v22_i';
    end
    %Cálculo de b
    [Ub,Db,Vb] = svd(V'*V);
    b = Vb(:,6);
    %Cálculo de la matriz cónica absoluta B (simétrica)
    B11 = b(1);
    B12 = b(2);
    B22 = b(3);
    B13 = b(4);
    B23 = b(5);
    B33 = b(6);
    %Cálculo de los parámetros intrínsecos
    v0 = (B12*B13-B11*B23)/(B11*B22-B12^2);
    cte = B33-(B13^2+v0*(B12*B13-B11*B23))/B11;
    a = sqrt(cte/B11);
    b = sqrt(cte*B11/(B11*B22-B12^2));
    c = -B12*a*a*b/cte;
    u0 = c*v0/a-B13*a*a/cte;
    %Cálculo aprox. de la matriz de parámetros intrínsecos (A)
    A = [a c u0; ...
         0 b v0; ...
         0 0 1];
    %Cálculo de los parámetros extrínsecos (R y T) para cada cámara (o posición)
    param_ext = zeros(1,6,imgs);
    RT = zeros(3,3,imgs);
    for i=1:imgs
        h1_i = H(1,:,i)';        
        h2_i = H(2,:,i)';     
        h3_i = H(3,:,i)';
        lambda = ((1/norm(inv(A)*h1_i))+(1/norm(inv(A)*h2_i)))/2;
        r1_i = lambda*inv(A)*h1_i;
        r2_i = lambda*inv(A)*h2_i;
        r3_i = cross(r1_i,r2_i);
        R_i = [r1_i r2_i r3_i];
        %Garantiza la ortonormalidad de R
        [U,D,V] = svd(R_i);
        R_i = U*V';
        %Calculo de las matrices R y T
        T_i = lambda*inv(A)*h3_i;
        %Cálculo de los ángulos asociados a la matriz R (OJO NO SON PRY)
        A1 = -asin(R_i(1,3)); 
        A2 = asin(R_i(1,2)/cos(A1));
        A3 = asin(R_i(2,3)/cos(A1));
        %Vector con los parámetros extrínsecos
        param_ext(:,:,i) = [A1 A2 A3 T_i'];
        RT(:,:,i) = [r1_i r2_i T_i];
    end
    
    %------------------------
    %Cálculo de la distorsión
    %------------------------
    %Cálculo de los factores de distorsión
    D = []; 
    d = []; 
    for i=1:imgs
        XYs = RT(:,:,i)*M;
        UVs = A*XYs;
        XY1_i=[XYs(1,:)./XYs(3,:); XYs(2,:)./XYs(3,:); XYs(3,:)./XYs(3,:)]; 
        UV1_i=[UVs(1,:)./UVs(3,:); UVs(2,:)./UVs(3,:); UVs(3,:)./UVs(3,:)]; 
        for j=1:ptos 
            D = [D; ((UV1_i(1,j)-u0)*((XY1_i(1,j))^2+(XY1_i(2,j))^2)) ((UV1_i(1,j)-u0)*((XY1_i(1,j))^2+(XY1_i(2,j))^2)^2);...
                    ((UV1_i(2,j)-v0)*((XY1_i(1,j))^2+(XY1_i(2,j))^2)) ((UV1_i(2,j)-v0)*((XY1_i(1,j))^2+(XY1_i(2,j))^2)^2)];
            d = [d; (m(1,j,i)-UV1_i(1,j));...
                    (m(2,j,i)-UV1_i(2,j))]; 
        end 
    end 
    k = inv(D'*D)*D'*d;
    
    %------------------------------------
    %Optimización de todos los parámetros
    %------------------------------------
    %Crea un vector con todos los parámetros a optimizar
    param_optim = [];
    for i=1:imgs
        param_optim = [param_optim param_ext(:,:,i)];
    end
    param_optim = [param_optim k(1) k(2) A(1,1) A(1,2) A(1,3) A(2,2) A(2,3)];
    %Optimización de todos los parámetros
    options = optimset('LargeScale','off','LevenbergMarquardt','on');
    param_def  = lsqnonlin(@optimizaParam_zhang_dist,param_optim,[],[],options,M,m);
%----------------------------------- FIN ----------------------------------
    

% -------------------------------------------------------------------------    
function F = optimizaParam_zhang_dist(param_optim,M,m)
%--------------------------------- INICIO ---------------------------------
    %-------------------------------------------
    %Función para optimizar todos los parámetros
    %-------------------------------------------
    %Reconstruye las matrices a optimizar
    imgs = size(m,3); 
    ptos = size(M,2);
    RT = [];
    for i=1:imgs 
        param_i = param_optim(((i-1)*6+1):((i-1)*6+6)); 
        A1_i = param_i(1); 
        A2_i = param_i(2); 
        A3_i = param_i(3); 
        T_i = param_i(4:6)'; 
        R_i = [(cos(A2_i)*cos(A1_i))                                 (sin(A2_i)*cos(A1_i))                                 (-sin(A1_i));...
               (-sin(A2_i)*cos(A3_i)+cos(A2_i)*sin(A1_i)*sin(A3_i))  (cos(A2_i)*cos(A3_i)+sin(A2_i)*sin(A1_i)*sin(A3_i))   (cos(A1_i)*sin(A3_i));...
               (sin(A2_i)*sin(A3_i)+cos(A2_i)*sin(A1_i)*cos(A3_i))   (-cos(A2_i)*sin(A3_i)+sin(A2_i)*sin(A1_i)*cos(A3_i))  (cos(A1_i)*cos(A3_i))]; 
        RT = [RT; R_i(:,1:2) T_i];
    end 
    k1 = param_optim((imgs*6)+1); 
    k2 = param_optim((imgs*6)+2); 
    a = param_optim((imgs*6)+3);
    b = param_optim((imgs*6)+6);
    c = param_optim((imgs*6)+4);
    u0 = param_optim((imgs*6)+5); 
    v0 = param_optim((imgs*6)+7); 
    A = [a c u0;...
         0 b v0;...
         0 0 1];
    %Recosntruye los puntos (U,V) para minimizar el error teniendo en cuenta la distorsión
    D = zeros(imgs*2,ptos); 
    d = zeros(imgs*2,ptos); 
    for i=1:imgs
        RT_i = RT(((i-1)*3+1):((i-1)*3+3),:); 
        XYs = RT_i*M; 
        UVs = A*XYs; 
        XY1_i=[XYs(1,:)./XYs(3,:); XYs(2,:)./XYs(3,:); XYs(3,:)./XYs(3,:)]; 
        r_i = ((XY1_i(1,:)).^2+(XY1_i(2,:)).^2);
        UV1_i=[UVs(1,:)./UVs(3,:); UVs(2,:)./UVs(3,:); UVs(3,:)./UVs(3,:)]; 
        D(((i-1)*2)+1,:) = (UV1_i(1,:)+(UV1_i(1,:)-u0).*r_i*k1+(UV1_i(1,:)-u0).*r_i.^2*k2);
        D(((i-1)*2)+2,:) = (UV1_i(2,:)+(UV1_i(2,:)-v0).*r_i*k1+(UV1_i(2,:)-v0).*r_i.^2*k2); 
        d(((i-1)*2)+1,:) = m(1,:,i);
        d(((i-1)*2)+2,:) = m(2,:,i); 
    end 
    error = d - D;
    F = error;
%----------------------------------- FIN ----------------------------------
    

% -------------------------------------------------------------------------    
function F = optimizaParam_zhang(param_optim,M,m)
%--------------------------------- INICIO ---------------------------------
    %-------------------------------------------
    %Función para optimizar todos los parámetros
    %-------------------------------------------
    %Reconstruye las matrices a optimizar
    imgs = size(m,3); 
    ptos = size(M,2);
    RT = [];
    for i=1:imgs 
        param_i = param_optim(((i-1)*6+1):((i-1)*6+6)); 
        A1_i = param_i(1); 
        A2_i = param_i(2); 
        A3_i = param_i(3); 
        T_i = param_i(4:6)'; 
        R_i = [(cos(A2_i)*cos(A1_i))                                 (sin(A2_i)*cos(A1_i))                                 (-sin(A1_i));...
               (-sin(A2_i)*cos(A3_i)+cos(A2_i)*sin(A1_i)*sin(A3_i))  (cos(A2_i)*cos(A3_i)+sin(A2_i)*sin(A1_i)*sin(A3_i))   (cos(A1_i)*sin(A3_i));...
               (sin(A2_i)*sin(A3_i)+cos(A2_i)*sin(A1_i)*cos(A3_i))   (-cos(A2_i)*sin(A3_i)+sin(A2_i)*sin(A1_i)*cos(A3_i))  (cos(A1_i)*cos(A3_i))]; 
        RT = [RT; R_i(:,1:2) T_i];
    end 
    a = param_optim((imgs*6)+1);
    b = param_optim((imgs*6)+4);
    c = param_optim((imgs*6)+2);
    u0 = param_optim((imgs*6)+3); 
    v0 = param_optim((imgs*6)+5); 
    A = [a c u0;...
         0 b v0;...
         0 0 1];
    %Recosntruye los puntos (U,V) para minimizar el error
    D = zeros(imgs*2,ptos); 
    d = zeros(imgs*2,ptos); 
    for i=1:imgs 
        RT_i = RT(((i-1)*3+1):((i-1)*3+3),:); 
        XYs = RT_i*M; 
        UVs = A*XYs; 
        UV1_i=[UVs(1,:)./UVs(3,:); UVs(2,:)./UVs(3,:); UVs(3,:)./UVs(3,:)]; 
        D(((i-1)*2)+1,:) = UV1_i(1,:);
        D(((i-1)*2)+2,:) = UV1_i(2,:); 
        d(((i-1)*2)+1,:) = m(1,:,i);
        d(((i-1)*2)+2,:) = m(2,:,i); 
    end 
    error = d - D;
    F = error;
%----------------------------------- FIN ----------------------------------
    

% -------------------------------------------------------------------------
function H = homografia(M,m)
%--------------------------------- INICIO ---------------------------------
    %-----------------------------------------------------------
    %Función para calcular las homografías dadas las coordenadas
    %mundo (M) y las coordenadas imagen (m) (ZHANG)
    %-----------------------------------------------------------
    %Normalización de los puntos
    [Mn, NM] = normaliza(M);
    [mn, Nm] = normaliza(m);
    ptos = size(Mn,2);
    ceros = zeros(ptos,3);
    %Cálculo de la Homografía
    L = [ceros -Mn' mn(2,:)'.*Mn(1,:)' mn(2,:)'.*Mn(2,:)' mn(2,:)';...
         Mn' ceros -mn(1,:)'.*Mn(1,:)' -mn(1,:)'.*Mn(2,:)' -mn(1,:)';...
         -mn(2,:)'.*Mn(1,:)' -mn(2,:)'.*Mn(2,:)' -mn(2,:)' mn(1,:)'.*Mn(1,:)' mn(1,:)'.*Mn(2,:)' mn(1,:)' ceros];
    [U,D,V] = svd(L);
    Hn = reshape(V(:,9),3,3)';
    %"Denormalización" de la Homografía
    H = (Nm\Hn*NM);
    Hscala = H/H(3,3);
    %Optimización de la Homografía
    options = optimset('LargeScale','off','LevenbergMarquardt','on'); 
    Hoptim  = lsqnonlin(@optimizaH,reshape(Hscala,1,9),[],[],options,M,m); 
    H = reshape(Hoptim,3,3); 
    H = H/H(3,3);
%----------------------------------- FIN ----------------------------------
       

% -------------------------------------------------------------------------    
function F = optimizaH(H,M,m) 
%--------------------------------- INICIO ---------------------------------
    %-------------------------------------------------
    %Función para optimizar las homgrafías (H) (ZHANG)
    %-------------------------------------------------
    %Reconstruye H
    H = reshape(H,3,3);
    %Cálculo de las coord. imagen usando la homografía (H)      
    mcalc = H*M; 
    mcalc = [mcalc(1,:)./mcalc(3,:) ; mcalc(2,:)./mcalc(3,:); mcalc(3,:)./mcalc(3,:)]; 
    %Error a minimizar
    error = m - mcalc; 
    F = [error(1,:), error(2,:)];  
%----------------------------------- FIN ----------------------------------
     

% -------------------------------------------------------------------------    
function [Xn, NX] = normaliza(X)
%--------------------------------- INICIO ---------------------------------
    %-----------------------------------------------
    %Función para normalizar las coordenadas (ZHANG)
    %HACE QUE AFECTE MENOS EL RUIDO DE LA IMAGEN
    %-----------------------------------------------
    %Toma como origen de las coordenadas el centroide de los puntos
    centroide = mean(X(1:2,:)')';
    Xh = [X(1,:) - centroide(1); X(2,:) - centroide(2); X(3,:)];
    distancia = mean(sqrt(Xh(1,:).^2 + Xh(2,:).^2));
    escala = sqrt(2)/distancia;
    NX = [escala 0      -escala*centroide(1);...
          0      escala -escala*centroide(2);...
          0      0      1];
    Xn = NX*X;
%----------------------------------- FIN ----------------------------------
    

% -------------------------------------------------------------------------    
function [v] = v_ecu(H,i,j)
%--------------------------------- INICIO ---------------------------------
    %-----------------------------------------------------------------
    %Función para calcular el vector V necesario para hallar la matriz
    %cónica absoluta (B) (ZHANG)
    %-----------------------------------------------------------------
    v = [H(i,1)*H(j,1); ...
         H(i,1)*H(j,2)+H(i,2)*H(j,1); ...
         H(i,2)*H(j,2); ...
         H(i,3)*H(j,1)+H(i,1)*H(j,3); ...
         H(i,3)*H(j,2)+H(i,2)*H(j,3); ...
         H(i,3)*H(j,3)];
%----------------------------------- FIN ----------------------------------

    
% -------------------------------------------------------------------------
function muestra_resultados_zhang(str,tipo_calib,uv_mean,xyz_mean)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% MUESTRA EN UN CUADRO DE DIALOGO LOS RESULTADOS DE LA CALIBRACION (ZHANG)
%-------------------------------------------------------------------------
global resultado_handler;
global param_finales;

    dim_uv_mean = size(uv_mean,1);
    dim_xyz_mean = size(xyz_mean,1);
        
    [existe] = figflag('Results');
    if existe
        return;
    else
        main_sz = get(gcf,'Position');
        figure('Position',[(main_sz(1)+(main_sz(3)-540)/2)...
                           (main_sz(2)+(main_sz(4)-550)/2)...
                           540 550],...
               'Resize','off',...
               'NumberTitle','off',...
               'Name','Results',...
               'Color', [0.925 0.914 0.847],...
               'MenuBar','none',...
               'ToolBar','none',...
               'Tag','dlg_resultados');
        resultado_handler = figure(gcf);
        dlg_sz = get(gcf,'Position');
        txt_res = uicontrol('Style', 'listbox',...
                            'SelectionHighlight', 'off',...
                            'BackgroundColor', [1 1 1],...
                            'Position', [10 50 dlg_sz(3)-20 dlg_sz(4)-60],...
                            'String',str,...
                            'HorizontalAlignment','left');
        OK_res_callback = 'global resultado_handler;close(resultado_handler);';               
        OK_res = uicontrol('Style', 'pushbutton',...
                           'String','OK',...
                           'Position', [15 10 120 30],...
                           'Callback', OK_res_callback);
        POS_res = uicontrol('Style', 'pushbutton',...
                             'String','Position',...
                             'Position', [145 10 120 30],...
                             'Callback', {@POS_res_zhang_callback,param_finales});
        GRAF_res = uicontrol('Style', 'pushbutton',...
                             'String','Graphical Results',...
                             'Position', [275 10 120 30],...
                             'Callback', {@GRAF_res_zhang_callback,uv_mean,xyz_mean});   
        SAVE_res = uicontrol('Style', 'pushbutton',...
                             'String','Save Results',...
                             'Position', [405 10 120 30],...
                             'Callback', {@SAVE_res_callback,str,tipo_calib});
    end
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function POS_res_zhang_callback(hObject,eventdata,param)
%--------------------------------- INICIO ---------------------------------
%-----------------------------------------------------------------------------------
% FUNCION QUE MUESTRA LAS POSICIONES DE LA CÁMARA CON RESPECTO AL CALIBRADOR (ZHANG)
%-----------------------------------------------------------------------------------
global param_finales;
global camera_handler;
global M;
    
    ptos = size(M,2);
    MatrizPtos = [(M(1:2,:))' zeros(ptos,1)];
    param_finales = param;
    n_param = size(param_finales,2);
    switch n_param
        case 23
            n_archivos = 3;
            distorsion = 0;
        case 29
            n_archivos = 4;
            distorsion = 0;
        case 35
            n_archivos = 5;
            distorsion = 0;
        case 25
            n_archivos = 3;
            distorsion = 1;
        case 31
            n_archivos = 4;
            distorsion = 1;
        case 37
            n_archivos = 5;
            distorsion = 1;
    end
    
    R = zeros(3,3,n_archivos);
    T = zeros(3,1,n_archivos);
    Rgrad = zeros(1,3,n_archivos);
    Rrad = zeros(1,3,n_archivos);
    cent_opt = zeros(3,1,n_archivos);
    dist = zeros(1,n_archivos);
    axis_l = zeros(1,n_archivos);
    for i=1:n_archivos 
        param_i = param_finales(((i-1)*6+1):((i-1)*6+6)); 
        A1_i = param_i(1); 
        A2_i = param_i(2); 
        A3_i = param_i(3); 
        T_i = param_i(4:6)'; 
        R_i = [(cos(A2_i)*cos(A1_i))                                 (sin(A2_i)*cos(A1_i))                                 (-sin(A1_i));...
               (-sin(A2_i)*cos(A3_i)+cos(A2_i)*sin(A1_i)*sin(A3_i))  (cos(A2_i)*cos(A3_i)+sin(A2_i)*sin(A1_i)*sin(A3_i))   (cos(A1_i)*sin(A3_i));...
               (sin(A2_i)*sin(A3_i)+cos(A2_i)*sin(A1_i)*cos(A3_i))   (-cos(A2_i)*sin(A3_i)+sin(A2_i)*sin(A1_i)*cos(A3_i))  (cos(A1_i)*cos(A3_i))]; 
        %Matriz de rotación
        R(:,:,i) = R_i; 
        %Vector de traslación
        T(:,:,i) = T_i; 
        
        
        
        %Ángulos de rotación en grados
        [Rx_i,Ry_i,Rz_i,Rx_rad_i,Ry_rad_i,Rz_rad_i] = R_mat2grad(R_i(1,1),R_i(1,2),R_i(1,3),R_i(2,1),R_i(2,2),R_i(2,3),R_i(3,1));
        Rgrad(:,:,i) = [Rx_i Ry_i Rz_i];
        Rrad(:,:,i) = [Rx_rad_i Ry_rad_i Rz_rad_i];
        
        
        
        cent_opt(:,i) = inv(R_i)*(-T_i); %Posición del centro óptico de la cámara
        dist(:,i) = sqrt((abs(T_i(1))-cent_opt(1,1,i))^2+...
                    (abs(T_i(2))-cent_opt(2,1,i))^2+...
                    (cent_opt(3,1,i))^2); %Longitud de la línea de visión
        axis_l(:,i) = (abs(T_i(3))/10); %Ajusta la longitud de los ejes a la escala de la figura
        
    end 
    
    if distorsion == 0
        a = param_finales((n_archivos*6)+1);
        b = param_finales((n_archivos*6)+4);
        c = param_finales((n_archivos*6)+2);
        u0 = param_finales((n_archivos*6)+3); 
        v0 = param_finales((n_archivos*6)+5); 
    else
        a = param_finales((n_archivos*6)+3);
        b = param_finales((n_archivos*6)+4);
        c = param_finales((n_archivos*6)+5);
        u0 = param_finales((n_archivos*6)+6); 
        v0 = param_finales((n_archivos*6)+7); 
    end
    
    axis_w = 2; %Grosor de los ejes
    lab_dist = 10; %Separación entre el eje y su etiqueta
    
    [existe] = figflag('Camera');
    if existe
        return;
    else
        %Crea la ventana que contendrá a la figura
        main_sz = get(gcf,'Position');
        figure('Position',[(main_sz(1)+(main_sz(3)-650)/2)...
                           (main_sz(2)+(main_sz(4)-650)/2)...
                           650 650],...
               'Name','Camera',...
               'NumberTitle','off',...
               'Color', [0.925 0.914 0.847],...
               'MenuBar','none',...
               'ToolBar','none',...
               'Tag','fig_position');
        camera_handler = figure(gcf);
        fig_sz = get(gcf,'Position');
        %Crea la figura con las propiedades de los ejes
        axes
        set(gca,'DataAspectRatio',[1 1 1],...
                'YDir','reverse',...
                'ZDir','reverse',...
                'XColor',[0.5 0.5 0.5],...
                'YColor',[0.5 0.5 0.5],...
                'ZColor',[0.5 0.5 0.5],...
                'GridLineStyle',':',...
                'FontSize',8);
        %Permite el giro de la figura
        rotate3d(gca);
        hold on;
        grid on;     
        
        %Dibuja los puntos de calibración
        plot3(MatrizPtos(:,1),MatrizPtos(:,2),MatrizPtos(:,3),'black.','MarkerSize',6);
                
        for i=1:n_archivos
            label_x = ['X' num2str(i)];
            label_y = ['Y' num2str(i)];
            label_z = ['Z' num2str(i)];
            %Dibuja una + en la posición de la cámara
            plot3(cent_opt(1,1,i),cent_opt(2,1,i),cent_opt(3,1,i),'black+','MarkerSize',6);
            %Dibuja la línea de visión de la cámara
            line([cent_opt(1,1,i); cent_opt(1,1,i)+dist(i)*R(3,1,i)],[cent_opt(2,1,i);cent_opt(2,1,i)+dist(i)*R(3,2,i)],[cent_opt(3,1,i);cent_opt(3,1,i)+dist(i)*R(3,3,i)],'LineStyle',':','Color',[0.5 0 0]);
            %Dibuja los ejes del sistema cámara
            line([cent_opt(1,1,i) cent_opt(1,1,i)+axis_l(i)*R(3,1,i)],[cent_opt(2,1,i) cent_opt(2,1,i)+axis_l(i)*R(3,2,i)],[cent_opt(3,1,i) cent_opt(3,1,i)+axis_l(i)*R(3,3,i)],'Color',[0.8 0 0],'LineWidth',axis_w);
            text(cent_opt(1,1,i)+(axis_l(i)+lab_dist)*R(3,1,i),cent_opt(2,1,i)+(axis_l(i)+lab_dist)*R(3,2,i),cent_opt(3,1,i)+(axis_l(i)+lab_dist)*R(3,3,i),label_z,'Color',[0.8 0 0]);
            line([cent_opt(1,1,i) cent_opt(1,1,i)+axis_l(i)*R(2,1,i)],[cent_opt(2,1,i) cent_opt(2,1,i)+axis_l(i)*R(2,2,i)],[cent_opt(3,1,i) cent_opt(3,1,i)+axis_l(i)*R(2,3,i)],'Color',[0 0.6 0],'LineWidth',axis_w);
            text(cent_opt(1,1,i)+(axis_l(i)+lab_dist)*R(2,1,i),cent_opt(2,1,i)+(axis_l(i)+lab_dist)*R(2,2,i),cent_opt(3,1,i)+(axis_l(i)+lab_dist)*R(2,3,i),label_y,'Color',[0 0.6 0]);
            line([cent_opt(1,1,i) cent_opt(1,1,i)+axis_l(i)*R(1,1,i)],[cent_opt(2,1,i) cent_opt(2,1,i)+axis_l(i)*R(1,2,i)],[cent_opt(3,1,i) cent_opt(3,1,i)+axis_l(i)*R(1,3,i)],'Color',[0 0 0.7],'LineWidth',axis_w);
            text(cent_opt(1,1,i)+(axis_l(i)+lab_dist)*R(1,1,i),cent_opt(2,1,i)+(axis_l(i)+lab_dist)*R(1,2,i),cent_opt(3,1,i)+(axis_l(i)+lab_dist)*R(1,3,i),label_x,'Color',[0 0 0.7]);
            %Dibuja los ejes del sistema mundo
        end
        line([0 0],[0 0],[0 axis_l(1)],'Color',[0.8 0 0],'LineWidth',axis_w);
        text(-2*lab_dist,-lab_dist,axis_l(1),'Zw','Color',[0.8 0 0]);
        line([0 0],[0 axis_l(1)],[0 0],'Color',[0 0.6 0],'LineWidth',axis_w);
        text(-2*lab_dist,axis_l(1),0,'Yw','Color',[0 0.6 0]);
        line([0 axis_l(1)],[0 0],[0 0],'Color',[0 0 0.7],'LineWidth',axis_w);
        text(axis_l(1),-lab_dist,0,'Xw','Color',[0 0 0.7]);
        hold off;
        %Botón para cerrar la ventana
        OK_fig_callback = 'global camera_handler;close(camera_handler);';               
        OK_fig = uicontrol('Style', 'pushbutton',...
                           'String','OK',...
                           'Position', [((fig_sz(3)-120)/2) 10 120 30],...
                           'Callback', OK_fig_callback);
    end
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function GRAF_res_zhang_callback(hObject,eventdata,uv_mean,xyz_mean)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% FUNCION QUE MUESTRA GRAFICAS CON LOS RESULTADOS (ZHANG)
%--------------------------------------------------------------------------
global grafica_handler;
global n_img;
global nombres_zhang;
    
    n_img = 1;
    imgs = size(uv_mean,2)/2;
    
    file_1 = nombres_zhang{1};
    file_2 = nombres_zhang{2};
    file_3 = nombres_zhang{3};
    switch imgs
        case 4
            file_4 = nombres_zhang{4};
        case 5
            file_4 = nombres_zhang{4};
            file_5 = nombres_zhang{5};
    end

    error_xyz = sqrt(xyz_mean(:,1).^2+xyz_mean(:,2).^2+xyz_mean(:,3).^2);
    error_uv = sqrt(uv_mean(:,1).^2+uv_mean(:,2).^2);
    media_xyz = mean(error_xyz);
    media_uv = mean(error_uv);
    nPtos = size(error_xyz,1);
    
    [existe] = figflag('Graphical Results');
    if existe
        return;
    else
        main_sz = get(gcf,'Position');
        figure('Position',[(main_sz(1)+(main_sz(3)-950)/2)...
                           (main_sz(2)+(main_sz(4)-700)/2)...
                           950 700],...
               'Resize','off',...
               'NumberTitle','off',...
               'Name','Graphical Results',...
               'Color', [0.925 0.914 0.847],...
               'MenuBar','none',...
               'ToolBar','none',...
               'Tag','dlg_graficas');
        grafica_handler = figure(gcf);
        dlg_sz = get(gcf,'Position');
        OK_res_callback = 'global grafica_handler;close(grafica_handler);';               
        OK_res = uicontrol('Style', 'pushbutton',...
                           'String','OK',...
                           'Position', [10 5 120 25],...
                           'Callback', OK_res_callback);    
        SAVE_err = uicontrol('Style', 'pushbutton',...
                             'String','Save Reconstruction Errors',...
                             'Position', [140 5 160 25],...
                             'Callback', {@SAVE_err_zhang_callback,xyz_mean,uv_mean}); 
        img_1 = uicontrol('Style', 'pushbutton',...
                          'String', file_1,...
                          'Position', [325 5 115 25],...
                          'Callback', {@ZHANG_graf_callback,xyz_mean(:,1:3),uv_mean(:,1:2),1}); 
        img_2 = uicontrol('Style', 'pushbutton',...
                          'String', file_2,...
                          'Position', [445 5 115 25],...
                          'Callback', {@ZHANG_graf_callback,xyz_mean(:,4:6),uv_mean(:,3:4),2}); 
        img_3 = uicontrol('Style', 'pushbutton',...
                          'String', file_3,...
                          'Position', [565 5 115 25],...
                          'Callback', {@ZHANG_graf_callback,xyz_mean(:,7:9),uv_mean(:,5:6),3}); 
        if imgs>3
            img_4 = uicontrol('Style', 'pushbutton',...
                              'String', file_4,...
                              'Position', [685 5 115 25],...
                              'Callback', {@ZHANG_graf_callback,xyz_mean(:,10:12),uv_mean(:,7:8),4});
            if imgs>4
                img_5 = uicontrol('Style', 'pushbutton',...
                                  'String', file_5,...
                                  'Position', [805 5 115 25],...
                                  'Callback', {@ZHANG_graf_callback,xyz_mean(:,13:15),uv_mean(:,9:10),5}); 
            end
        end
        hold on;
        subplot(2,2,1);
        plot(error_uv,'LineStyle','none','Marker','.','MarkerEdgeColor',[0.4 0.4 1]);
        line([0 nPtos],[media_uv media_uv],'Color','k','LineStyle',':');
        set(gca,'Position',[0.075 0.575 0.4 0.38],'FontSize',8);
        xlabel('Point','FontSize',10);
        ylabel('|Error| (pixel)','FontSize',10);
        title('(u,v) coordinate error','FontSize',12,'FontWeight','bold');
        subplot(2,2,2);
        plot(error_xyz,'LineStyle','none','Marker','.','MarkerEdgeColor',[1 0.4 0.4]);
        line([0 nPtos],[media_xyz media_xyz],'Color','k','LineStyle',':');
        set(gca,'Position',[0.55 0.575 0.4 0.38],'FontSize',8);
        xlabel('Point','FontSize',10);
        ylabel('|Error| (mm)','FontSize',10);
        title('(X,Y,Z) coordinate error','FontSize',12,'FontWeight','bold');
        subplot(2,2,3); 
        histfit(error_uv,16);
        set(gca,'Position',[0.075 0.1 0.4 0.38],'FontSize',8);
        h = get(gca,'Children');
        set(h(1),'Color','k','LineStyle',':');
        set(h(2),'FaceColor',[0.8 0.8 1])
        xlabel('|Error| (pixel)','FontSize',10);
        ylabel('nº points','FontSize',10);
        title('(u,v) coordinate error','FontSize',12,'FontWeight','bold');
        subplot(2,2,4);
        histfit(error_xyz,16);
        set(gca,'Position',[0.55 0.1 0.4 0.38],'FontSize',8);
        h = get(gca,'Children');
        set(h(1),'Color','k','LineStyle',':');
        set(h(2),'FaceColor',[1 0.8 0.8])
        xlabel('|Error| (mm)','FontSize',10);
        ylabel('nº points','FontSize',10);
        title('(X,Y,Z) coordinate error','FontSize',12,'FontWeight','bold');
        hold off;
    end
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function ZHANG_graf_callback(hObject,eventdata,xyz_mean,uv_mean,img)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% FUNCION QUE GUARDA LOS RESULTADOS DE LA CALIBRACION EN UN TXT (ZHANG)
%--------------------------------------------------------------------------
global n_img;

    n_img = img;
    error_xyz = sqrt(xyz_mean(:,1).^2+xyz_mean(:,2).^2+xyz_mean(:,3).^2);
    error_uv = sqrt(uv_mean(:,1).^2+uv_mean(:,2).^2);
    media_xyz = mean(error_xyz);
    media_uv = mean(error_uv);
    nPtos = size(error_xyz,1);
    
    hold on;
    subplot(2,2,1);
    plot(error_uv,'LineStyle','none','Marker','.','MarkerEdgeColor',[0.4 0.4 1]);
    line([0 nPtos],[media_uv media_uv],'Color','k','LineStyle',':');
    set(gca,'Position',[0.075 0.575 0.4 0.38],'FontSize',8);
    xlabel('Point','FontSize',10);
    ylabel('|Error| (pixel)','FontSize',10);
    title('(u,v) coordinate error','FontSize',12,'FontWeight','bold');
    subplot(2,2,2);
    plot(error_xyz,'LineStyle','none','Marker','.','MarkerEdgeColor',[1 0.4 0.4]);
    line([0 nPtos],[media_xyz media_xyz],'Color','k','LineStyle',':');
    set(gca,'Position',[0.55 0.575 0.4 0.38],'FontSize',8);
    xlabel('Point','FontSize',10);
    ylabel('|Error| (mm)','FontSize',10);
    title('(X,Y,Z) coordinate error','FontSize',12,'FontWeight','bold');
    subplot(2,2,3); 
    histfit(error_uv,16);
    set(gca,'Position',[0.075 0.1 0.4 0.38],'FontSize',8);
    h = get(gca,'Children');
    set(h(1),'Color','k','LineStyle',':');
    set(h(2),'FaceColor',[0.8 0.8 1])
    xlabel('|Error| (pixel)','FontSize',10);
    ylabel('nº points','FontSize',10);
    title('(u,v) coordinate error','FontSize',12,'FontWeight','bold');
    subplot(2,2,4);
    histfit(error_xyz,16);
    set(gca,'Position',[0.55 0.1 0.4 0.38],'FontSize',8);
    h = get(gca,'Children');
    set(h(1),'Color','k','LineStyle',':');
    set(h(2),'FaceColor',[1 0.8 0.8])
    xlabel('|Error| (mm)','FontSize',10);
    ylabel('nº points','FontSize',10);
    title('(X,Y,Z) coordinate error','FontSize',12,'FontWeight','bold');
    hold off;
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function SAVE_err_zhang_callback(hObject,eventdata,xyz_mean,uv_mean)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% FUNCION QUE GUARDA LOS RESULTADOS DE LA CALIBRACION EN UN TXT (ZHANG)
%--------------------------------------------------------------------------
global grafica_handler;
global n_img;
    
    switch n_img
        case 1
            Recon_err = [xyz_mean(:,1:3) uv_mean(:,1:2)];
        case 2
            Recon_err = [xyz_mean(:,4:6) uv_mean(:,3:4)];
        case 3
            Recon_err = [xyz_mean(:,7:9) uv_mean(:,5:6)];
        case 4
            Recon_err = [xyz_mean(:,10:12) uv_mean(:,7:8)];
        case 5
            Recon_err = [xyz_mean(:,13:15) uv_mean(:,9:10)];
    end
    [filename_err, pathname_err, filterindex_err] = uiputfile( ...
               {  '*.txt','Text file (*.txt)'; ...
                  '*.*',  'All files (*.*)'}, ...
                  'Save reconstruction errors to file');
    if filterindex_err ~= 0
        save([pathname_err filename_err],'Recon_err','-ASCII');
    end
    close(grafica_handler);
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function GRAF_UV_res_callback(hObject,eventdata,uv_mean,xyz_mean)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% FUNCION QUE MUESTRA GRAFICAS CON LA COMPARACIÓN DE UV Y UV RECONS.
%--------------------------------------------------------------------------
global grafica_handler;
global uv_res;
global uv_recons_res;
global Cu_org_res;
global Cv_org_res;
    
    [existe] = figflag('Graphical Results');
    if existe
        return;
    else
        main_sz = get(gcf,'Position');
        figure('Position',[(main_sz(1)+(main_sz(3)-950)/2)...
                           (main_sz(2)+(main_sz(4)-700)/2)...
                           950 700],...
               'Resize','off',...
               'NumberTitle','off',...
               'Name','Graphical Results',...
               'Color', [0.925 0.914 0.847],...
               'MenuBar','none',...
               'ToolBar','none',...
               'Tag','dlg_graficas');
           zoom on;
        grafica_handler = figure(gcf);
        dlg_sz = get(gcf,'Position');
        aspecto = Cu_org_res/Cv_org_res;
        newplot;
        set(gca,'XAxisLocation','Top',...
                'YDir','reverse',...
                'PlotBoxAspectRatio',[aspecto 1 1],...
                'XLim',[0 Cu_org_res],...
                'YLim',[0 Cv_org_res],...
                'Box','on');
        hold on;
        dif_uv = uv_recons_res-uv_res;
        flechas = quiver(uv_res(:,1),uv_res(:,2),dif_uv(:,1).*3,dif_uv(:,2).*3);
        set(flechas,'AutoScale','off');
        set(flechas,'Color',[0 0 1]);
        hold off;
        OK_res_callback = 'global grafica_handler;close(grafica_handler);';               
        OK_res = uicontrol('Style', 'pushbutton',...
                           'String','OK',...
                           'Position', [10 5 120 25],...
                           'Callback', OK_res_callback);                
        GRAF_1_res = uicontrol('Style', 'pushbutton',...
                               'String','Points+Lines',...
                               'Position', [140 5 120 25],...
                               'Callback', {@GRAF_UV_err_callback,uv_res,uv_recons_res,1,Cu_org_res,Cv_org_res,flechas});                
        GRAF_2_res = uicontrol('Style', 'pushbutton',...
                               'String','Points',...
                               'Position', [270 5 120 25],...
                               'Callback', {@GRAF_UV_err_callback,uv_res,uv_recons_res,2,Cu_org_res,Cv_org_res,flechas});                
        GRAF_3_res = uicontrol('Style', 'pushbutton',...
                               'String','Arrows',...
                               'Position', [400 5 120 25],...
                               'Callback', {@GRAF_UV_err_callback,uv_res,uv_recons_res,3,Cu_org_res,Cv_org_res,flechas});    
        SAVE_err = uicontrol('Style', 'pushbutton',...
                             'String','Save UV Recons. Errors',...
                             'Position', [530 5 160 25],...
                             'Callback', {@SAVE_UV_err_callback,uv_res,uv_recons_res}); 
    end
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function GRAF_UV_err_callback(hObject,eventdata,uv_res,uv_recons_res,tipo,Cu_org_res,Cv_org_res,flechas)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% CAMBIA LA GRAFICA UV (ptos,líneas,ptos+líneas)
%--------------------------------------------------------------------------
set(gca,'XAxisLocation','Top',...
        'YDir','reverse',...
        'PlotBoxAspectRatio',[Cu_org_res/Cv_org_res 1 1],...
        'XLim',[0 Cu_org_res],...
        'YLim',[0 Cv_org_res],...
        'Box','on');
switch tipo
    case 1
        hold on;
        cla;
        plot(uv_recons_res(:,1),uv_recons_res(:,2),'black.','MarkerSize',6);
        plot(uv_res(:,1),uv_res(:,2),'red.','MarkerSize',6);
        ptos = size(uv_res,1);
        for i=1:ptos
            line([uv_res(i,1) uv_recons_res(i,1)],[uv_res(i,2) uv_recons_res(i,2)],'Color','b');
        end
        hold off;
    case 2
        hold on;
        cla;
        plot(uv_recons_res(:,1),uv_recons_res(:,2),'black.','MarkerSize',6);
        plot(uv_res(:,1),uv_res(:,2),'red.','MarkerSize',6);
        hold off;
    case 3
        hold on;
        cla;   
        dif_uv = uv_recons_res-uv_res;
        flechas = quiver(uv_res(:,1),uv_res(:,2),dif_uv(:,1).*3,dif_uv(:,2).*3);
        set(flechas,'AutoScale','off');
        set(flechas,'Color',[0 0 1]);
        hold off;
end
%----------------------------------- FIN ----------------------------------


% -------------------------------------------------------------------------
function SAVE_UV_err_callback(hObject,eventdata,uv_res,uv_recons_res)
%--------------------------------- INICIO ---------------------------------
%--------------------------------------------------------------------------
% FUNCION QUE GUARDA EL ERROR DE RECONSTRUCCIÓN DE LOS PTOS UV
%--------------------------------------------------------------------------
global grafica_handler;
global MatrizPtos;
    
    UV_err = [MatrizPtos (uv_recons_res-uv_res)];
    [filename_err, pathname_err, filterindex_err] = uiputfile( ...
               {  '*.txt','Text file (*.txt)'; ...
                  '*.*',  'All files (*.*)'}, ...
                  'Save reconstruction errors to file');
    if filterindex_err ~= 0
        save([pathname_err filename_err],'UV_err','-ASCII');
    end
    close(grafica_handler);
%----------------------------------- FIN ----------------------------------

