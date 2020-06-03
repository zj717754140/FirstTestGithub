function [state, location] = TCNN_update(state, I, varargin)
 
    state.To = state.To + 1;
    img = I;
 % ================================================== % 
 pos = state.pos;
 % pos = [state.targetLoc(1,2),state.targetLoc(1,1)] +floor(state.targetLoc(1,[4,3])/2);
 
 if ismatrix(img),  img = cat(3, img, img, img);  end
 
 if state.To ==2  
      init_scale_para(rgb2gray(img), state.target_sz, pos);
 end

    feat = extractFeature(img, pos, state.window_sz, state.cos_window, state.indLayers);
        % Predict position
            response_all = single([]);
            econfs = single([]);
            econfs_all = 0;
            
               for i = 1:length(state.cand_blocks)
                        c = state.cand_blocks(i);
                        % ================================================================================
                        % Compute correlation filter responses at each layer
                        % ================================================================================
                        res_layer = zeros([state.l1_patch_num, length(state.indLayers)]);
                        for ii = 1 : length(state.indLayers)
                            zf = fft2(feat{ii});
                            kzf=sum(zf .* conj(state.blocks(c).model_xf{ii}), 3) / numel(zf);
                            temp= real(fftshift(ifft2(state.blocks(c).model_alphaf{ii} .* kzf)));  %equation for fast detection
                            res_layer(:,:,ii)=temp/max(temp(:));
                        end
                        % Combine responses from multiple layers (see Eqn. 5)
                        response = sum(bsxfun(@times, res_layer, state.nweights), 3);
                        %%
                        response_all{i} = response;
                        econfs_all = max(max(response));
                        econfs = [econfs;econfs_all]; 
               end
                        minconfs = min(cell2mat({state.blocks(state.cand_blocks).maxminconf})', econfs);
                       
                       
                         weights = minconfs;
                         weights = weights/sum(weights); 
                        response = zeros(size(feat{1},1),size(feat{1},2));
                        
%                  if length(state.cand_blocks) == state.opts.parent_blocks       
                        for ii = 1 : length(state.cand_blocks)
                           response_s = response_all{ii} * weights(ii); 
                           response = response_s + response ;
                         end
%                  else
%                      response = response_all{1};
%                  end
                % ================================================================================
                % Find target location
                % ================================================================================
                % Target location is at the maximum response. we must take into
                % account the fact that, if the target doesn't move, the peak
                % will appear at the top-left corner, not at the center (this is
                % discussed in the KCF paper). The responses wrap around cyclically.
                [vert_delta, horiz_delta] = find(response == max(response(:)), 1);
                vert_delta  = vert_delta  - floor(size(zf,1)/2);
                horiz_delta = horiz_delta - floor(size(zf,2)/2);
                % Map the position to the image space
                pos = pos + state.cell_size * [vert_delta - 1, horiz_delta - 1];
               
                            % =============================================
%             [pos,response_max] = predictPosition(feat, pos, state.indLayers, state.nweights, state.cell_size, state.l1_patch_num, ...
%             state.blocks(c).model_xf, state.blocks(c).model_alphaf);
           
        
        
        state.current_scale_factor = estimate_scale( rgb2gray(img), pos, state.current_scale_factor);  
        target_sz_t = state.target_sz * state.current_scale_factor;
        state.targetLoc = [pos([2,1]) - round(target_sz_t([2,1])/2), target_sz_t([2,1])];
        location = state.targetLoc;
        state.pos = pos;
             
        
         feat = extractFeature(img, pos, state.window_sz, state.cos_window, state.indLayers);
         
          state.total_pos_data{end+1} = feat;
         if (state.To > state.opts.block_frames*(state.opts.parent_blocks+1))
                  state.total_pos_data{end-state.opts.block_frames*(state.opts.parent_blocks+1)} = single([]);
         end
%          for i = 1:length(state.cand_blocks)
%                 [model_xf, model_alphaf] = updateModel(feat, state.yf, state.interp_factor, state.lambda, state.To, ...
%                state.blocks(state.cand_blocks(i)).model_xf, state.blocks(state.cand_blocks(i)).model_alphaf);
%                 state.blocks(state.cand_blocks(i)).model_xf = model_xf;
%                 state.blocks(state.cand_blocks(i)).model_alphaf = model_alphaf;
%          end

%         if length(state.cand_blocks) == state.opts.parent_blocks
%           for i = 1:6
%                 [model_xf, model_alphaf] = updateModel(feat, state.yf, state.interp_factor, state.lambda, state.To, ...
%                state.blocks(state.cand_blocks(i)).model_xf, state.blocks(state.cand_blocks(i)).model_alphaf);
%                 state.blocks(state.cand_blocks(i)).model_xf = model_xf;
%                 state.blocks(state.cand_blocks(i)).model_alphaf = model_alphaf;
%           end
%         else
%             for i = 1
%                 [model_xf, model_alphaf] = updateModel(feat, state.yf, state.interp_factor, state.lambda, state.To, ...
%                state.blocks(state.cand_blocks(i)).model_xf, state.blocks(state.cand_blocks(i)).model_alphaf);
%                 state.blocks(state.cand_blocks(i)).model_xf = model_xf;
%                 state.blocks(state.cand_blocks(i)).model_alphaf = model_alphaf;
%           end
%        end


       if length(state.cand_blocks)<13   % 13_niubi_4
         for i = 1:length(state.cand_blocks)
                [model_xf, model_alphaf] = updateModel(feat, state.yf, state.interp_factor, state.lambda, state.To, ...
               state.blocks(state.cand_blocks(i)).model_xf, state.blocks(state.cand_blocks(i)).model_alphaf);
                state.blocks(state.cand_blocks(i)).model_xf = model_xf;
                state.blocks(state.cand_blocks(i)).model_alphaf = model_alphaf;
         end
       else
            for i = 1:4   % 1:4 _niubi_4
                [model_xf, model_alphaf] = updateModel(feat, state.yf, state.interp_factor, state.lambda, state.To, ...
               state.blocks(state.cand_blocks(i)).model_xf, state.blocks(state.cand_blocks(i)).model_alphaf);
                state.blocks(state.cand_blocks(i)).model_xf = model_xf;
                state.blocks(state.cand_blocks(i)).model_alphaf = model_alphaf;
         end
       end 
       
       
       
       
       
       %  pos = floor(pos_all/response_max_out);
   %  state.targetLoc(1,[2,1]) = floor(pos-state.targetLoc(1,[4,3])/2);
    
    %% update graph
    if size(state.blocks,2) < state.curBlock
        state.blocks(state.curBlock) = struct('frames',cell(1,1), 'parents',[], 'econfs',[],...
        'rel_parents',[], 'minconfs',[], 'maxminparent',[], 'maxminconf',inf('single'),...
        'model_xf',[],'model_alphaf',[]);
    end     
    
    state.blocks(state.curBlock).frames = [state.blocks(state.curBlock).frames, state.To];
   %  econfs_mean = mean(scores_all(idx(1:5),:));
    state.blocks(state.curBlock).econfs = [state.blocks(state.curBlock).econfs; econfs'];
    
    %% training
    if(length(state.blocks(state.curBlock).frames)>=state.opts.block_frames)
        
        state.blocks(state.curBlock).econfs = mean(state.blocks(state.curBlock).econfs);
        state.blocks(state.curBlock).minconfs = min(cell2mat({state.blocks(state.cand_blocks).maxminconf})', state.blocks(state.curBlock).econfs')';
        [state.blocks(state.curBlock).maxminconf, ~] = max(state.blocks(state.curBlock).minconfs);
        
%    pos =[state.targetLoc(1,2),state.targetLoc(1,1)] +floor(state.targetLoc(1,[4,3])/2);
%     feat  = extractFeature(img, pos, state.window_sz, state.cos_window, state.indLayers);
    % Model update
    
 

%     [model_xf, model_alphaf] = updateModel(feat, state.yf, state.interp_factor, state.lambda, state.To, ...
%        model_xf, model_alphaf);
%    
%            state.blocks(state.curBlock).model_xf = model_xf;
%            state.blocks(state.curBlock).model_alphaf = model_alphaf;
    
        maxes = state.blocks(state.curBlock).minconfs == state.blocks(state.curBlock).maxminconf;
        
%         if strcmp(state.chooseMax, 'linear')
%             pid = length(maxes);
%         elseif strcmp(state.chooseMax, 'oldest')
 %         pid = find(maxes, 1, 'first');
%         elseif strcmp(state.chooseMax, 'latest')
 %            pid = find(maxes, 1, 'last');
         pid = find(maxes, 1);
%         elseif strcmp(state.chooseMax, 'stochastic')
 %           pid = randsample(length(state.blocks(state.curBlock).minconfs),1,true,maxes);
%         elseif strcmp(state.chooseMax, 'random')
%             pid = randsample(length(state.blocks(state.curBlock).minconfs),1,true);
%         else
%             error('chooseMax error');
%         end
%         fprintf('pid: %d\n', state.cand_blocks(pid));
        state.blocks(state.curBlock).maxminparent = state.cand_blocks(pid);
        state.blocks(state.curBlock).parents  = state.cand_blocks;
% 
%         if strcmp(state.chooseSample, 'all')
%             pos_frames = [state.blocks(state.cand_blocks(pid)).frames, state.blocks(state.curBlock).frames];
%         elseif strcmp(state.chooseSample, 'only')
%             pos_frames = state.blocks(state.curBlock).frames;
%         else
%             error('chooseSample error');
%         end
%             pos_frames = blocks(curBlock).frames;
%         neg_frames = state.blocks(state.curBlock).frames;
%         pos_data = cell2mat(state.total_pos_data(pos_frames));
%         neg_data = cell2mat(state.total_neg_data(neg_frames));
% 
%         [state.net_fc, state.hardnegs] = gnet_finetune_hnm(state.blocks(state.cand_blocks(pid)).cnn,pos_data,neg_data,state.opts,...
%             'maxiter',state.opts.maxiter_update,'learningRate',state.opts.learningRate_update);
% %                         [net_fc] = gnet_finetune(blocks(cand_blocks(pid)).cnn,pos_data,neg_data,opts,...
% %                             'maxiter',opts.maxiter_update,'learningRate',opts.learningRate_update);
%         state.blocks(state.curBlock).cnn = state.net_fc;      
        %%
        
 % parent_frames = [ state.blocks(state.curBlock).frames];
    parent_frames = [state.blocks(state.cand_blocks(pid)).frames, state.blocks(state.curBlock).frames];
 %   parent_frames = [state.blocks(state.cand_blocks(pid)).frames];
   parent_data = state.total_pos_data(parent_frames);
     model_xf =state.blocks(state.cand_blocks(1)).model_xf;
     model_alphaf = state.blocks(state.cand_blocks(1)).model_alphaf;
     
%      model_xf     = cell(1, state.numLayers);
%      model_alphaf = cell(1, state.numLayers);
%      aa = state.total_pos_data(state.blocks(state.curBlock).frames(1));
%      [model_xf, model_alphaf] = updateModel(aa{1}, state.yf, state.interp_factor, state.lambda, 1, ...
%        model_xf, model_alphaf);
   
%      model_xf     = state.blocks(state.cand_blocks(1)).model_xf;
%     model_alphaf = state.blocks(state.cand_blocks(1)).model_alphaf;
    
     for i = 1:length(parent_data)
    [model_xf, model_alphaf] = updateModel(parent_data{i}, state.yf, state.interp_factor, state.lambda, state.To, ...
       model_xf, model_alphaf);
     end
%    if pid ~= 0
        state.blocks(state.curBlock).model_xf = model_xf;
        state.blocks(state.curBlock).model_alphaf = model_alphaf;
%  end
        %%
        state.cand_blocks(end+1) = state.curBlock;
        if length(state.cand_blocks)>state.opts.parent_blocks
          %  state.blocks(state.cand_blocks(1)).cnn = single([]);
%              state.blocks(state.cand_blocks(2)).model_xf =...
%                  state.blocks(state.cand_blocks(1)).model_xf;
%              state.blocks(state.cand_blocks(2)).model_alphaf =...
%                  state.blocks(state.cand_blocks(1)).model_alphaf;
%  
            state.blocks(state.cand_blocks(2)) = state.blocks(state.cand_blocks(1));

            state.blocks(state.cand_blocks(1)).model_xf = single([]);
            state.blocks(state.cand_blocks(1)).model_alphaf = single([]);
            state.cand_blocks = state.cand_blocks(2:end);
        end

        state.curBlock = state.curBlock+1;
    end    
    
    %% DISPLAY
    display=0;
    if display
        subplot(2,1,1);
        imshow(img,'initialmagnification','fit'); hold on;
        
%         rectangle('Position', config.Data.gt(state.To,:), 'EdgeColor', [0 1 0], 'Linewidth', 3);
%         rectangle('Position', result(state.To,:), 'EdgeColor', [1 0 0], 'Linewidth', 3);
         rectangle('Position', location, 'EdgeColor', [0 1 0], 'Linewidth', 1);
         
        set(gca,'position',[0 0.5 1 0.5]);
%        score_max=max(scores);
        text(10,10,num2str(state.To),'Color','y', 'HorizontalAlignment', 'left', 'FontWeight','bold', 'FontSize', 30); % frameIndex
%        text(10,size(img,1)-10,num2str(score_max),'Color','b', 'HorizontalAlignment', 'left', 'FontWeight','bold', 'FontSize', 30); % frameIndex
        hold off; drawnow; pause(0.001);
        set(gca,'position',[0.1 0.05 0.8 0.4]);
    end
end

% ========================================
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



function [pos,response_max]= predictPosition(feat, pos, indLayers, nweights,cell_size, l1_patch_num, ...
    model_xf, model_alphaf)

% ================================================================================
% Compute correlation filter responses at each layer
% ================================================================================
res_layer = zeros([l1_patch_num, length(indLayers)]);

for ii = 1 : length(indLayers)
    zf = fft2(feat{ii});
    kzf=sum(zf .* conj(model_xf{ii}), 3) / numel(zf);
    
    temp= real(fftshift(ifft2(model_alphaf{ii} .* kzf)));  %equation for fast detection
    res_layer(:,:,ii)=temp/max(temp(:));
end

% Combine responses from multiple layers (see Eqn. 5)
response = sum(bsxfun(@times, res_layer, nweights), 3);

% ================================================================================
% Find target location
% ================================================================================
% Target location is at the maximum response. we must take into
% account the fact that, if the target doesn't move, the peak
% will appear at the top-left corner, not at the center (this is
% discussed in the KCF paper). The responses wrap around cyclically.
[vert_delta, horiz_delta] = find(response == max(response(:)), 1);
vert_delta  = vert_delta  - floor(size(zf,1)/2);
horiz_delta = horiz_delta - floor(size(zf,2)/2);

% Map the position to the image space
pos = pos + cell_size * [vert_delta - 1, horiz_delta - 1];
response_max =max(max(response));

end