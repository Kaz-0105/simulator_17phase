function run(obj)
    % QueueLengthについて
    if obj.queue_length_flag
        obj.showQueueLength();
    end

    % NumVehsについて
    if obj.num_vehs_flag
        obj.showNumVehs();
    end

    % DelayTimeについて
    if obj.delay_time_flag
        obj.showDelayTime();
    end

    % CalcTimeについて
    if obj.calc_time_flag
        obj.showCalcTime();
    end
end