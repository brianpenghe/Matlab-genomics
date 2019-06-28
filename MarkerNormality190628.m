function P=MarkerNormality190628(Matrix)
%MarkerNormality190628 is a function to get P values of ks test to see whether Matrix contains rows that follow a standard normal distribution
%P=MarkerNormality190628(Matrix)
P=[];
for i=1:size(Matrix,1)
    [h,p]=kstest(zscore(double(Matrix(i,:))));
    P=[P p];
end
cdfplot(-log10(P))
line([-log10(0.05/7482),-log10(0.05/size(Matrix,1))],[0,1])
line([-log10(0.05),-log10(0.05)],[0,1])
xlabel('-log10(P)')
ylabel('fraction')
end
