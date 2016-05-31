function [compliance_output] = additionalSeriesParsing(compliance_output, requiredStruct)

for i=1:length(requiredStruct)

    compliance_output.AdditionalSeries{1,i}.ClassifyType = requiredStruct(i).fullclassifyType;
    compliance_output.AdditionalSeries{1,i}.SeriesInstanceUID = requiredStruct(i).SeriesInstanceUID;
    compliance_output.AdditionalSeries{1,i}.SeriesNumber = requiredStruct(i).SeriesNumber;
end