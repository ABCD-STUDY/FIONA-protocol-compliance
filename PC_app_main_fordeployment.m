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
    compliance_output.Session_1.T1.acquired = 'Yes';
    fprintf('Input directory does not exist. Aborting...\n');
    return;
end

% ============= Load keys ===========================%

compliance_key=loadjson('compliance_key.json');
compliance_output=loadjson('compliance_output.json');


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
        
        if (~isempty(compliance_output.Session_1.error_messages))
           compliance_output.Session_1.error_messages{length(compliance_output.Session_1.error_messages)+1} = sprintf('corrupted json file: %s', fname); 
        else
           compliance_output.Session_1.error_messages{1} = sprintf('corrupted json file: %s', fname);
        end
        errorlist = [errorlist, i];
        continue;
    end
    requiredStruct(i).fullclassifyType = parsedExam.ClassifyType;
    requiredStruct(i).classifyType = parsedExam.ClassifyType{end};
    requiredStruct(i).manufacturer = parsedExam.Manufacturer;
    if (strcmp(requiredStruct(i).manufacturer, 'SIEMENS'))
       requiredStruct(i).pePolarity = parsedExam.PhaseEncodingDirectionPositive; 
    end
    requiredStruct(i).SeriesInstanceUID = parsedExam.SeriesInstanceUID;
    requiredStruct(i).SeriesNumber = str2double(parsedExam.SeriesNumber);
    
    %%%Scan Info
    compliance_output.Session_1.StudyDate = parsedExam.StudyDate;
    compliance_output.Session_1.StudyTime =  parsedExam.StudyTime;
    compliance_output.Session_1.StudyInstanceUID = parsedExam.StudyInstanceUID;
    compliance_output.Session_1.Manufacturer = parsedExam.Manufacturer;
    compliance_output.Session_1.ManufacturerModelName = parsedExam.Manufacturer;
    
end

requiredStruct(errorlist)=[];

seriesNumbers = [requiredStruct(:).SeriesNumber];
[~,idx] = sort(seriesNumbers);
requiredStruct = requiredStruct(idx); 


%======== Search for ABCD-T1 Series ================%

index = find(strcmp({requiredStruct.classifyType}, compliance_key{1,1}.classifyType)==1);

if (~isempty(index))
    [compliance_output, requiredStruct] = check_T1_compliance(compliance_output, requiredStruct, compliance_key{1,1}, index);
else
    compliance_output.Session_1.T1.message = 'ABCD-T1 classify type was not found';
end

%======== Search for ABCD-T2 Series ================%

index = find(strcmp({requiredStruct.classifyType}, compliance_key{1,2}.classifyType)==1);

if (~isempty(index))
    [compliance_output, requiredStruct] = check_T2_compliance(compliance_output, requiredStruct, compliance_key{1,2}, index);
else
    compliance_output.Session_1.T2.message = 'ABCD-T2 classify type was not found';
end

%======== Search for ABCD-DTI Block ================%

index = find(strcmp({requiredStruct.classifyType}, compliance_key{1,3}.classifyType)==1);

if (~isempty(index))
    if strcmp(requiredStruct(index(1)).manufacturer,'SIEMENS')
        [compliance_output, requiredStruct] = check_DTI_block_compliance_SIEMENS(compliance_output, requiredStruct, compliance_key, index);
    else
        [compliance_output, requiredStruct] = check_DTI_block_compliance(compliance_output, requiredStruct, compliance_key, index);
    end
else
    compliance_output.Session_1.DTI_Block.message = 'Compliant DTI component was not found. A compliant DTI component should include a Diffusion field map followed by a DTI acquisition';
end

%======== Search for ABCD-rsFMRI Block ================%


index = find(strcmp({requiredStruct.classifyType}, compliance_key{1,5}.classifyType)==1);

if (~isempty(index))
        if strcmp(requiredStruct(index(1)).manufacturer,'SIEMENS')
            [compliance_output, requiredStruct] = check_rsfMRI_block_compliance_SIEMENS(compliance_output, requiredStruct, compliance_key, index);
        else
            [compliance_output, requiredStruct] = check_rsfMRI_block_compliance(compliance_output, requiredStruct, compliance_key, index);
        end
else
    compliance_output.Session_1.rsfMRI_Block.message = 'Compliant resting state fMRI component was not found. A compliant resting state fMRI component should include the following acquisition sequence: field map, rsfMRI run#1, rsfMRI run#2, field map, rsfMRI run#3. Additionally, rsfMRI run#4 recommended but not mandatory for compliance';
end



%======== Search for ABCD-fMRI task1 Block ================%



%======== Search for ABCD-fMRI task2 Block ================%



%======== Search for ABCD-fMRI task3 Block ================%


%======== Tag leftover series ====================%
        
compliance_output = additionalSeriesParsing(compliance_output, requiredStruct);

%==== Check Session 1 compliance ===%

if (str2double(compliance_output.Session_1.rsfMRI_Block.status)...,
        && str2double(compliance_output.Session_1.DTI_Block.status)...,
        && str2double(compliance_output.Session_1.T1.status)...,
        && str2double(compliance_output.Session_1.T2.status))

    compliance_output.Session_1.status = '1'; 
    compliance_output.Session_1.message = 'Session 1 is compliant with the ABCD protocol'; 

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

