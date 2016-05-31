function [compliance_output, requiredStruct] = check_rsfMRI_block_compliance_SIEMENS(compliance_output, requiredStruct, compliance_key, index)

%==========Any code to check rsfMRI_block compliance ==========%
% Use rules in parsedExam to check compliance


for i=1:length(index)

    testingSeries_rsfMRI_1 = requiredStruct(index(i));
    
    compliance_output.rsfMRI_Block_1.rs_fMRI_run1.SeriesInstanceUID = testingSeries_rsfMRI_1.SeriesInstanceUID;
    compliance_output.rsfMRI_Block_1.rs_fMRI_run1.SeriesNumber = testingSeries_rsfMRI_1.SeriesNumber;
    compliance_output.rsfMRI_Block_1.rs_fMRI_run1.status = '1';
    compliance_output.rsfMRI_Block_1.rs_fMRI_run1.message = 'Resting state fMRI run is compliant with ABCD protocol';   
    
    if length(requiredStruct) > index(i)
        testingSeries_rsfMRI_2 = requiredStruct(index(i)+1);

        if cTypeFinder(testingSeries_rsfMRI_2.fullclassifyType, compliance_key{1,6}.classifyType)
            compliance_output.rsfMRI_Block_1.rs_fMRI_run2.SeriesInstanceUID = testingSeries_rsfMRI_2.SeriesInstanceUID;
            compliance_output.rsfMRI_Block_1.rs_fMRI_run2.SeriesNumber = testingSeries_rsfMRI_2.SeriesNumber;
            compliance_output.rsfMRI_Block_1.rs_fMRI_run2.status = '1';
            compliance_output.rsfMRI_Block_1.rs_fMRI_run2.message = 'Resting state fMRI run is compliant with ABCD protocol';

        end
    end
    
    testingSeries_FM_fwd = requiredStruct(index(i)-2);
    testingSeries_FM_rev = requiredStruct(index(i)-1);
    
    if cTypeFinder(testingSeries_FM_fwd.fullclassifyType, compliance_key{1,5}.classifyType) &&...,
            cTypeFinder(testingSeries_FM_rev.fullclassifyType, compliance_key{1,5}.classifyType)
        
        compliance_output.rsfMRI_Block_1.rs_fMRI_FM.SeriesInstanceUID{1} = testingSeries_FM_fwd.SeriesInstanceUID;
        compliance_output.rsfMRI_Block_1.rs_fMRI_FM.SeriesNumber{1} = testingSeries_FM_fwd.SeriesNumber;
        compliance_output.rsfMRI_Block_1.rs_fMRI_FM.SeriesInstanceUID{2} = testingSeries_FM_rev.SeriesInstanceUID;
        compliance_output.rsfMRI_Block_1.rs_fMRI_FM.SeriesNumber{2} = testingSeries_FM_rev.SeriesNumber;
        
        if (testingSeries_FM_fwd.pePolarity == testingSeries_FM_rev.pePolarity) 
            compliance_output.rsfMRI_Block_1.rs_fMRI_FM.message = 'Resting state field map volumes do not have different phase encoding polarity'; 
        else
            compliance_output.rsfMRI_Block_1.rs_fMRI_FM.status = '1';
            compliance_output.rsfMRI_Block_1.rs_fMRI_FM.message = 'fMRI field map acquisition is compliant with ABCD protocol';       
        end
           
    end
    
    %Assuming compliance of the first rs fMRI block
    if str2double(compliance_output.rsfMRI_Block_1.rs_fMRI_FM.status) &&...,
            str2double(compliance_output.rsfMRI_Block_1.rs_fMRI_run1.status) &&...,
            str2double(compliance_output.rsfMRI_Block_1.rs_fMRI_run2.status) 
    
        requiredStruct(index(i)-2)=[];
        requiredStruct(index(i)-2)=[];
        requiredStruct(index(i)-2)=[]; 
        requiredStruct(index(i)-2)=[]; 
        index = index - 4;
        index(i) = [];
        index(i) = [];
        compliance_output.rsfMRI_Block_1.status = '1';
        compliance_output.rsfMRI_Block_1.message = 'Compliant 1st resting state ABCD-fMRI component was found. Field map plus two rs fMRI runs';                
        break;    
    end
    
