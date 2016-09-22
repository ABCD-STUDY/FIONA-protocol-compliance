function [compliance_output, requiredStruct] = check_nBack_task_compliance(compliance_output, requiredStruct, compliance_key, index)
index(index<2)=[];
for i=1:2:length(index)    

    testingSeries_nBack = requiredStruct(index(i));
    
    %Additional rules for the fMRI task to be added here and checked from using compliance_key
    compliance_output.nBack_fMRI_Block.nBack_fMRI_run1.SeriesInstanceUID = testingSeries_nBack.SeriesInstanceUID;
    compliance_output.nBack_fMRI_Block.nBack_fMRI_run1.SeriesNumber = testingSeries_nBack.SeriesNumber;
    compliance_output.nBack_fMRI_Block.nBack_fMRI_run1.status = '1';
    compliance_output.nBack_fMRI_Block.nBack_fMRI_run1.message = 'Compliant nBack fMRI task was found';  
    
    %Check that field map is preceding the fMRI task
    testingSeries_FM = requiredStruct(index(i)-1);
     if cTypeFinder(testingSeries_FM.fullclassifyType, compliance_key{1,5}.classifyType)
        %Additional rules for the field map to be added here and checked from using compliance_key
        compliance_output.nBack_fMRI_Block.nBack_fMRI_FM.SeriesInstanceUID = testingSeries_FM.SeriesInstanceUID;
        compliance_output.nBack_fMRI_Block.nBack_fMRI_FM.SeriesNumber = testingSeries_FM.SeriesNumber;
        compliance_output.nBack_fMRI_Block.nBack_fMRI_FM.status = '1';
        compliance_output.nBack_fMRI_Block.nBack_fMRI_FM.message = 'Compliant fMRI field map was found preceding nBack fMRI task';
     else
        compliance_output.nBack_fMRI_Block.nBack_fMRI_FM.message = 'There is no fMRI field map preceding nBack fMRI task';
     end
     
    if length(requiredStruct) > index(i)
        testingSeries_nBack_2 = requiredStruct(index(i)+1);
        if cTypeFinder(testingSeries_nBack_2.fullclassifyType, compliance_key{1,9}.classifyType)
            compliance_output.nBack_fMRI_Block.nBack_fMRI_run2.SeriesInstanceUID = testingSeries_nBack_2.SeriesInstanceUID;
            compliance_output.nBack_fMRI_Block.nBack_fMRI_run2.SeriesNumber = testingSeries_nBack_2.SeriesNumber;
            compliance_output.nBack_fMRI_Block.nBack_fMRI_run2.status = '1';
            compliance_output.nBack_fMRI_Block.nBack_fMRI_run2.message = 'Compliant nBack fMRI task was found';
        end
    end
     
         
    %Assuming compliance
    if (str2double(compliance_output.nBack_fMRI_Block.nBack_fMRI_FM.status) &&...,
            str2double(compliance_output.nBack_fMRI_Block.nBack_fMRI_run1.status) &&...,
            str2double(compliance_output.nBack_fMRI_Block.nBack_fMRI_run2.status))
        requiredStruct(index(i)-1)=[];
        requiredStruct(index(i)-1)=[];
        requiredStruct(index(i)-1)=[];  
        compliance_output.nBack_fMRI_Block.status = '1';
        compliance_output.nBack_fMRI_Block.message = 'Compliant ABCD nBack fMRI task component was found';       
        break;  
    end   
end     