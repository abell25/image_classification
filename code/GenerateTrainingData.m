function [X_train, X_test, y_train, y_test] = ...
    GenerateTrainingData(train_imgs, test_imgs, train_classes, test_classes, ...
        patches_per_image=10, patch_dim=20, num_color_buckets=3, num_centers=20, ...
        train_subset=0, test_subset=0)

  q = 1; %be quiet!
  colors_dim = num_color_buckets^3;

  % if train/test subset not used, then use all the images given
  train_subset = ifelse(train_subset, train_subset, length(train_imgs));
  test_subset = ifelse(test_subset, test_subset, length(test_imgs));

  train_indexes = randperm(length(train_imgs))(1:train_subset);
  test_indexes  = randperm(length(test_imgs))(1:test_subset);

  
  if !q, printf('loading %d patches, %d patches with dim %d\n', ...
          length(train_imgs), patches_per_image, patch_dim); tic;
  end
  train_patches = GetPatches(train_imgs(train_indexes), patches_per_image, patch_dim);
  test_patches = GetPatches(test_imgs(test_indexes), patches_per_image, patch_dim);
  if !q, printf('completed in %d seconds\n', toc); tic; end
  
  if !q, printf('generating histograms using %d color buckets\n', num_color_buckets); end
  [train_hists train_hists_matrix] = GetFeaturesForPatches(train_patches, num_color_buckets);
  [test_hists test_hists_matrix] = GetFeaturesForPatches(test_patches, num_color_buckets);
  if !q, printf('completed in %d seconds\n', toc); tic; end
  
  if !q, printf('running clustering algorithm\n'); end
  [centers, distances] = GetClusters(train_hists_matrix, num_centers);
  if !q, printf('completed in %d seconds\n', toc); tic; end
  
  if !q, printf('calculating distances from centers\n'); end
  train_center_distances = GetDistances(centers, train_hists);
  test_center_distances = GetDistances(centers, test_hists);
  if !q, printf('completed in %d seconds\n', toc); tic; end
  
  if !q, printf('generating histograms of center memberships\n'); end
  train_center_counts = GetCenterFeatures(train_center_distances);
  test_center_counts = GetCenterFeatures(test_center_distances);
  if !q, printf('completed in %d seconds\n', toc); end
  
  X_train = train_center_counts;
  X_test = test_center_counts;
  y_train = train_classes(train_indexes)';
  y_test = test_classes(test_indexes)';
endfunction



function [patches] = GetPatches(images, num_patches, patch_dim)
  patches = {};
  for k=1:length(images)
      patches{end+1} = ExtractRandomPatches(images{k}, num_patches, patch_dim);
  end
endfunction

function [hists hists_matrix] = GetFeaturesForPatches(patches, num_buckets)
    [hists hists_matrix] = GetColorHistForPatches(patches, num_buckets);
endfunction


function [centers, distances] = GetClusters(hists_matrix, num_centers)
    [idx, centers, _, distances] = ... 
        kmeans(hists_matrix, num_centers, 'emptyaction', 'singleton');
endfunction

% center_features: 1 row per image, with num_centers columns
function final_features = GetCenterFeatures(train_center_distances)
  final_features = GetCenterHists(train_center_distances);
endfunction


