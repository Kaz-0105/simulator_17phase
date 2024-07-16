function emergencyTreatment(obj)
    % SignalGroupごとの車両数を格納するマップ
    SignalGroupNumVehsMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

    % 初期化
    for i = 1:12
        SignalGroupNumVehsMap(i) = 0;
    end

    for road_id = 1: obj.road_num
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            for route = transpose(obj.RoadLinkRouteVehsMap.get(road_id, link_id))
                % 数のインクリメント
                SignalGroupNumVehsMap(route + (road_id-1)*(obj.road_num-1)) = SignalGroupNumVehsMap(route + (road_id-1)*(obj.road_num-1)) + 1;
            end
        end
    end

    % フェーズごとの車両数を格納するマップ
    PhaseNumVehsMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

    for phase_id = 1: obj.phase_num
        for signal_group_id = obj.PhaseSignalGroupMap(phase_id)
            if ~isKey(PhaseNumVehsMap, phase_id)
                PhaseNumVehsMap(phase_id) = SignalGroupNumVehsMap(signal_group_id);
            else
                PhaseNumVehsMap(phase_id) = PhaseNumVehsMap(phase_id) + SignalGroupNumVehsMap(signal_group_id);
            end
        end
    end

    % 最大のバリューを持つキーを取得
    max_key = 1;
    max_value = PhaseNumVehsMap(1);

    for phase_id = 2:obj.phase_num
        tmp_value = PhaseNumVehsMap(phase_id);
        if tmp_value > max_value
            max_key = phase_id;
            max_value = tmp_value;
        end
    end

    obj.u_opt = [];

    u_future_data = obj.UResults.get('future_data');

    for step = 1: obj.fix_num
        obj.u_opt = [obj.u_opt, u_future_data(:,step)];
    end

    tmp_u = zeros(obj.signal_num, 1);
    tmp_u(obj.PhaseSignalGroupMap(max_key)) = ones(4, 1);

    for step = obj.fix_num + 1: obj.N_p
        obj.u_opt = [obj.u_opt, tmp_u];
    end

    obj.phi_opt = zeros(1, obj.N_p-1);

    % 計算時間を設定
    if obj.exitflag == 0
        % 計算が間に合っていないとき
        obj.calc_time = obj.max_time * 2;
    elseif obj.exitflag == -2
        % 実行可能解が見つからなかったとき
        obj.calc_time = -1;
    end
end
