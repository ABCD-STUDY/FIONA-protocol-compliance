function human_compliance(requiredStruct, compliance_key, compliance_output, outdir, datastore)


%======== Search for ABCD-T1 Series ================%

index = [];
for i=1:length(requiredStruct)
    fullclassifyType = requiredStruct(i).fullclassifyType;
    if(cTypeFinder(fullclassifyType, compliance_key{1,1}.classifyType))
        index = [index i];
    end
end

%index = find(strcmp({requiredStruct.classifyType}, compliance_key{1,1}.classifyType)==1);

if (~isempty(index))
    [compliance_output, requiredStruct] = check_T1_compliance(compliance_output, requiredStruct, compliance_key, index);
else
    compliance_output.T1.message = 'ABCD-T1 classify type was not found';
end

%======== Search for ABCD-T2 Series ================%

%index = find(strcmp({requiredStruct.classifyType}, compliance_key{1,2}.classifyType)==1);

index = [];
for i=1:length(requiredStruct)
    fullclassifyType = requiredStruct(i).fullclassifyType;
    if(cTypeFinder(fullclassifyType, compliance_key{1,2}.classifyType))
        index = [index i];
    end
end

if (~isempty(index))
    [compliance_output, requiredStruct] = check_T2_compliance(compliance_output, requiredStruct, compliance_key, index);
else
    compliance_output.T2.message = 'ABCD-T2 classify type was not found';
end

%======== Search for ABCD-DTI Block ================%

%index = find(strcmp({requiredStruct.classifyType}, compliance_key{1,3}.classifyType)==1);

index = [];
for i=1:length(requiredStruct)
    fullclassifyType = requiredStruct(i).fullclassifyType;
    if(cTypeFinder(fullclassifyType, compliance_key{1,4}.classifyType))
        index = [index i];
    end
end

if (~isempty(index))
    [compliance_output, requiredStruct] = check_DTI_block_compliance(compliance_output, requiredStruct, compliance_key, index);
else
    compliance_output.DTI_Block.message = 'Compliant DTI component was not found. A compliant DTI component should include a Diffusion field map followed by a DTI acquisition';
end

%======== Search for ABCD-rsFMRI Block ================%


%index = find(strcmp({requiredStruct.classifyType}, compliance_key{1,5}.classifyType)==1);
index = [];
for i=1:length(requiredStruct)
    fullclassifyType = requiredStruct(i).fullclassifyType;
    if(cTypeFinder(fullclassifyType, compliance_key{1,6}.classifyType))
        index = [index i];
    end
end

if (~isempty(index))
    [compliance_output, requiredStruct] = check_rsfMRI_block_compliance(compliance_output, requiredStruct, compliance_key, index);
end


%======== Search for ABCD-fMRI MID task ================%

index = [];
for i=1:length(requiredStruct)
    fullclassifyType = requiredStruct(i).fullclassifyType;
    if(cTypeFinder(fullclassifyType, compliance_key{1,7}.classifyType))
        index = [index i];
    end
end

if (~isempty(index))
    [compliance_output, requiredStruct] = check_MID_task_compliance(compliance_output, requiredStruct, compliance_key, index);
else
    compliance_output.MID_fMRI_Block.message = 'Compliant MID fMRI task was not found. A compliant MID fMRI task component should include a fMRI field map followed by the MID fMRI task acquisition';
end


%======== Search for ABCD-fMRI SST task ================%

index = [];
for i=1:length(requiredStruct)
    fullclassifyType = requiredStruct(i).fullclassifyType;
    if(cTypeFinder(fullclassifyType, compliance_key{1,8}.classifyType))
        index = [index i];
    end
end

if (~isempty(index))
    [compliance_output, requiredStruct] = check_SST_task_compliance(compliance_output, requiredStruct, compliance_key, index);
else
    compliance_output.SST_fMRI_Block.message = 'Compliant SST fMRI task was not found. A compliant SST fMRI task component should include a fMRI field map followed by the SST fMRI task acquisition';
end

%======== Search for ABCD-fMRI nBack task ================%

index = [];
for i=1:length(requiredStruct)
    fullclassifyType = requiredStruct(i).fullclassifyType;
    if(cTypeFinder(fullclassifyType, compliance_key{1,9}.classifyType))
        index = [index i];
    end
end

if (~isempty(index))
    [compliance_output, requiredStruct] = check_nBack_task_compliance(compliance_output, requiredStruct, compliance_key, index);
