function [qubevalue,max] = calculate_qubeadd(fvalue,nframe)
% this function returns qube value according to the blush curve
min = 1023; inc = 0;
max = -1023; dec = 0;

for p = 1:nframe
    % find curve's minimum and maximum
    if (min>=fvalue(p))
        min = fvalue(p);
    end
    if (max<=fvalue(p))
        max = fvalue(p);
    end
    
    % determine the location of the blush value in the slope
    if (inc<(fvalue(p)-min))
        dec = 0;
    end
    
    % calculate the increasing slope
    if (inc<=(fvalue(p)-min))
        inc = fvalue(p)-min;
    end
    
    % calculate the decreasing slope
    if ((max-fvalue(p))>=dec)
        dec = max-fvalue(p);
    end
end

% calculate qubevalue
qubevalue = inc + dec;
fprintf('inc : %5.4f \n',inc)
fprintf('dec : %5.4f \n',dec)
