function makeClearingTimeFlag(obj)
    % クリアリング時間の形式の設定
    if obj.Config.intersection.yellow_time && obj.Config.intersection.red_time
        % 1: 黄色時間あり、赤色時間あり
        obj.clearing_time_flag = 1;

    elseif obj.Config.intersection.yellow_time && ~obj.Config.intersection.red_time
        % 2: 黄色時間あり、赤色時間なし
        obj.clearing_time_flag = 2;

    elseif ~obj.Config.intersection.yellow_time && obj.Config.intersection.red_time
        % 3: 黄色時間なし、赤色時間あり
        obj.clearing_time_flag = 3;

    elseif ~obj.Config.intersection.yellow_time && ~obj.Config.intersection.red_time
        % 4: 黄色時間なし、赤色時間なし
        obj.clearing_time_flag = 4;
        
    end
end