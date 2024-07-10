function values = connect(Map)
    values = [];
    for value = Map.values
        value = value{1};

        if ~ isnumeric(value)
            error('The value is not numeric. We cannot calculate the average.');
        end

        values = [values, value];
    end
end