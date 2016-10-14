function [compliance_output, requiredStruct] = check_DTI_block_compliance_SIEMENS(compliance_output, requiredStruct, compliance_key, index)

%==========Any code to check DTI_block compliance ==========%
% Use rules in parsedExam to check compliance

index(index<3)=[];
for i=1:length(index)
    
    testingSeries_DTI = requiredStruct(index(i));
        
    compliance_output.DTI_Block.DTI.SeriesInstanceUID = testingSeries_DTI.SeriesInstanceUID;
    compliance_output.DTI_Block.DTI.SeriesNumber = testingSeries_DTI.SeriesNumber;
    compliance_output.DTI_Block.DTI.status = '1';
    compliance_output.DTI_Block.DTI.message = 'Compliant DTI was found';   
    if (cErrorFinder(testingSeries_DTI.fullclassifyType))
        compliance_output.DTI_Block.DTI.message = [compliance_output.DTI_Block.DTI.message '. Warning: Coil Error Detected'];
    end 
    
     %First check that field map is preceding DTI
    testingSeries_FM_fwd = requiredStruct(index(i)-2);
    testingSeries_FM_rev = requiredStruct(index(i)-1);
     
    if cTypeFinder(testingSeries_FM_fwd.fullclassifyType, compliance_key{1,3}.classifyType) &&...,
            cTypeFinder(testingSeries_FM_rev.fullclassifyType, compliance_key{1,4}.classifyType)        

        compliance_output.DTI_Block.DTI_FM_PA.SeriesInstanceUID = testingSeries_FM_fwd.SeriesInstanceUID;
        compliance_output.DTI_Block.DTI_FM_PA.SeriesNumber = testingSeries_FM_fwd.SeriesNumber;
        compliance_output.DTI_Block.DTI_FM_AP.SeriesInstanceUID = testingSeries_FM_rev.SeriesInstanceUID;
        compliance_output.DTI_Block.DTI_FM_AP.SeriesNumber = testingSeries_FM_rev.SeriesNumber;

        %Additional rules to be added here and checked for FM DTI
           
        compliance_output.DTI_Block.DTI_FM_PA.status = '1';
        compliance_output.DTI_Block.DTI_FM_PA.message = 'Compliant Diffusion field map was found with PA phase encoding';
        if (cErrorFinder(testingSeries_FM_fwd.fullclassifyType))
            compliance_output.DTI_Block.DTI_FM_PA.message = [compliance_output.DTI_Block.DTI_FM_PA.message '. Warning: Coil Error Detected'];
        end 
        
        compliance_output.DTI_Block.DTI_FM_AP.status = '1';
        compliance_output.DTI_Block.DTI_FM_AP.message = 'Compliant Diffusion field map was found with AP phase encoding';
        if (cErrorFinder(testingSeries_FM_rev.fullclassifyType))
            compliance_output.DTI_Block.DTI_FM_AP.message = [compliance_output.DTI_Block.DTI_FM_AP.message '. Warning: Coil Error Detected'];
        end 
    
    end
    %Assuming compliance
    if (str2double(compliance_output.DTI_Block.DTI_FM_AP.status) && str2double(compliance_output.DTI_Block.DTI_FM_PA.status) && str2double(compliance_output.DTI_Block.DTI.status))
        requiredStruct(index(i)-2)=[];
        requiredStruct(index(i)-2)=[];
        requiredStruct(index(i)-2)=[];  
        compliance_output.DTI_Block.status = '1';
        compliance_output.DTI_Block.message = 'Compliant ABCD-DTI component was found';       
        break;  
    end
end    
end     