function [compliance_output] = additionalSeriesParsing(compliance_output, requiredStruct, datastore)

stUID = compliance_output.StudyInstanceUID;
suidprefixpfile = 'SUID_';
prefixpfile = '_subjid_';
pID = compliance_output.PatientID;

kspace_index = 0;
for i=1:length(requiredStruct)
    compliance_output.AdditionalSeries{1,i+kspace_index}.status = '0';
    compliance_output.AdditionalSeries{1,i+kspace_index}.message = 'Series is not compliant, it is duplicated, or it is part of an uncompleted block';
    compliance_output.AdditionalSeries{1,i+kspace_index}.ClassifyType = requiredStruct(i).fullclassifyType;
    compliance_output.AdditionalSeries{1,i+kspace_index}.SeriesInstanceUID = requiredStruct(i).SeriesInstanceUID;
    compliance_output.AdditionalSeries{1,i+kspace_index}.SeriesNumber = requiredStruct(i).SeriesNumber;
    
    sUI = compliance_output.AdditionalSeries{1,i+kspace_index}.SeriesInstanceUID;
    fname = sprintf('%s_%s.t*', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.AdditionalSeries{1,i+kspace_index}.file{1,1}.path = ffname;
        compliance_output.AdditionalSeries{1,i+kspace_index}.file{1,1}.size = fresult.bytes;
    else
        ffname = fullfile('/unknown', fname);
        compliance_output.AdditionalSeries{1,i+kspace_index}.file{1,1}.path = ffname;   
    end
    
    sNo = num2str(compliance_output.AdditionalSeries{1,i+kspace_index}.SeriesNumber);
    fname = strcat(suidprefixpfile, stUID, prefixpfile, pID, '*se', sNo, '_', '*.t*');
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);

    if ~isempty(fresult)
        kspace_index = kspace_index + 1;
        fresult = fresult(1,1);
        ffname = fullfile(datastore,fresult.name);
        compliance_output.AdditionalSeries{1,i+kspace_index}.status = '0';
        compliance_output.AdditionalSeries{1,i+kspace_index}.message = sprintf('Raw k-space data for series number: %s', sNo);
        compliance_output.AdditionalSeries{1,i+kspace_index}.ClassifyType = requiredStruct(i).fullclassifyType;
        compliance_output.AdditionalSeries{1,i+kspace_index}.SeriesInstanceUID = requiredStruct(i).SeriesInstanceUID;
        compliance_output.AdditionalSeries{1,i+kspace_index}.SeriesNumber = requiredStruct(i).SeriesNumber;
        compliance_output.AdditionalSeries{1,i+kspace_index}.file{1,1}.path = ffname;
        compliance_output.AdditionalSeries{1,i+kspace_index}.file{1,1}.size = fresult.bytes;   
    else
        kspace_index = kspace_index + 1;
        ffname = fullfile('/unknown', fname);
        compliance_output.AdditionalSeries{1,i+kspace_index}.status = '0';
        compliance_output.AdditionalSeries{1,i+kspace_index}.message = sprintf('Raw k-space data for series number: %s', sNo);
        compliance_output.AdditionalSeries{1,i+kspace_index}.ClassifyType = requiredStruct(i).fullclassifyType;
        compliance_output.AdditionalSeries{1,i+kspace_index}.SeriesInstanceUID = requiredStruct(i).SeriesInstanceUID;
        compliance_output.AdditionalSeries{1,i+kspace_index}.SeriesNumber = requiredStruct(i).SeriesNumber;
        compliance_output.AdditionalSeries{1,i+kspace_index}.file{1,1}.path = ffname;                 
    end
       
end