function run(obj)
    % フラグがTrueの場合のみ描画

    % フェーズごとの比較
    if obj.phase_comparison_flg
        obj.makePhaseComparisonGraph();
    end
    
    % QueueLengthについて
    if obj.flags.queue_length
        obj.showQueueLength();
    end

    % NumVehsについて
    if obj.flags.num_vehs
        obj.showNumVehs();
    end

    % DelayTimeについて
    if obj.flags.delay_time
        obj.showDelayTime();
    end

    % CalcTimeについて
    if obj.flags.calc_time
        obj.showCalcTime();
    end

    % Speedについて
    if obj.flags.speed
        obj.showSpeed()
    end

    % Databaseについて
    if obj.flags.database
        obj.updateDatabase();
    end
end