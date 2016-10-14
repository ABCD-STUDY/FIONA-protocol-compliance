function [compliance_output, requiredStruct] = check_T2_compliance(compliance_output, requiredStruct, compliance_key, index)

%==========Any code to check T2 compliance ==========%
% Use rules in parsedExam to check compliance


for i=1:length(index)
    compliance = 0;
    testingSeries = requiredStruct(index(i));
    
    %Additional rules to be added here and checked from using compliance_key. Right now assumes
    %compliance if ABCD-T2 classify type is there
    
    compliance = 1;
    
    %Assuming compliance
    if (compliance)
        requiredStruct(index(i))=[];
        compliance_output.T2.SeriesInstanceUID = testingSeries.SeriesInstanceUID;
        compliance_output.T2.SeriesNumber = testingSeries.SeriesNumber;
        compliance_output.T2.status = '1';
        compliance_output.T2.message = 'Compliant ABCD-T2 series was found';
        if (cErrorFinder(testingSeries.fullclassifyType))
            compliance_output.T2.message = [compliance_output.T2.message '. Warning: Coil Error Detected'];
        end
        break;  
    end
    
end       