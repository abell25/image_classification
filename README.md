## Image classification pipeline
> author: Anthony Bell

This project constructs a image category classification pipeline.

The main Pipeline class is in `Pipeline.m`.
The pipeline consists of the following stages:

```
% 1. Generating patches from the images
function [patches] = GetPatches(images, num_patches, patch_dim)
% 2. Generating features from the patches
function [hists] = GetFeaturesForPatches(patches, num_buckets)
% 3. Creating a codebook from the features
function [centers] = GetClusters(hists_matrix, num_centers)
% 4. Generating a vector of features for each image from the codebook.
function final_features = GetCenterFeatures(center_distances)
% 5. Classify using the vector of features for each image
function [y_pred, score] = TrainAndClassify(X_train, X_test, y_train, y_test)
```

Any of these stages can be swapped out be having the interface method call a different implementation.

To See an example of using the Pipeline, you can look at `HW5.m`.  
To run the whole thing with cross-validation just type `source('HW5.m') in the octave console.`

The files included are teh following:
====================================

* `HW5.m`: top level example of running the pipeline.  type `source('HW5.m') to run.`
* `TrainTestSplitImages.m`: Converts the images from the file system into the train/test split.
* `ExtractRandomPatches.m`: Extracts random patches from a list of images
* `RgbHist.m`: Calculates a histogram using `num_buckets` number of buckets for each of the rgb color channels.
* `GetColorHistForPatches.m`: Gets color histograms for an array of rgb image patches, using `RgbHist` as a sub-routine.
* `GetDistances.m`: Calculates the distances for all the images from the list of centers generated from the clustering algorithm.
* `GetCenterHists.m`: Converts an marray of matrices of patch x center distances to a matrix of histogram counts for each centroid.
* `allCombinations.m`: helper function to generate all possible combinations from an array of lists.
* `ParameterSweep.m`: Takes an array of lists of hyper-parameter values with a classifier and runs a k-split parameter sweep over the values. 
* `GetBootstrapSamples.m`: Takes a train set with labels and outputs k-splits of the data, partitioning `test_percent` of the data into a test set for each split.
* `ColorsAvail.m`: visualization of the color range available for a given binning of the color space.
* `confusionMatrax.m`: calculates a confusion matrix, along with per-class accuracy, precision, and specificity percentages.
