% function GetCenterHists
%   converts an array of matrices of patch x center distances to
%   a matrix of histogram counts for each centroid.
%
% input:  
%   distances : m [n p] matrices of distances from p centroids,
%         for m images with n patches and p clusters
% output: 
%   center_hists : [m p] matrix of counts, where a value i in 1:p
%         is incremented when a row has the smallest distance at
%         at index i.

function [center_hists] = GetCenterHists(distances)
    num_examples = size(distances, 2);
    num_centers = size(distances{1}, 2);
    center_hists = zeros(num_examples, num_centers);
    for i=1:num_examples
        counts = zeros(1, num_centers);
        [values clusters] = max(distances{i}');
        for j=1:length(clusters)
            counts(clusters(j)) += 1;
        end
        center_hists(i, 1:num_centers) = counts;
    end
endfunction

