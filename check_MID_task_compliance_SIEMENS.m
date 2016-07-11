function [compliance_output, requiredStruct] = check_MID_task_compliance_SIEMENS(compliance_output, requiredStruct, compliance_key, index)

%==========Any code to check MID_task_block compliance for SIEMENS==========%

% Use rules in parsedExam to check compliance

%%%% Check for the 2 runs MID fMRI experiment with FM

for i=1:2:length(index)    

    testingSeries_MID = requiredStruct(index(i));
    
  
    compliance_output.MID_fMRI_Block.MID_fMRI_run1.SeriesInstanceUID = testingSeries_MID.SeriesInstanceUID;
    compliance_output.MID_fMRI_Block.MID_fMRI_run1.SeriesNumber = testingSeries_MID.SeriesNumber;
    compliance_output.MID_fMRI_Block.MID_fMRI_run1.status = '1';
    compliance_output.MID_fMRI_Block.MID_fMRI_run1.message = 'Compliant MID fMRI task was found';  
    
    %Check that field map is preceding the fMRI task
    
    testingSeries_FM_fwd = requiredStruct(index(i)-2);
    testingSeries_FM_rev = requiredStruct(index(i)-1);
    
    if cTypeFinder(testingSeries_FM_fwd.fullclassifyType, compliance_key{1,6}.classifyType) &&...,
            cTypeFinder(testingSeries_FM_rev.fullclassifyType, compliance_key{1,7}.classifyType)
        
        compliance_output.MID_fMRI_Block.MID_fMRI_FM_PA.SeriesInstanceUID = testingSeries_FM_fwd.SeriesInstanceUID;
        compliance_output.MID_fMRI_Block.MID_fMRI_FM_PA.SeriesNumber = testingSeries_FM_fwd.SeriesNumber;
        compliance_output.MID_fMRI_Block.MID_fMRI_FM_AP.SeriesInstanceUID = testingSeries_FM_rev.SeriesInstanceUID;
        compliance_output.MID_fMRI_Block.MID_fMRI_FM_AP.SeriesNumber = testingSeries_FM_rev.SeriesNumber;

        compliance_output.MID_fMRI_Block.MID_fMRI_FM_PA.status = '1';
        compliance_output.MID_fMRI_Block.MID_fMRI_FM_PA.message = 'fMRI field map acquisition with PA phase encoding direction is compliant with ABCD protocol';   
        
        compliance_output.MID_fMRI_Block.MID_fMRI_FM_AP.status = '1';
        compliance_output.MID_fMRI_Block.MID_fMRI_FM_AP.message = 'fMRI field map acquisition with AP phase encoding direction is compliant with ABCD protocol';   
    end
    
     
    if length(requiredStruct) > index(i)
        testingSeries_MID_2 = requiredStruct(index(i)+1);
        if cTypeFinder(testingSeries_MID_2.fullclassifyType, compliance_key{1,9}.classifyType)
            compliance_output.MID_fMRI_Block.MID_fMRI_run2.SeriesInstanceUID = testingSeries_MID_2.SeriesInstanceUID;
            compliance_output.MID_fMRI_Block.MID_fMRI_run2.SeriesNumber = testingSeries_MID_2.SeriesNumber;
            compliance_output.MID_fMRI_Block.MID_fMRI_run2.status = '1';
            compliance_output.MID_fMRI_Block.MID_fMRI_run2.message = 'Compliant MID fMRI task was found';
        end
    end
                   
    %Assuming compliance
    if (str2double(compliance_output.MID_fMRI_Block.MID_fMRI_FM_PA.status) &&...,
            str2double(compliance_output.MID_fMRI_Block.MID_fMRI_FM_AP.status) &&...,
            str2double(compliance_output.MID_fMRI_Block.MID_fMRI_run1.status) &&...,
            str2double(compliance_output.MID_fMRI_Block.MID_fMRI_run2.status))
        requiredStruct(index(i)-2)=[];
        requiredStruct(index(i)-2)=[];
        requiredStruct(index(i)-2)=[];
        requiredStruct(index(i)-2)=[];
        compliance_output.MID_fMRI_Block.status = '1';
        compliance_output.MID_fMRI_Block.message = 'Compliant ABCD MID fMRI task component was found';       
        break;  
    end   
end     
