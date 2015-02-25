function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 20-Dec-2014 23:18:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;
imgs = dir(strcat('images\test_images\','*.jpg'));
%imgs(1).name
%firstnamee= imgs(1).name;
features = dir(strcat('images\test_images\', '*.txt'));
featuresT = dir(strcat('images\train_images\', '*.txt'));
imgsT = dir(strcat('images\train_images\','*.jpg'));
%featuresN = dir(strcat('images\normalized_images\', '*.txt'));
imgsN = dir(strcat('images\normalized_images\','*.jpg'));
handles.jpg_test_image_array  = imgs;
handles.txt_test_file_array  = features;
handles.jpg_train_image_array = imgsT;
handles.txt_train_file_array = featuresT;
handles.jpg_normalized_file_array = imgsN;


set(handles.imageListbox, 'String', {handles.jpg_test_image_array.name});

axes(handles.selectedTestImage);
imshow(['images\test_images\' handles.jpg_test_image_array(1).name]);
set(handles.selectedImageName, 'String', handles.jpg_test_image_array(1).name(1: end - 6));

axes(handles.relatedImage1);
imshow(['images\test_images\' handles.jpg_test_image_array(1).name]);

axes(handles.relatedImage2);
imshow(['images\test_images\' handles.jpg_test_image_array(1).name]);

axes(handles.relatedImage3);
imshow(['images\test_images\' handles.jpg_test_image_array(1).name]);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in startPushbutton.
function startPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to startPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('still working please wait ; if you press multiple start it will run these multiple times !!');
    set(handles.imageListbox, 'Enable', 'off');

    f_bar = getFbar(handles);

    E1 = 0;
    E2 = 0;
    E3 = 0;

    for i = 1 : length(handles.jpg_test_image_array)

        [related_image_1, related_image_2, related_image_3, related_image_name_1, related_image_name_2, related_image_name_3, error_1, error_2, error_3] = recognize_face(handles, handles.jpg_test_image_array(i).name(1: end - 4), f_bar);

        E1 = E1 + error_1;
        E2 = E2 + error_2;
        E3 = E3 + error_3;
        
    end
    
    accuracy_1 = (1 - (E1 / length(handles.jpg_test_image_array))) * 100;
    accuracy_2 = (1 - (E2 / length(handles.jpg_test_image_array))) * 100;
    accuracy_3 = (1 - (E3 / length(handles.jpg_test_image_array))) * 100;
    
    set(handles.accuracyValue1, 'String', accuracy_1);
    set(handles.accuracyValue2, 'String', accuracy_2);
    set(handles.accuracyValue3, 'String', accuracy_3);
    disp('done you can now change faces');
    set(handles.imageListbox, 'Enable', 'on');


% --- Executes on selection change in imageListbox.
function imageListbox_Callback(hObject, eventdata, handles)
% hObject    handle to imageListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    index = get(hObject, 'Value');

    axes(handles.selectedTestImage);
    imshow(['images\test_images\' handles.jpg_test_image_array(index).name]);
    set(handles.selectedImageName, 'String', handles.jpg_test_image_array(index).name(1: end - 6));
    
    Fbar = getFbar(handles);

    [related_image_1, related_image_2, related_image_3, related_image_name_1, related_image_name_2, related_image_name_3, error_1, error_2, error_3] = recognize_face(handles, handles.jpg_test_image_array(index).name(1: end - 4), Fbar);

    axes(handles.relatedImage1);
    imshow(related_image_1);
    set(handles.relatedImageName1, 'String', related_image_name_1);

    axes(handles.relatedImage2);
    imshow(related_image_2);
    set(handles.relatedImageName2, 'String', related_image_name_2);

    axes(handles.relatedImage3);
    imshow(related_image_3);
    set(handles.relatedImageName3, 'String', related_image_name_3);
    
%   set(handles.accuracyValue1, 'String', error_1);
%   set(handles.accuracyValue2, 'String', error_2);
%   set(handles.accuracyValue3, 'String', error_3);

    
% --- Executes during object creation, after setting all properties.
function imageListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
