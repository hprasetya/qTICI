function [fvalue] = blush_withoutfilterblock(image,UNIF,BW)

% Inversion of each frame
sous = (UNIF - double(image));
ri = BW.*sous;

% Patch divsion
fun = @(block_struct) ...
   mean(mean(block_struct.data)) * ones(size(block_struct.data));
ri2 = blockproc(ri,[4 4],fun);

% Contrast value

med = median(median(ri2));


for i=1:1024                    % Removing values under the median
    for j=1:1024
        if (ri2(i,j)<med)
            ri2(i,j) = 0;
        end
    end
end

A = find (ri2(:,:)~=0);
B = size (A);
C = B(1,1);                     % Number of values different from zero

if (C==0)
    C=1;
end

i=0;
j=0;
sum=0;

for i=1:1024
    for j=1:1024
        sum = sum + ri2(i,j);
    end
end

% Average
fvalue = sum/C;


