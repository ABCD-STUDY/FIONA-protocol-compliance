function [compliance_output, requiredStruct] = check_rsfMRI_block_compliance_SIEMENS(compliance_output, requiredStruct, compliance_key, index)

%==========Any code to check rsfMRI_block compliance ==========%
% Use rules in parsedExam to check compliance

%%%% Check for the 2 runs rsfMRI experiment with FM
index(index<3)=[];
for i=1:2:length(index)
    
    testingSeries_rsfMRI_1 = requiredStruct(index(i));
    
    compliance_output.rsfMRI_Block_1.rs_fMRI_run1.SeriesInstanceUID = testingSeries_rsfMRI_1.SeriesInstanceUID;
    compliance_output.rsfMRI_Block_1.rs_fMRI_run1.SeriesNumber = testingSeries_rsfMRI_1.SeriesNumber;
    compliance_output.rsfMRI_Block_1.rs_fMRI_run1.status = '1';
    compliance_output.rsfMRI_Block_1.rs_fMRI_run1.message = 'Resting state fMRI run is compliant with ABCD protocol';
    if (cErrorFinder(testingSeries_rsfMRI_1.fullclassifyType))
        compliance_output.rsfMRI_Block_1.rs_fMRI_run1.message = [compliance_output.rsfMRI_Block_1.rs_fMRI_run1.message '. Warning: Coil Error Detected'];
    end       
    
    %First check that the sequence of events is compliant
    
    testingSeries_FM_fwd = requiredStruct(index(i)-2);
    testingSeries_FM_rev = requiredStruct(index(i)-1);
    
    if cTypeFinder(testingSeries_FM_fwd.fullclassifyType, compliance_key{1,6}.classifyType) &&...,
            cTypeFinder(testingSeries_FM_rev.fullclassifyType, compliance_key{1,7}.classifyType)
        
        compliance_output.rsfMRI_Block_1.rs_fMRI_FM_PA.SeriesInstanceUID = testingSeries_FM_fwd.SeriesInstanceUID;
        compliance_output.rsfMRI_Block_1.rs_fMRI_FM_PA.SeriesNumber = testingSeries_FM_fwd.SeriesNumber;
        compliance_output.rsfMRI_Block_1.rs_fMRI_FM_AP.SeriesInstanceUID = testingSeries_FM_rev.SeriesInstanceUID;
        compliance_output.rsfMRI_Block_1.rs_fMRI_FM_AP.SeriesNumber = testingSeries_FM_rev.SeriesNumber;

        compliance_output.rsfMRI_Block_1.rs_fMRI_FM_PA.status = '1';
        compliance_output.rsfMRI_Block_1.rs_fMRI_FM_PA.message = 'fMRI field map acquisition with PA phase encoding direction is compliant with ABCD protocol';   
        if (cErrorFinder( testingSeries_FM_fwd.fullclassifyType))
            compliance_output.rsfMRI_Block_1.rs_fMRI_FM_PA.message = [compliance_output.rsfMRI_Block_1.rs_fMRI_FM_PA.message '. Warning: Coil Error Detected'];
        end   
        
        compliance_output.rsfMRI_Block_1.rs_fMRI_FM_AP.status = '1';
        compliance_output.rsfMRI_Block_1.rs_fMRI_FM_AP.message = 'fMRI field map acquisition with AP phase encoding direction is compliant with ABCD protocol';
        if (cErrorFinder( testingSeries_FM_rev.fullclassifyType))
            compliance_output.rsfMRI_Block_1.rs_fMRI_FM_AP.message = [compliance_output.rsfMRI_Block_1.rs_fMRI_FM_AP.message '. Warning: Coil Error Detected'];
        end  
    end
    
        
    if length(requiredStruct) > index(i)
        testingSeries_rsfMRI_2 = requiredStruct(index(i)+1);

        if cTypeFinder(testingSeries_rsfMRI_2.fullclassifyType, compliance_key{1,8}.classifyType)
            compliance_output.rsfMRI_Block_1.rs_fMRI_run2.SeriesInstanceUID = testingSeries_rsfMRI_2.SeriesInstanceUID;
            compliance_output.rsfMRI_Block_1.rs_fMRI_run2.SeriesNumber = testingSeries_rsfMRI_2.SeriesNumber;
            compliance_output.rsfMRI_Block_1.rs_fMRI_run2.status = '1';
            compliance_output.rsfMRI_Block_1.rs_fMRI_run2.message = 'Resting state fMRI run is compliant with ABCD protocol';
            if (cErrorFinder(testingSeries_rsfMRI_2.fullclassifyType))
                compliance_output.rsfMRI_Block_1.rs_fMRI_run2.message = [compliance_output.rsfMRI_Block_1.rs_fMRI_run2.message '. Warning: Coil Error Detected'];
            end 
        end
    end
    

    
    %Assuming compliance of the first rs fMRI block
    if str2double(compliance_output.rsfMRI_Block_1.rs_fMRI_FM_PA.status) &&...,
            str2double(compliance_output.rsfMRI_Block_1.rs_fMRI_FM_AP.status) &&...,
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
        compliance_output.rsfMRI_Block_1.message = 'Compliant 1st resting state ABCD-fMRI component was found. Field map (two separate series with opposed phase encoding direction) plus two rs fMRI runs';                
        break;    
    end
    
end
    

%%%% Check for the up to two runs rsfMRI experiment with FM

