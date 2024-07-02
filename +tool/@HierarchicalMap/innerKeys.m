function values = innerKeys(obj, key1)
    if isKey(obj.OuterMap, key1)
        InnerMap = obj.OuterMap(key1);
        values = cell2mat(keys(InnerMap));
    else
        error('Outer key is not found.');
    end
end