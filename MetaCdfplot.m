function MetaCdfplot = MetaCdfplot(DistriMatrix)
%MetaCdfplot is a function to plot multiple cdf curves on the same figure
%Useful for comparing different distributions of the same sample size
%DistriMatrix should be a matrix whose columns are individual distributions
%MetaCdfplot(DistriMatrix)

[m n]=size(DistriMatrix);
figure;
for i=1:n
    cdfplot(DistriMatrix(:,i));
    hold on;
end;

end

