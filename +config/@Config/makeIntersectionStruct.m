function makeIntersectionStruct(obj, data)
    % 黄色の時間の有無
    if strcmp(data.intersection.yellow_time, 'on')
        obj.intersection.yellow_time = true;
    elseif strcmp(data.intersection.yellow_time, 'off')
        obj.intersection.yellow_time = false;
    else
        error('Invalid yellow_time');
    end
end