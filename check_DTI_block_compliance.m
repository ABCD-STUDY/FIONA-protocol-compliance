function [compliance_output, requiredStruct] = check_DTI_block_compliance(compliance_output, requiredStruct, compliance_key, index)

%==========Any code to check DTI_block compliance ==========%
% Use rules in parsedExam to check compliance


for i=1:length(index)
if length(requiredStruct) < index(i)+1  %At least the requested series should be present
    break;
else      
    %First check that field map is followed by DTI
    testingSeries_FM = requiredStruct(index(i));
    testingSeries_DTI = requiredStruct(index(i)+1);
    
    %if strcmp({testingSeries_DTI.classifyType}, compliance_key{1,4}.classifyType)
     if cTypeFinder(testingSeries_DTI.fullclassifyType, compliance_key{1,4}.classifyType)
        %Additional rules to be added here and checked from using compliance_key. Right now assumes
        %compliance if DTI block includes consecutive FM and DTI
        compliance_output.Session_1.DTI_Block.DTI_FM.SeriesInstanceUID = testingSeries_FM.SeriesInstanceUID;
        compliance_output.Session_1.DTI_Block.DTI_FM.SeriesNumber = testingSeries_FM.SeriesNumber;
        compliance_output.Session_1.DTI_Block.DTI_FM.status = '1';
        compliance_output.Session_1.DTI_Block.DTI_FM.message = 'Compliant Diffusion field map was found';     
        
        compliance_output.Session_1.DTI_Block.DTI.SeriesInstanceUID = testingSeries_DTI.SeriesInstanceUID;
        compliance_output.Session_1.DTI_Block.DTI.SeriesNumber = testingSeries_DTI.SeriesNumber;
        compliance_output.Session_1.DTI_Block.DTI.status = '1';
        compliance_output.Session_1.DTI_Block.DTI.message = 'Compliant DTI was found';            
    end
    
    %Assuming compliance
    if (str2double(compliance_output.Session_1.DTI_Block.DTI_FM.status) && str2double(compliance_output.Session_1.DTI_Block.DTI.status))
        requiredStruct(index(i))=[];
        requiredStruct(index(i))=[];  
        compliance_output.Session_1.DTI_Block.status = '1';
        compliance_output.Session_1.DTI_Block.message = 'Compliant ABCD-DTI component was found';       
        break;  
    end
end    
end     