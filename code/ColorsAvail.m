1;

num_rows = 20;
num_cols = 20;
N = 3;
u = floor(255/N);
vals = [1:N]*u;

squareSize = 10;
img = uint8(zeros(10*20, 10*20, 3));
k=1;
all_colors = {};
for r=vals
    for g=vals
        for b=vals
            color = [r g b];
            all_colors{end+1} = color;
        end
    end
end


num_colors = numel(all_colors);
k=0;
for y=1:num_rows,
    for x=1:num_cols,
        k = ifelse(k == num_colors, 1, k+1);
        start_y = 1+(y-1)*squareSize;
        start_x = 1+(x-1)*squareSize;
        for i=1:squareSize,
            for j=1:squareSize,
       % img(1+(y-1)*squareSize:y*squareSize,1+(x-1)*squareSize:x*squareSize,:) = all_colors{k};
      img(start_y+i,start_x+j,:) = all_colors{k};
            end
        end
    end
end

imshow(img);
