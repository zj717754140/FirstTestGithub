
clc;
clear;

numColor = 10;
colorset=cell(10,1);
colorset{1}='GRAY';
colorset{2}='RGB';
colorset{3}='NRGB';
colorset{4}='HSV';
colorset{5}='OPPONENT';
colorset{6}='COPPONENT';
colorset{7}='NOPPONENT';
colorset{8}='HUE';
colorset{9}='TRGB';
colorset{10}='LAB';

numSeq = 129;
seqset=cell(numSeq, 1);
seqset{1}='Basketball';
seqset{2}='Bicycle';
seqset{3}='Biker';
seqset{4}='Bird';
seqset{5}='Board';
seqset{6}='Bolt';
seqset{7}='Boy';
seqset{8}='CarDark';
seqset{9}='CarScale';
seqset{10}='Coke';
seqset{11}='Couple';
seqset{12}='Crossing';
seqset{13}='Cup';
seqset{14}='David';
seqset{15}='David3';
seqset{16}='Deer';
seqset{17}='Diving';
seqset{18}='Doll';
seqset{19}='FaceOcc1';
seqset{20}='Football1';
seqset{21}='Girl';
seqset{22}='Girlmov';
seqset{23}='Gym';
seqset{24}='Hand';
seqset{25}='Iceskater';
seqset{26}='Ironman';
seqset{27}='Jogging1';
seqset{28}='Jogging2';
seqset{29}='Juice';
seqset{30}='Lemming';
seqset{31}='Liquor';
seqset{32}='Matrix';
seqset{33}='MotorRolling';
seqset{34}='MountainBike';
seqset{35}='Panda';
seqset{36}='Shaking';
seqset{37}='Singer1';
seqset{38}='Singer2';
seqset{39}='Skating1';
seqset{40}='Skating2';
seqset{41}='Skiing';
seqset{42}='Soccer';
seqset{43}='Subway';
seqset{44}='Sunshade';
seqset{45}='Tiger1';
seqset{46}='Tiger2';
seqset{47}='Torus';
seqset{48}='Trellis';
seqset{49}='Walking';
seqset{50}='Walking2';
seqset{51}='Woman';

seqset{52}='Airport_ce';
seqset{53}='Baby_ce';
seqset{54}='Badminton_ce1';
seqset{55}='Badminton_ce2';
seqset{56}='Basketball_ce1';
seqset{57}='Basketball_ce2';
seqset{58}='Basketball_ce3';
seqset{59}='Bike_ce1';
seqset{60}='Bike_ce2';
seqset{61}='Bikeshow_ce';
seqset{62}='Boat_ce1';
seqset{63}='Boat_ce2';
seqset{64}='Busstation_ce1';
seqset{65}='Busstation_ce2';
seqset{66}='Carchasing_ce1';
seqset{67}='Carchasing_ce3';
seqset{68}='Carchasing_ce4';
seqset{69}='Eagle_ce';
seqset{70}='Electricalbike_ce';
seqset{71}='Face_ce';
seqset{72}='Guitar_ce1';
seqset{73}='Guitar_ce2';
seqset{74}='Hurdle_ce1';
seqset{75}='Hurdle_ce2';
seqset{76}='Kite_ce1';
seqset{77}='Kite_ce2';
seqset{78}='Kite_ce3';
seqset{79}='Kobe_ce';
seqset{80}='Logo_ce';
seqset{81}='Messi_ce';
seqset{82}='Michaeljackson_ce';
seqset{83}='Motorbike_ce';
seqset{84}='Plane_ce2';
seqset{85}='Railwaystation_ce';
seqset{86}='Singer_ce1';
seqset{87}='Singer_ce2';
seqset{88}='Skating_ce1';
seqset{89}='Skating_ce2';
seqset{90}='Skiing_ce';
seqset{91}='Skyjumping_ce';
seqset{92}='Spiderman_ce';
seqset{93}='Suitcase_ce';
seqset{94}='Surf_ce1';
seqset{95}='Surf_ce2';
seqset{96}='Surf_ce3';
seqset{97}='Surf_ce4';
seqset{98}='Tennis_ce1';
seqset{99}='Tennis_ce2';
seqset{100}='Tennis_ce3';
seqset{101}='Toyplane_ce';

seqset{102}='Ball_ce1';
seqset{103}='Ball_ce2';
seqset{104}='Ball_ce3';
seqset{105}='Ball_ce4';
seqset{106}='Bee_ce';
seqset{107}='Charger_ce';
seqset{108}='Cup_ce';
seqset{109}='Face_ce2';
seqset{110}='Fish_ce1';
seqset{111}='Fish_ce2';
seqset{112}='Hand_ce1';
seqset{113}='Hand_ce2';
seqset{114}='Microphone_ce1';
seqset{115}='Microphone_ce2';
seqset{116}='Plate_ce1';
seqset{117}='Plate_ce2';
seqset{118}='Pool_ce1';
seqset{119}='Pool_ce2';
seqset{120}='Pool_ce3';
seqset{121}='Ring_ce';
seqset{122}='Sailor_ce';
seqset{123}='SuperMario_ce';
seqset{124}='TableTennis_ce';
seqset{125}='TennisBall_ce';
seqset{126}='Thunder_ce';
seqset{127}='Yo-yos_ce1';
seqset{128}='Yo-yos_ce2';
seqset{129}='Yo-yos_ce3';

