%
%
%
%
close all;
clear;
% video_path='./data/David3/img/';
video_path='./data/MotorRolling/img/';
img_files = dir([video_path '*.png']);
        if isempty(img_files),
		 	img_files = dir([video_path '*.jpg']);
			assert(~isempty(img_files), 'No image files to load.')
         end
      %   v_path=repmat(video_path,252,1); %David3
        v_path=repmat(video_path,164,1);  % MotorRolling
		img_files = sort({img_files.name});
      img_files=strcat(v_path,img_files');
  % initialize the seq.s_frames and seq.init_rect=ground_truth(1,:);   
seq.s_frames =img_files;
% seq.init_rect=[83,200,35,131]; %David3
seq.init_rect=[117,68,122,125];
res_path='./res_OTB';

addpath('utility','model','cf_scale');

 %  vl_setupnn();
run_TCNN(seq, res_path);



