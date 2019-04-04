function [x] = IHT(A, y, s, u,iterations)   % IHT�㷨
%IHT 
%  The IHT function was written by Xu Cao, a student from
%  Fudan University.

    x0 = zeros(84,1);
    for k =0:iterations
        x = x0 + u*A'*(y - A*x0);
        [num, index] = sort(x,1,'descend'); % ����sort����Ѱ������s��
        x(index(s+1:end))=0;   % Hs����������s�����£���������
        x0 = x;
    end
end

