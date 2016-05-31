function [compliance_output, requiredStruct] = check_SST_task_compliance(compliance_output, requiredStruct, compliance_key, index)

for i=1:length(index)    

    testingSeries_SST = requiredStruct(index(i));
    
    %Additional rules for the fMRI task to be added here and checked from using compliance_key
    compliance_output.SST_fMRI_Block.SST_fMRI_run1.SeriesInstanceUID = testingSeries_SST.SeriesInstanceUID;
    compliance_output.SST_fMRI_Block.SST_fMRI_run1.SeriesNumber = testingSeries_SST.SeriesNumber;
    compliance_output.SST_fMRI_Block.SST_fMRI_run1.status = '1';
    compliance_output.SST_fMRI_Block.SST_fMRI_run1.message = 'Compliant SST fMRI task was found';  
    
    %Check that field map is preceding the fMRI task
    testingSeries_FM = requiredStruct(index(i)-1);
     if cTypeFinder(testingSeries_FM.fullclassifyType, compliance_key{1,5}.classifyType)
        %Additional rules for the field map to be added here and checked from using compliance_key
        compliance_output.SST_fMRI_Block.SST_fMRI_FM.SeriesInstanceUID = testingSeries_FM.SeriesInstanceUID;
        compliance_output.SST_fMRI_Block.SST_fMRI_FM.SeriesNumber = testingSeries_FM.SeriesNumber;
        compliance_output.SST_fMRI_Block.SST_fMRI_FM.status = '1';
        compliance_output.SST_fMRI_Block.SST_fMRI_FM.message = 'Compliant fMRI field map was found preceding SST fMRI task';
     else
        compliance_output.SST_fMRI_Block.SST_fMRI_FM.message = 'There is no fMRI field map preceding SST fMRI task';
     end
    
    if length(requiredStruct) > index(i)
        testingSeries_SST_2 = requiredStruct(index(i)+1);
        if cTypeFinder(testingSeries_SST_2.fullclassifyType, compliance_key{1,8}.classifyType)
            compliance_output.SST_fMRI_Block.SST_fMRI_run2.SeriesInstanceUID = testingSeries_SST_2.SeriesInstanceUID;
            compliance_output.SST_fMRI_Block.SST_fMRI_run2.SeriesNumber = testingSeries_SST_2.SeriesNumber;
            compliance_output.SST_fMRI_Block.SST_fMRI_run2.status = '1';
            compliance_output.SST_fMRI_Block.SST_fMRI_run2.message = 'Compliant SST fMRI task was found';
        end
    end
     
    %Assuming compliance
    if (str2double(compliance_output.SST_fMRI_Block.SST_fMRI_FM.status) &&...,
            str2double(compliance_output.SST_fMRI_Block.SST_fMRI_run1.status) &&...,
            str2double(compliance_output.SST_fMRI_Block.SST_fMRI_run2.status))
        requiredStruct(index(i)-1)=[];
        requiredStruct(index(i)-1)=[];  
        requiredStruct(index(i)-1)=[];  
        compliance_output.SST_fMRI_Block.status = '1';
        compliance_output.SST_fMRI_Block.message = 'Compliant ABCD SST fMRI task component was found';       
        break;  
    end   
end     