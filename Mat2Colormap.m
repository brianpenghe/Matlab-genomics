function ColorMatrix = Mat2Colormap(Matrix,ColorMap,Mode)
%The input matrix is used to map to a specified colormap
%If Matrix is a 2D matrix, ColorMatrix will be a 3D matrix with the third dimension as RGB
%If Matrix is an array, you know what you get
%function MyMatrix = tsnePlot(Matrix,'jet','Symmetric');
%Mode can be 'Symmetric' or not. Symmetric means middle color has to represent 0, useful for fold change display

if nargin < 2
    ColorMap='jet';
end;
if nargin < 3
    Mode='Asymmetric';
end;

[m n]=size(Matrix);
test2=discretize(Matrix,64);
    if Mode=='Symmetric'
        if (max(max(Matrix)')-min(min(Matrix)')) >= 0
            test2=discretize([Matrix;repmat(-max(max(Matrix)'),1,n)],64);
        elseif (max(max(Matrix)')-min(min(Matrix)')) < 0
            test2=discretize([Matrix;repmat(-min(min(Matrix)'),1,n)],64); 
        end;
        test2(end,:)=[];
    end;
                                                 
MyMap=colormap(ColorMap);

[m n]=size(test2);
for i=1:m
    for j=1:n
        test3R(i,j)=MyMap(test2(i,j),1);
        test3G(i,j)=MyMap(test2(i,j),2);
        test3B(i,j)=MyMap(test2(i,j),3);
    end;
end;


ColorMatrix=test3R;
ColorMatrix(:,:,2)=test3G;
ColorMatrix(:,:,3)=test3B;
end

