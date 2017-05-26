function ColorMatrix = Mat2Colormap(Matrix,ColorMap)
%The input matrix is used to map to a specified colormap
%If Matrix is a 2D matrix, ColorMatrix will be a 3D matrix with the third dimension as RGB
%If Matrix is an array, you know what you get
%function MyMatrix = tsnePlot(Matrix,'jet');

if nargin < 2
    ColorMap='jet';
end;

test2=discretize(Matrix,64);
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