else
    compliance_output.nBack_fMRI_Block.message = 'Compliant nBack fMRI task was not found. A compliant nBack fMRI task component should include a fMRI field map followed by the nBack fMRI task acquisition';
end



%======== Tag leftover series ====================%
        
compliance_output = additionalSeriesParsing(compliance_output, requiredStruct, datastore);



%==== Check possible compliances (Full, subsession) ===%

if (str2double(compliance_output.rsfMRI_Block_1.status)...,
        && str2double(compliance_output.rsfMRI_Block_2.status)...,
        && str2double(compliance_output.nBack_fMRI_Block.status)...,
        && str2double(compliance_output.MID_fMRI_Block.status)...,
        && str2double(compliance_output.SST_fMRI_Block.status)...,
        && str2double(compliance_output.DTI_Block.status)...,
        && str2double(compliance_output.T1.status)...,
        && str2double(compliance_output.T2.status))

    compliance_output.status = '1'; 
    compliance_output.message = 'A completed compliant protocol was obtained. One session based acquisition.';
    compliance_output.shortmessage = 'C';
    
elseif (str2double(compliance_output.rsfMRI_Block_1.status)...,
        && str2double(compliance_output.rsfMRI_Block_2.status)...,
        && str2double(compliance_output.DTI_Block.status)...,
        && str2double(compliance_output.T1.status)...,
        && str2double(compliance_output.T2.status))
    
    compliance_output.status = '1'; 
    compliance_output.message = 'A completed compliant session was acquired. Two session based acquisition. Subsession Type A part 1';  
    compliance_output.shortmessage = 'A1';
    
elseif (str2double(compliance_output.rsfMRI_Block_1.status)...,
        && str2double(compliance_output.rsfMRI_Block_2.status)...,
        && str2double(compliance_output.DTI_Block.status)...,
        && str2double(compliance_output.T2.status))
    
    compliance_output.status = '1'; 
    compliance_output.message = 'A completed compliant session was acquired. Two session based acquisition. Subsession Type B part 2';
    compliance_output.shortmessage = 'B2';
    
elseif  (str2double(compliance_output.nBack_fMRI_Block.status)...,
        && str2double(compliance_output.MID_fMRI_Block.status)...,
        && str2double(compliance_output.SST_fMRI_Block.status)...,
        && str2double(compliance_output.T1.status))
    
    compliance_output.status = '1'; 
    compliance_output.message = 'A completed compliant session was acquired. Two session based acquisition. Subsession Type B part 1';    
    compliance_output.shortmessage = 'B1';
    
elseif  (str2double(compliance_output.nBack_fMRI_Block.status)...,
        && str2double(compliance_output.MID_fMRI_Block.status)...,
        && str2double(compliance_output.SST_fMRI_Block.status))
    
    compliance_output.status = '1'; 
    compliance_output.message = 'A completed compliant session was acquired. Two session based acquisition. Subsession Type A part 2';   
    compliance_output.shortmessage = 'A2';
     
end


%==========Get file size and paths====================%

stUID = compliance_output.StudyInstanceUID;
suidprefixpfile = 'SUID_';
prefixpfile = '_subjid_';
pID = compliance_output.PatientID;
%sdate = compliance_output.StudyDate;
%fsdate = strcat(sdate(5:6), '-', sdate((end-1):end), '-', sdate(1:4));
%stime = compliance_output.StudyTime;


if str2num(compliance_output.T1.status)
    sUI = compliance_output.T1.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.T1.file{1,1}.path = ffname;
        compliance_output.T1.file{1,1}.size = fresult.bytes;
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.T1.file{1,1}.path = ffname;
    end
end

%%%

if str2num(compliance_output.T2.status)
    sUI = compliance_output.T2.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.T2.file{1,1}.path = ffname;
        compliance_output.T2.file{1,1}.size = fresult.bytes;
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.T2.file{1,1}.path = ffname;
    end

end

%%%

