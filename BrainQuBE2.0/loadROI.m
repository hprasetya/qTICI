% Choosing segmentation file
[SegFileName,SegPathName] = uigetfile('*.gz','Select the segmentation file');
segfile=strcat(SegPathName,SegFileName);
mask = load_nii(segfile);
% detecting frame that contains segmentation label
[~,~,seg_idx] = ind2sub(size(mask.img),find(mask.img == 1,1));
% retrieve real mask pos ('load_nii' flipped nifti file)
mask = flip(imrotate(mask.img(:,:,seg_idx),-90));