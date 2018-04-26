function ClassID = gscatterTable(Tbl,xvar,yvar,colors,classvar)
%gscatterTable plots a scatter plot with colors indicating classvar identities
%
ClassID=categorical(table2array(Tbl(:,classvar)));
gscatter(table2array(Tbl(:,xvar)),table2array(Tbl(:,yvar)),ClassID,colors)
axis([1 50000 1 50000])
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
xlabel(xvar)
ylabel(yvar)
end
