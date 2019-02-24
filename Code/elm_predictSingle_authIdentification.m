function [predictedId, TestingTime] = elm_predictSingle_authIdentification(featureVector,elmModel)
    TV.P=featureVector(:,1:size(featureVector,2))';
    NumberofTestingData=1;
    %load elm_model.mat;
    start_time_test=cputime;
    tempH_test=elmModel.InputWeight*TV.P;
    clear TV.P;             %   Release input of testing data             
    ind=ones(1,NumberofTestingData);
    BiasMatrix=elmModel.BiasofHiddenNeurons(:,ind);              %   Extend the bias matrix BiasofHiddenNeurons to match the demention of H
    tempH_test=tempH_test + BiasMatrix;
    switch lower(elmModel.ActivationFunction)
        case {'sig','sigmoid'}
            %%%%%%%% Sigmoid 
            H_test = 1 ./ (1 + exp(-tempH_test));
        case {'sin','sine'}
            %%%%%%%% Sine
            H_test = sin(tempH_test);        
        case {'hardlim'}
            %%%%%%%% Hard Limit
            H_test = hardlim(tempH_test);        
            %%%%%%%% More activation functions can be added here        
    end
    TY=(H_test' * elmModel.OutputWeight)';                       %   TY: the actual output of the testing data
    end_time_test=cputime;
    TestingTime=end_time_test-start_time_test;           %   Calculate CPU time (seconds) spent by ELM predicting the whole testing data
    %[~,predictedId] = max(TY(:,1));%have bug of non sequential author ids
    [~,predictionIdx]=max(TY(:,1));
    %display(predictionIdx);
    predictedId = elmModel.label(predictionIdx);%bug fixed
end