function varargout = untitled(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
%--------------------------------------------------------------------------
clc;
clear;
fprintf('**************************************************************\r')
fprintf('* Title         :  Stepper Motor Driver With Matlab          *\r')
fprintf('**************************************************************\r')
fprintf('\r')
%s=serial('COM14');
%set(s,'baudrate',9600,'Terminator',13,'Timeout',1,'InputBufferSize',16,'OutputBufferSize',8);
%fopen(s);

function varargout = untitled_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


function input1_Callback(hObject, eventdata, handles)
input = str2num(get(hObject,'String'));
if (isempty(input))
    set(hObject,'String','0')
end
guidata(hObject, handles);

function input1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton_Right_Callback(hObject, eventdata, handles)
    stepper_data_str = get(handles.text5,'String');
    stepper_data = str2num(stepper_data_str);
    %stepper_data=128;    
    set(handles.pushbutton_Right,'Enable','off')
    set(handles.pushbutton_Left,'Visible','off')
    set(handles.text4,'Visible','off')
    step = get(handles.input1,'String');
    step = str2num(step);
    speed = get(handles.input2,'String');
    speed = str2num(speed);
    fprintf('Running ... \r')
    s=serial('COM1');
    set(s,'baudrate',9600,'Terminator',13,'Timeout',1,'InputBufferSize',16,'OutputBufferSize',8);
    fopen(s);
        for i=1:step
            stepper_data=stepper_data*2;
            if (stepper_data > 128) stepper_data=16; end
            stepper_data_str=num2str(stepper_data);
            set(handles.text5,'String',stepper_data_str);
            fprintf('stepper_data=	%d\n', stepper_data);
            fprintf(s,stepper_data_str); 
            pause(speed); 
        end
	set(handles.pushbutton_Right,'Enable','on')
	set(handles.pushbutton_Left,'Visible','on')
    set(handles.text4,'Visible','on')
    fclose(s);
    delete(s); 

function input2_Callback(hObject, eventdata, handles)
input = str2num(get(hObject,'String'));
if (isempty(input))
    set(hObject,'String','0')
end
guidata(hObject, handles);


function input2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushbutton_Left_Callback(hObject, eventdata, handles)
    stepper_data_str = get(handles.text5,'String');
    stepper_data = str2num(stepper_data_str);
    %stepper_data=16; 
    set(handles.pushbutton_Left,'Enable','off')
    set(handles.pushbutton_Right,'Visible','off')
    set(handles.text4,'Visible','off')
    step = get(handles.input1,'String');
    step = str2num(step);
    speed = get(handles.input2,'String');
    speed = str2num(speed);
    s=serial('COM1');
    set(s,'baudrate',9600,'Terminator',13,'Timeout',1,'InputBufferSize',16,'OutputBufferSize',8);
    fopen(s);
    fprintf('Running ... \r')
        for i=1:step
            stepper_data=stepper_data/2;
            if (stepper_data < 16) stepper_data=128; end
            stepper_data_str=num2str(stepper_data);
            set(handles.text5,'String',stepper_data_str);
            fprintf('stepper_data=	%d\n', stepper_data);
            fprintf(s,stepper_data_str); 
            pause(speed); 
        end
    set(handles.pushbutton_Left,'Enable','on')
    set(handles.pushbutton_Right,'Visible','on')
    set(handles.text4,'Visible','on')
    fclose(s);
    delete(s);


