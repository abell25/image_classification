function [M, accuracy, sensitivity, precision] = confusionMatrix(y_pred, y_true, num_classes)

    M = zeros(num_classes, num_classes);
    N = numel(y_true);

    for actual=1:num_classes,
        for pred=1:num_classes,
            M(pred, actual) = sum(y_pred == pred & y_true == actual);
        end
    end

    for k=1:num_classes,
        num_true = sum(y_true == k);
        num_false = N - num_true;
        TP = sum(y_true == k & y_pred == k);
        TN = sum(y_true != k & y_pred != k);
        FP = sum(y_true == k & y_pred != k);
        FN = sum(y_true != k & y_pred == k);
        accuracy(k) = (TP + TN)/N * 100.0;
        sensitivity(k) = TP / (TP + FN);
        precision(k)   = TP / (TP + FP);
    end

endfunction
