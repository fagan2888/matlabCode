function outCell = UnitPairwiseWInCellHelper(dataCell,varargin)
normName = DefaultArgs(varargin,{'minus'});
normMethod = eval(['@' normName]);

for j=1:5
        col{j} = unique(dataCell(:,j));
end
pairs = nchoosek(1:length(col{5}),2);
pairs = cat(1,pairs,fliplr(pairs));

row = 1;
for j=1:length(col{1})
    for k=1:length(col{2})
        for m=1:length(col{3})
            for n=1:length(col{4})
                catData = [];
                for p=1:size(pairs,1)

                    dataIndexes = ...
                        strcmp(dataCell(:,1),col{1}{j}) & ...
                        strcmp(dataCell(:,2),col{2}{k}) & ...
                        strcmp(dataCell(:,3),col{3}{m}) & ...
                        strcmp(dataCell(:,4),col{4}{n}) & ...
                        strcmp(dataCell(:,5),col{5}{pairs(p,1)});
                    if any(dataIndexes)
                        tempData1 = dataCell{dataIndexes,6};

                        dataIndexes = ...
                            strcmp(dataCell(:,1),col{1}{j}) & ...
                            strcmp(dataCell(:,2),col{2}{k}) & ...
                            strcmp(dataCell(:,3),col{3}{m}) & ...
                            strcmp(dataCell(:,4),col{4}{n}) & ...
                            strcmp(dataCell(:,5),col{5}{pairs(p,2)});
                        if any(dataIndexes)
                            tempData2 = dataCell{dataIndexes,6};

                            outCell{row,1} = col{1}{j};
                            outCell{row,2} = col{2}{k};
                            outCell{row,3} = col{3}{m};
                            outCell{row,4} = col{4}{n};
                            outCell{row,5} = cat(2,col{5}{pairs(p,1)},normName,col{5}{pairs(p,2)});
                            outCell{row,6} = normMethod(tempData1, tempData2);

                            row = row + 1;
                        end
                    end
%                     
%                     
%                     
%                     tempData1 = dataCell(dataIndexes,6);
%                 for p=1:length(col{5})
%                     dataIndexes = ...
%                         strcmp(dataCell(:,1),col{1}{j}) & ...
%                         strcmp(dataCell(:,2),col{2}{k}) & ...
%                         strcmp(dataCell(:,3),col{3}{m}) & ...
%                         strcmp(dataCell(:,4),col{4}{n}) & ...
%                         strcmp(dataCell(:,5),col{5}{p});
%                     tempData = dataCell(dataIndexes,6);
%                     if ~isempty(tempData) & length(tempData)==1
%                         catData(:,p) = tempData{1};
% %                         dataCell(dataIndexes,6) = {log10(tempData{1})};
%                     end
%                 end
%                 if ~isempty(catData)
%                     meanData = mean(catData,2);
%                     for p=1:length(col{5})
%                         dataIndexes = ...
%                             strcmp(dataCell(:,1),col{1}{j}) & ...
%                             strcmp(dataCell(:,2),col{2}{k}) & ...
%                             strcmp(dataCell(:,3),col{3}{m}) & ...
%                             strcmp(dataCell(:,4),col{4}{n}) & ...
%                             strcmp(dataCell(:,5),col{5}{p});
%                         dataCell(dataIndexes,6) = {catData(:,p) - meanData};
%                     end
                end
            end
        end
    end
end
