function [FacPat, FacStr, FacScr, FacRef, FacCor, scree, facVar, facVarQ, varSD] = doPCA(ROTATION, MAT_TYPE, NUM_FAC, data, KAISER, indexdata, GAVE);% doPCA - [FacPat, FacStr, FacScr, FacRef, FacCor, scree, facVar, facVarQ, varSD] = doPCA(ROTATION, MAT_TYPE, NUM_FAC, data, KAISER, indexdata, GAVE) - do PCA and calculate factor scores%Inputs%  ROTATION	: Type of rotation (VMAX:varimax or PMAX: promax or UNRT: unrotated or ICA: IMAX)%               ICA is run with the PCA subspace option on by default.  This program can be edited to change its options.%               Output is rescaled to be consistent with PCA conventions.%  MAT_TYPE	: Matrix type (SCP: sums-of-squares-cross-product matrix, COV: variance-covariance matrix, COR: correlation matrix)%  NUM_FAC	: Number of factors retained%  data     : Data matrix (observations, variables)%  KAISER	: Kaiser normalization ('K' Kaiser normalization, 'N' no Kaiser normalization, 'C' covariance loadings).%%  OPTIONAL%%  indexdata: Descriptor of the data rows.  First column is output%  cell,second is the subject, third is the channel or timepoint.%  GAVE     : Convert the data to grand average form, perform the analysis,%               then reconvert the factor scores back to average form, 'Y' or 'N'%%Outputs%  FacPat	: Factor pattern matrix - produces standardized variables from scores, scaled by communality  (rows=variables, cols=factors)%  FacStr	: Factor structure matrix - correlation between factors and variables (rows=variables, cols=factors)%  FacScr	: Factor scores, variance standardized, non-mean corrected (rows=variables, cols=factors)%  FacRef	: Reference vector - correlation of factor with variables with variance from other factors eliminated (rows=variables, cols=factors)%             Only computed for Promax.  Working out computation for other rotations is on the to-do list.%  FacCor	: Factor correlations%  scree    : The full set of unrotated eigenvalues, prior to truncation.%  facVar   : %age of variance accounted for by each Promax rotated factor, ignoring other factors (based on PmxStr)%			  Calculated based on variance of relationship matrix (if COV or SCP, each variable weighted)%  facVarQ  : %age of variance uniquely accounted for by each Promax rotated factor, (based on PmxRef)%			  Calculated based on variance of relationship matrix (if COV or SCP, each variable weighted)%             Only computed for Promax.  Working out computation for other rotations is on the to-do list.%  varSD    : Standard deviations of the variables.%%History%  by Joseph Dien (4/99)%  University of Kansas%  jdien@ku.edu%%  with assistance by Bill Dunlap and dedicated to his memory.%%  modified 6/00 JD%  Scree output added.%  %  modified 9/30/00 JD%  Kaiser normalization can be turned off and %age variance accounted for calculated.%%  modified 1/10/00 JD%  %age of variance accounted for by each Promax rotated factor returned.  Fixed error in Promax algorithm.%  changed output variable names to more readable names.  Added varSD output.%%  corrected 2/27/01 JD%  fixed error in factor score calculations for cov and sscp matrices.%%  modified 3/2/01 JD%  Rotating factor scores directly to avoid singularity problems from generalized inverse of relation matrix.  Dropped scoring coefficient output.%%  modified 7/27/02 JD%  Implemented non mean-corrected factor scores.%%  modified 8/4/02 JD%  Output generalized so that type of rotation can be specified.  Variance correcting factor scores after varimax rotation.%%  modified 10/29/02 JD%  Added option for unrotated output.%%  bugfix 12/5/02 JD%  Prerotation factor score standardization was incorrect (recently%  introduced error).  Not entirely sure that SSCP is implemented%  correctly, although it matches up with JMP output.  No time for now to%  work out.%%  modified 4/25/03 JD%  Added ICA, also known as infomax rotation, to rotation options.  FacRef more properly set to empty%  matrix for rotations other than Promax.%%  modified 10/26/03 JD%  Added option for unscaled loadings during rotation (not for Infomax).  Set Infomax%  rotation to automatically use covariance matrix (i.e., mean-corrected%  but not variance-corrected variables).%%  bugfix 11/18/03 JD%  Fixed bug to ICA factor score computation.%%  bugfix 2/15/04 JD%  Added fix for when using both covariance loadings and varimax rotation%  together.  Fixed unscaled loadings option.  Now specified as alternative to Kaiser normalization%  and not operational during Promax step.%%  modified 12/29/04 JD%  ICA option set to reinitialize random number generator to the starting%  state with each use.  Also, set ICA routine to non-verbose output.%%  modified 2/14/05 JD%  Added grand average analysis option.if nargin < 6  GAVE = 'N';endif (ROTATION ~= 'VMAX') & (ROTATION ~= 'PMAX') & (ROTATION ~= 'UNRT') & (ROTATION ~= 'IMAX')	error('Rotation must be set to either VMAX or PMAX or UNRT or IMAX');end;if GAVE == 'Y'    if size(indexdata,1)~=size(data,1)        error('Size of indexdata array must match that of the data array.');    end;    cellNum=length(unique(indexdata(:,1)));    subjNum=length(unique(indexdata(:,2)));    obsNum=length(unique(indexdata(:,3)));    data=sortrows([indexdata data],[1:3]); %make sure that data and indexdata are sorted properly.    indexdata=data(:,1:3);    data=data(:,4:size(data,2));        rawData=data;    data=zeros(cellNum*obsNum,size(data,2));    for i=1:subjNum        data=data+rawData(cellNum*obsNum*(i-1)+1:cellNum*obsNum*i,:);    end;    data=data/subjNum;end;    varMean = mean(data);meanmatrix = ones(size(data,1),1) * varMean;varSD = std(data);D = diag(varSD);  %diagonal matrix of standard deviations of variablesif (ROTATION == 'IMAX')     if ((MAT_TYPE == 'COR') | (MAT_TYPE == 'SCP'))        MAT_TYPE = 'COV';        disp('Infomax rotations automatically carried out with covariance rotation.');    end;end;if MAT_TYPE == 'SCP'	S = ((data)' * (data))/(size(data,1) - 1); %SSCP    Sd = diag(sqrt(diag(S)));  %diagonal matrix of standard deviations of variables as used to generate relationship matrix    disp('Warning:algorithms involving SSCP relationship matrix have not been fully validated.  Use with caution.');elseif MAT_TYPE == 'COV'	S = cov(data); %covariance matrix    Sd = diag(sqrt(diag(S)));  %diagonal matrix of standard deviations of variables as used to generate relationship matrixelseif MAT_TYPE == 'COR'	S = corrcoef(data); %correlation matrix    Sd = diag(ones(size(data,2),1));  %diagonal of standard deviations of variables as used to generate relationship matrixelse	error('Error - matrix type not specified');endif (ROTATION == 'PMAX') | (ROTATION == 'VMAX') | (ROTATION == 'UNRT')    [V,L] = eig(S);    L = flipud(fliplr(L));    V = fliplr(V);    NUM_VAR = size (S,1);  %number of variables    V = V(:,1:NUM_FAC);  %truncated eigenvector matrix    scree = diag(L);    L = L(1:NUM_FAC,1:NUM_FAC);  %truncated eigenvalue matrix    %factor scores    if MAT_TYPE == 'SCP'    	VmxScr = (data) * V;	%V is factor scoring coefficient matrix    elseif MAT_TYPE == 'COV'        VmxScr = (data) * V;    %factor scores, not mean corrected.    elseif MAT_TYPE == 'COR'        VmxScr = (data) * inv(D) * V; %same as above but also corrected for variable variance    else    	error('Error - matrix type not specified');    end        ScrDiag = diag(std(VmxScr));    A = inv(Sd) * (V * ScrDiag);  %unrotated factor loading matrix    %Note, this equation is commonly cited in statistics books but is misleading in this form.  The full    %form is A = inv(Sd) * (inv(V') * sqrt (L))    %this means that A is not in fact a scaled form of V as is commonly implied.    %This makes sense since A is a factor loading matrix (converts scores to raw data)    %while V is a scoring coefficient matrix (converts raw data to scores).    %inv(V') does reduce down to V, though, since X'=inv(X)    %for an orthogonal matrix, X.    VmxScr=(VmxScr)*inv(ScrDiag); %Standardize factor scores, not mean corrected.        if KAISER == 'C'        A = D *A;    end;end;if (ROTATION == 'PMAX') | (ROTATION == 'VMAX')    [VmxPat, VmxScr]= doVarimax(A, VmxScr, KAISER);    ScrDiag = diag(std(VmxScr));    VmxScr=(VmxScr)*inv(diag(std(VmxScr)));  %Standardize Varimax factor scores to make up for rounding errors, etc.  Not mean-corrected.    if KAISER == 'C'        A = inv(D) *A;        VmxPat = inv(D) * VmxPat;    end;end;if ROTATION == 'PMAX'	[PmxPat, PmxStr, PmxCor, PmxRef, PmxScr] = doPromax(VmxPat, VmxScr, 3);	%Standardizing the Promax factor scores is necessary since the Promax algorithm does not preserve scaling.	PmxScr=(PmxScr)*inv(diag(std(PmxScr)));  %Promax factor scores are normally standardized (Gorsuch, p. 214).  Not mean-corrected.end;if ROTATION == 'IMAX'    rand('state',0);    [weights,sphere] = runica(data', 'pca', NUM_FAC, 'verbose', 'off');	PmxScr = (weights * sphere * data')';    PmxStr=corrcoef([PmxScr data]); %compute factor structure matrix    PmxStr=PmxStr(NUM_FAC+1:size(PmxStr,1),1:NUM_FAC);    phi = corrcoef(PmxScr);    PmxPat = PmxStr * inv(phi); %compute factor pattern matrix    varSD=std(data);    PmxCor = corrcoef(PmxScr);    scree = sort(std(PmxScr));end;Var=Sd.^2;if ROTATION == 'VMAX'    if (NUM_FAC == 1)	    Vcom = (VmxPat'.^2)';    else	    Vcom = sum(VmxPat'.^2)';	%calculate communalities    end    Vvar=sum(Var*Vcom)/sum(diag(Var));    disp(['Amount of variance (communality) accounted for by Varimax solution is ' num2str(100*Vvar) '%.']);end;if ROTATION == 'UNRT'    if (NUM_FAC == 1)	    Vcom = (A'.^2)';    else	    Vcom = sum(A'.^2)';	%calculate communalities    end    Vvar=sum(Var*Vcom)/sum(diag(Var));    disp(['Amount of variance (communality) accounted for by the unrotated solution is ' num2str(100*Vvar) '%.']);end;if ROTATION == 'PMAX'	if (NUM_FAC == 1)		Pcom = (PmxPat'.^2)';	else		Pcom = sum(PmxPat'.^2)';	%calculate communalities	end	Pvar=sum(Var*Pcom)/sum(diag(Var));	disp(['Amount of variance (communality) accounted for by Promax solution is ' num2str(100*Pvar) '%.']);end;if ROTATION == 'IMAX'	if (NUM_FAC == 1)		Pcom = (PmxPat'.^2)';	else		Pcom = sum(PmxPat'.^2)';	%calculate communalities	end	Pvar=sum(Var*Pcom)/sum(diag(Var));	disp(['Amount of variance (communality) accounted for by Infomax solution is ' num2str(100*Pvar) '%.']);end;if ROTATION == 'UNRT'	FacPat = A;	FacStr = A;	FacCor = ones(NUM_FAC);	FacRef = [];	FacScr = VmxScr;end;if ROTATION == 'VMAX'	FacPat = VmxPat;	FacStr = VmxPat;	FacCor = ones(NUM_FAC);	FacRef = [];	FacScr = VmxScr;end;if ROTATION == 'PMAX'	FacPat = PmxPat;	FacStr = PmxStr;	FacCor = PmxCor;	FacRef = PmxRef;	FacScr = PmxScr;end;if ROTATION == 'IMAX'	FacPat = PmxPat;	FacStr = PmxStr;	FacCor = PmxCor;	FacRef = [];	FacScr = PmxScr;end;facVar = sum((Sd*FacStr).^2)/(sum(diag(Var)));facVarQ = [];if ROTATION == 'PMAX'    facVarQ = sum((Sd*FacRef).^2)/(sum(diag(Var)));end;if GAVE == 'Y'    FacScf = pinv(corrcoef(data))*FacStr;    FacScr = rawData*FacScf;end;