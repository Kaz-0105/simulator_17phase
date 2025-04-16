function makeVissimStruct(obj, data)
    % グラフィックモードの設定
    try
        obj.vissim.graphic_mode = data.vissim.graphic_mode;
    catch
        obj.vissim.graphic_mode = 0;
    end

    % シード値の設定
    try
        obj.vissim.seed = data.vissim.seed;
    catch
        obj.vissim.seed = randi(100);
    end

    % シミュレーションの解像度の設定（シミュレーション内の時間で1秒間に何回自動車の位置を更新するか）
    try
        obj.vissim.resolution = data.vissim.resolution;
    catch
        obj.vissim.resolution = 10;
    end

    % シミュレーションの最高速度の設定
    try 
        if strcmp(data.vissim.max_sim_speed, 'on')
            obj.vissim.max_sim_speed = true;
        else
            obj.vissim.max_sim_speed = false;
        end
    catch
        obj.vissim.max_sim_speed = false;
    end

    % 4フェーズ，8フェーズ，17フェーズの比較をするフラグの設定
    try
        if strcmp(data.vissim.phase_comparison_flg, 'on')
            obj.vissim.phase_comparison_flg = true;
        else
            obj.vissim.phase_comparison_flg = false;
        end
    catch
        obj.vissim.phase_comparison_flg = false;
    end
end