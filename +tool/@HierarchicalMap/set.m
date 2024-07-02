function set(obj, key1, key2, value)
    if isKey(obj.OuterMap, key1)
        InnerMap = obj.OuterMap(key1);
    else
        error('Outer key is not found.');
    end

    if isKey(InnerMap, key2)
        InnerMap(key2) = value;
    else
        error('Inner key is not found.');
    end
end