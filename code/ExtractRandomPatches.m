function [patches] = ExtractRandomPatches(img, num_patches, dim)
    img_dims = size(img)(1:2);
    y_max = img_dims(1)-dim+1; 
    x_max = img_dims(2)-dim+1;
    patches = {};
    for k=1:num_patches
        y = round(rand(1)*(y_max-1)+1); 
        x = round(rand(1)*(x_max-1)+1);
        patches{end+1} = img(y:y+dim-1,x:x+dim-1,:);
    end
endfunction
