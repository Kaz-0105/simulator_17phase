function values = combine(map)
    values = [];
    for value = map.values
        value = value{1};

        if ~ isnumeric(value)
            error('The value is not numeric. We cannot calculate the average.');
        end

        values = [values, value];
    end
end