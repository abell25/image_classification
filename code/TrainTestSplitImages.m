function [train_images, train_class, test_images, test_class] = TrainTestSplitImages()

    [train_images, train_class, train_files] = loadImages("../data/", "train");
    [test_images, test_class, test_files] = loadImages("../data/", "validation");

endfunction

function [imgs, classes_list, files_list] = loadImages(images_location, type)
    classes = {"airplanes", "cars", "faces", "motorbikes"};
    files_list = {};
    classes_list = [];
    for class_idx=1:size(classes,2)
        imgs_dir = cstrcat(images_location, classes{class_idx}, "_", type, "/");
        imgs_glob = cstrcat(imgs_dir, "*.jpg");
        files = dir(imgs_glob);
        printf("loading %s images for %s\n", type, classes{class_idx});
        for file_idx=1:length(files)
            filename = cstrcat(imgs_dir, files(file_idx).name);
            files_list{end+1} = cstrcat(filename);
            classes_list(end+1) = class_idx;
            printf('files_list = %s, class = %s, %i\n', ... 
                files_list{end}, classes{class_idx}, classes_list(end));
        end
    end

    imgs = {}
    for k=1:size(files_list,2)
        %printf('image: %s\n', files_list{k});
        img = imread(files_list{k});

        %we'll just convert black and white to a color image
        if length(size(img)) == 2
            printf('converting black and white image %s to color\n', files_list{k});
            color_image = uint8(zeros(size(img,1), size(img,2), 3));
            for c=1:3
                color_image(:,:,c) = img;
            end
            img = color_image;
        end

        imgs{end+1} = img;
    end

endfunction

