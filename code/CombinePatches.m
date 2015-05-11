function [img] = CombinePatches(patches, xdim, ydim)
  patch_dims = size(patches{1})(1:2);
  patch_height = patch_dims(1);
  patch_width  = patch_dims(2);
  img_height = patch_height*ydim;
  img_width  = patch_width *xdim;
  img = uint8(ones(img_height, img_width, 3));
  k=1;
  for y=1:ydim,
      img_y = 1 + (y-1)*patch_height;
      for x=1:xdim,
        img_x = 1 + (x-1)*patch_width;
        patch = patches{k};
        img(img_y:img_y+patch_height-1,img_x:img_x+patch_width-1,1:3) = patch;
        k += 1;
      end
  end
endfunction
