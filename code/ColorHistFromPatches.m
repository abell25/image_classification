function H = ColorHistFromPatches(patches, num_buckets)
    all_hists = [];
    for k=1:length(patches)
        patch = patches{k};
        hist = RgbHist(patch, num_buckets);
        all_hists(end+1, 1:num_buckets^3) = reshape(hist, [1 num_buckets^3]);
    end
endfunction
