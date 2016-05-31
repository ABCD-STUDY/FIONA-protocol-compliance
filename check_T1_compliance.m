function [compliance_output, requiredStruct] = check_T1_compliance(compliance_output, requiredStruct, compliance_key, index)

%==========Any code to check T1 compliance ==========%
% Use rules in parsedExam to check compliance


for i=1:length(index)
    compliance = 0;
    testingSeries = requiredStruct(index(i));
    
    %Additional rules to be added here and checked from using compliance_key. Right now assumes
    %compliance if ABCD-T1 classify type is there
    
    compliance = 1;
    
    %Assuming compliance
    if (compliance)
        requiredStruct(index(i))=[];
        compliance_output.T1.SeriesInstanceUID = testingSeries.SeriesInstanceUID;
        compliance_output.T1.SeriesNumber = testingSeries.SeriesNumber;
        compliance_output.T1.status = '1';
        compliance_output.T1.message = 'Compliant ABCD-T1 series was found';       
        break;  
    end
    
end     