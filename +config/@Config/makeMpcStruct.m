function makeMpcStruct(obj, data)
    % 予測ホライゾンの設定
    obj.mpc.predictive_horizon = data.mpc.predictive_horizon;

    % 制御ホライズンの設定
    obj.mpc.control_horizon = data.mpc.control_horizon;

    % タイムステップの設定
    obj.mpc.time_step = data.mpc.time_step;

    % 最適化時間の上限を設定
    obj.mpc.max_time = data.mpc.max_time;

    % 制御のインターバル時間の設定
    obj.mpc.control_interval = obj.mpc.control_horizon*obj.mpc.time_step;
end