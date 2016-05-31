function [compliance_output, requiredStruct] = check_DTI_block_compliance_SIEMENS(compliance_output, requiredStruct, compliance_key, index)

%==========Any code to check DTI_block compliance ==========%
% Use rules in parsedExam to check compliance


for i=1:length(index)
    
    testingSeries_DTI = requiredStruct(index(i));
    
    %Additional rules to be added here and checked from using
    %compliance_key. DTI only
        
    compliance_output.DTI_Block.DTI.SeriesInstanceUID = testingSeries_DTI.SeriesInstanceUID;
    compliance_output.DTI_Block.DTI.SeriesNumber = testingSeries_DTI.SeriesNumber;
    compliance_output.DTI_Block.DTI.status = '1';
    compliance_output.DTI_Block.DTI.message = 'Compliant DTI was found';   
    
    
     %First check that field map is followed by DTI
    testingSeries_FM_fwd = requiredStruct(index(i)-2);
    testingSeries_FM_rev = requiredStruct(index(i)-1);
     
    if cTypeFinder(testingSeries_FM_fwd.fullclassifyType, compliance_key{1,3}.classifyType) &&...,
            cTypeFinder(testingSeries_FM_rev.fullclassifyType, compliance_key{1,3}.classifyType)        

        compliance_output.DTI_Block.DTI_FM.SeriesInstanceUID{1} = testingSeries_FM_fwd.SeriesInstanceUID;
        compliance_output.DTI_Block.DTI_FM.SeriesNumber{1} = testingSeries_FM_fwd.SeriesNumber;
        compliance_output.DTI_Block.DTI_FM.SeriesInstanceUID{2} = testingSeries_FM_rev.SeriesInstanceUID;
        compliance_output.DTI_Block.DTI_FM.SeriesNumber{2} = testingSeries_FM_rev.SeriesNumber;
               
        %========Check reversed polarities of field map=======%
        if(testingSeries_FM_fwd.pePolarity == testingSeries_FM_rev.pePolarity)
            compliance_output.DTI_Block.DTI_FM.message = 'Diffusion field map volumes do not have opposed phase encoding direction'; 
        else

        %Additional rules to be added here and checked for FM DTI
           
            compliance_output.DTI_Block.DTI_FM.status = '1';
            compliance_output.DTI_Block.DTI_FM.message = 'Compliant Diffusion field map was found';              
    
        end
    end
    %Assuming compliance
    if (str2double(compliance_output.DTI_Block.DTI_FM.status) && str2double(compliance_output.DTI_Block.DTI.status))
        requiredStruct(index(i)-2)=[];
        requiredStruct(index(i)-2)=[];
        requiredStruct(index(i)-2)=[];  
        compliance_output.DTI_Block.status = '1';
        compliance_output.DTI_Block.message = 'Compliant ABCD-DTI component was found';       
        break;  
    end
end    
end     