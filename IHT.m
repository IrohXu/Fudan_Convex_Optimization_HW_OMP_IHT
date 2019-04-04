function [x] = IHT(A, y, s, u,iterations)   % IHT算法
%IHT 
%  The IHT function was written by Xu Cao, a student from
%  Fudan University.

    x0 = zeros(84,1);
    for k =0:iterations
        x = x0 + u*A'*(y - A*x0);
        [num, index] = sort(x,1,'descend'); % 利用sort函数寻找最大的s个
        x(index(s+1:end))=0;   % Hs处理：把最大的s个留下，其余置零
        x0 = x;
    end
end

