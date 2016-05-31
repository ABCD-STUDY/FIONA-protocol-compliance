function PC_app_main_fordeployment(input,varargin)
%HUMAN_QC_MAIN Summary of this function goes here
%   Detailed explanation goes here
tic
% ============== parse input arguments ============== %

if nargin <2
    fprintf('Requires input and output directory. Aborting...\n');
    return;
elseif nargin == 2
    output = varargin{1};
end

if ~exist(input, 'dir')               
    fprintf('Input directory does not exist. Aborting...\n');
    return;
end

if ~exist(output, 'dir')               
    mkdir(output);
    fprintf('Creating output directory...\n');
end

% ============= Load keys ===========================%

compliance_key=loadjson('./compliance_key.json');
compliance_output=loadjson('./compliance_output.json');


%===================================%

inputFolderList = dir(fullfile(input,'*.json'));

jsonDatenum = [inputFolderList(:).datenum];
[~,idx] = sort(jsonDatenum);
filelist = {inputFolderList(idx).name}; 

requiredStruct = ([]);
errorlist = [];
for i=1:length(filelist)

    fname = fullfile(input,filelist{i});
    try 
        parsedExam = loadjson(fname);   
    
    catch ME
        
        if (~isempty(compliance_output.error_messages))
           compliance_output.error_messages{length(compliance_output.error_messages)+1} = sprintf('corrupted json file: %s', fname); 
        else
           compliance_output.error_messages{1} = sprintf('corrupted json file: %s', fname);
        end
        errorlist = [errorlist, i];
        continue;
    end
    requiredStruct(i).fullclassifyType = parsedExam.ClassifyType;
    requiredStruct(i).manufacturer = parsedExam.Manufacturer;
    if (strcmp(requiredStruct(i).manufacturer, 'SIEMENS'))
       requiredStruct(i).pePolarity = parsedExam.PhaseEncodingDirectionPositive; 
    end
    requiredStruct(i).SeriesInstanceUID = parsedExam.SeriesInstanceUID;
    requiredStruct(i).SeriesNumber = str2double(parsedExam.SeriesNumber);
    
    %%%Scan Info
    compliance_output.StudyDate = parsedExam.StudyDate;
    compliance_output.StudyTime =  parsedExam.StudyTime;
    compliance_output.StudyInstanceUID = parsedExam.StudyInstanceUID;
    compliance_output.Manufacturer = parsedExam.Manufacturer;
    compliance_output.ManufacturerModelName = parsedExam.Manufacturer;
    
end

requiredStruct(errorlist)=[];

seriesNumbers = [requiredStruct(:).SeriesNumber];
[~,idx] = sort(seriesNumbers);
requiredStruct = requiredStruct(idx); 


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
    if strcmp(requiredStruct(index(1)).manufacturer,'SIEMENS')
        [compliance_output, requiredStruct] = check_DTI_block_compliance_SIEMENS(compliance_output, requiredStruct, compliance_key, index);
    else
        [compliance_output, requiredStruct] = check_DTI_block_compliance(compliance_output, requiredStruct, compliance_key, index);
    end
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
        if strcmp(requiredStruct(index(1)).manufacturer,'SIEMENS')
            [compliance_output, requiredStruct] = check_rsfMRI_block_compliance_SIEMENS(compliance_output, requiredStruct, compliance_key, index);
        else
            [compliance_output, requiredStruct] = check_rsfMRI_block_compliance(compliance_output, requiredStruct, compliance_key, index);
        end
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
    if strcmp(requiredStruct(index(1)).manufacturer,'SIEMENS')
        [compliance_output, requiredStruct] = check_MID_task_compliance_SIEMENS(compliance_output, requiredStruct, compliance_key, index);
    else
        [compliance_output, requiredStruct] = check_MID_task_compliance(compliance_output, requiredStruct, compliance_key, index);
    end
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
    if strcmp(requiredStruct(index(1)).manufacturer,'SIEMENS')
        [compliance_output, requiredStruct] = check_SST_task_compliance_SIEMENS(compliance_output, requiredStruct, compliance_key, index);
    else
        [compliance_output, requiredStruct] = check_SST_task_compliance(compliance_output, requiredStruct, compliance_key, index);
    end
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
    if strcmp(requiredStruct(index(1)).manufacturer,'SIEMENS')
        [compliance_output, requiredStruct] = check_nBack_task_compliance_SIEMENS(compliance_output, requiredStruct, compliance_key, index);
    else
        [compliance_output, requiredStruct] = check_nBack_task_compliance(compliance_output, requiredStruct, compliance_key, index);
    end
else
    compliance_output.nBack_fMRI_Block.message = 'Compliant nBack fMRI task was not found. A compliant nBack fMRI task component should include a fMRI field map followed by the nBack fMRI task acquisition';
end



%======== Tag leftover series ====================%
        
compliance_output = additionalSeriesParsing(compliance_output, requiredStruct);



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
    compliance_output.message = 'A completed compliant protocol was obtained';
    compliance_output.subsession_status = '1'; 
    compliance_output.subsession_message = 'A completed compliant protocol was obtained'; 

elseif (str2double(compliance_output.rsfMRI_Block_1.status)...,
        && str2double(compliance_output.rsfMRI_Block_2.status)...,
        && str2double(compliance_output.DTI_Block.status)...,
        && str2double(compliance_output.T1.status)...,
        && str2double(compliance_output.T2.status))
    
    compliance_output.status = '0'; 
    compliance_output.message = 'Full protocol is not completed';
    compliance_output.subsession_status = '1'; 
    compliance_output.subsession_message = 'A completed compliant session was acquired. Session 1 Type A (Two session based acquisition)'; 
    
elseif (str2double(compliance_output.rsfMRI_Block_1.status)...,
        && str2double(compliance_output.rsfMRI_Block_2.status)...,
        && str2double(compliance_output.DTI_Block.status)...,
        && str2double(compliance_output.T2.status))
    
    compliance_output.status = '0'; 
    compliance_output.message = 'Full protocol is not completed';
    compliance_output.subsession_status = '1'; 
    compliance_output.subsession_message = 'A completed compliant session was acquired. Session 2 Type B (Two session based acquisition)'; 

elseif  (str2double(compliance_output.nBack_fMRI_Block.status)...,
        && str2double(compliance_output.MID_fMRI_Block.status)...,
        && str2double(compliance_output.SST_fMRI_Block.status)...,
        && str2double(compliance_output.T1.status))
    
    compliance_output.status = '0'; 
    compliance_output.message = 'Full protocol is not completed';
    compliance_output.subsession_status = '1'; 
    compliance_output.subsession_message = 'A completed compliant session was acquired. Session 1 Type B (Two session based acquisition)';   
    
elseif  (str2double(compliance_output.nBack_fMRI_Block.status)...,
        && str2double(compliance_output.MID_fMRI_Block.status)...,
        && str2double(compliance_output.SST_fMRI_Block.status))
    
    compliance_output.status = '0'; 
    compliance_output.message = 'Full protocol is not completed';
    compliance_output.subsession_status = '1'; 
    compliance_output.subsession_message = 'A completed compliant session was acquired. Session 2 Type A (Two session based acquisition)';  
       
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%if isdeployed    
    % write out proc.json for smart routing
    fname_proc = sprintf('%s/compliance_output.json', output);
    opt.FileName = fname_proc;
    opt.ArrayIndent = 0;
    opt.NoRowBracket = 1;
    savejson('',compliance_output,opt);
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


fprintf('Finished\n');

toc


end

