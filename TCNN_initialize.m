function [state, location] = TCNN_initialize(I, region, varargin)
     img = I;
    state.targetLoc = region;
    %% initialize displayots  dispaly
    display_img=0;
    if display_img
        figure(1);
        set(gcf,'Position',[200 100 600 800],'MenuBar','none','ToolBar','none');

        subplot(2,1,1);
        imshow(img,'initialmagnification','fit'); hold on;

        rectangle('Position', state.targetLoc, 'EdgeColor', [1 0 0], 'Linewidth', 1);
        set(gca,'position',[0 0.5 1 0.5]);

        % frame index
        text(10,10,'1','Color','y', 'HorizontalAlignment', 'left', 'FontWeight','bold', 'FontSize', 30);
        hold off; drawnow; pause(0.001);
    end
    state.To = 1;
    state.curBlock = 2;        
    location = state.targetLoc;
       
 %% initial correlation filter parameter
state.padding = struct('generic', 1.8, 'large', 1, 'height', 0.4);
state.lambda = 1e-4;              % Regularization parameter (see Eqn 3 in our paper)
state.output_sigma_factor = 0.1;  % Spatial bandwidth (proportional to the target size)
state.interp_factor = 0.01;       % Model learning rate (see Eqn 6a, 6b)
state.cell_size = 4;              % Spatial cell size
state.target_sz = [region(1,4),region(1,3)];
pos = [region(1,2),region(1,1)] +floor(state.target_sz/2);
state.current_scale_factor =1;
state.opts.block_frames =26; % 
state.opts.parent_blocks = 13; % 13
% Environment setting
state.indLayers = [37, 28, 19];   % The CNN layers Conv5-4, Conv4-4, and Conv3-4 in VGG Net
state.nweights  = [1, 0.5, 0.25]; 
state.nweights  = reshape(state.nweights,1,1,[]);% Weights for combining correlation filter responses
state.numLayers = length(state.indLayers);
model_xf     = cell(1, state.numLayers);
model_alphaf = cell(1, state.numLayers);
% Get image size and search window size
state.im_sz     = size(img);
state.window_sz = get_search_window(state.target_sz, state.im_sz, state.padding);
state.pos = pos;
% Compute the sigma for the Gaussian function label
state.output_sigma = sqrt(prod(state.target_sz)) * state.output_sigma_factor / state.cell_size;

%create regression labels, gaussian shaped, with a bandwidth
%proportional to target size    d=bsxfun(@times,c,[1 2]);

state.l1_patch_num = floor(state.window_sz/ state.cell_size);

% Pre-compute the Fourier Transform of the Gaussian function label
state.yf = fft2(gaussian_shaped_labels(state.output_sigma, state.l1_patch_num));
state.total_pos_data = cell(1);
% Pre-compute and cache the cosine window (for avoiding boundary discontinuity)
state.cos_window = hann(size(state.yf,1)) * hann(size(state.yf,2))';

feat  = extractFeature(img, pos, state.window_sz, state.cos_window, state.indLayers);
state.total_pos_data{1} = feat;
% Model update

[model_xf, model_alphaf] = updateModel(feat, state.yf, state.interp_factor,...
        state.lambda, state.To,model_xf, model_alphaf);
    state.blocks(1).model_alphaf = model_alphaf;
    state.blocks(1).model_xf = model_xf;
    %% initial graph
    state.blocks = struct('frames',cell(1,1), 'parents',[], 'econfs',[],...
        'rel_parents',[], 'minconfs',[], 'maxminparent',[], 'maxminconf',inf('single'),...
       'model_xf',[],'model_alphaf',[]);
    state.blocks(1).frames = 1;
    state.blocks(1).model_xf = model_xf;
    state.blocks(1).model_alphaf = model_alphaf;
    state.cand_blocks = 1;
%         state.model_xf_ = model_xf;
%        state.model_alphaf_ = model_alphaf;

end
function [model_xf, model_alphaf] = updateModel(feat, yf, interp_factor, lambda, frame, ...
    model_xf, model_alphaf)

numLayers = length(feat);

% ================================================================================
% Initialization
% ================================================================================
xf       = cell(1, numLayers);
alphaf   = cell(1, numLayers);

% ================================================================================
% Model update
% ================================================================================
for ii=1 : numLayers
    xf{ii} = fft2(feat{ii});
    kf = sum(xf{ii} .* conj(xf{ii}), 3) / numel(xf{ii});
    alphaf{ii} = yf./ (kf+ lambda);   % Fast training
end

% Model initialization or update
if frame == 1,  % First frame, train with a single image
    for ii=1:numLayers
        model_alphaf{ii} = alphaf{ii};
        model_xf{ii} = xf{ii};
    end
else
    % Online model update using learning rate interp_factor
    for ii=1:numLayers
        model_alphaf{ii} = (1 - interp_factor) * model_alphaf{ii} + interp_factor * alphaf{ii};
        model_xf{ii}     = (1 - interp_factor) * model_xf{ii}     + interp_factor * xf{ii};
    end
end


end