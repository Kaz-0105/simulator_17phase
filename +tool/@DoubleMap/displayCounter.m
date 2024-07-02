function displayCounter(obj)
    for key1 = cell2mat(keys(obj.CounterMap))
        fprintf('key: %s, count: %d\n', string(key1), obj.CounterMap(key1));
    end
end