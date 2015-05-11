% Creates num_sets number of train/test sets
%
% num_sets: the number of train/test sets to create
% precent_test: the percent of the data used for testing
% num_examples_used: if given, it will only use this many examples for each split.
%
function bootstrapSamples = GetBootstrapSamples(train_imgs, train_classes, num_sets=3, percent_test=0.3, num_examples_used=0)

  bootstrapSamples = {};
  N = ifelse(iscell(train_imgs), length(train_imgs), rows(train_imgs));
  num_examples_used = ifelse(num_examples_used, num_examples_used, N);
  idx = floor(num_examples_used*percent_test);

  for k=1:num_sets,
      indexes = randperm(N);
      test_indexes = indexes(1:idx);
      train_indexes  = indexes(idx+1:num_examples_used);
      if iscell(train_imgs)
          bootstrapSamples{k,1} = train_imgs(train_indexes);
          bootstrapSamples{k,2} = train_imgs(test_indexes);
          bootstrapSamples{k,3} = train_classes(train_indexes);
          bootstrapSamples{k,4} = train_classes(test_indexes);
      else
          bootstrapSamples{k,1} = train_imgs(train_indexes,:);
          bootstrapSamples{k,2} = train_imgs(test_indexes,:);
          bootstrapSamples{k,3} = train_classes(train_indexes);
          bootstrapSamples{k,4} = train_classes(test_indexes);
      end
  end
endfunction
