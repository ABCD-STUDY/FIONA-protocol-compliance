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
    compliance_output.PatientID = parsedExam.PatientID;
    compliance_output.PatientName = parsedExam.PatientName;
end

requiredStruct(errorlist)=[];

seriesNumbers = [requiredStruct(:).SeriesNumber];
[~,idx] = sort(seriesNumbers);
requiredStruct = requiredStruct(idx); 


%====================Select phantom or human PC====================%

[phantom_result] = check_phantomQA(requiredStruct, phantom_compliance_key);

if phantom_result
    phantom_compliance(requiredStruct, phantom_compliance_key, compliance_output, output, datastore) 
else
    human_compliance(requiredStruct, compliance_key, compliance_output, output, datastore);
end;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

toc

fprintf('Finished\n');


end

