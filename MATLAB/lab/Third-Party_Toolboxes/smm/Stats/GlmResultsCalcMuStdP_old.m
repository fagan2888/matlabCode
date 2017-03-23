function [mu stDev p] = GlmResultsCalcMuStdP(analData,varargin)
[log10Bool,depVarType,tranformBool] = DefaultArgs(varargin,{0,'',0});

analNames = fieldnames(analData);
for n=1:length(analNames)
    % calc stats
    if size(analData.(analNames{n}),1) > size(analData.(analNames{n}),2)
        bonferroniN = size(analData.(analNames{n}),1)*(size(analData.(analNames{n}),2)+1)/2;
    else
        bonferroniN = size(analData.(analNames{n}),2)*(size(analData.(analNames{n}),1)+1)/2;
    end
     for j=1:size(analData.(analNames{n}),1)
         for k=1:size(analData.(analNames{n}),2)
             
             ttestData = analData.(analNames{n}){j,k};
             ttestData = ttestData(isfinite(ttestData));
             if log10Bool
                 ttestData = log10(ttestData);
             end
             if isempty(ttestData)
                 p.(analNames{n})(j,k) = NaN;
                 mu.(analNames{n})(j,k) = NaN;
                 stDev.(analNames{n})(j,k) = NaN;
             else
                 %%%%% calc pval %%%%%
                 if strcmp(analNames{n},'Constant')
                     p.(analNames{n})(j,k) = NaN;
                 else
                     [h p.(analNames{n})(j,k)] = ttest(ttestData);
                     p.(analNames{n})(j,k) = clip(p.(analNames{n})(j,k)*bonferroniN,-inf,1);
                 end
                 %%%%% calc means %%%%%
                 if strcmp(analNames{n},'Constant') | tranformBool
                     if strcmp(depVarType,'coh')
                         mu.(analNames{n})(j,k) = UnATanCoh(mean(ttestData));
                         stDev.(analNames{n})(j,k) = ...
                             UnATanCoh(mean(ttestData)+std(ttestData)) - mu.(analNames{n})(j,k);
                     else
                         mu.(analNames{n})(j,k) = mean(ttestData);
                         stDev.(analNames{n})(j,k) = std(ttestData);

%                      if strcmp(depVarType,'phase')
%                          mu.(analNames{n})(j,k) = mean(ttestData)./pi.*360;
                     end
                 else
                      mu.(analNames{n})(j,k) = mean(ttestData);
                     stDev.(analNames{n})(j,k) = std(ttestData);
                 end
             end
         end
     end
end
return
