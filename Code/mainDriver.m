function varargout = mainDriver(varargin)
% MAINDRIVER MATLAB code for mainDriver.fig
%      MAINDRIVER, by itself, creates a new MAINDRIVER or raises the existing
%      singleton*.
%
%      H = MAINDRIVER returns the handle to a new MAINDRIVER or the handle to
%      the existing singleton*.
%
%      MAINDRIVER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINDRIVER.M with the given input arguments.
%
%      MAINDRIVER('Property','Value',...) creates a new MAINDRIVER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mainDriver_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mainDriver_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mainDriver

% Last Modified by GUIDE v2.5 02-Apr-2017 21:46:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mainDriver_OpeningFcn, ...
                   'gui_OutputFcn',  @mainDriver_OutputFcn, ...
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


% --- Executes just before mainDriver is made visible.
function mainDriver_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mainDriver (see VARARGIN)

% Choose default command line output for mainDriver
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(findall(handles.codeBookPannel, '-property', 'enable'), 'enable', 'off');
set(findall(handles.enrollPannel, '-property', 'enable'), 'enable', 'off');
%handles.testValue='Hello tat';
handles.codeBookFlag=false;%tells codeBookIs not generated.
handles.authorDBFlag=false;%tells no author is enrolled in the data base
handles.dirtyDBFlag=false;%this flag keeps track whether elm model is trained with the latest updated version of author Data base
handles.elmModelFlag=false;%tells elm is not trained
handles.codeBookUpdated=false;
handles.authorDBUpdated=false;
handles.elmModelUpdated=false;
guidata(handles.mainWindow,handles);%updating the variables
%loding saved files if they are already existing
    if exist(strcat(pwd,'\codeBook.mat'),'file')==2
        codeBook=load(strcat(pwd,'\codeBook.mat'));
        codeBook=struct2cell(codeBook);
        codeBook=codeBook{1,1};
        handles.codeBook=codeBook;%loads the codeBook into the handle structure
        handles.codeBookFlag=true;%setting the codeBookFlag true which tells codeBook is there ready for use
    end
    if exist(strcat(pwd,'\authorDB.mat'),'file')==2
        authorDB=load(strcat(pwd,'\authorDB.mat'));
        authorDB=struct2cell(authorDB);
        authorDB=authorDB{1,1};
        handles.authorDB=authorDB;%loads the author database into tthe handle structure 
        handles.authorDBFlag=true;%setting the authorDBFlag true which tells author Data Base is there ready for use
    else
        handles.authorDB=[];%creating a dummy author data base in case database is not already present
        handles.authorDBFlag=true;%setting the authorDBFlag true which tells author Data Base (though empty) is there ready for use
    end
    if exist(strcat(pwd,'\elmModel.mat'),'file')==2
        elmModelStr=load(strcat(pwd,'\elmModel.mat'));%elmModelStr is the structure containing elmModel structure as a sub structure
        handles.elmModel=elmModelStr.elmModel;%loding the elmModel structure into the handles structure as a substructure
        handles.elmModelFlag=true;%setting the elmModelFlag true which tells elm model is already trained and ready for use
    else
        handles.dirtyDBFlag=true;
    end
guidata(handles.mainWindow,handles);

% UIWAIT makes mainDriver wait for user response (see UIRESUME)
% uiwait(handles.mainWindow);


% --- Outputs from this function are returned to the command line.
function varargout = mainDriver_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




function sampleImgVerify_Callback(hObject, eventdata, handles)
% hObject    handle to sampleImgVerify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sampleImgVerify as text
%        str2double(get(hObject,'String')) returns contents of sampleImgVerify as a double


% --- Executes during object creation, after setting all properties.
function sampleImgVerify_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampleImgVerify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseVerify.
function browseVerify_Callback(hObject, eventdata, handles)
% hObject    handle to browseVerify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,FilePath ]= uigetfile();
ExPath = fullfile(FilePath, FileName);
set(handles.sampleImgVerify,'string',ExPath);


