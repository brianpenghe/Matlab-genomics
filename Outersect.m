function C = Outersect(A,B)
%Outersect outputs elements in A that are not in B
%function C = Outersect(A,B)


[D ia ib]=intersect(A,B,'stable');
C=A;
C(ia)=[];

end
