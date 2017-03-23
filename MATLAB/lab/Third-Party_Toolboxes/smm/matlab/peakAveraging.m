function peakAveraging(inFileBase,fileExt, nChan,alignTimes,segLen,priorToAlign,samp,outFileNameAddition)

segLen = round(segLen*samp/1000);
priorToAlign = round(priorToAlign*samp/1000);
data = zeros(nChan,segLen,length(alignTimes));
for i=1:length(alignTimes) 
    data(:,:,i) = bload([inFileBase fileExt],[nChan, segLen],(alignTimes(i)-priorToAlign)*nChan*2);
end
meanData = mean(data,3);
outFile = fopen([inFileBase outFileNameAddition fileExt],'w');
fwrite(outFile,meanData,'int16');
fclose(outFile);