% --- Executes on button press in verifyAuthorButton.
function verifyAuthorButton_Callback(hObject, eventdata, handles)
% hObject    handle to verifyAuthorButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.dirtyDBFlag
    set(handles.text8,'string','Processing input for verification...');
    pause(0.1);
    imgSample=get(handles.sampleImgVerify,'string');
    if handles.codeBookFlag && handles.elmModelFlag
        imgSample=imread(imgSample);
        %set(handles.text8,'string','Processing input for verification...');
        [authId,~]=verifyAuthor(imgSample,handles.codeBook,handles.elmModel);
        set(handles.text8,'string',sprintf('Predicted Author id: %d',authId));
    else
        uiwait(msgbox('Error. Make sure codeBook and trained elm model is present and try again'));
    end
else
    uiwait(msgbox('classifier is not trained with updated data base. Please train the system and try again.'));
%guidata(handles.mainWindow,handles);
end


function imageSampleEnroll_Callback(hObject, eventdata, handles)
% hObject    handle to imageSampleEnroll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imageSampleEnroll as text
%        str2double(get(hObject,'String')) returns contents of imageSampleEnroll as a double


% --- Executes during object creation, after setting all properties.
function imageSampleEnroll_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageSampleEnroll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseImageSampleButton.
function browseImageSampleButton_Callback(hObject, eventdata, handles)
% hObject    handle to browseImageSampleButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,FilePath ]= uigetfile();
ExPath = fullfile(FilePath, FileName);
set(handles.imageSampleEnroll,'string',ExPath);



function authorIdEnroll_Callback(hObject, eventdata, handles)
% hObject    handle to authorIdEnroll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hints: get(hObject,'String') returns contents of authorIdEnroll as text
%        str2double(get(hObject,'String')) returns contents of authorIdEnroll as a double


% --- Executes during object creation, after setting all properties.
function authorIdEnroll_CreateFcn(hObject, eventdata, handles)
% hObject    handle to authorIdEnroll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in enrollAuthor.
function enrollAuthor_Callback(hObject, eventdata, handles)
% hObject    handle to enrollAuthor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.codeBookFlag
    sampleImg=get(handles.imageSampleEnroll,'string');%image file name
    sampleImg=imread(sampleImg);
    authorId=str2num(get(handles.authorIdEnroll,'string'));%corresponding author id
    %------------->future implementation of duplicate author detection to be done here<--------
    if handles.authorDBFlag
        handles.authorDBFlag=false;
        guidata(handles.mainWindow,handles);%to be verified
        %set display with message that enrollment is under process
        set(handles.text8,'string','Author is being Enrolled');
        pause(0.1);%to set the display properly and show the above message
        handles.authorDB=enrollAuthor(sampleImg,authorId,handles.codeBook,handles.authorDB);%enrolling the author in the data base
        handles.authorDBFlag=true;
        %set display with message that enrollment is done
        handles.dirtyDBFlag=true;%authorDB has been updated so it is dirty. it will be cleaned after elm is trained
        handles.authorDBUpdated=true;
        guidata(handles.mainWindow,handles);
        set(handles.text8,'string','Author Enrolled');
    else
        uiwait(msgbox('Author DB is being updated or does not exist. please try again sometime later'));
    end
else
    uiwait(msgbox('Code Book not present. Generate code book first and try again'));
end

% --- Executes on button press in trainElmButton.
function trainElmButton_Callback(hObject, eventdata, handles)
% hObject    handle to trainElmButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
numHneurons=100;%number of hidden neurones for elm
actFunc='sig';%using sigmoid activation function
if handles.dirtyDBFlag %train only if the database is dirty
    if isempty(handles.authorDB);
        uiwait(msgbox('Author database is empty. Please enroll author and try again'));
    else
        handles.elmModelFlag=false;
        guidata(handles.mainWindow,handles);%to be verified
        set(handles.text8,'string','System is being trained. Please Wait...');
        pause(0.1);
        [elmModel,trTime,~]=elm_train_authIdentification(handles.authorDB,numHneurons,actFunc);
        handles.elmModel=elmModel;
        handles.elmModelFlag=true;
        handles.dirtyDBFlag=false;
        handles.elmModelUpdated=true;
        guidata(handles.mainWindow,handles);%to be verified
        set(handles.text8,'string',sprintf('System trained in %f seconds.',trTime));
    end
