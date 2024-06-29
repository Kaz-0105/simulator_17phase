function emergencyTreatmentCopy(obj)
    % SignalGroupごとの車両数を格納するマップ
    SignalGroupVehicleMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

    % 初期化
    for i = 1:12
        SignalGroupVehicleMap(i) = 0;
    end

    for route = obj.route_vehs.north'
        SignalGroupVehicleMap(route) = SignalGroupVehicleMap(route) + 1;
    end

    for route = obj.route_vehs.east'
        SignalGroupVehicleMap(route + 3) = SignalGroupVehicleMap(route + 3) + 1;
    end

    for route = obj.route_vehs.south'
        SignalGroupVehicleMap(route + 6) = SignalGroupVehicleMap(route + 6) + 1;
    end

    for route = obj.route_vehs.west'
        SignalGroupVehicleMap(route + 9) = SignalGroupVehicleMap(route + 9) + 1;
    end

    % フェーズごとの車両数を格納するマップ
    PhaseVehicleMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

    % PhaseSignalGrouMapのkeyを取得（セル配列→配列）
    keys_phase_id = cell2mat(obj.PhaseSignalGroupMap.keys);

    for phase_id = keys_phase_id
        for signal_group_id = obj.PhaseSignalGroupMap(phase_id)
            if ~isKey(PhaseVehicleMap, phase_id)
                PhaseVehicleMap(phase_id) = SignalGroupVehicleMap(signal_group_id);
            else
                PhaseVehicleMap(phase_id) = PhaseVehicleMap(phase_id) + SignalGroupVehicleMap(signal_group_id);
            end
        end
    end

    % 最大のバリューを持つキーを取得
    max_key = 1;
    max_value = PhaseVehicleMap(1);

    for phase_id = 2:obj.phase_num
        tmp_value = PhaseVehicleMap(phase_id);
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
