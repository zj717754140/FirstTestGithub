function x = get_features(im, features, cell_size, cos_window)
%GET_FEATURES
%   Extracts dense features from image.
%
%   X = GET_FEATURES(IM, FEATURES, CELL_SIZE)
%   Extracts features specified in struct FEATURES, from image IM. The
%   features should be densely sampled, in cells or intervals of CELL_SIZE.
%   The output has size [height in cells, width in cells, features].
%
%   To specify HOG features, set field 'hog' to true, and
%   'hog_orientations' to the number of bins.
%
%   To experiment with other features simply add them to this function
%   and include any needed parameters in the FEATURES struct. To allow
%   combinations of features, stack them with x = cat(3, x, new_feat).
%
%   Joao F. Henriques, 2014
%   http://www.isr.uc.pt/~henriques/
imHeight=size(im,1);
imWidth=size(im,2);

n_min=0;
n_max=255;
numCh=1;  % number of channels of the color model

if strcmp(features.colorModel,'GRAY')
    numCh=1;
    if(size(im,3)==3)
        ccdata=rgb2gray(im);
    else
        ccdata=im;
    end
    ccdata=double(ccdata);
    %    ccdata=min_max_norm(ccdata,n_min,n_max);
elseif strcmp(features.colorModel,'RGB')
    numCh=3;
    ccdata=im;
    ccdata=double(ccdata);
    %     ccdata(:,:,1)=min_max_norm(ccdata(:,:,1),n_min,n_max);
    %     ccdata(:,:,2)=min_max_norm(ccdata(:,:,2),n_min,n_max);
    %     ccdata(:,:,3)=min_max_norm(ccdata(:,:,3),n_min,n_max);
elseif strcmp(features.colorModel,'NRGB')
    numCh=2;
    ccdata=zeros(imHeight,imWidth,2);
    ccdata=double(ccdata);
    im=double(im);
    ccdata(:,:,1)=im(:,:,1);
    ccdata(:,:,2)=im(:,:,2);
    %ccdata(:,:,3)=im(:,:,3);
    tpdata=im(:,:,1)+im(:,:,2)+im(:,:,3);
    ccdata(:,:,1)=ccdata(:,:,1)./tpdata;
    ccdata(:,:,2)=ccdata(:,:,2)./tpdata;
    %ccdata(:,:,3)=ccdata(:,:,3)./tpdata;
    
    tpdata=ccdata(:,:,1);
    tpdata(find(tpdata==Inf))=0;
    tpdata(find(tpdata==-Inf))=0;
    ccdata(:,:,1)=tpdata;
    tpdata=ccdata(:,:,2);
    tpdata(find(tpdata==Inf))=0;
    tpdata(find(tpdata==-Inf))=0;
    ccdata(:,:,2)=tpdata;
    %     tpdata=ccdata(:,:,3);
    %     tpdata(find(tpdata==Inf))=0;
    %     tpdata(find(tpdata==-Inf))=0;
    %     ccdata(:,:,3)=tpdata;
    
    tpdata=ccdata(:,:,1);
    tpinx=isnan(tpdata);
    tpdata(find(tpinx==1))=0;
    ccdata(:,:,1)=tpdata;
    tpdata=ccdata(:,:,2);
    tpindex=isnan(tpdata);
    tpdata(find(tpinx==1))=0;
    ccdata(:,:,2)=tpdata;
    %     tpdata=ccdata(:,:,3);
    %     tpindex=isnan(tpdata);
    %     tpdata(find(tpinx==1))=0;
    %     ccdata(:,:,3)=tpdata;
    
    ccdata(:,:,1)=min_max_norm(ccdata(:,:,1),n_min,n_max);
    ccdata(:,:,2)=min_max_norm(ccdata(:,:,2),n_min,n_max);
    %    ccdata(:,:,3)=min_max_norm(ccdata(:,:,3),n_min,n_max);