% base_path='F:/Data/color_objectness_tracking/Color_tracking/color_sequences/128-color-sequences';
  base_path = 'E:/project/drrt/dataset/Temple-color-128';
% 
% if ~exist('result', 'dir')
%     mkdir('result');
% end

for cm = 1:10 %choose the color representation
    for i=1:129 %choose the sequence
        close all;
        colorModel = colorset{cm};
        fprintf('%s %d\n', colorModel, i);
        saveDir = ['result/' colorModel '/'];
        if ~exist(saveDir, 'dir')
            mkdir(saveDir);
        end
%         %parameters according to the paper. at this point we can override
%         %parameters based on the chosen kernel or feature type
         video = seqset{i};
%         show_visualization = ~strcmp(video, 'all');
%         show_plots = ~strcmp(video, 'all');
%         kernel.type = 'gaussian';
%         feature_type = 'hog';
%         
%         features.gray = false;
%         features.hog = false;
%         
%         padding = 1.5;  %extra area surrounding the target
%         lambda = 1e-4;  %regularization
%         output_sigma_factor = 0.1;  %spatial bandwidth (proportional to target)
%         
%         interp_factor = 0.02;
%         
%         kernel.sigma = 0.5;
%         
%         kernel.poly_a = 1;
%         kernel.poly_b = 9;
%         
%         features.hog = true;
%         features.hog_orientations = 9;
%         cell_size = 4;
%         features.colorModel = colorModel;
%         
%         [img_files, pos, target_sz, ground_truth, video_path, depth_path] = load_video_color(base_path, video);
%         
%         show_visualization = 0;
%         %call tracker function with all the relevant parameters
%         [positions, my_time] = tracker(video_path, depth_path, img_files, pos, target_sz,padding, kernel, lambda, output_sigma_factor, interp_factor,cell_size, features, show_visualization);
%         
%         rects = [positions(:,2) - target_sz(2)/2, positions(:,1) - target_sz(1)/2];
%         rects(:,3) = target_sz(2);
%         rects(:,4) = target_sz(1);



         video_path = ['E:/project/drrt/dataset/Temple-color-128/' seqset{i} '/img/'];
         img_files = dir([video_path '*.png']);
         if isempty(img_files),
 		 	img_files = dir([video_path '*.jpg']);
 			assert(~isempty(img_files), 'No image files to load.')
         end
%         frames_path = ['/home/mmc_xhma/Jiezhang/data/Temple-color-128/' seqset{i} '_frames.txt' ];
%       
%         
%         
%         
%       filename = frames_path ;
% 	%try to load ground truth from text file (Benchmark's format)
% 	%filename = [video_path 'groundtruth_rect' suffix '.txt'];
% 	f = fopen(filename);
% 	assert(f ~= -1, ['No initial position or ground truth to load ("' filename '").'])
% 	
% 	%the format is [x, y, width, height]
% 	try
% 		ground_truth = textscan(f, '%f,%f', 'ReturnOnError',false);  
% 	catch  %#ok, try different format (no commas)
% 		frewind(f);
% 		ground_truth = textscan(f, '%f %f ');  
% 	end
% 	ground_truth = cat(2, ground_truth{:});
% 	fclose(f);
	
	%set initial position and size
% 	target_sz = [ground_truth(1,4), ground_truth(1,3)];
% 	pos = [ground_truth(1,2), ground_truth(1,1)] + floor(target_sz/2);
 video_path = [base_path '/' seqset{i} '/img/'];
% depth_path = [basePath '/' seqset{i} '/imgd/'];

   framesFileName=[base_path '/' seqset{i} '/' seqset{i} '_frames.txt'];
   startEnd=dlmread(framesFileName);
   startFrame=startEnd(1,1);
   endFrame=startEnd(1,2);
     gtFileName=[base_path '/' seqset{i} '/' seqset{i} '_gt.txt'];
     tp_gt=dlmread(gtFileName);
%         
%         
%         
      v_path=repmat(video_path,endFrame,1);   %soccer
 		img_files = sort({img_files.name});
       img_files=strcat(v_path,img_files');
%   % initialize the seq.s_frames and seq.init_rect=ground_truth(1,:);   
% seq.s_frames =img_files;
% 
% seq.init_rect=[302,135,67,81]; %soccer
% res_path='./res_OTB';

seq.s_frames = img_files;
seq.init_rect = tp_gt(1,:);

run setup_gamma1.m;
addpath('utility','model','cf_scale');
all_images = seq.s_frames;
tracking_res = [];

region = seq.init_rect;
tracking_res = [tracking_res; region];

[state, ~] = TCNN_initialize(imread(all_images{1}), region);
nframes	= length(all_images);

for i = 2:nframes
    [state, region] = TCNN_update(state, imread(all_images{i}));
    tracking_res = [tracking_res;region];
end

 
results.type   = 'rect';
results.res    = tracking_res;
results.fps    = 1;

        save_file = [saveDir video '_TCF_' colorModel '.txt'];
        fid = fopen(save_file, 'w+');
        num_row = size(tracking_res, 1);
        for k = 1 : num_row
            fprintf(fid, '%.4f,%.4f,%.4f,%.4f\n', tracking_res(k, 1), tracking_res(k, 2), tracking_res(k, 3), tracking_res(k, 4));
        end
        fclose(fid);
    end
end
fprintf('finished...\n');