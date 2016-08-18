function varargout = loading_tool(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @loading_tool_OpeningFcn, ...
                   'gui_OutputFcn',  @loading_tool_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before loading_tool is made visible.
function loading_tool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to loading_tool (see VARARGIN)

% Choose default command line output for loading_tool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes loading_tool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = loading_tool_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on button press in getDir.
function getDir_Callback(hObject, eventdata, handles)

initialDir = cd;
directory_name = uigetdir;
    cd(directory_name);
files = dir('*.DPT');
% Data Matrix
for i=1:length(files);
M(:,(2*i-1):2*i)=csvread(files(i).name);
end
wn=M(:,1)';
Data=M(:,2:2:end)';

for i=1:length(files);
[pathstr,name,ext,versn] = fileparts(files(i).name);
Orden(i,1)=str2num(name);
end

MB=[Orden Data];
ImportedMatrix=sortrows(MB,1);
ImportedMatrix(:,1)=[];

checkLabels={'Save the spectral matrix'};
varNames={'Result_SWG'};
items={ImportedMatrix};
export2wsdlg(checkLabels,varNames,items,'Save the spectral matrix: ');

checkLabels={'Save the wavenumbers vector'};
varNames={'Result_Wn'};
items={wn};
export2wsdlg(checkLabels,varNames,items,'Save the wavenumbers vector: ');


cd(initialDir);