if str2num(compliance_output.DTI_Block.DTI_FM.status)
    sUI = compliance_output.DTI_Block.DTI_FM.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.DTI_Block.DTI_FM.file{1,1}.path = ffname;
        compliance_output.DTI_Block.DTI_FM.file{1,1}.size = fresult.bytes;
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.DTI_Block.DTI_FM.file{1,1}.path = ffname;   
    end

    sNo = num2str(compliance_output.DTI_Block.DTI_FM.SeriesNumber);
    fname = strcat(suidprefixpfile, stUID, prefixpfile, pID, '*se', sNo, '_', '*.t*');
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);

    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.DTI_Block.DTI_FM_kspace.file{1,1}.path = ffname;
        compliance_output.DTI_Block.DTI_FM_kspace.file{1,1}.size = fresult.bytes;
        compliance_output.DTI_Block.DTI_FM_kspace.status = '1';
        compliance_output.DTI_Block.DTI_FM_kspace.message = 'k-space data was received';
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.DTI_Block.DTI_FM_kspace.file{1,1}.path = ffname;   
    end

end

if str2num(compliance_output.DTI_Block.DTI.status)
    sUI = compliance_output.DTI_Block.DTI.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.DTI_Block.DTI.file{1,1}.path = ffname;
        compliance_output.DTI_Block.DTI.file{1,1}.size = fresult.bytes;
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.DTI_Block.DTI.file{1,1}.path = ffname;   
    end

    sNo = num2str(compliance_output.DTI_Block.DTI.SeriesNumber);
    fname = strcat(suidprefixpfile, stUID, prefixpfile, pID, '*se', sNo, '_', '*.t*');
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);

    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.DTI_Block.DTI_kspace.file{1,1}.path = ffname;
        compliance_output.DTI_Block.DTI_kspace.file{1,1}.size = fresult.bytes;
        compliance_output.DTI_Block.DTI_kspace.status = '1';
        compliance_output.DTI_Block.DTI_kspace.message = 'k-space data was received';
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.DTI_Block.DTI_kspace.file{1,1}.path = ffname;   
    end

end


%%%

if str2num(compliance_output.MID_fMRI_Block.MID_fMRI_FM.status)
    sUI = compliance_output.MID_fMRI_Block.MID_fMRI_FM.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.MID_fMRI_Block.MID_fMRI_FM.file{1,1}.path = ffname;
        compliance_output.MID_fMRI_Block.MID_fMRI_FM.file{1,1}.size = fresult.bytes;
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.MID_fMRI_Block.MID_fMRI_FM.file{1,1}.path = ffname;   
    end

end

if str2num(compliance_output.MID_fMRI_Block.MID_fMRI_run1.status)
    sUI = compliance_output.MID_fMRI_Block.MID_fMRI_run1.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.MID_fMRI_Block.MID_fMRI_run1.file{1,1}.path = ffname;
        compliance_output.MID_fMRI_Block.MID_fMRI_run1.file{1,1}.size = fresult.bytes;
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.MID_fMRI_Block.MID_fMRI_run1.file{1,1}.path = ffname;   
    end

    sNo = num2str(compliance_output.MID_fMRI_Block.MID_fMRI_run1.SeriesNumber);
    fname = strcat(suidprefixpfile, stUID, prefixpfile, pID, '*se', sNo, '_', '*.t*');
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);

    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.MID_fMRI_Block.MID_fMRI_run1_kspace.file{1,1}.path = ffname;
        compliance_output.MID_fMRI_Block.MID_fMRI_run1_kspace.file{1,1}.size = fresult.bytes;
        compliance_output.MID_fMRI_Block.MID_fMRI_run1_kspace.status = '1';
        compliance_output.MID_fMRI_Block.MID_fMRI_run1_kspace.message = 'k-space data was received';
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.MID_fMRI_Block.MID_fMRI_run1_kspace.file{1,1}.path = ffname;   
    end

end

if str2num(compliance_output.MID_fMRI_Block.MID_fMRI_run2.status)
    sUI = compliance_output.MID_fMRI_Block.MID_fMRI_run2.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.MID_fMRI_Block.MID_fMRI_run2.file{1,1}.path = ffname;
        compliance_output.MID_fMRI_Block.MID_fMRI_run2.file{1,1}.size = fresult.bytes;        
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.MID_fMRI_Block.MID_fMRI_run2.file{1,1}.path = ffname;   
    end
    sNo = num2str(compliance_output.MID_fMRI_Block.MID_fMRI_run2.SeriesNumber);
    fname = strcat(suidprefixpfile, stUID, prefixpfile, pID, '*se', sNo, '_', '*.t*');
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);

    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.MID_fMRI_Block.MID_fMRI_run2_kspace.file{1,1}.path = ffname;
        compliance_output.MID_fMRI_Block.MID_fMRI_run2_kspace.file{1,1}.size = fresult.bytes;
        compliance_output.MID_fMRI_Block.MID_fMRI_run2_kspace.status = '1';
        compliance_output.MID_fMRI_Block.MID_fMRI_run2_kspace.message = 'k-space data was received';
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.MID_fMRI_Block.MID_fMRI_run2_kspace.file{1,1}.path = ffname;   
    end
