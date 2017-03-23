function names = GetFileNames(regEx,orderIndexes)
% Returns a matrix with each row containing the basename of each file in the current directory 
% that matches the regular expression regEx
% If the orderIndexes are given the output is ordered based on the number found
% between index1 & index2 in each filename

infoStruct = dir(regEx);
numentries = size(infoStruct,1);
names = [];
%fprintf('skipping %s',infoStruct(1).name);
for i=1:numentries;
    names = [names; infoStruct(i).name];
    %names((i+1)/2,:) = a(f(i)+1:f(i+1)-5);
end
names = names(:,1:end-size(regEx,2)+1);
if exist('orderIndexes', 'var')
    %[m n] = size(names);
    numbers = str2num(names(:,orderIndexes(1):orderIndexes(2)));
    [junk orderindex] = sort(numbers);
    names = names(orderindex,:);
end
    
return