function makeResultStruct(obj, data)
    % 結果の保存の有無
    if strcmp(char(data.result.save.active), 'on')
        obj.result.save.active = true;
    elseif strcmp(char(data.result.save.active), 'off')
        obj.result.save.active = false;
    else
        error('The value of save is invalid in yaml file.');
    end

    % 保存するディレクトリのパス
    obj.result.save.path = char(data.result.save.path);

    % 結果の比較の有無
    if strcmp(char(data.result.compare.active), 'on')
        obj.result.compare.active = true;
    elseif strcmp(char(data.result.compare.active), 'off')
        obj.result.compare.active = false;
    else
        error('The value of compare is invalid in yaml file.');
    end

    % 結果を比較するファイルのパス
    obj.result.compare.PathMap = containers.Map('KeyType', 'int32', 'ValueType', 'char');

    for path_id = 1: length(data.result.compare.path)
        path = data.result.compare.path{path_id};
        obj.result.compare.PathMap(path_id) = char(path);
    end

    % 計算時間について
    obj.result.contents.calc_time = data.result.contents.calc_time;

    if strcmp(char(obj.result.contents.calc_time.active), 'on')
        obj.result.contents.calc_time.active = true;
    elseif strcmp(char(obj.result.contents.calc_time.active), 'off')
        obj.result.contents.calc_time.active = false;
    else
        error('The value of calc_time is invalid in yaml file.');
    end

    obj.result.contents.calc_time.scale = char(obj.result.contents.calc_time.scale);

    % キューについて
    obj.result.contents.queue_length = data.result.contents.queue_length;

    if strcmp(char(obj.result.contents.queue_length.active), 'on')
        obj.result.contents.queue_length.active = true;
    elseif strcmp(char(obj.result.contents.queue_length.active), 'off')
        obj.result.contents.queue_length.active = false;
    else
        error('The value of queue_length is invalid in yaml file.');
    end

    obj.result.contents.queue_length.scale = char(obj.result.contents.queue_length.scale);

    % 車両数について
    obj.result.contents.num_vehs = data.result.contents.num_vehs;
    
    if strcmp(char(obj.result.contents.num_vehs.active), 'on')
        obj.result.contents.num_vehs.active = true;
    elseif strcmp(char(obj.result.contents.num_vehs.active), 'off')
        obj.result.contents.num_vehs.active = false;
    else
        error('The value of num_vehs is invalid in yaml file.');
    end

    obj.result.contents.num_vehs.scale = char(obj.result.contents.num_vehs.scale);

    % 遅れ時間について
    obj.result.contents.delay_time = data.result.contents.delay_time;
    
    if strcmp(char(obj.result.contents.delay_time.active), 'on')
        obj.result.contents.delay_time.active = true;
    elseif strcmp(char(obj.result.contents.delay_time.active), 'off')
        obj.result.contents.delay_time.active = false;
    else
        error('The value of delay_time is invalid in yaml file.');
    end
    
    obj.result.contents.delay_time.scale = char(obj.result.contents.delay_time.scale);
end