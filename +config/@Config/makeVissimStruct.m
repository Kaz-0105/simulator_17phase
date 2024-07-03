function makeVissimStruct(obj, data)
    % グラフィックモードの設定
    try
        obj.vissim.graphic_mode = data.graphic_mode;
    catch
        obj.vissim.graphic_mode = 0;
    end

    % シード値の設定
    try
        obj.vissim.seed = data.seed;
    catch
        obj.vissim.seed = randi(100);
    end

    % シミュレーションの解像度の設定（シミュレーション内の時間で1秒間に何回自動車の位置を更新するか）
    try
        obj.vissim.resolution = data.resolution;
    catch
        obj.vissim.resolution = 10;
    end
end