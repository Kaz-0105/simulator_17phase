function remove(obj, key1, key2)
    if isKey(obj.OuterMap, key1)
        InnerMap = obj.OuterMap(key1);
        if isKey(InnerMap, key2)
            remove(InnerMap, key2);
            obj.CounterMap(key1) = obj.CounterMap(key1) - 1;
            if isempty(InnerMap)
                remove(obj.OuterMap, key1);
                remove(obj.CounterMap, key1);
            end
        else
            error('Inner key is not found.');
        end
    else
        error('Outer key is not found.');
    end
end