end
    

%%%% Check for the up to two runs rsfMRI experiment with FM

if (~isempty(index))
    
    for i=1:length(index)
        
        testingSeries_rsfMRI_1 = requiredStruct(index(i));

        compliance_output.rsfMRI_Block_2.rs_fMRI_run1.SeriesInstanceUID = testingSeries_rsfMRI_1.SeriesInstanceUID;
        compliance_output.rsfMRI_Block_2.rs_fMRI_run1.SeriesNumber = testingSeries_rsfMRI_1.SeriesNumber;
        compliance_output.rsfMRI_Block_2.rs_fMRI_run1.status = '1';
        compliance_output.rsfMRI_Block_2.rs_fMRI_run1.message = 'Resting state fMRI run is compliant with ABCD protocol';   
        
        if length(requiredStruct) > index(i)
            testingSeries_rsfMRI_2 = requiredStruct(index(i)+1);

            if cTypeFinder(testingSeries_rsfMRI_2.fullclassifyType, compliance_key{1,6}.classifyType)
                compliance_output.rsfMRI_Block_2.rs_fMRI_run2.SeriesInstanceUID = testingSeries_rsfMRI_2.SeriesInstanceUID;
                compliance_output.rsfMRI_Block_2.rs_fMRI_run2.SeriesNumber = testingSeries_rsfMRI_2.SeriesNumber;
                compliance_output.rsfMRI_Block_2.rs_fMRI_run2.status = '1';
                compliance_output.rsfMRI_Block_2.rs_fMRI_run2.message = 'Resting state fMRI run is compliant with ABCD protocol';

            end
        end
        
        testingSeries_FM_fwd = requiredStruct(index(i)-2);
        testingSeries_FM_rev = requiredStruct(index(i)-1);
    
        if cTypeFinder(testingSeries_FM_fwd.fullclassifyType, compliance_key{1,5}.classifyType) &&...,
            cTypeFinder(testingSeries_FM_rev.fullclassifyType, compliance_key{1,5}.classifyType)
        
            compliance_output.rsfMRI_Block_2.rs_fMRI_FM.SeriesInstanceUID{1} = testingSeries_FM_fwd.SeriesInstanceUID;
            compliance_output.rsfMRI_Block_2.rs_fMRI_FM.SeriesNumber{1} = testingSeries_FM_fwd.SeriesNumber;
            compliance_output.rsfMRI_Block_2.rs_fMRI_FM.SeriesInstanceUID{2} = testingSeries_FM_rev.SeriesInstanceUID;
            compliance_output.rsfMRI_Block_2.rs_fMRI_FM.SeriesNumber{2} = testingSeries_FM_rev.SeriesNumber;

            if (testingSeries_FM_fwd.pePolarity == testingSeries_FM_rev.pePolarity) 
                compliance_output.rsfMRI_Block_2.rs_fMRI_FM.message = 'Resting state field map volumes do not have different phase encoding polarity'; 
            else
                compliance_output.rsfMRI_Block_2.rs_fMRI_FM.status = '1';
                compliance_output.rsfMRI_Block_2.rs_fMRI_FM.message = 'fMRI field map acquisition is compliant with ABCD protocol';       
            end
           
        end
                
        
        %Assuming compliance of the first rs fMRI block
        if str2double(compliance_output.rsfMRI_Block_2.rs_fMRI_FM.status) &&...,
            str2double(compliance_output.rsfMRI_Block_2.rs_fMRI_run1.status) 
    
            requiredStruct(index(i)-2)=[];
            requiredStruct(index(i)-2)=[];
            requiredStruct(index(i)-2)=[];
            compliance_output.rsfMRI_Block_1.status = '1';
            compliance_output.rsfMRI_Block_1.message = 'Compliant 2nd resting state ABCD-fMRI component was found. Field map plus two rs fMRI runs';                

            if  str2double(compliance_output.rsfMRI_Block_2.rs_fMRI_run2.status) 
                requiredStruct(index(i)-2)=[];
            end

            break;    
        
        end
    end       
end






    
  