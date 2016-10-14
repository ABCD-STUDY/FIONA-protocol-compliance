function result = cErrorFinder(classifyType)

result = 0;
    if any(strcmp(classifyType, 'Coil Error'))       
        result = 1;
    end

end