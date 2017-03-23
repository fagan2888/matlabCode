% function outStruct = MergeStructs(struct1,struct2,varargin)
% overWriteFieldBool = DefaultArgs(varargin,{0});
% tag:merge
% tag:struct
function outStruct = MergeStructs(struct1,struct2,varargin)
overWriteFieldBool = DefaultArgs(varargin,{0});

outStruct = [];
if ~isstruct(struct1) & ~isstruct(struct2)
    if overWriteFieldBool | ...
            ((size(struct1) == size(struct2)) & ...
            ((struct1 == struct2) | (isnan(struct1) & isnan(struct2))))
        outStruct = struct1;
    else
        error('ERROR_STRUCT_FIELDS_WITH_DIFFERENT_VALUES','ERROR_STRUCT_FIELDS_WITH_DIFFERENT_VALUES');
    end
elseif isstruct(struct1) & isstruct(struct2)
    struct1Fields = fieldnames(struct1);
    struct2Fields = fieldnames(struct2);
    
    for j=1:length(struct1Fields)
        if any(strcmp(struct2Fields,struct1Fields{j}))
            outStruct.(struct1Fields{j}) = MergeStructs(struct1.(struct1Fields{j}),...
                struct2.(struct1Fields{j}),overWriteFieldBool);
        else
            outStruct.(struct1Fields{j}) = MergeStructs(struct1.(struct1Fields{j}),...
                struct1.(struct1Fields{j}),overWriteFieldBool);
        end
    end
    for j=1:length(struct2Fields)
        if ~any(strcmp(struct1Fields,struct2Fields{j}))
             outStruct.(struct2Fields{j}) = MergeStructs(struct2.(struct2Fields{j}),...
                 struct2.(struct2Fields{j}),overWriteFieldBool);
        end
    end
else
    error('ERROR_ONE_INPUT_IS_STRUCT_AND_OTHER_IS_NOT','ERROR_ONE_INPUT_IS_STRUCT_AND_OTHER_IS_NOT')
end
return


%% testing %%
   infoStruct = [];
    infoStruct = setfield(infoStruct,'whlSamp',1);
    infoStruct = setfield(infoStruct,'eegSamp',2);
    infoStruct = setfield(infoStruct,'minSpeed',3);
    infoStruct = setfield(infoStruct,'winLength',4);
    junk1 = infoStruct;
   
    infoStruct = [];    
    infoStruct = setfield(infoStruct,'midPointsBool',5);
    infoStruct = setfield(infoStruct,'trialTypesBool',6);
    infoStruct = setfield(infoStruct,'excludeLocations',7);
    infoStruct = setfield(infoStruct,'fileExt',8);
    infoStruct = setfield(infoStruct,'calcTimeFunc',9);
    junk2 = infoStruct;
    
        infoStruct = [];    
    infoStruct = setfield(infoStruct,'whlSamp',1);
    infoStruct = setfield(infoStruct,'eegSamp',2);
     infoStruct = setfield(infoStruct,'midPointsBool',5);
    infoStruct = setfield(infoStruct,'trialTypesBool',6);
    infoStruct = setfield(infoStruct,'excludeLocations',7);
    infoStruct = setfield(infoStruct,'fileExt',8);
    infoStruct = setfield(infoStruct,'calcTimeFunc',9);
    junk2 = infoStruct;
   
