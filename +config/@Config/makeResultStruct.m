function makeResultStruct(obj, data)
    % 計算時間について
    obj.result.calc_time = data.result.calc_time;
    obj.result.calc_time.active = char(obj.result.calc_time.active);
    obj.result.calc_time.scale = char(obj.result.calc_time.scale);

    % キューについて
    obj.result.queue = data.result.queue;
    obj.result.queue.active = char(obj.result.queue.active);
    obj.result.queue.scale = char(obj.result.queue.scale);

    % 車両数について
    obj.result.num_vehs = data.result.num_vehs;
    obj.result.num_vehs.active = char(obj.result.num_vehs.active);
    obj.result.num_vehs.scale = char(obj.result.num_vehs.scale);

    % 遅れ時間について
    obj.result.delay = data.result.delay;
    obj.result.delay.active = char(obj.result.delay.active);
    obj.result.delay.scale = char(obj.result.delay.scale);

end