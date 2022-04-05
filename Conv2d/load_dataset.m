function [blocks] = load_dataset(datapath, file_ext, block_dim1, block_dim2)   
    fileinfo = dir(strcat(datapath, '*', file_ext));
    im_names = {fileinfo.name};
    
    cont = 0;
    for i=1:length(im_names)
        image = imread(strcat(datapath,char(im_names(i))));
        image = double(rgb2gray(image));
        im_dims = size(image);

        res_row = mod(im_dims(1), block_dim1);
        res_col = mod(im_dims(2), block_dim2);

        row_new = im_dims(1)-res_row;
        col_new = im_dims(2)-res_col;

        image = image(1:row_new, 1:col_new);    
        array_blocks = get_blocks(image, block_dim1, block_dim2);   
        
        for j=1:length(array_blocks)
            cont = cont + 1;
            blocks(:, :, 1, cont) = cell2mat(array_blocks(j));
        end   
    end
end

