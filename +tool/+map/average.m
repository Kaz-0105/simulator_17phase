function value = average(map)
    is_first = true;
    count = 0;

    for key = cell2mat(map.keys)
        if ~isnumeric(map(key))
            error('The value is not numeric. We cannot calculate the average.');
        end

        if is_first
            sum = map(key);
            is_first = false;
        else
            sum = sum + map(key);
        end

        count = count + 1;
    end

    value = double(sum) / count;
end