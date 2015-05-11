% function GetDistances
%   takes an array of variable length image feature histograms and
%   cluster centers and returns an array of matrices of distances of
%   each feature histogram to the clusters.
%
% input:
%  centers: centers generated from some clustering algorithm over
%      the image features.
%  img_color_hists: the array of matrices of image feature histograms
%
% output:
%  distances: array of feature x center distance matrices

function [distances] = GetDistances(centers, imgs_color_hists)
    num_imgs = length(imgs_color_hists);
    num_centers = size(centers, 1);
    distances = {};
    for i=1:num_imgs
        hists_per_image = length(imgs_color_hists{i});
        hists = imgs_color_hists{i};
        distances{i} = zeros(hists_per_image, num_centers);
        for j=1:hists_per_image
            hist = hists{j};
            dists = sqrt(sum((bsxfun(@minus, hist, centers).^2)'));
            distances{i}(j,1:num_centers) = dists;
        end
    end
endfunction

%function [center_hists] = GetCenterHists(distances)
