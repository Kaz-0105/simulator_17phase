function value = get(obj, key1, key2)
    if isKey(obj.OuterMap, key1)
        InnerMap = obj.OuterMap(key1);
        if isKey(InnerMap, key2)
            value = InnerMap(key2);
        else
            error('Inner key is not found.');
        end
    else
        error('Outer key is not found.');
    end
end