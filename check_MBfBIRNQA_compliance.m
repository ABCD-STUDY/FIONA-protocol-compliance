function [compliance_output, requiredStruct] = check_MBfBIRNQA_compliance(compliance_output, requiredStruct, compliance_key, index)

%==========Any code to check coilQA compliance ==========%
% Use rules in parsedExam to check compliance


for i=1:length(index)
    compliance = 0;
    testingSeries = requiredStruct(index(i));
    
    %Additional rules to be added here and checked from using compliance_key. Right now assumes
    %compliance if ABCD-MB-fMRI-QA classify type is there
    
    compliance = 1;
    
    %Assuming compliance
    if (compliance)
        requiredStruct(index(i))=[];
        compliance_output.ABCD_MB_fMRI_QA.SeriesInstanceUID = testingSeries.SeriesInstanceUID;
        compliance_output.ABCD_MB_fMRI_QA.SeriesNumber = testingSeries.SeriesNumber;
        compliance_output.ABCD_MB_fMRI_QA.status = '1';
        compliance_output.ABCD_MB_fMRI_QA.message = 'Compliant Coil-QA series was found';       
        break;  
    end
    
end     