end

%%%

if str2num(compliance_output.SST_fMRI_Block.SST_fMRI_FM.status)
    sUI = compliance_output.SST_fMRI_Block.SST_fMRI_FM.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.SST_fMRI_Block.SST_fMRI_FM.file{1,1}.path = ffname;
        compliance_output.SST_fMRI_Block.SST_fMRI_FM.file{1,1}.size = fresult.bytes;
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.SST_fMRI_Block.SST_fMRI_FM.file{1,1}.path = ffname;   
    end


end

if str2num(compliance_output.SST_fMRI_Block.SST_fMRI_run1.status)
    sUI = compliance_output.SST_fMRI_Block.SST_fMRI_run1.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.SST_fMRI_Block.SST_fMRI_run1.file{1,1}.path = ffname;
        compliance_output.SST_fMRI_Block.SST_fMRI_run1.file{1,1}.size = fresult.bytes;
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.SST_fMRI_Block.SST_fMRI_run1.file{1,1}.path = ffname;   
    end

    sNo = num2str(compliance_output.SST_fMRI_Block.SST_fMRI_run1.SeriesNumber);
    fname = strcat(suidprefixpfile, stUID, prefixpfile, pID, '*se', sNo, '_', '*.t*');
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);

    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.SST_fMRI_Block.SST_fMRI_run1_kspace.file{1,1}.path = ffname;
        compliance_output.SST_fMRI_Block.SST_fMRI_run1_kspace.file{1,1}.size = fresult.bytes;
        compliance_output.SST_fMRI_Block.SST_fMRI_run1_kspace.status = '1';
        compliance_output.SST_fMRI_Block.SST_fMRI_run1_kspace.message = 'k-space data was received';
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.SST_fMRI_Block.SST_fMRI_run1_kspace.file{1,1}.path = ffname;
    end

end

if str2num(compliance_output.SST_fMRI_Block.SST_fMRI_run2.status)
    sUI = compliance_output.SST_fMRI_Block.SST_fMRI_run2.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.SST_fMRI_Block.SST_fMRI_run2.file{1,1}.path = ffname;
        compliance_output.SST_fMRI_Block.SST_fMRI_run2.file{1,1}.size = fresult.bytes;
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.SST_fMRI_Block.SST_fMRI_run2.file{1,1}.path = ffname;
    end

    sNo = num2str(compliance_output.SST_fMRI_Block.SST_fMRI_run2.SeriesNumber);
    fname = strcat(suidprefixpfile, stUID, prefixpfile, pID, '*se', sNo, '_', '*.t*');
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);

    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.SST_fMRI_Block.SST_fMRI_run2_kspace.file{1,1}.path = ffname;
        compliance_output.SST_fMRI_Block.SST_fMRI_run2_kspace.file{1,1}.size = fresult.bytes;
        compliance_output.SST_fMRI_Block.SST_fMRI_run2_kspace.status = '1';
        compliance_output.SST_fMRI_Block.SST_fMRI_run2_kspace.message = 'k-space data was received';
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.SST_fMRI_Block.SST_fMRI_run2_kspace.file{1,1}.path = ffname;
    end

end

%%%

if str2num(compliance_output.nBack_fMRI_Block.nBack_fMRI_FM.status)
    sUI = compliance_output.nBack_fMRI_Block.nBack_fMRI_FM.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.nBack_fMRI_Block.nBack_fMRI_FM.file{1,1}.path = ffname;
        compliance_output.nBack_fMRI_Block.nBack_fMRI_FM.file{1,1}.size = fresult.bytes;
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.nBack_fMRI_Block.nBack_fMRI_FM.file{1,1}.path = ffname;
    end

end

