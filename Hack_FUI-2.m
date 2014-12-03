function varargout = Hack_FUI(varargin)
% HACK_FUI MATLAB code for Hack_FUI.fig
%      HACK_FUI, by itself, creates a new HACK_FUI or raises the existing
%      singleton*.
%
%      H = HACK_FUI returns the handle to a new HACK_FUI or the handle to
%      the existing singleton*.
%
%      HACK_FUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HACK_FUI.M with the given input arguments.
%
%      HACK_FUI('Property','Value',...) creates a new HACK_FUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Hack_FUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Hack_FUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Hack_FUI

% Last Modified by GUIDE v2.5 02-Dec-2014 16:02:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Hack_FUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Hack_FUI_OutputFcn, ...
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


% --- Executes just before Hack_FUI is made visible.
function Hack_FUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Hack_FUI (see VARARGIN)
    set(handles.Rp,'String','--');
    set(handles.Rs,'String','--');
    set(handles.C,'String','--');
    set(handles.Filepath_Box,'String','--');
% Choose default command line output for Hack_FUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Hack_FUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = Hack_FUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Load_Button.
function Load_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    fileName=uigetfile('*.mpt');
    handles.fileName=fileName;
    set(handles.Filepath_Box,'String',fileName);
    %Later add code to display the fileName
    guidata(hObject,handles);


% --- Executes on button press in Process_Button.
function Process_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Process_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    fileName=handles.fileName;
    %Add code the chops up the data and processes it
    fid=fopen(fileName);
    
    %Read in until the dE/dt value is found, and set nu equal to that value
    flag=1;
    while (flag==1)
        tline=fgetl(fid);
        matches = regexp(tline, '^(?:dE/dt)\s+(.*)', 'tokens');
        if(~isempty(matches))
            nu = str2double(matches{1});
            flag = 0;
        end
    end
    
    %Then read until the E1 value is found, and set Emax equal to that
    %value
    flag=1;
    while (flag==1)
        tline=fgetl(fid);
        matches = regexp(tline, '^(?:E1 \(V\))\s+(.*)', 'tokens');
        if(~isempty(matches))
            Emax = str2double(matches{1});
            flag=0;
        end
    end
    
    %Then read until the E2 value is found, and set Emin equal to that
    %value
    flag=1;
    while (flag==1)
        tline=fgetl(fid);
        matches = regexp(tline, '^(?:E2 \(V\))\s+(.*)', 'tokens');
        if(~isempty(matches))
            Emin = str2double(matches{1});
            flag = 0;
        end
    end
    
    %Then read until the nc cycles value is found, and set cyc equal to
    %that value
    flag=1;
    while (flag==1)
        tline=fgetl(fid);
        matches = regexp(tline, '^(?:nc cycles)\s+(.*)', 'tokens');
        if(~isempty(matches))
            cyc = str2double(matches{1});
            flag = 0;
        end
    end   
    
    %Read forward until at the start of the data
    for i=1:8
        fgetl(fid);
    end
    
    lambda=(Emax-Emin)/nu;
    
    data=textscan(fid,'%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f');
    data=cell2mat(data)
    fclose(fid);
    
    E= data(:,9);
    I = data(:,10);
    cn = data(:,11);
    t = data(:,7);
    MaxCircle=max(cn);
    index = (cn==1)|(cn==MaxCircle);
    E(index)=[];
    I(index)=[];
    t(index)=[];

    for i = 2:MaxCircle-1

        ind = (cn==i);
        Es = E(ind);
        Emax(i) = max(Es);
        Emin(i) = min(Es);
        N(i) = sum(ind);
        ind1(i) = find(Es==Emax(i));
        ind2(i) = find(Es==Emin(i));

    end

    Ef=[];
    If=[];
    tf=[];

    TotNum = length(Es);

    fid = 1:ind1(1);
    bid = ind2(1):TotNum;

    lambda = 2.5;

    for i = 2:MaxCircle-1

        Ef(:,i-1) = E(fid+(i-2)*TotNum);
        If(:,i-1) = I(fid+(i-2)*TotNum);
        tf(:,i-1) = t(fid+(i-2)*TotNum);

        Eb(:,i-1) = E(bid+(i-2)*TotNum);
        Ib(:,i-1) = I(bid+(i-2)*TotNum);
        tb(:,i-1) = t(bid+(i-2)*TotNum);

        tp(:,i-1) = tf(:,i-1) - 2*lambda*i;
        tpp(:,i-1)=tb(:,i-1) - (2*i+1)*lambda;

    end
    RsRpC1 = [5, 3000, .112] %initial guess of parameters
    set(handles.Data_Plot,plotting(tp, tpp,t,RsRpC1, If, Ib, Eb, Ef, E))




