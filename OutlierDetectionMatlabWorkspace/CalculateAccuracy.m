function accuracy = CalculateAccuracy(rejectedNormalsRatio,acceptedOutliersRatio,testSet)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
labels=getlabels(testSet);
numberOfTargets=0;
numberOfOutliers=0;
for i = 1:size(labels,1),
    if strcmp(labels(i),'t'),
        numberOfTargets=numberOfTargets+1;
    end
end
numberOfOutliers=size(labels,1)-numberOfTargets;
truePositives=(1-rejectedNormalsRatio)*numberOfTargets;
trueNegatives=(1-acceptedOutliersRatio)*numberOfOutliers;
falsePositives=acceptedOutliersRatio*numberOfOutliers;
falseNegatives=rejectedNormalsRatio*numberOfTargets;
accuracy=(truePositives+trueNegatives)/(truePositives+trueNegatives+falsePositives+falseNegatives);
end

