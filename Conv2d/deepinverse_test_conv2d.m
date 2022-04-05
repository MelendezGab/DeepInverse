
datapath = '..\TestSet\';
results_path = '..\Results\';
fileinfo = dir(strcat(datapath,'*.tiff'));
im_names = {fileinfo.name};
cs_rate = 0.1;
load(strcat('trained_deep_CS', num2str(cs_rate),'.mat'));
block_dim1 = 32;
block_dim2 = 32;

for i=1:length(im_names)
    image = imread(strcat(datapath, char(im_names(i))));
    image = double(image);
    
    im_dims = size(image);
    
    array_blocks = get_blocks(image, block_dim1, block_dim2);
    
    block_rows = im_dims(1)/block_dim1;
    block_cols = im_dims(2)/block_dim2;
    
    rec_blocks = {};
    
    for j = 1:length(array_blocks)        
        block = cell2mat(array_blocks(j));                             
        block = double(block);
        measurement = Phi*block(:);
        x_tilde = Phi'*measurement;
        x_tilde = reshape(x_tilde, [32,32]);
        rec_block = predict(net, x_tilde);        
        rec_blocks(j) = {rec_block};        
    end

    rec_image = reshape(rec_blocks, block_rows, block_cols);
    rec_image = uint8(cell2mat(rec_image));
    imwrite(rec_image, strcat(results_path, char(im_names(i))));

    results{i, 1} = char(im_names(i));
    results{i, 2} = psnr(uint8(image), rec_image);
    results{i, 3} = ssim(uint8(image), rec_image);
end

writecell(results, char(strcat(results_path, 'results - CS rate', {' '}, num2str(cs_rate),'.csv')));

disp('Reconstructed images saved in the results folder.');