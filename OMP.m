function [x] = OMP(A, y, s)  % s is the sparse coefficient

    x = zeros(84,1);
    r = zeros(size(y,1),1);  
    r = y ;      %  Initial residual value
    I = [];   % The initial I is an empty matrix, 
    % which is then used to add the selected max(abs(A'*r))
    for k =1:s
        [num, index] = max(abs(A'*r));                                                 %#ok<ASGLU>
        I = [I, A(:,index)];                                                           %#ok<AGROW>
        A(:,index) = zeros(size(A,1),1);  % Selected column is set to zero
        r = y - I*pinv(I)*y;    %  Residual
        array(k) = index;                                                             %#ok<AGROW>
    end
    x(array,1) = pinv(I)*y;
end
