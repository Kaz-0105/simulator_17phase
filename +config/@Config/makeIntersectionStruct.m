function makeIntersectionStruct(obj, data)
    % 黄色の時間の有無
    if strcmp(data.intersection.yellow_time, 'on')
        obj.intersection.yellow_time = true;
    elseif strcmp(data.intersection.yellow_time, 'off')
        obj.intersection.yellow_time = false;
    else
        error('Invalid yellow_time');
    end

    % 赤色の時間の有無
    if strcmp(data.intersection.red_time, 'on')
        obj.intersection.red_time = true;
    elseif strcmp(data.intersection.red_time, 'off')
        obj.intersection.red_time = false;
    else
        error('Invalid red_time');
    end
end