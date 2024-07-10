function values = sum(Map)
    is_first = true;

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
    end

    values = sum;
end