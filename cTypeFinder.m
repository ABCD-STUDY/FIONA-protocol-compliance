function result = cTypeFinder(classifyTypes, key)

if any(strcmp(classifyTypes, key))       
    result = 1;
else
    result = 0;
end

end