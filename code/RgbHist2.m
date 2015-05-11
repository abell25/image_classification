function H = RgbHist2(image, num_buckets)

H = zeros(num_buckets, num_buckets, num_buckets);
%for y=1:size(image, 1)
%    for x=1:size(image, 2)
%        color = double(reshape(image(y,x,:), [1 3]));
%        buckets = floor(color/(256/num_buckets)) + 1;
%        H(buckets(1), buckets(2), buckets(3)) += 1;
%    end
%end

bins = [];
bins(:,1) = floor(image(:,:,1)(:)/(256/num_buckets)) + 1;
bins(:,2) = floor(image(:,:,2)(:)/(256/num_buckets)) + 1;
bins(:,3) = floor(image(:,:,3)(:)/(256/num_buckets)) + 1;
f = @(i) H(bins(i,1), bins(i,2), bins(i,3)) += 1;
arrayfun(f, [1:size(image,1)*size(image,2)]);

endfunction