if (~isempty(index))
    index(index<3)=[];
    
    for i=1:2:length(index)
        
        testingSeries_rsfMRI_1 = requiredStruct(index(i));

        compliance_output.rsfMRI_Block_2.rs_fMRI_run1.SeriesInstanceUID = testingSeries_rsfMRI_1.SeriesInstanceUID;
        compliance_output.rsfMRI_Block_2.rs_fMRI_run1.SeriesNumber = testingSeries_rsfMRI_1.SeriesNumber;
        compliance_output.rsfMRI_Block_2.rs_fMRI_run1.status = '1';
        compliance_output.rsfMRI_Block_2.rs_fMRI_run1.message = 'Resting state fMRI run is compliant with ABCD protocol';   
        if (cErrorFinder(testingSeries_rsfMRI_1.fullclassifyType))
            compliance_output.rsfMRI_Block_2.rs_fMRI_run1.message = [compliance_output.rsfMRI_Block_2.rs_fMRI_run1.message '. Warning: Coil Error Detected'];
        end  
        
        
        testingSeries_FM_fwd = requiredStruct(index(i)-2);
        testingSeries_FM_rev = requiredStruct(index(i)-1);
    
        if cTypeFinder(testingSeries_FM_fwd.fullclassifyType, compliance_key{1,6}.classifyType) &&...,
            cTypeFinder(testingSeries_FM_rev.fullclassifyType, compliance_key{1,7}.classifyType)
        
            compliance_output.rsfMRI_Block_2.rs_fMRI_FM_PA.SeriesInstanceUID = testingSeries_FM_fwd.SeriesInstanceUID;
            compliance_output.rsfMRI_Block_2.rs_fMRI_FM_PA.SeriesNumber = testingSeries_FM_fwd.SeriesNumber;
            compliance_output.rsfMRI_Block_2.rs_fMRI_FM_AP.SeriesInstanceUID = testingSeries_FM_rev.SeriesInstanceUID;
            compliance_output.rsfMRI_Block_2.rs_fMRI_FM_AP.SeriesNumber = testingSeries_FM_rev.SeriesNumber;

            compliance_output.rsfMRI_Block_2.rs_fMRI_FM_PA.status = '1';
            compliance_output.rsfMRI_Block_2.rs_fMRI_FM_PA.message = 'fMRI field map acquisition with PA phase encoding direction is compliant with ABCD protocol';   
            if (cErrorFinder(testingSeries_FM_fwd.fullclassifyType))
                compliance_output.rsfMRI_Block_2.rs_fMRI_FM_PA.message = [compliance_output.rsfMRI_Block_2.rs_fMRI_FM_PA.message '. Warning: Coil Error Detected'];
            end  
                        
            compliance_output.rsfMRI_Block_2.rs_fMRI_FM_AP.status = '1';
            compliance_output.rsfMRI_Block_2.rs_fMRI_FM_AP.message = 'fMRI field map acquisition with AP phase encoding direction is compliant with ABCD protocol';   
            if (cErrorFinder(testingSeries_FM_rev.fullclassifyType))
                compliance_output.rsfMRI_Block_2.rs_fMRI_FM_AP.message = [compliance_output.rsfMRI_Block_2.rs_fMRI_FM_AP.message '. Warning: Coil Error Detected'];
            end  
            
        end
        
             
        if length(requiredStruct) > index(i)
            testingSeries_rsfMRI_2 = requiredStruct(index(i)+1);

            if cTypeFinder(testingSeries_rsfMRI_2.fullclassifyType, compliance_key{1,8}.classifyType)
                compliance_output.rsfMRI_Block_2.rs_fMRI_run2.SeriesInstanceUID = testingSeries_rsfMRI_2.SeriesInstanceUID;
                compliance_output.rsfMRI_Block_2.rs_fMRI_run2.SeriesNumber = testingSeries_rsfMRI_2.SeriesNumber;
                compliance_output.rsfMRI_Block_2.rs_fMRI_run2.status = '1';
                compliance_output.rsfMRI_Block_2.rs_fMRI_run2.message = 'Resting state fMRI run is compliant with ABCD protocol';
                if (cErrorFinder(testingSeries_rsfMRI_2.fullclassifyType))
                    compliance_output.rsfMRI_Block_2.rs_fMRI_run2.message = [compliance_output.rsfMRI_Block_2.rs_fMRI_run2.message '. Warning: Coil Error Detected'];
                end  
            end
        end
                     
        %Assuming compliance of the first rs fMRI block
        if str2double(compliance_output.rsfMRI_Block_2.rs_fMRI_FM_PA.status) &&...,
            str2double(compliance_output.rsfMRI_Block_2.rs_fMRI_FM_AP.status) &&...,
            str2double(compliance_output.rsfMRI_Block_2.rs_fMRI_run1.status) 
    
            requiredStruct(index(i)-2)=[];
            requiredStruct(index(i)-2)=[];
            requiredStruct(index(i)-2)=[];
            compliance_output.rsfMRI_Block_2.status = '1';
            compliance_output.rsfMRI_Block_2.message = 'Compliant 2nd resting state ABCD-fMRI component was found. Field map (two separate series with opposed phase encoding direction) plus two rs fMRI runs';                

            if  str2double(compliance_output.rsfMRI_Block_2.rs_fMRI_run2.status) 
                requiredStruct(index(i)-2)=[];
            end

            break;    
        
        end
    end       
end






    
  