function P=MarkerNormality190628(Matrix,Correct)
%MarkerNormality190628 is a function to get P values of ks test to see whether Matrix contains rows that follow a standard normal distribution
%P=MarkerNormality190628(Matrix,1)
if nargin < 2
    Correct=0
end

P=[];
for i=1:size(Matrix,1)
    [h,p]=kstest(zscore(double(Matrix(i,:))));
    P=[P p];
end
figure;
if Correct==1
    Pc=min(1,P.*size(Matrix,1));
    cdfplot(-log10(Pc))
    P=Pc;
    xlabel('-log10(Pcorrected)')
else
    cdfplot(-log10(P))
    line([-log10(0.05/size(Matrix,1)),-log10(0.05/size(Matrix,1))],[0,1])
    xlabel('-log10(P)')
end
line([-log10(0.05),-log10(0.05)],[0,1])
ylabel('fraction')
end
