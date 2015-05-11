1;
pkg load image;
pkg load statistics;
pkg load parallel;

if !exist('train_imgs', 'var')
    printf('loading images\n'); tic;
    [train_imgs, train_classes, test_imgs, test_classes] = TrainTestSplitImages()
    printf('completed in %d seconds\n', toc);
else
    printf('images already loaded!\n');
end

%%%%%%%%%%%%%%%%%%%%%%% Exploratory Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%

function [img_all] = seeAllClasses(images, num_examples)
    image_idxs = round(linspace(1, size(images)(2), 4*num_examples));
    small_imgs = {}; 
    for k=1:columns(image_idxs)
        img = images{image_idxs(k)};
        small_imgs{k} = imresize(img, [100, 100]);
    end
    img_all = CombinePatches(small_imgs, num_examples, 4);
endfunction

function [all_combined] = seeAllClassesPatches(images, num_examples)
    image_idxs = round(linspace(1, size(images)(2), 4*num_examples));
    all_patches = {};
    for k=1:columns(image_idxs)
      patches = ExtractRandomPatches(images{image_idxs(k)}, 100, 25);
      all_patches{k} = CombinePatches(patches, 10, 10);
    end
    all_combined = CombinePatches(all_patches, num_examples, 4);
endfunction

function viewData(images, num_examples, num_patch_examples)
    figure(1);
    img_classes = seeAllClasses(images, num_examples);
    imshow(img_classes);
    
    figure(2);
    patches_classes = seeAllClassesPatches(images, num_patch_examples);
    imshow(patches_classes);
endfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [score, y_pred] = Predict(clf, train_imgs, test_imgs, train_classes, test_classes, args)
    parameters = args;
    [y_pred, score] = clf(train_imgs, test_imgs, train_classes, test_classes, args);
endfunction


function plot_scores(scores, cv_scores, params, labels)
    hold on;
    for k=1:numel(labels),
        if numel(cv_scores), 
            subplot(2,3,k);
            plot(params(:,k), scores, 'rx', 'linewidth', 2, params(:,k), cv_scores, 'r.', 'linewidth', 1);
        else
            subplot(2,3,k);
            hold on;
            plot(params(:,k), scores, 'bx', 'linewidth', 2);
            hold off;
        end
        ylabel('score');
        xlabel(labels{k});
        title(['score vs ', labels{k}]);
    end
    hold off;
endfunction

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% running parameter sweep %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf('starting\n');
start_time = time();
fflush(stdout);

labels = {'patches per image', 'patch dim', 'num color buckets', 'num centers', 'num examples'};
patches_per_image_list = [50];
patch_dim_list = [30];
num_color_buckets_list = [4];
num_centers_list = [500];
num_examples_list = [16];
use_parallel = 0;

parameters = {patches_per_image_list, patch_dim_list, num_color_buckets_list, num_centers_list, num_examples_list};

[scores, cv_scores, params, total_times] = ParameterSweep(@Pipeline, train_imgs, test_imgs, train_classes, test_classes, ...
                                              parameters, num_splits=1, test_percent=0.25, use_parallel)


ranked = flipud(sortrows([params scores' total_times'], columns(params)+1));
ranked_params = ranked(:,1:columns(params));
ranked_scores = ranked(:,columns(params)+1);
ranked_times = ranked(:,columns(params)+2);

end_time = time();
printf('finished parameter sweep in %.2f seconds!\n', end_time-start_time);
fflush(stdout);

figure(1);
plot_scores(scores, cv_scores, params, labels);
figure(2);
plot_scores(scores, cv_scores, params, labels);

start_validation = time();
n_best_to_try = 0;
n_best_to_try = min(rows(params), n_best_to_try);
printf('using the best %d parameters to predict on the validation set\n', n_best_to_try);

f = @(k) Predict(@Pipeline, train_imgs, test_imgs, ...
                 train_classes, test_classes, args=ranked_params(k,:));

if use_parallel,
    [validation_scores_arr, predictions_arr] = pararrayfun(min(nproc, n_best_to_try), f, [1:n_best_to_try], 'UniformOutput', false);
else
    [validation_scores_arr, predictions_arr] = arrayfun(f, [1:n_best_to_try], 'UniformOutput', false);
end

for k=1:n_best_to_try, validation_scores(k) = validation_scores_arr{k}; end
validation_params = ranked_params(1:n_best_to_try,1:columns(params)-1);

validation_scores
[best_score best_score_index] = max(validation_scores);
printf('best parameters on the validation set scored %.2f\n', max(validation_scores));

figure(2);
plot_scores(validation_scores, [], validation_params, labels(1:end-1));
figure(3);
plot_scores(validation_scores, [], validation_params, labels(1:end-1));

printf('finished validation in %.2f seconds!\n', time() - start_validation);
[confusionMatrix, class_accuracy, class_sensitivity, class_precision] = ...
        confusionMatrix(test_classes', predictions_arr{best_score_index}', 4)

