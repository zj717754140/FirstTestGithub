function results=run_TCF(seq, res_path, bSaveImage)
% 
close all;
%
% opt.n_sample = 50; %seq.particle_number;	%70	% number of particles   40
% opt.rel_std_afnv =  [0.01,0.0001,0.0001,0.01,2,2];
%
run setup_gamma1.m;

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






