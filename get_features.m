% GET_FEATURES: Extracting hierachical convolutional features

function feat = get_features(im, cos_window, layers)

global net1
global enableGPU
net_file = fullfile('/visual_tracking_jie/TCF1/TCNN/models/imagenet-vgg-verydeep-19.mat');
net1 = load(net_file);
if isempty(net1)
    initial_net();
end

sz_window = size(cos_window);

% Preprocessing
img = single(im);        % note: [0, 255] range
% img = imResample(img, net.meta.normalization.imageSize(1:2));
img = imResample(img, net1.normalization.imageSize(1:2));
% average=net.meta.normalization.averageImage;
average=net1.normalization.averageImage;
if numel(average)==3
    average=reshape(average,1,1,3);
end

img = bsxfun(@minus, img, average);

if enableGPU, img = gpuArray(img); end

% Run the CNN
res = vl_simplenn(net1,img);

% Initialize feature maps
feat = cell(length(layers), 1);

for ii = 1:length(layers)
    
    % Resize to sz_window
    if enableGPU
        x = gather(res(layers(ii)).x); 
    else
        x = res(layers(ii)).x;
    end
    
    x = imResample(x, sz_window(1:2));
    
    % windowing technique
    if ~isempty(cos_window),
        x = bsxfun(@times, x, cos_window);
    end
    
    feat{ii}=x;
end

end
