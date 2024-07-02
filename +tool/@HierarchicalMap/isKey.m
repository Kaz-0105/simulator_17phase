function flag = isKey(obj, key1, key2)
    if isKey(obj.OuterMap, key1)
        InnerMap = obj.OuterMap(key1);
        flag = isKey(InnerMap, key2);
    else
        flag = false;
    end
end