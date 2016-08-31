clear all
close all
% This is the main program of QuBE

%% DICOM Loader
[FileName,PathName] = uigetfile('*.DCM','Select the DICOM file');
file=strcat(PathName,FileName);

% Extract dicom information
dicom_im=dicomread(file);
info=dicominfo(file);
tot_frame = info.NumberOfFrames;
width=info.Width;
height = info.Height;
bitdepth = info.BitDepth;
max_pi = double(2^bitdepth);

% Imshow3D displays 3D grayscale images in slice by slice fashion with 
% mouse based slice browsing and window and level adjustment control.

% Remove the null dimension
m = squeeze(dicom_im);  
% Normalize the pixel intensities to 255
m = m*(255/max_pi);

%% Retrieve ROI
loadROI;
BW = double(mask);
FOR = m(:,:,seg_idx);
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
    end
    % QuBE score
    [QuBEmaxaddblock,maxcurvemaxaddblock] = calculate_qubeadd(blushmaxaddblock,tot_frame);
    
     i = i+1;
end

Q0maxaddblock = QuBEmaxaddblock(1); % QuBE score without polygon's combinational movement
fprintf('QuBEmaxaddblock score : %5.4f \n',Q0maxaddblock)
title(sprintf('QuBE Score: %0.4f', Q0maxaddblock))
xlabel('# frame');ylabel('arbitrary unit')