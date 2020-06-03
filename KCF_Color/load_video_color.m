function [img_files, pos, target_sz, ground_truth, video_path, depth_path] = load_video_color(basePath, title)

video_path = [basePath '/' title '/img/'];
depth_path = [basePath '/' title '/imgd/'];

framesFileName=[basePath '/' title '/' title '_frames.txt'];
startEnd=dlmread(framesFileName);
startFrame=startEnd(1,1);
endFrame=startEnd(1,2);

numFrame = endFrame - startFrame + 1;
img_files = cell(1, numFrame);
for i=startFrame:endFrame
    img_files{i - startFrame + 1} = sprintf('%04d.jpg', i);
end


gtFileName=[basePath '/' title '/' title '_gt.txt'];
tp_gt=dlmread(gtFileName);
tp_left=tp_gt(1,1);
tp_top=tp_gt(1,2);
tp_width=tp_gt(1,3);
tp_height=tp_gt(1,4);
p1_row=tp_top;
p1_col=tp_left;
p2_row=tp_top+tp_height-1;
p2_col=tp_left;
p3_row=tp_top;
p3_col=tp_left+tp_width-1;

target_sz = [tp_gt(1,4), tp_gt(1,3)];
pos = [tp_gt(1,2), tp_gt(1,1)] + floor(target_sz/2);

if size(tp_gt,1) == 1,
    %we have ground truth for the first frame only (initial position)
    ground_truth = [];
else
    %store positions instead of boxes
    ground_truth = tp_gt(:,[2,1]) + tp_gt(:,[4,3]) / 2;
end