elseif strcmp(features.colorModel,'HSV')
    numCh=3;
    ccdata=rgb2hsv(im);
    ccdata=double(ccdata);
    ccdata(:,:,1)=min_max_norm(ccdata(:,:,1),n_min,n_max);
    ccdata(:,:,2)=min_max_norm(ccdata(:,:,2),n_min,n_max);
    ccdata(:,:,3)=min_max_norm(ccdata(:,:,3),n_min,n_max);
elseif strcmp(features.colorModel,'OPPONENT')
    numCh=3;
    ccdata=zeros(imHeight,imWidth,3);
    ccdata=double(ccdata);
    im=double(im);
    ccdata(:,:,1)=(im(:,:,1)-im(:,:,2))./sqrt(2);
    ccdata(:,:,2)=(im(:,:,1)+im(:,:,2)-2*im(:,:,3))./sqrt(6);
    ccdata(:,:,3)=(im(:,:,1)+im(:,:,2)+im(:,:,3))./sqrt(3);
    ccdata(:,:,1)=min_max_norm(ccdata(:,:,1),n_min,n_max);
    ccdata(:,:,2)=min_max_norm(ccdata(:,:,2),n_min,n_max);
    ccdata(:,:,3)=min_max_norm(ccdata(:,:,3),n_min,n_max);
elseif  strcmp(features.colorModel,'COPPONENT')
    numCh=2;
    ccdata=zeros(imHeight,imWidth,2);
    ccdata=double(ccdata);
    im=double(im);
    ccdata(:,:,1)=(im(:,:,1)-im(:,:,2))./sqrt(2);
    ccdata(:,:,2)=(im(:,:,1)+im(:,:,2)-2*im(:,:,3))./sqrt(6);
    ccdata(:,:,1)=min_max_norm(ccdata(:,:,1),n_min,n_max);
    ccdata(:,:,2)=min_max_norm(ccdata(:,:,2),n_min,n_max);
elseif strcmp(features.colorModel,'NOPPONENT')
    numCh=2;
    ccdata=zeros(imHeight,imWidth,2);
    ccdata=double(ccdata);
    im=double(im);
    ccdata(:,:,1)=(im(:,:,1)-im(:,:,2))./sqrt(2);
    ccdata(:,:,2)=(im(:,:,1)+im(:,:,2)-2*im(:,:,3))./sqrt(6);
    tpdata=(im(:,:,1)+im(:,:,2)+im(:,:,3))./sqrt(3);
    ccdata(:,:,1)=ccdata(:,:,1)./tpdata;
    ccdata(:,:,2)=ccdata(:,:,2)./tpdata;
    
    tpdata=ccdata(:,:,1);
    tpdata(find(tpdata==Inf))=0;
    tpdata(find(tpdata==-Inf))=0;
    ccdata(:,:,1)=tpdata;
    tpdata=ccdata(:,:,2);
    tpdata(find(tpdata==Inf))=0;
    tpdata(find(tpdata==-Inf))=0;
    ccdata(:,:,2)=tpdata;
    tpdata=ccdata(:,:,1);
    tpinx=isnan(tpdata);
    tpdata(find(tpinx==1))=0;
    ccdata(:,:,1)=tpdata;
    tpdata=ccdata(:,:,2);
    tpindex=isnan(tpdata);
    tpdata(find(tpinx==1))=0;
    ccdata(:,:,2)=tpdata;
    
    ccdata(:,:,1)=min_max_norm(ccdata(:,:,1),n_min,n_max);
    ccdata(:,:,2)=min_max_norm(ccdata(:,:,2),n_min,n_max);
elseif strcmp(features.colorModel,'HUE')
    numCh=1;
    ccdata=zeros(imHeight,imWidth,1);
    ccdata=double(ccdata);
    im=double(im);
    tpdata_1=(im(:,:,1)-im(:,:,2))./sqrt(2);
    tpdata_2=(im(:,:,1)+im(:,:,2)-2*im(:,:,3))./sqrt(6);
    ccdata=tpdata_1./tpdata_2;
    ccdata(find(ccdata==Inf))=0;
    ccdata(find(ccdata==-Inf))=0;
    tpinx=isnan(ccdata);
    ccdata(find(tpinx==1))=0;
    ccdata=min_max_norm(ccdata,n_min,n_max);
