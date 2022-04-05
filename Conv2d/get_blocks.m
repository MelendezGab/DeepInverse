function [blocks_array] = get_blocks(image, size_n, size_m)
%GET_BLOCKS Summary of this function goes here
%   This function receives an image and divides it into
%   nonoverlapping blocks of size n x m.
%   This function returns an array of blocks
    [n, m] = size(image);
    aa = 1:size_n:n;
    bb = 1:size_m:m;
    [ii,jj] = ndgrid(aa, bb);
    blocks = arrayfun(@(x, y) image(x:x+size_n-1,y:y+size_m-1), ii, jj, 'un', 0);
    blocks_array = reshape(blocks, 1, (n/size_n * m/size_m));
end

