%% Support Vector Data Description (SVDD) of Roller Bearing time series
% Detection of Outliers in Rolling Element Bearing Datasets using Support
% Vector Data Description
%% Preprocessing 
%Split Roller Bearing time signals into segments of 5 revolutions 
numberOfRevolutionsPerSegment=5;
rpm=1796;
sampleFrequency=48000;
normalSegments=SplitSignal(...
    rollerBearingNormalData,...
    rpm,...
    sampleFrequency,...
    numberOfRevolutionsPerSegment); 
ballFaultSegments=SplitSignal(...
    rollerBearingBallFaultData,...
    rpm,...
    sampleFrequency,...
    numberOfRevolutionsPerSegment); 
innerRacewayFaultSegments=SplitSignal(...
    rollerBearingInnerRacewayFaultData,...
     rpm,...
     sampleFrequency,...
     numberOfRevolutionsPerSegment); 
 outerRacewayFaultSegments=SplitSignal(...
    rollerBearingOuterRacewayFaultData,...
     rpm,...
     sampleFrequency,...
     numberOfRevolutionsPerSegment);
%   % Feature Extraction
%   Extracts Kurtosis (k),Mel Frequency Cepstrum Coefficients (c) and Multifractal
%   Dimensions (m) as 27-tupels in the format (c1...c13,m1...,m13,k) (3)
  normalFeatures = ...
      ScaleFeatures(ExtractFeatures(normalSegments, sampleFrequency));
  ballFaultFeatures =...
      ScaleFeatures(ExtractFeatures(ballFaultSegments,sampleFrequency));
  innerRacewayFaultFeatures =...
      ScaleFeatures(ExtractFeatures(innerRacewayFaultSegments,sampleFrequency));
  outerRacewayFaultFeatures=...
      ScaleFeatures(ExtractFeatures( outerRacewayFaultSegments,sampleFrequency));
  % Data set construction
  normalFeaturesDataSet=dataset(normalFeatures);
  ballFaultFeaturesDataSet=dataset(ballFaultFeatures);
  innerRacewayFaultFeaturesDataset=dataset( innerRacewayFaultFeatures );
  outerRacewayFaultFeaturesDataset=dataset(  outerRacewayFaultFeatures);
  %Creates a target data training set with normal features
  normalFeaturesOcDataset =...
      gendatoc(normalFeaturesDataSet);
  %Creates an outlier dataset with ball fault features
  ballFaultFeaturesOcDataset =...
      gendatoc([],  ballFaultFeaturesDataSet);
  %Creates an outlier dataset with inner raceway fault features
  innerRacewayFaultFeaturesOcDataset=...
      gendatoc([],  innerRacewayFaultFeaturesDataset);
  %Creates an outlier dataset with outer raceway fault features
  outerRacewayFaultFeaturesOcDataset=...
      gendatoc([],  outerRacewayFaultFeaturesDataset);
 %% Definition of performance measures
 numberOfRuns=10;
 numberOfFeatures=size(normalFeaturesOcDataset,2);
 parzenWindowsRejectedNormals =zeros(1,numberOfRuns);
 parzenWindowsAcceptedOutliers= zeros(1,numberOfRuns);
 parzenWindowsTrainingRuntime=zeros(1,numberOfRuns);
 parzenWindowsTestingRuntime=zeros(1,numberOfRuns);
 %% Iterative training and testing
 for i=1:numberOfRuns
     %Create a test dataset with 50 random samples drawn from each dataset
     numberOfTestSamplesPerClass=90; %Should be divisible by 3 for a balanced test set
     [targetTestSet,trainingSet]=...
         gendat(normalFeaturesOcDataset, numberOfTestSamplesPerClass);
     [ballFaultTestSet]=...
         gendat(ballFaultFeaturesOcDataset, numberOfTestSamplesPerClass/3);
     [innerRacewayFaultTestSet]=...
         gendat(innerRacewayFaultOutliers,numberOfTestSamplesPerClass/3);
     [outerRacewayFaultTestSet]=...
         gendat(outerRacewayFaultFeaturesOcDataset,numberOfTestSamplesPerClass/3);  
     testSet=[targetTestSet;...
         ballFaultTestSet;...
         innerRacewayFaultTestSet;...
         outerRacewayFaultTestSet];
     fractionOfRejectedTrainingData=0.1;
     % Parzen-dd
     tic;
     w = parzen_dd(trainingSet, fractionOfRejectedTrainingData);
     parzenWindowsTrainingRuntime(i)=toc;
     tic;
     e = dd_error(testSet,w);
     parzenWindowsTestingRuntime(i)=toc;
     parzenWindowsRejectedNormals(i) =   e(1);
     parzenWindowsAcceptedOutliers(i)=   e(2);
      tic;
 end
 test=parzenWindowsTrainingRuntime(1,:)
 averageParzenWindowsTrainingRuntime=mean(parzenWindowsTrainingRuntime(1,:))
 averageParzenWindowsTestingRuntime=mean(parzenWindowsTestingRuntime(1,:))
 averageParzenWindowsRejectedNormals=mean(parzenWindowsRejectedNormals(1,:))
 averageParzenWindowsAcceptedOutliers=mean(parzenWindowsAcceptedOutliers(1,:))
 averageParzenWindowsAccuracy=CalculateAccuracy(averageParzenWindowsRejectedNormals,averageParzenWindowsAcceptedOutliers,testSet)
 %% References
 % # PRTools4, A Matlab Toolbox for Pattern Recognition Version 4.1
 % (R.P.W. Duin,D.M.J. Tax et al.)
 % # <http://csegroups.case.edu/bearingdatacenter/pages/welcome-case-western-reserve-university-bearing-data-center-website>


  