function result = sTypeFinder(classifyTypes, key)

result = 0;
for i=1:length(key)
    if any(strcmp(classifyTypes, key{i}))       
        result = 1;
    end
end

end