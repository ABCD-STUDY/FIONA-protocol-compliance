function [compliance_output] = additionalSeriesParsing(compliance_output, requiredStruct)

for i=1:length(requiredStruct)

    compliance_output.Session_1.AdditionalSeriesInstanceUID{i} = requiredStruct(i).SeriesInstanceUID;
    compliance_output.Session_1.AdditionalSeriesNumber{i} = requiredStruct(i).SeriesNumber;
    compliance_output.Session_1.AdditionalClassifyType{i} = requiredStruct(i).classifyType;

end