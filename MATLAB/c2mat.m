function m=c2mat(c)
% m=zeros(length(c),length(c{1}));
m=[];
for k=1:length(c)
    if size(c,2)<2
    m=[m;c{k}];
    else
    m=[m,c{k}];
    end
end
% for k=1:length(c)
%     m(k,:)=c{k}(:)';
% end
% if size(c,2)>2
%     m=m';
% end