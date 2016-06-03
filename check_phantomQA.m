function [phantom_result] = check_phantomQA(requiredStruct, phantom_key)

phantom_result = 0;

for i=1:size(phantom_key,2)
    keys{i}=phantom_key{1,i}.classifyType;
end

index = 1;
for i=1:size(requiredStruct,2)
    for j=1:size(requiredStruct(i).fullclassifyType,2)
        classifyTypes{index} = requiredStruct(i).fullclassifyType{1,j};
        index = index + 1;
    end
end
clear index;

for i=1:length(keys)
    if any(strcmp(classifyTypes, keys{i}))       
        phantom_result = 1;
        break;
    end

end

end

