clear all; 
close all;

%% Array creation and path

[filename, pathname]= uigetfile('*.*','MultiSelect','on');
addpath(genpath(pathname));

for i=1:length(filename)
    filename2 = [filename(i),pathname];   
end

%% Properties

tot_frame = i;

for j=1:length(filename)
    file = filename{1,j};
    info=dicominfo(file);
    width=info.Width;
    height = info.Height;
end

bitdepth = info.BitDepth;
max_pi = double(2^bitdepth);

%% DICOM Loader

m =  uint16(zeros(width,height,tot_frame)); % initialization of Img

for j=1:length(filename)
    file = filename{1,j};
    dicom_im=dicomread(file);
    m(:,:,j)=dicom_im; % filling of Img
end

% Imshow3D displays 3D grayscale images in slice by slice fashion with 
% mouse based slice browsing and window and level adjustment control.

% Normalize the pixel intensities to 255
m = m*(255/max_pi);

%% Selection of the Frame of Reference

figure,f2p = imshow3D(m, [0 255]);

if isempty(f2p)
    f2p=round(size(m,3)/2);
end

FOR = m(:,:,f2p);

% Limit the frame loaded
if (tot_frame) > 125
    tot_frame = 125;
end

figure(1); imshow(FOR,[0 255]); 

%% Polygon area selection

% Polygon formation
[xdata, ydata, BW, xp, yp] = roipoly;

if isempty(xp)&&isempty(yp)
    fprintf('Please define a polygon over the area of interest\n')
    break;
end

%% Initialization of blush and QuBE values

blush = zeros(tot_frame,1);
QuBE = zeros(1,1);

%% Inversion of DSA

REF = double(FOR);
Mmax = double(max(max(FOR)));

% Uniform color frame
unifmax = uint16(Mmax*ones(1024, 1024));
UNIFmax= double(unifmax);

%% Blush and QuBE calculation

i = 1;
while i<2
    
    for j = 1:tot_frame
        I1 = m(:,:,j);
        blushmaxaddblock(j,:) = blush_withoutfilterblock(I1,UNIFmax,BW);
    end
    if i==1
        figure(3);plot(blushmaxaddblock);
        grid minor
        title('Blush MAXADD Curve')
    end
    % QuBE score
    [QuBEmaxaddblock,maxcurvemaxaddblock] = calculate_qubeadd(blushmaxaddblock,tot_frame);
    
     i = i+1;
end

Q0maxaddblock = QuBEmaxaddblock(1); % QuBE score without polygon's combinational movement
fprintf('QuBEmaxaddblock score : %5.4f \n',Q0maxaddblock)