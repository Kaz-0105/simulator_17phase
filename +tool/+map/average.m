function values = average(Map)
    is_first = true;
    count = 0;

    for key = Map.keys
        key = key{1};
        if ~isnumeric(Map(key))
            error('The value is not numeric. We cannot calculate the average.');
        end

        if is_first
            sum = Map(key);
            is_first = false;
        else
            sum = sum + Map(key);
        end

        count = count + 1;
    end

    values = double(sum) / count;
end