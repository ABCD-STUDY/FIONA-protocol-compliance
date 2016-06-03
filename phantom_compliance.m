function phantom_compliance(requiredStruct, compliance_key, c_output, outdir) 

%============Load phantom compliance output json=======%

compliance_output=loadjson('./phantom_compliance_output.json');

%%%Update key
compliance_output.StudyDate = c_output.StudyDate;
compliance_output.StudyTime =  c_output.StudyTime;
compliance_output.StudyInstanceUID = c_output.StudyInstanceUID;
compliance_output.Manufacturer = c_output.Manufacturer;
compliance_output.ManufacturerModelName = c_output.Manufacturer;
compliance_output.error_messages = c_output.error_messages;


%======== Search for Coil-QA Series ================%

index = [];
for i=1:length(requiredStruct)
    fullclassifyType = requiredStruct(i).fullclassifyType;
    if(cTypeFinder(fullclassifyType, compliance_key{1,1}.classifyType))
        index = [index i];
    end
end

if (~isempty(index))
    [compliance_output, requiredStruct] = check_coilQA_compliance(compliance_output, requiredStruct, compliance_key, index);
else
    compliance_output.ABCD_Coil_QA.message = 'ABCD-Coil-QA classify type was not found';
end


%======== Search for fBIRN-QA Series ================%

index = [];
for i=1:length(requiredStruct)
    fullclassifyType = requiredStruct(i).fullclassifyType;
    if(cTypeFinder(fullclassifyType, compliance_key{1,2}.classifyType))
        index = [index i];
    end
end

if (~isempty(index))
    [compliance_output, requiredStruct] = check_fBIRNQA_compliance(compliance_output, requiredStruct, compliance_key, index);
else
    compliance_output.ABCD_fBIRN_QA.message = 'ABCD-fBIRN-QA classify type was not found';
end




%======== Search for Coil-QA Series ================%

index = [];
for i=1:length(requiredStruct)
    fullclassifyType = requiredStruct(i).fullclassifyType;
    if(cTypeFinder(fullclassifyType, compliance_key{1,3}.classifyType))
        index = [index i];
    end
end

if (~isempty(index))
    [compliance_output, requiredStruct] = check_MBfBIRNQA_compliance(compliance_output, requiredStruct, compliance_key, index);
else
    compliance_output.ABCD_MB_fBIRN_QA.message = 'ABCD-MB-fBIRN-QA classify type was not found';
end


%======== Search for Coil-QA Series ================%

index = [];
for i=1:length(requiredStruct)
    fullclassifyType = requiredStruct(i).fullclassifyType;
    if(cTypeFinder(fullclassifyType, compliance_key{1,4}.classifyType))
        index = [index i];
    end
end

if (~isempty(index))
    [compliance_output, requiredStruct] = check_DiffusionQA_compliance(compliance_output, requiredStruct, compliance_key, index);
else
    compliance_output.ABCD_Diffusion_QA.message = 'ABCD-Diffusion-QA classify type was not found';
end

%======== Tag leftover series ====================%
        
compliance_output = additionalSeriesParsing(compliance_output, requiredStruct);

if (str2double(compliance_output.ABCD_Coil_QA.status)...,
        && str2double(compliance_output.ABCD_fBIRN_QA.status)...,
        && str2double(compliance_output.ABCD_MB_fMRI_QA.status)...,
        && str2double(compliance_output.ABCD_Diffusion_QA.status))

    compliance_output.status = '1'; 
    compliance_output.message = 'A completed compliant phantom QA protocol was obtained';

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%if isdeployed    
    % write out proc.json for smart routing
    fname_proc = sprintf('%s/compliance_output.json', outdir);
    opt.FileName = fname_proc;
    opt.ArrayIndent = 0;
    opt.NoRowBracket = 1;
    savejson('',compliance_output,opt);
%end


