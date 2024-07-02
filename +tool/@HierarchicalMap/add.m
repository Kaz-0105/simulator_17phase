function add(obj, key1, key2, value)
    if ~isKey(obj.OuterMap, key1)
        obj.OuterMap(key1) = containers.Map('KeyType', obj.key_type2, 'ValueType', obj.value_type);
        obj.CounterMap(key1) = 0;
    end

    InnerMap = obj.OuterMap(key1);
    
    if isKey(InnerMap, key2)
        error('Inner and outer key pair already exists. please use set method to update the value.');
    else
        InnerMap(key2) = value;
        obj.CounterMap(key1) = obj.CounterMap(key1) + 1;
    end
end