elseif strcmp(features.colorModel,'TRGB')
    numCh=3;
    ccdata=zeros(imHeight,imWidth,3);
    ccdata=double(ccdata);
    im=double(im);
    
    ccdata(:,:,1)=im(:,:,1);
    tp_data=ccdata(:,:,1);
    tp_col_data=tp_data(:);
    tp_mean=mean(tp_col_data);
    tp_std=std(tp_col_data);
    ccdata(:,:,1)=ccdata(:,:,1)-tp_mean;
    ccdata(:,:,1)=ccdata(:,:,1)/tp_std;
    
    ccdata(:,:,2)=im(:,:,2);
    tp_data=ccdata(:,:,2);
    tp_col_data=tp_data(:);
    tp_mean=mean(tp_col_data);
    tp_std=std(tp_col_data);
    ccdata(:,:,2)=ccdata(:,:,2)-tp_mean;
    ccdata(:,:,2)=ccdata(:,:,2)/tp_std;
    
    ccdata(:,:,3)=im(:,:,3);
    tp_data=ccdata(:,:,3);
    tp_col_data=tp_data(:);
    tp_mean=mean(tp_col_data);
    tp_std=std(tp_col_data);
    ccdata(:,:,3)=ccdata(:,:,3)-tp_mean;
    ccdata(:,:,3)=ccdata(:,:,3)/tp_std;
    
    tpdata=ccdata(:,:,1);
    tpdata(find(tpdata==Inf))=0;
    tpdata(find(tpdata==-Inf))=0;
    ccdata(:,:,1)=tpdata;
    tpdata=ccdata(:,:,2);
    tpdata(find(tpdata==Inf))=0;
    tpdata(find(tpdata==-Inf))=0;
    ccdata(:,:,2)=tpdata;
    tpdata=ccdata(:,:,3);
    tpdata(find(tpdata==Inf))=0;
    tpdata(find(tpdata==-Inf))=0;
    ccdata(:,:,3)=tpdata;
    tpdata=ccdata(:,:,1);
    tpinx=isnan(tpdata);
    tpdata(find(tpinx==1))=0;
    ccdata(:,:,1)=tpdata;
    tpdata=ccdata(:,:,2);
    tpindex=isnan(tpdata);
    tpdata(find(tpinx==1))=0;
    ccdata(:,:,2)=tpdata;
    tpdata=ccdata(:,:,3);
    tpindex=isnan(tpdata);
    tpdata(find(tpinx==1))=0;
    ccdata(:,:,3)=tpdata;
    
    
    ccdata(:,:,1)=min_max_norm(ccdata(:,:,1),n_min,n_max);
    ccdata(:,:,2)=min_max_norm(ccdata(:,:,2),n_min,n_max);
    ccdata(:,:,3)=min_max_norm(ccdata(:,:,3),n_min,n_max);
elseif strcmp(features.colorModel,'LAB')
    numCh=3;
    cform = makecform('srgb2lab');
    ccdata = applycform(im,cform);
    ccdata = double(ccdata);
    ccdata(:,:,1)=min_max_norm(ccdata(:,:,1),n_min,n_max);
    ccdata(:,:,2)=min_max_norm(ccdata(:,:,2),n_min,n_max);
    ccdata(:,:,3)=min_max_norm(ccdata(:,:,3),n_min,n_max);
else
    error('The color type is not correct');
end


if features.hog,
    %HOG features, from Piotr's Toolbox
    x = double(fhog(single(ccdata(:,:,1)) / 255, cell_size, features.hog_orientations));
    x(:,:,end) = [];  %remove all-zeros channel ("truncation feature")
   for i=2:numCh
        tpx = double(fhog(single(ccdata(:,:,i)) / 255, cell_size, features.hog_orientations));
        tpx(:,:,end) = [];
        if i==1
            x = tpx;
        else
            x = cat(3, x, tpx);
        end
   end
end

if features.gray,
    %gray-level (scalar feature)
    x = double(im) / 255;
    
    x = x - mean(x(:));
end

%process with cosine window if needed
if ~isempty(cos_window),
    x = bsxfun(@times, x, cos_window);
end

end
