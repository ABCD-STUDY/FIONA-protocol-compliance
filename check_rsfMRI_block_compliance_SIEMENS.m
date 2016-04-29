function [compliance_output, requiredStruct] = check_rsfMRI_block_compliance_SIEMENS(compliance_output, requiredStruct, compliance_key, index)

%==========Any code to check rsfMRI_block compliance ==========%
% Use rules in parsedExam to check compliance


for i=1:length(index)

if length(requiredStruct) < index(i)+6  %At least the requested series should be present
    break;
else
    %First check that the sequence of events is compliant
    testingSeries_FM_fwd_1 = requiredStruct(index(i));
    testingSeries_FM_rev_1 = requiredStruct(index(i)+1);
    testingSeries_rsfMRI_1 = requiredStruct(index(i)+2);
    testingSeries_rsfMRI_2 = requiredStruct(index(i)+3);
    testingSeries_FM_fwd_2 = requiredStruct(index(i)+4);
    testingSeries_FM_rev_2 = requiredStruct(index(i)+5);
    testingSeries_rsfMRI_3 = requiredStruct(index(i)+6);
    
    if length(requiredStruct) >= index(i)+7
        testingSeries_rsfMRI_4 = requiredStruct(index(i)+7);
    end
    
    if strcmp({testingSeries_FM_rev_1.classifyType}, compliance_key{1,5}.classifyType) &&...,
        strcmp({testingSeries_rsfMRI_1.classifyType}, compliance_key{1,6}.classifyType) &&...,
        strcmp({testingSeries_rsfMRI_2.classifyType}, compliance_key{1,6}.classifyType) &&...,
        strcmp({testingSeries_FM_fwd_2.classifyType}, compliance_key{1,5}.classifyType) &&...,
        strcmp({testingSeries_FM_rev_2.classifyType}, compliance_key{1,5}.classifyType) &&...,
        strcmp({testingSeries_rsfMRI_3.classifyType}, compliance_key{1,6}.classifyType)
            

        %Additional rules to be added here and checked from using compliance_key. Right now assumes
        %compliance if rsfMRI block includes defined sequence
        
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_1.SeriesInstanceUID = testingSeries_rsfMRI_1.SeriesInstanceUID;
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_1.SeriesNumber = testingSeries_rsfMRI_1.SeriesNumber;
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_1.status = '1';
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_1.message = 'Resting state fMRI acquisition is compliant with ABCD protocol';
        
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_2.SeriesInstanceUID = testingSeries_rsfMRI_2.SeriesInstanceUID;
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_2.SeriesNumber = testingSeries_rsfMRI_2.SeriesNumber;
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_2.status = '1';
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_2.message = 'Resting state fMRI acquisition is compliant with ABCD protocol';
        
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_3.SeriesInstanceUID = testingSeries_rsfMRI_3.SeriesInstanceUID;
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_3.SeriesNumber = testingSeries_rsfMRI_3.SeriesNumber;
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_3.status = '1';
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_3.message = 'Resting state fMRI acquisition is compliant with ABCD protocol';
        
        if exist('testingSeries_rsfMRI_4','var') && strcmp({testingSeries_rsfMRI_4.classifyType}, compliance_key{1,6}.classifyType)     
            compliance_output.Session_1.rsfMRI_Block.rs_fMRI_4.SeriesInstanceUID = testingSeries_rsfMRI_4.SeriesInstanceUID;
            compliance_output.Session_1.rsfMRI_Block.rs_fMRI_4.SeriesNumber = testingSeries_rsfMRI_4.SeriesNumber;
            compliance_output.Session_1.rsfMRI_Block.rs_fMRI_4.status = '1';
            compliance_output.Session_1.rsfMRI_Block.rs_fMRI_4.message = 'Resting state fMRI acquisition is compliant with ABCD protocol';      
        end
        
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_FM_1.SeriesInstanceUID{1} = testingSeries_FM_fwd_1.SeriesInstanceUID;
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_FM_1.SeriesNumber{1} = testingSeries_FM_fwd_1.SeriesNumber;
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_FM_1.SeriesInstanceUID{2} = testingSeries_FM_rev_1.SeriesInstanceUID;
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_FM_1.SeriesNumber{2} = testingSeries_FM_rev_1.SeriesNumber;
 
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_FM_2.SeriesInstanceUID{1} = testingSeries_FM_fwd_2.SeriesInstanceUID;
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_FM_2.SeriesNumber{1} = testingSeries_FM_fwd_2.SeriesNumber;
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_FM_2.SeriesInstanceUID{2} = testingSeries_FM_rev_2.SeriesInstanceUID;
        compliance_output.Session_1.rsfMRI_Block.rs_fMRI_FM_2.SeriesNumber{2} = testingSeries_FM_rev_2.SeriesNumber;
               
        
        %========Check reversed polarities of field map=======%
        if (testingSeries_FM_fwd_1.pePolarity == testingSeries_FM_rev_1.pePolarity) 
            compliance_output.Session_1.rsfMRI_Block.rs_fMRI_FM_1.message = 'Resting state field map volumes do not have different phase encoding polarity'; 
        else
            compliance_output.Session_1.rsfMRI_Block.rs_fMRI_FM_1.status = '1';
            compliance_output.Session_1.rsfMRI_Block.rs_fMRI_FM_1.message = 'fMRI field map acquisition is compliant with ABCD protocol';       
        end
        
        if (testingSeries_FM_fwd_2.pePolarity == testingSeries_FM_rev_2.pePolarity) 
            compliance_output.Session_1.rsfMRI_Block.rs_fMRI_FM_2.message = 'Resting state field map volumes do not have different phase encoding polarity'; 
        else
            compliance_output.Session_1.rsfMRI_Block.rs_fMRI_FM_2.status = '1';
            compliance_output.Session_1.rsfMRI_Block.rs_fMRI_FM_2.message = 'fMRI field map acquisition is compliant with ABCD protocol';       
        end
     

        
    end
    
    %Assuming compliance
    if str2double(compliance_output.Session_1.rsfMRI_Block.rs_fMRI_FM_1.status) &&...,
            str2double(compliance_output.Session_1.rsfMRI_Block.rs_fMRI_FM_2.status) &&...,
            str2double(compliance_output.Session_1.rsfMRI_Block.rs_fMRI_1.status) &&...,
            str2double(compliance_output.Session_1.rsfMRI_Block.rs_fMRI_2.status) &&...,
            str2double(compliance_output.Session_1.rsfMRI_Block.rs_fMRI_3.status)
        
        requiredStruct(index(i))=[];
        requiredStruct(index(i))=[];
        requiredStruct(index(i))=[];
        requiredStruct(index(i))=[];
        requiredStruct(index(i))=[];  
        requiredStruct(index(i))=[];  
        requiredStruct(index(i))=[];
        
        if str2double(compliance_output.Session_1.rsfMRI_Block.rs_fMRI_FM_1.status)
            requiredStruct(index(i))=[];
        end
        
        compliance_output.Session_1.rsfMRI_Block.status = '1';
        compliance_output.Session_1.rsfMRI_Block.message = 'Compliant resting state ABCD-fMRI component was found';       
        break;  
    end
      
end    
end     