else
    uiwait(msgbox('system is already trained'));
end



function codeBookSize_Callback(hObject, eventdata, handles)
% hObject    handle to codeBookSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of codeBookSize as text
%        str2double(get(hObject,'String')) returns contents of codeBookSize as a double


% --- Executes during object creation, after setting all properties.
function codeBookSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to codeBookSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function folderPathCodeBook_Callback(hObject, eventdata, handles)
% hObject    handle to folderPathCodeBook (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of folderPathCodeBook as text
%        str2double(get(hObject,'String')) returns contents of folderPathCodeBook as a double


% --- Executes during object creation, after setting all properties.
function folderPathCodeBook_CreateFcn(hObject, eventdata, handles)
% hObject    handle to folderPathCodeBook (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseCodeBookFolderButton.
function browseCodeBookFolderButton_Callback(hObject, eventdata, handles)
% hObject    handle to browseCodeBookFolderButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FolderName= uigetdir();
%ExPath = fullfile(FilePath, FileName)
set(handles.folderPathCodeBook,'string',FolderName);


% --- Executes on button press in generateCodeBook.
function generateCodeBook_Callback(hObject, eventdata, handles)
% hObject    handle to generateCodeBook (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cbSize=str2num(get(handles.codeBookSize,'String'));%size of the code book. default 300
folderPath=get(handles.folderPathCodeBook,'String');
codeBookGenerating=false;%this flag while true, denotes code book generation is under process
if handles.codeBookFlag
    answer=questdlg('Code book is already there in memory. This operation will over write the existing code book. Would you like to continue?');
    if strcmp(answer,'Yes') && ~codeBookGenerating
        codeBookGenerating=true;
        handles.codeBookFlag=false;%this line requires verification.
        guidata(handles.mainWindow,handles);
        set(handles.text8,'string','Code book is being generated');
        pause(0.1);
        codeBook=codeBookGen(folderPath,cbSize);%calling the code book generation function
        handles.codeBook=codeBook;%this line requires verification.
        handles.codeBookFlag=true;%this line requires verification.
        handles.codeBookUpdated=true;
        codeBookGenerating=false;
        guidata(handles.mainWindow,handles);
        set(handles.text8,'string','Code book ready');
    end
else
    if ~codeBookGenerating
        codeBookGenerating=true;
        set(handles.text8,'string','Code book is being generated');
        pause(0.1);
        codeBook=codeBookGen(folderPath,cbSize);%calling the code book generation function
        handles.codeBook=codeBook;%this line requires verification.
        handles.codeBookFlag=true;%this line requires verification.
        handles.codeBookUpdated=true;
        guidata(handles.mainWindow,handles);
        codeBookGenerating=false;
        set(handles.text8,'string','Code book ready');
    end
end



% --- Executes during object creation, after setting all properties.
function adminId_CreateFcn(hObject, eventdata, handles)
% hObject    handle to adminId (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function password_Callback(hObject, eventdata, handles)
% hObject    handle to password (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of password as text
%        str2double(get(hObject,'String')) returns contents of password as a double


% --- Executes during object creation, after setting all properties.
function password_CreateFcn(hObject, eventdata, handles)
% hObject    handle to password (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loginButton.
function loginButton_Callback(hObject, eventdata, handles)
% hObject    handle to loginButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
userId=get(handles.adminId,'string');
pass=get(handles.password,'Userdata');
set(handles.adminId,'string','');
set(handles.password,'string','');
%display(pass);
loginStatus=get(hObject,'UserData');
if ~loginStatus
    if strcmp(userId,'tat') && strcmp(pass,'root')
        uiwait(msgbox('Successfully logged in'));
        %uiwait(msgbox(strcat('Successfully logged in ',handles.testValue)));
        loginStatus=true;
        %hObject.UserData=loginStatus;
        set(hObject,'UserData',loginStatus);
        set(findall(handles.codeBookPannel, '-property', 'enable'), 'enable', 'on');
        set(findall(handles.enrollPannel, '-property', 'enable'), 'enable', 'on');
        set(handles.loginButton,'string','Logout');
    else
        uiwait(msgbox('Wrong input. Login error'));
    end
else
    loginStatus=false;
    set(hObject,'UserData',loginStatus);
    set(findall(handles.codeBookPannel, '-property', 'enable'), 'enable', 'off');
    set(findall(handles.enrollPannel, '-property', 'enable'), 'enable', 'off');
    uiwait(msgbox('Successfully Logged out'));
    set(handles.loginButton,'string','Login');
end


function adminId_Callback(hObject, eventdata, handles)
% hObject    handle to adminId (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of adminId as text
%        str2double(get(hObject,'String')) returns contents of adminId as a double


% --- Executes on key press with focus on password and none of its controls.
function password_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to password (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
% Function to replace all characters in the password edit box with
% asterisks
password = get(hObject,'Userdata');
%key = get(mainDriver,'CurrentCharacter');
key=eventdata.Key;
switch key
    case 'backspace'
        password = password(1:end-1); % Delete the last character in the password
    %case 'return'  % This cannot be done through callback without making tab to the same thing
     %   gui = getappdata(0,'logindlg');
      %  OK([],[],gui.main);
    %case 'tab'  % Avoid tab triggering the OK button
     %   gui = getappdata(0,'logindlg');
      %  uicontrol(gui.OK);
    %case 'escape'
        % Close the loginPannel dialog
     %   Escape(fig,[])
    %otherwise
    case{'q','w','e','r','t','y','u','i','o','p','a','s','d','f','g','h','j','k','l','z','x','c','v','b','n','m','Q','W','E','R','T','Y','U','I','O','P','A','S','D','F','G','H','J','K','L','Z','X','C','V','B','N','M','1','2','3','4','5','6','7','8','9','0','!','@','#','$','%','^','&','*','(',')'}
        %password = [password get(handles,'CurrentCharacter')]; % Add the typed character to the password
        password = [password eventdata.Key]; % Add the typed character to the password
    %case{'_','-','+','=','`','~',',','<','>','/','?',';',':','"','[','{',']','}','\','|'}
     %   password = [password eventdata.Key];
    %otherwise
     %   password(end+1)='';
        
end

SizePass = size(password); % Find the number of asterisks
if SizePass(2) > 0
    asterisk(1,1:SizePass(2)) = '*'; % Create a string of asterisks the same size as the password
    set(hObject,'String',asterisk) % Set the text in the password edit box to the asterisk string
else
    set(hObject,'String','')
end
set(hObject,'Userdata',password) % Store the password in its current state


% --- Executes during object creation, after setting all properties.
function loginButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loginButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject,'UserData',false);%initially login status is false, means not logged in


% --- Executes when user attempts to close mainWindow.
function mainWindow_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to mainWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
try
    if handles.codeBookUpdated
        codeBook=handles.codeBook;
        save('codeBook.mat','codeBook');
    end
catch
    uiwait(msgbox('Problem in saving updated code book'));
end

try
    if handles.authorDBUpdated
        authorDB=handles.authorDB;
        save('authorDB.mat','authorDB');
    end
catch
    uiwait(msgbox('Problem in saving updated author data base'));
end

try
    if handles.elmModelUpdated
        elmModel=handles.elmModel;
        save('elmModel.mat','elmModel');
    end
catch
    uiwait(msgbox('Problem in saving updated elm model'));
end

delete(hObject);
