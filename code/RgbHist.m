function H = RgbHist(image, num_buckets)

H = zeros(num_buckets, num_buckets, num_buckets);
for y=1:size(image, 1)
    for x=1:size(image, 2)
        color = double(reshape(image(y,x,:), [1 3]));
        buckets = floor(color/(256/num_buckets)) + 1;
        H(buckets(1), buckets(2), buckets(3)) += 1;
    end
end

endfunction
