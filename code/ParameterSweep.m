function [scores, cv_scores, params, total_times] = ParameterSweep(clf, ...
                        train_imgs, test_imgs, train_classes, test_classes, ...
                        sweep_vals, num_splits, test_percent=0.3, use_parallel=1)

  params = allCombinations(sweep_vals);
  printf('running a parameter sweep with %d unique combinations\n', rows(params));

  scores = [];
  cv_scores = [];
  total_times = [];

  f = @(j) BootstrapPredict(clf, train_imgs, test_imgs, train_classes, test_classes, ...
             params(j,:), num_splits, test_percent=0.3);

  if use_parallel,
      [cv_scores_arr all_times] = pararrayfun(nproc, f, [1:rows(params)], 'UniformOutput', false);
  else
      [cv_scores_arr all_times] = arrayfun(f, [1:rows(params)], 'UniformOutput', false);
  end

  for j=1:numel(cv_scores_arr)
     cv_scores(j,:) = cv_scores_arr{j};
     scores(j) = mean(cv_scores_arr{j});
     total_times(j) = all_times{j};
  end

  printf('parameter sweep completed!\n');
endfunction

% Helper function:
% for a given set of parameters, performs 1 round of splits.
function [cv_scores, total_time] = BootstrapPredict(clf, train_imgs, test_imgs, train_classes, test_classes, ...
                                                    params, num_splits, test_percent)

    start_time = time();

    num_examples = params(end);
    bootstrapSamples = GetBootstrapSamples(train_imgs, train_classes, num_splits, test_percent, num_examples);
    train_size = length(bootstrapSamples{1,3});
    test_size = length(bootstrapSamples{1,4});

    for k=1:rows(bootstrapSamples),
        [bs_train_imgs, bs_test_imgs, bs_train_classes, bs_test_classes] = bootstrapSamples{k,:};
        [y_pred, score] = clf(bs_train_imgs, bs_test_imgs, bs_train_classes, bs_test_classes, params);
        cv_scores(k) = score;
    end
    mean_score = mean(cv_scores);
    end_time = time();
    total_time = end_time - start_time;

endfunction

