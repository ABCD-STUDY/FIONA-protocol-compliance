function PC_app_main_fordeployment(input, varargin)
%HUMAN_QC_MAIN Summary of this function goes here
%   Detailed explanation goes here
tic
% ============== parse input arguments ============== %

if nargin <3
    fprintf('Requires input, output and data storage directory. Aborting...\n');
    return;
else
    output = varargin{1};
    datastore = varargin{2};
end


% ============= Load keys ===========================%

phantom_compliance_key=loadjson('./phantom_compliance_key.json');
compliance_key=loadjson('./compliance_key.json');
compliance_key_siemens=loadjson('./compliance_key_SIEMENS.json');

compliance_output=loadjson('./compliance_output.json');

unwanted_keys = loadjson('./skip_key.json');

%===================================%

inputFolderList = dir(fullfile(input,'*.json'));

jsonDatenum = [inputFolderList(:).datenum];
[~,idx] = sort(jsonDatenum);
filelist = {inputFolderList(idx).name}; 

requiredStruct = ([]);
skipedStruct =([]);
errorlist = [];
index = 1;
s_index = 1;
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
        errorlist = [errorlist, index];
        continue;
    end
    
    fullclassifyType = parsedExam.ClassifyType;
    skiptypes = unwanted_keys.ClassifyTypes;
    if(sTypeFinder(fullclassifyType, skiptypes))
        skipedStruct(s_index).fullclassifyType = parsedExam.ClassifyType;
        skipedStruct(s_index).manufacturer = parsedExam.Manufacturer;
        skipedStruct(s_index).SeriesInstanceUID = parsedExam.SeriesInstanceUID;
        skipedStruct(s_index).SeriesNumber = str2double(parsedExam.SeriesNumber);
        s_index = s_index + 1;
        continue;
    end
    
    requiredStruct(index).fullclassifyType = parsedExam.ClassifyType;
    requiredStruct(index).manufacturer = parsedExam.Manufacturer;
    requiredStruct(index).SeriesInstanceUID = parsedExam.SeriesInstanceUID;
    requiredStruct(index).SeriesNumber = str2double(parsedExam.SeriesNumber);
    
    %%%Scan Info
    compliance_output.StudyDate = parsedExam.StudyDate;
    compliance_output.StudyTime =  parsedExam.StudyTime;
    compliance_output.StudyInstanceUID = parsedExam.StudyInstanceUID;
    compliance_output.Manufacturer = parsedExam.Manufacturer;
    compliance_output.ManufacturerModelName = parsedExam.Manufacturer;
    compliance_output.PatientID = parsedExam.PatientID;
    compliance_output.PatientName = parsedExam.PatientName;
    index = index + 1;
end

requiredStruct(errorlist)=[];

seriesNumbers = [requiredStruct(:).SeriesNumber];
[~,idx] = sort(seriesNumbers);
requiredStruct = requiredStruct(idx); 


%====================Select phantom or human PC====================%

[phantom_result] = check_phantomQA(requiredStruct, phantom_compliance_key);

if phantom_result
    phantom_compliance(requiredStruct, phantom_compliance_key, compliance_output, output, datastore, skipedStruct) 

else
    if any(strfind(parsedExam.Manufacturer, 'GE'))
        human_compliance(requiredStruct, compliance_key, compliance_output, output, datastore, skipedStruct);
    elseif any(strfind(parsedExam.Manufacturer, 'SIEMENS')) 
        human_compliance_SIEMENS(requiredStruct, compliance_key_siemens, compliance_output, output, datastore, skipedStruct);
    elseif any(strfind(parsedExam.Manufacturer, 'Philips'))
        human_compliance_SIEMENS(requiredStruct, compliance_key_siemens, compliance_output, output, datastore, skipedStruct); %Initially Philips compliance should be similar to SIEMENS
    else
        return
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

toc

fprintf('Finished\n');


end

