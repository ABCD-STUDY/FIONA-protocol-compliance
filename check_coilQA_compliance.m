function [compliance_output, requiredStruct] = check_coilQA_compliance(compliance_output, requiredStruct, compliance_key, index)

%==========Any code to check coilQA compliance ==========%
% Use rules in parsedExam to check compliance


for i=1:length(index)
    compliance = 0;
    testingSeries = requiredStruct(index(i));
    
    %Additional rules to be added here and checked from using compliance_key. Right now assumes
    %compliance if ABCD-Coil-QA classify type is there
    
    compliance = 1;
    
    %Assuming compliance
    if (compliance)
        requiredStruct(index(i))=[];
        compliance_output.ABCD_Coil_QA.SeriesInstanceUID = testingSeries.SeriesInstanceUID;
        compliance_output.ABCD_Coil_QA.SeriesNumber = testingSeries.SeriesNumber;
        compliance_output.ABCD_Coil_QA.status = '1';
        compliance_output.ABCD_Coil_QA.message = 'Compliant Coil-QA series was found';  
        if (cErrorFinder(testingSeries.fullclassifyType))
            compliance_output.ABCD_Coil_QA.message = [compliance_output.ABCD_Coil_QA.message '. Warning: Coil Error Detected'];
        end
        break;
    end
    
end     
