% Gets a color histogram for each patch
%
% input:
%   patches_by_image: an array of arrays of patches
%   num_buckets: number of color buckets to use for each color dimension
%
% output:
%   hists_by_image: an array of arrays of color histograms, one for each patch
%   all_hists: a matrix of all histograms, given to simply calculating clusters
%
function [hists_by_image, all_hists] = GetColorHistForPatches(patches_by_image, num_buckets)
    hists_by_image = {};
    all_hists = [];
    for i=1:length(patches_by_image)
        patches = patches_by_image{i};
        hists = {};
        for j=1:length(patches)
            patch = patches{j};
            rgbHist = RgbHist(patch, num_buckets);
            hists{j} = reshape(rgbHist, [1 num_buckets^3]);
            all_hists(end+1,1:num_buckets^3) = hists{j};
        end
        hists_by_image{end+1} = hists;
    end
endfunction
