logger = kifu.Logger('project', 'thtfrhgfest2');

data = rand(10, 10, 1, 100);
responses = categorical(round(rand(100,1)));

layers = [
    imageInputLayer([10, 10, 1])
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', 'OutputFcn', @logger.log);

trainNetwork(data, responses, layers, options);