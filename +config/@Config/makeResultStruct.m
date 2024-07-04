function makeResultStruct(obj, data)
    % 結果の保存の有無
    if strcmp(char(data.result.save), 'on')
        obj.result.save = true;
    elseif strcmp(char(data.result.save), 'off')
        obj.result.save = false;
    else
        error('The value of result.save is invalid in yaml file.');
    end

    % 結果の比較の有無
    if strcmp(char(data.result.comparison), 'on')
        obj.result.comparison = true;
    elseif strcmp(char(data.result.comparison), 'off')
        obj.result.comparison = false;
    else
        error('The value of result.comparison is invalid in yaml file.');
    end

    % 計算時間について
    obj.result.contents.calc_time = data.result.contents.calc_time;

    if strcmp(char(obj.result.contents.calc_time.active), 'on')
        obj.result.contents.calc_time.active = true;
    elseif strcmp(char(obj.result.contents.calc_time.active), 'off')
        obj.result.contents.calc_time.active = false;
    else
        error('The value of result.contents.calc_time.active is invalid in yaml file.');
    end

    obj.result.contents.calc_time.scale = char(obj.result.contents.calc_time.scale);

    % キューについて
    obj.result.contents.queue = data.result.contents.queue;

    if strcmp(char(obj.result.contents.queue.active), 'on')
        obj.result.contents.queue.active = true;
    elseif strcmp(char(obj.result.contents.queue.active), 'off')
        obj.result.contents.queue.active = false;
    else
        error('The value of result.contents.queue.active is invalid in yaml file.');
    end

    obj.result.contents.queue.scale = char(obj.result.contents.queue.scale);

    % 車両数について
    obj.result.contents.num_vehs = data.result.contents.num_vehs;
    
    if strcmp(char(obj.result.contents.num_vehs.active), 'on')
        obj.result.contents.num_vehs.active = true;
    elseif strcmp(char(obj.result.contents.num_vehs.active), 'off')
        obj.result.contents.num_vehs.active = false;
    else
        error('The value of result.contents.num_vehs.active is invalid in yaml file.');
    end

    obj.result.contents.num_vehs.scale = char(obj.result.contents.num_vehs.scale);

    % 遅れ時間について
    obj.result.contents.delay = data.result.contents.delay;
    
    if strcmp(char(obj.result.contents.delay.active), 'on')
        obj.result.contents.delay.active = true;
    elseif strcmp(char(obj.result.contents.delay.active), 'off')
        obj.result.contents.delay.active = false;
    else
        error('The value of result.contents.delay.active is invalid in yaml file.');
    end
    
    obj.result.contents.delay.scale = char(obj.result.contents.delay.scale);
end