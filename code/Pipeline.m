function [y_pred, score] = Pipeline(train_imgs, test_imgs, train_classes, test_classes, ...
        params=[patches_per_image=50, patch_dim=30, num_color_buckets=4, num_centers=100], ...
        algs={'random', 'colorhist', 'kmeans', 'max_counts', 'svm'})

  q = 1; %be quiet!
  patches_per_image = params(1);
  patch_dim = params(2);
  num_color_buckets = params(3);
  num_centers = params(4);
  colors_dim = num_color_buckets^3;

  train_indexes = randperm(length(train_imgs));
  
  if !q, printf('loading %d patches, %d patches with dim %d\n', ...
          length(train_imgs), patches_per_image, patch_dim); tic;
  end
  train_patches = GetPatches(train_imgs(train_indexes), patches_per_image, patch_dim, algs{1});
  test_patches = GetPatches(test_imgs, patches_per_image, patch_dim, algs{1});
  if !q, printf('completed in %d seconds\n', toc); tic; end
  
  if !q, printf('generating histograms using %d color buckets\n', num_color_buckets); end
  [train_hists train_hists_matrix] = GetFeaturesForPatches(train_patches, num_color_buckets, algs{2});
  [test_hists test_hists_matrix] = GetFeaturesForPatches(test_patches, num_color_buckets, algs{2});
  if !q, printf('completed in %d seconds\n', toc); tic; end
  
  if !q, printf('running clustering algorithm\n'); end
  [centers, distances] = GetClusters(train_hists_matrix, num_centers, algs{3});
  if !q, printf('completed in %d seconds\n', toc); tic; end
  
  if !q, printf('calculating distances from centers\n'); end
  train_center_distances = GetDistances(centers, train_hists);
  test_center_distances = GetDistances(centers, test_hists);
  if !q, printf('completed in %d seconds\n', toc); tic; end
  
  if !q, printf('generating histograms of center memberships\n'); end
  train_center_counts = GetCenterFeatures(train_center_distances, algs{4});
  test_center_counts = GetCenterFeatures(test_center_distances, algs{4});
  if !q, printf('completed in %d seconds\n', toc); end
  
  X_train = train_center_counts;
  X_test = test_center_counts;
  y_train = train_classes(train_indexes)';
  y_test = test_classes';

  [y_pred, score] = TrainAndClassify(X_train, X_test, y_train, y_test, algs{5});

endfunction

%%%%%%%%%%%%%%%%%%%%%%%%%   Pipeline stages   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [patches] = GetPatches(images, num_patches, patch_dim, alg='random')
  patches = {};
  if strcmp(alg, 'random'),
      for k=1:length(images)
          patches{end+1} = ExtractRandomPatches(images{k}, num_patches, patch_dim);
      end
  end
endfunction

function [hists hists_matrix] = GetFeaturesForPatches(patches, num_buckets, alg='colorhist')
    if strcmp(alg, 'colorhist'),
        [hists hists_matrix] = GetColorHistForPatches(patches, num_buckets);
    end
endfunction

function [centers, distances] = GetClusters(hists_matrix, num_centers, alg='kmeans')
    if strcmp(alg, 'kmeans'),
        [idx, centers, _, distances] = ... 
            kmeans(hists_matrix, num_centers, 'emptyaction', 'singleton');
    end
endfunction

function final_features = GetCenterFeatures(train_center_distances, alg='max_counts')
  if strcmp(alg, 'max_counts'),
      final_features = GetCenterHists(train_center_distances);
  end
endfunction

function [y_pred, score] = TrainAndClassify(X_train, X_test, y_train, y_test, alg='svm')
    if strcmp(alg, 'svm'),
        model = svmtrain(y_train, X_train, '-s 0 -t 2 -c 1 -q');
        [y_pred, accuracy, prob_estimates] = svmpredict(y_test, X_test, model);
        score = mean(y_pred == y_test)*100;
    end
endfunction

