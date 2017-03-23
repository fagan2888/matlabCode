function (inFileBase,fileExt, nChan,segLen,stimTimes,outFileNameAddition)

data = zeros(nChan,segLen,length(stimTimes));
for i=1:length(stimTimes)
    data(:,:,i) = bload([inFileBase fileExt],[nChan, segLen],stimTimes((i)-segLen/2)*nChan*2);
end
meanData = mean(data,3);
outFile = fopen([fileBase outFileNameAddition fileExt],'w')
fwrite(outFile,meanData,'int16');
fclose(outFile);