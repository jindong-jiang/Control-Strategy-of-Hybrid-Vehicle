function varargout = Simulation_Hybrid(varargin)
% SIMULATION_HYBRID MATLAB code for Simulation_Hybrid.fig
%      SIMULATION_HYBRID, by itself, creates a new SIMULATION_HYBRID or raises the existing
%      singleton*.
%
%      H = SIMULATION_HYBRID returns the handle to a new SIMULATION_HYBRID or the handle to
%      the existing singleton*.
%
%      SIMULATION_HYBRID('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMULATION_HYBRID.M with the given input arguments.
%
%      SIMULATION_HYBRID('Property','Value',...) creates a new SIMULATION_HYBRID or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Simulation_Hybrid_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Simulation_Hybrid_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Simulation_Hybrid

% Last Modified by GUIDE v2.5 23-Aug-2016 22:45:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Simulation_Hybrid_OpeningFcn, ...
                   'gui_OutputFcn',  @Simulation_Hybrid_OutputFcn, ...
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


% --- Executes just before Simulation_Hybrid is made visible.
function Simulation_Hybrid_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Simulation_Hybrid (see VARARGIN)

% Choose default command line output for Simulation_Hybrid
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Simulation_Hybrid wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Simulation_Hybrid_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loaddata.
function loaddata_Callback(hObject, eventdata, handles)
% hObject    handle to loaddata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin('base','InputMain')


% --- Executes on button press in startsimulation.
function startsimulation_Callback(hObject, eventdata, handles)
% hObject    handle to startsimulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin('base','sim(''BD_INSIGHT'')')


% --- Executes on button press in checkresults.
function checkresults_Callback(hObject, eventdata, handles)
% hObject    handle to checkresults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%figure;
evalin('base',' OutputMain')


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
ls=get(hObject,'Value');
 switch ls
     case 1
     evalin('base','Output.CheckFuelConverterOperation;')
     case 2
     evalin('base','Output.CheckFuelConverterEfficiency;')
     case 3
     evalin('base','Output.CheckMotorControllerOperation;')
     case 4
     evalin('base','Output.CheckMotorControllerEfficiency;')
 end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in serialset.
function serialset_Callback(hObject, eventdata, handles)
% hObject    handle to serialset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin('base','Serial.mtlb_ardn_serialSet');


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
evalin('base','sim(''sim_M_test'')')


% --- Executes on selection change in Strategy.
function Strategy_Callback(hObject, eventdata, handles)
% hObject    handle to Strategy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Strategy contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Strategy
ls=get(hObject,'Value');
 switch ls
     case 1
    
    hh = waitbar(0,'Original Insight Strategy is Calculating ...');
    steps = 1000;
   for step = 1:steps
    % computations take place here
    waitbar(step / steps)
    end
   close(hh) 
   
   evalin('base','sim(''BD_INSIGHT_Orgnl'')')
    evalin('base','Output.CheckLoadFirst');
    Fuel_100km=evalin('base','Fuel_100km');
    set(handles.edit1,'string',Fuel_100km);
     case 2
    hh = waitbar(0,'Original Insight Strategy is Calculating ......');
    steps = 1000;
   for step = 1:steps
    % computations take place here
    waitbar(step / steps)
   end
    close(hh) 
    evalin('base','sim(''BD_INSIGHT'')')
    evalin('base','Output.CheckLoadFirst');
    Fuel_100km=evalin('base','Fuel_100km');
    set(handles.edit1,'string',Fuel_100km);
     
 end
 




% --- Executes during object creation, after setting all properties.
function Strategy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Strategy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
