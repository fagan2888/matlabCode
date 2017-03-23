% function CheckSpectraVarSim(fileBaseCell,spectAnalBase,fileExtCell,spectVar1,spectVar2)
% Checks to see whether spectral files exist and are the same length as
% each other
% tag:check
% tag:spectral
% tag:var
% tag:similarity

function CheckSpectraVarSim(fileBaseCell,spectAnalBase,fileExtCell,spectVar1,spectVar2)

for j=1:length(fileBaseCell)
    for k=1:length(fileExtCell)
            dirName = [SC(fileBaseCell{j}) SC([spectAnalBase fileExtCell{k}])];
            fileName1 = [dirName spectVar1];
            fileName2 = [dirName spectVar2];
            if ~exist(fileName1,'file')
                fprintf('FILE MISSING: %s\n',fileName1)
            elseif ~exist(fileName2,'file')
                fprintf('FILE MISSING: %s\n',fileName2)
            else
                var1 = LoadVar(fileName1);
                var2 = LoadVar(fileName2);
                if any(size(var1)~=size(var2)) | any(var1~=var2)
                    fprintf('FILES NOT EQUAL: %s\n',dirName)
                    fprintf('spectVar1')
                    size(var1)
                    fprintf('spectVar2')
                    size(var2)
                end
            end
    end
end