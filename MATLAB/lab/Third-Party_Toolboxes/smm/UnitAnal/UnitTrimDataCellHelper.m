function dataCell = UnitTrimDataCellHelper(dataCell,colNamesCell)
for j=1:5
    if isempty(colNamesCell) | isempty(colNamesCell{j})
        col{j} = unique(dataCell(:,j));
    else
        [junk ia] = intersect(colNamesCell{j},unique(dataCell(:,j)));
        col{j} = colNamesCell{j}(sort(ia));
    end
end
keepIndexes = zeros(size(dataCell,1),1);
for j=1:length(col{1})
    for k=1:length(col{2})
        for m=1:length(col{3})
            for n=1:length(col{4})
                for p=1:length(col{5})
                    dataIndexes = ...
                        strcmp(dataCell(:,1),col{1}{j}) & ...
                        strcmp(dataCell(:,2),col{2}{k}) & ...
                        strcmp(dataCell(:,3),col{3}{m}) & ...
                        strcmp(dataCell(:,4),col{4}{n}) & ...
                        strcmp(dataCell(:,5),col{5}{p});
                    keepIndexes = keepIndexes | dataIndexes;
                end
            end
        end
    end
end
dataCell(~keepIndexes,:) = [];