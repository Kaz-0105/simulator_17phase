function Map = getInnerMap(obj, key1)
    if isKey(obj.OuterMap, key1)
        Map = obj.OuterMap(key1);
    else
        error('Outer key is not found.');
    end
end