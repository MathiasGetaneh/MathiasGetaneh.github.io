VATSP = readtable("VATSP.csv", ReadRowNames= true, ReadVariableNames=true, VariableNamingRule="preserve");
%Aeq = ones(size(VATSP)-1) - diag(ones(1,size(VATSP,1) - 1));
Aeq = zeros(size(VATSP,1)*2,size(VATSP,1)^2 + size(VATSP,1)-1);
beq = ones(size(Aeq,1),1);
critNum = size(VATSP,1)-1;
%sum_{i}x_{ij}=1 for all j
for i = 1:(size(VATSP,1))
    vals = (critNum+1)*i-critNum:(critNum+1)*i;
    for j = 1:size(vals,2)
        if (i ~= j)
            Aeq(i,vals(j)) = 1;
        end
    end
end
%sum_{j}x_{ij}=1 for all i
for i = 1:(size(VATSP,1))
    vals = i:(critNum+1):size(VATSP,1)^2;
    for j = 1:size(vals,2)
        if (i ~= j)
            Aeq(i+size(VATSP,1),vals(j)) = 1;
        end
    end
end
A = [];
for i=2:(size(VATSP,1))
    for j = 2:(size(VATSP,1))
        if (i ~= j)
            colIndex1 = (i-1)*(size(VATSP,1))+j;
            colIndex2 = (size(VATSP,1))^2+i-1;
            colIndex3 = (size(VATSP,1))^2+j-1;
            Atemp = zeros(1,size(Aeq,2));
            Atemp(1,colIndex1) = size(VATSP,1);
            Atemp(1,colIndex2) = 1;
            Atemp(1,colIndex3) = -1;
            A = [A;Atemp];
        end
    end
end
b = ones(size(A,1),1)*(size(VATSP,1)-1);
f = [reshape(table2array(VATSP), size(VATSP,1)^2,1);zeros(size(VATSP,1)-1,1)];
lb = [zeros(size(VATSP,1)^2,1);ones(size(VATSP,1)-1,1)];
ub = [ones(size(VATSP,1)^2,1);size(VATSP,1)*ones(size(VATSP,1)-1,1)];
intcon = 1:size(A,2);
%[xOpt, optVal] = linprog(f,A,b,Aeq,beq,lb,ub);
[xOpt, optVal] = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);
xij = xOpt(1:size(VATSP,1)^2);
order = [transpose(2:10),xOpt(size(VATSP,1)^2+1:size(xOpt,1))];
order = [1,10; order];