if str2num(compliance_output.nBack_fMRI_Block.nBack_fMRI_run1.status)
    sUI = compliance_output.nBack_fMRI_Block.nBack_fMRI_run1.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.nBack_fMRI_Block.nBack_fMRI_run1.file{1,1}.path = ffname;
        compliance_output.nBack_fMRI_Block.nBack_fMRI_run1.file{1,1}.size = fresult.bytes;
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.nBack_fMRI_Block.nBack_fMRI_run1.file{1,1}.path = ffname;
    end
    
    sNo = num2str(compliance_output.nBack_fMRI_Block.nBack_fMRI_run1.SeriesNumber);
    fname = strcat(suidprefixpfile, stUID, prefixpfile, pID, '*se', sNo, '_', '*.t*');
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);

    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.nBack_fMRI_Block.nBack_fMRI_run1_kspace.file{1,1}.path = ffname;
        compliance_output.nBack_fMRI_Block.nBack_fMRI_run1_kspace.file{1,1}.size = fresult.bytes;
        compliance_output.nBack_fMRI_Block.nBack_fMRI_run1_kspace.status = '1';
        compliance_output.nBack_fMRI_Block.nBack_fMRI_run1_kspace.message = 'k-space data was received';
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.nBack_fMRI_Block.nBack_fMRI_run1_kspace.file{1,1}.path = ffname;
    end


end

if str2num(compliance_output.nBack_fMRI_Block.nBack_fMRI_run2.status)
    sUI = compliance_output.nBack_fMRI_Block.nBack_fMRI_run2.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)  
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.nBack_fMRI_Block.nBack_fMRI_run2.file{1,1}.path = ffname;
        compliance_output.nBack_fMRI_Block.nBack_fMRI_run2.file{1,1}.size = fresult.bytes;
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.nBack_fMRI_Block.nBack_fMRI_run2.file{1,1}.path = ffname;
    end

    sNo = num2str(compliance_output.nBack_fMRI_Block.nBack_fMRI_run2.SeriesNumber);
    fname = strcat(suidprefixpfile, stUID, prefixpfile, pID, '*se', sNo, '_', '*.t*');
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);

    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.nBack_fMRI_Block.nBack_fMRI_run2_kspace.file{1,1}.path = ffname;
        compliance_output.nBack_fMRI_Block.nBack_fMRI_run2_kspace.file{1,1}.size = fresult.bytes;
        compliance_output.nBack_fMRI_Block.nBack_fMRI_run2_kspace.status = '1';
        compliance_output.nBack_fMRI_Block.nBack_fMRI_run2_kspace.message = 'k-space data was received';
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.nBack_fMRI_Block.nBack_fMRI_run2_kspace.file{1,1}.path = ffname;
    end

end

%%%

if str2num(compliance_output.rsfMRI_Block_1.rs_fMRI_FM.status)
    sUI = compliance_output.rsfMRI_Block_1.rs_fMRI_FM.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.rsfMRI_Block_1.rs_fMRI_FM.file{1,1}.path = ffname;
        compliance_output.rsfMRI_Block_1.rs_fMRI_FM.file{1,1}.size = fresult.bytes;
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.rsfMRI_Block_1.rs_fMRI_FM.file{1,1}.path = ffname;
    end

end

if str2num(compliance_output.rsfMRI_Block_1.rs_fMRI_run1.status)
    sUI = compliance_output.rsfMRI_Block_1.rs_fMRI_run1.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.rsfMRI_Block_1.rs_fMRI_run1.file{1,1}.path = ffname;
        compliance_output.rsfMRI_Block_1.rs_fMRI_run1.file{1,1}.size = fresult.bytes;
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.rsfMRI_Block_1.rs_fMRI_run1.file{1,1}.path = ffname;
    end

    sNo = num2str(compliance_output.rsfMRI_Block_1.rs_fMRI_run1.SeriesNumber);
    fname = strcat(suidprefixpfile, stUID, prefixpfile, pID, '*se', sNo, '_', '*.t*');
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);

    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.rsfMRI_Block_1.rs_fMRI_run1_kspace.file{1,1}.path = ffname;
        compliance_output.rsfMRI_Block_1.rs_fMRI_run1_kspace.file{1,1}.size = fresult.bytes;
        compliance_output.rsfMRI_Block_1.rs_fMRI_run1_kspace.status = '1';
        compliance_output.rsfMRI_Block_1.rs_fMRI_run1_kspace.message = 'k-space data was received';
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.rsfMRI_Block_1.rs_fMRI_run1_kspace.file{1,1}.path = ffname;
    end


end

