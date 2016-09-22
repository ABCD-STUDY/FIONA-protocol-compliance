function [compliance_output, requiredStruct] = check_DTI_block_compliance(compliance_output, requiredStruct, compliance_key, index)

%==========Any code to check DTI_block compliance ==========%
% Use rules in parsedExam to check compliance

index(index<2)=[];
for i=1:length(index)
  
    testingSeries_DTI = requiredStruct(index(i));
   
    compliance_output.DTI_Block.DTI.SeriesInstanceUID = testingSeries_DTI.SeriesInstanceUID;
    compliance_output.DTI_Block.DTI.SeriesNumber = testingSeries_DTI.SeriesNumber;
    compliance_output.DTI_Block.DTI.status = '1';
    compliance_output.DTI_Block.DTI.message = 'Compliant DTI was found';     
    
    %First check that field map is preceding DTI
    testingSeries_FM = requiredStruct(index(i)-1);
     if cTypeFinder(testingSeries_FM.fullclassifyType, compliance_key{1,3}.classifyType)
        compliance_output.DTI_Block.DTI_FM.SeriesInstanceUID = testingSeries_FM.SeriesInstanceUID;
        compliance_output.DTI_Block.DTI_FM.SeriesNumber = testingSeries_FM.SeriesNumber;
        compliance_output.DTI_Block.DTI_FM.status = '1';
        compliance_output.DTI_Block.DTI_FM.message = 'Compliant Diffusion field map was found';                  
    end
    
    %Assuming compliance
    if (str2double(compliance_output.DTI_Block.DTI_FM.status) && str2double(compliance_output.DTI_Block.DTI.status))
        requiredStruct(index(i)-1)=[];
        requiredStruct(index(i)-1)=[];  
        compliance_output.DTI_Block.status = '1';
        compliance_output.DTI_Block.message = 'Compliant ABCD-DTI component was found';       
        break;  
    end
    
    
end     