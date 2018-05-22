logger = kifu.Logger('project', 'big_test');

n = 100;
data = rand(48, 48, 1, n);
responses = categorical(round(rand(n,1)));

layers = [
    imageInputLayer([48, 48, 1]) ...
    ...
    convolution2dLayer([3, 3], 64, 'Padding', 'same') ...
    convolution2dLayer([3, 3], 64, 'Padding', 'same') ...
    maxPooling2dLayer([3, 3], 'Stride', [2, 2]) ...
    dropoutLayer(0.25) ...
    ...
    convolution2dLayer([3, 3], 128, 'Padding', 'same') ...
    convolution2dLayer([3, 3], 128, 'Padding', 'same') ...
    maxPooling2dLayer([3, 3], 'Stride', [2, 2]) ...
    dropoutLayer(0.25) ...
    ...
    convolution2dLayer([3, 3], 256, 'Padding', 'same') ...
    convolution2dLayer([3, 3], 256, 'Padding', 'same') ...
    convolution2dLayer([3, 3], 256, 'Padding', 'same') ...
    maxPooling2dLayer([3, 3], 'Stride', [2, 2]) ...
    dropoutLayer(0.25) ...
    ...
    fullyConnectedLayer(1024) ...
    reluLayer ...
    dropoutLayer(0.5) ...
    ...
    fullyConnectedLayer(2)...
    softmaxLayer() ...
    classificationLayer()
];

options = trainingOptions('sgdm', ...
                            'MaxEpochs', 2, ...
                            'OutputFcn', @logger.log);

trainNetwork(data, responses, layers, options);