if str2num(compliance_output.rsfMRI_Block_1.rs_fMRI_run2.status)
    sUI = compliance_output.rsfMRI_Block_1.rs_fMRI_run2.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.rsfMRI_Block_1.rs_fMRI_run2.file{1,1}.path = ffname;
        compliance_output.rsfMRI_Block_1.rs_fMRI_run2.file{1,1}.size = fresult.bytes;
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.rsfMRI_Block_1.rs_fMRI_run2.file{1,1}.path = ffname;
    end
    
    sNo = num2str(compliance_output.rsfMRI_Block_1.rs_fMRI_run2.SeriesNumber);
    fname = strcat(suidprefixpfile, stUID, prefixpfile, pID, '*se', sNo, '_', '*.t*');
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);

    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.rsfMRI_Block_1.rs_fMRI_run2_kspace.file{1,1}.path = ffname;
        compliance_output.rsfMRI_Block_1.rs_fMRI_run2_kspace.file{1,1}.size = fresult.bytes;
        compliance_output.rsfMRI_Block_1.rs_fMRI_run2_kspace.status = '1';
        compliance_output.rsfMRI_Block_1.rs_fMRI_run2_kspace.message = 'k-space data was received';
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.rsfMRI_Block_1.rs_fMRI_run2_kspace.file{1,1}.path = ffname;    
    end

end

%%%

if str2num(compliance_output.rsfMRI_Block_2.rs_fMRI_FM.status)
    sUI = compliance_output.rsfMRI_Block_2.rs_fMRI_FM.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.rsfMRI_Block_2.rs_fMRI_FM.file{1,1}.path = ffname;
        compliance_output.rsfMRI_Block_2.rs_fMRI_FM.file{1,1}.size = fresult.bytes;
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.rsfMRI_Block_2.rs_fMRI_FM.file{1,1}.path = ffname;
    end

end

if str2num(compliance_output.rsfMRI_Block_2.rs_fMRI_run1.status)
    sUI = compliance_output.rsfMRI_Block_2.rs_fMRI_run1.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.rsfMRI_Block_2.rs_fMRI_run1.file{1,1}.path = ffname;
        compliance_output.rsfMRI_Block_2.rs_fMRI_run1.file{1,1}.size = fresult.bytes;
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.rsfMRI_Block_2.rs_fMRI_run1.file{1,1}.path = ffname;
    end

    sNo = num2str(compliance_output.rsfMRI_Block_2.rs_fMRI_run1.SeriesNumber);
    fname = strcat(suidprefixpfile, stUID, prefixpfile, pID, '*se', sNo, '_', '*.t*');
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);

    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.rsfMRI_Block_2.rs_fMRI_run1_kspace.file{1,1}.path = ffname;
        compliance_output.rsfMRI_Block_2.rs_fMRI_run1_kspace.file{1,1}.size = fresult.bytes;
        compliance_output.rsfMRI_Block_2.rs_fMRI_run1_kspace.status = '1';
        compliance_output.rsfMRI_Block_2.rs_fMRI_run1_kspace.message = 'k-space data was received';
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.rsfMRI_Block_2.rs_fMRI_run1_kspace.file{1,1}.path = ffname;    
    end


end

if str2num(compliance_output.rsfMRI_Block_2.rs_fMRI_run2.status)
    sUI = compliance_output.rsfMRI_Block_2.rs_fMRI_run2.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.rsfMRI_Block_2.rs_fMRI_run2.file{1,1}.path = ffname;
        compliance_output.rsfMRI_Block_2.rs_fMRI_run2.file{1,1}.size = fresult.bytes;
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.rsfMRI_Block_2.rs_fMRI_run2.file{1,1}.path = ffname;       
    end

    sNo = num2str(compliance_output.rsfMRI_Block_2.rs_fMRI_run2.SeriesNumber);
    fname = strcat(suidprefixpfile, stUID, prefixpfile, pID, '*se', sNo, '_', '*.t*');
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);

    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.rsfMRI_Block_2.rs_fMRI_run2_kspace.file{1,1}.path = ffname;
        compliance_output.rsfMRI_Block_2.rs_fMRI_run2_kspace.file{1,1}.size = fresult.bytes;
        compliance_output.rsfMRI_Block_2.rs_fMRI_run2_kspace.status = '1';
        compliance_output.rsfMRI_Block_2.rs_fMRI_run2_kspace.message = 'k-space data was received';
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.rsfMRI_Block_2.rs_fMRI_run2_kspace.file{1,1}.path = ffname;   
    end

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
