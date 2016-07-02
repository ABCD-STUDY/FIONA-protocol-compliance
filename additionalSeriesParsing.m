function [compliance_output] = additionalSeriesParsing(compliance_output, requiredStruct, datastore)

stUID = compliance_output.StudyInstanceUID;
prefixpfile = 'subjid';
pID = compliance_output.PatientID;

kspace_index = 0;
for i=1:length(requiredStruct)
    compliance_output.AdditionalSeries{1,i+kspace_index}.status = '0';
    compliance_output.AdditionalSeries{1,i+kspace_index}.message = 'Series is not compliant or it is part of an uncompleted block';
    compliance_output.AdditionalSeries{1,i+kspace_index}.ClassifyType = requiredStruct(i+kspace_index).fullclassifyType;
    compliance_output.AdditionalSeries{1,i+kspace_index}.SeriesInstanceUID = requiredStruct(i+kspace_index).SeriesInstanceUID;
    compliance_output.AdditionalSeries{1,i+kspace_index}.SeriesNumber = requiredStruct(i+kspace_index).SeriesNumber;
    
    sUI = compliance_output.AdditionalSeries{1,i+kspace_index}.SeriesInstanceUID;
    fname = sprintf('%s_%s.tar', stUID, sUI);
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);
    
    if ~isempty(fresult)
        ffname = fullfile(datastore,fresult.name);
        compliance_output.AdditionalSeries{1,i+kspace_index}.file{1,1}.path = ffname;
        compliance_output.AdditionalSeries{1,i+kspace_index}.file{1,1}.size = fresult.bytes;
    end
    
    sNo = num2str(compliance_output.AdditionalSeries{1,i+kspace_index}.SeriesNumber);
    fname = strcat(prefixpfile, pID, '*se', sNo, '*.tgz');
    ffname = fullfile (datastore, fname);
    fresult = dir(ffname);

    if ~isempty(fresult)
        kspace_index = kspace_index + 1;
        ffname = fullfile(datastore,fresult.name);
        compliance_output.AdditionalSeries{1,i+kspace_index}.status = '0';
        compliance_output.AdditionalSeries{1,i+kspace_index}.message = sprintf('Raw k-space data for series number: %s', sNo);
        compliance_output.AdditionalSeries{1,i+kspace_index}.ClassifyType = requiredStruct(i+kspace_index-1).fullclassifyType;
        compliance_output.AdditionalSeries{1,i+kspace_index}.SeriesInstanceUID = compliance_output.AdditionalSeries{1,i+kspace_index-1}.SeriesInstanceUID;
        compliance_output.AdditionalSeries{1,i+kspace_index}.SeriesNumber = compliance_output.AdditionalSeries{1,i+kspace_index-1}.SeriesNumber;
        compliance_output.AdditionalSeries{1,i+kspace_index}.file{1,1}.path = ffname;
        compliance_output.AdditionalSeries{1,i+kspace_index}.file{1,1}.size = fresult.bytes;

    end
    
    
end