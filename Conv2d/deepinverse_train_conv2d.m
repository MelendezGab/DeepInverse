
block_dim1 = 32;
block_dim2 = 32;
n = block_dim1 * block_dim2;
cs_rate = 0.1;
m = floor(n*cs_rate);
Phi = randn(m, n);

blocks = load_dataset('..\TrainSet\', '.png', block_dim1, block_dim2);

for i = 1:length(blocks)    
    block = double(blocks(:,:,i));
    measurement = Phi*block(:);
    x_tilde = Phi'*measurement;
    x_tilde = reshape(x_tilde, [32,32]);
    input_data(:, :, 1, i) = x_tilde;  
    target(:, :, 1, i) = block;
end
whos input_data
whos target

layers = [
    
    imageInputLayer([32 32 1], 'Normalization', 'none')
	% layer = convolution2dLayer(filterSize,numFilters,Name,Value)
    convolution2dLayer(11, 64, 'Stride', 1,'Padding', 5, 'DilationFactor', 1)
    batchNormalizationLayer
    leakyReluLayer
        
    convolution2dLayer(11, 32, 'Stride', 1,'Padding', 5, 'DilationFactor', 1)
    batchNormalizationLayer
    leakyReluLayer    
            
    convolution2dLayer(11, 1, 'Stride', 1,'Padding', 5, 'DilationFactor', 1)
    batchNormalizationLayer
    leakyReluLayer
    
    regressionLayer
];

miniBatchSize = 64;

options = trainingOptions( 'adam',...
    'MiniBatchSize', miniBatchSize,...
    'MaxEpochs', 10,...
    'InitialLearnRate', 0.5,...
    'Plots', 'training-progress');

net = trainNetwork(input_data, target, layers, options);	

save(strcat('trained_deep_CS', num2str(cs_rate),'.mat'), 'net', 'Phi');
