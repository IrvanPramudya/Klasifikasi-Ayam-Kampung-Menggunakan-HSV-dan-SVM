function varargout = AYAMKU(varargin)
% AYAMKU MATLAB code for AYAMKU.fig
%      AYAMKU, by itself, creates a new AYAMKU or raises the existing
%      singleton*.
%
%      H = AYAMKU returns the handle to a new AYAMKU or the handle to
%      the existing singleton*.
%
%      AYAMKU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AYAMKU.M with the given input arguments.
%
%      AYAMKU('Property','Value',...) creates a new AYAMKU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AYAMKU_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AYAMKU_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AYAMKU

% Last Modified by GUIDE v2.5 22-Jun-2021 12:35:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AYAMKU_OpeningFcn, ...
                   'gui_OutputFcn',  @AYAMKU_OutputFcn, ...
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


% --- Executes just before AYAMKU is made visible.
function AYAMKU_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AYAMKU (see VARARGIN)

% Choose default command line output for AYAMKU
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AYAMKU wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AYAMKU_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pilihgbr.
% untuk mengupload gambar


% --- Executes on button press in ekstrasiHSV.
% mengekstrasi fitur-fitur HSV
function ekstrasiHSV_Callback(hObject, eventdata, handles)
    global gambarnya HSV
    HSV
    a = [1 2 3; 3 4 5; 6 7 8];
    [mean, deviasi, kewnya] = fungsi_ekstrasi(a);
    sum=(mean+deviasi+kewnya)
    
    
    hasilHSV(1,1)=mean
    hasilHSV(1,2)=deviasi
    hasilHSV(1,3)=kewnya
    hasilHSV(1,4)=(sum*100) %PENAMBAHAN
    set(handles.tabelhasil,'Data',hasilHSV);


% --- Executes on button press in EkstrakDS.
% mengekstrasi Semua Data
function EkstrakDS_Callback(hObject, eventdata, handles)
    set(handles.status_ekstrasi,'String','On Proses Bro');
    global fitur_hsv
    fitur_hsv = zeros(200,5);
    % fitur hsv dengan matrik kosong, yang panjangnya 200 x 4, dimana 200
    % adalah jumlah dataset yang kita punya dan 4 adalah jumlah ekstraksi
    % dimana ada mean deviasi keynes dan group (1 atau 2)
    
    for x=1:100
        %menganmbil 100 dataset yang terletak pada alamat dibawah
        I = strcat('E:\TUGAS PCDL\SEGAR\',int2str(x),'.jpg');
        I = imread(I);
        I = rgb2hsv(I);
        [mean, deviasi, kewnya] = fungsi_ekstrasi(I);
        
        sum = (mean+deviasi+kewnya)
        %average = (sum/100)
        
        fitur_hsv(x,1)=mean
        fitur_hsv(x,2)=deviasi
        fitur_hsv(x,3)=kewnya
        fitur_hsv(x,4)=(sum*100)
        fitur_hsv(x,5)=2
        total       = fitur_hsv(x,4)    %PENAMBAHAN
        rata_rata   = (total/100)       %PENAMBAHAN
    end

    for x=1:100
        I = strcat('E:\TUGAS PCDL\NON SEGAR\',int2str(x),'.jpg');
        I = imread(I);
        I = rgb2hsv(I);
        [mean, deviasi, kewnya] = fungsi_ekstrasi(I);
        
        sum = (mean+deviasi+kewnya)
        %average = (sum/100)
        
        fitur_hsv(x+100,1)=mean
        fitur_hsv(x+100,2)=deviasi
        fitur_hsv(x+100,3)=kewnya
        fitur_hsv(x+100,4)=(sum*100)
        fitur_hsv(x+100,5)=1
    end

        set(handles.status_ekstrasi,'String','Selesai');
        set(handles.tabelhasil,'Data',fitur_hsv);

    hasilnya = strcat('E:\TUGAS PCDL\Ekstraksi.xlsx');
    xlswrite(hasilnya,fitur_hsv);
    xlswrite(hasilnya,fitur_hsv); %PENAMBAHAN


% --- Executes on button press in TrainingData.
function TrainingData_Callback(hObject, eventdata, handles)
    global fitur_hsv HasilTraining
    HasilTraining = svmtrain(fitur_hsv(:,1:2),fitur_hsv(:,5)); 
    %menentukan hasil fitur hsv antara 1 atau 2 pada kolom ke 5
    hasilnya = strcat('E:\TUGAS PCDL\Training.mat');
    save(hasilnya,'HasilTraining');


% --- Executes on button press in DataTest.
function DataTest_Callback(hObject, eventdata, handles)
    global gambar_tes HSV
    [filename,pathname] = uigetfile('*.jpg'); %mengambil file dari sebuah folder
    gambar_tes = imread(fullfile(pathname,filename));
    axes(handles.GambarTest);
    imshow(gambar_tes);
    HSV = rgb2hsv(gambar_tes); %convert rgb ke hsv
    axes(handles.testHSV);
    imshow(HSV); %menampilkan hasil hsv
    
    [mean, deviasi, kewnya] = fungsi_ekstrasi(HSV);

    hasilHSV(1,1)=mean
    hasilHSV(1,2)=deviasi
    hasilHSV(1,3)=kewnya
    set(handles.hasiltest,'Data',hasilHSV);


% --- Executes on button press in TestData.
function TestData_Callback(hObject, eventdata, handles)
   

    global gambar_tes HasilTraining
    HSV_testing = rgb2hsv(gambar_tes);
    [mean, deviasi, kewnya] = fungsi_ekstrasi(HSV_testing);
    
    sum = (mean+deviasi+kewnya)
    
    testing_hsv(1,1)=mean
    testing_hsv(1,2)=deviasi
    testing_hsv(1,3)=kewnya
    testing_hsv(1,4)=(sum*100)
    HasilTraining
    svm = svmclassify(HasilTraining,testing_hsv(:,1:2))
    if svm == 2
        status = 'SEGAR';
    else
        status = 'BURUK';
    end
    
    
    hasil_test(1,1)=mean
    hasil_test(1,2)=deviasi
    hasil_test(1,3)=kewnya
    hasil_test(1,4)=(sum*100)
    hasil_test(1,5)=svm
    
        set(handles.hasil_tes,'String',status);
        set(handles.hasiltest,'Data',hasil_test);
        
    hasilnya = strcat('E:\TUGAS PCDL\HasilTest.xlsx');
    xlswrite(hasilnya,hasil_test,status);


% --- Executes during object creation, after setting all properties.
function background_CreateFcn(hObject, eventdata, handles)
% hObject    handle to background (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate background
