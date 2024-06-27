function emergencyTreatment(obj)
    % SignalGroupごとの車両数を格納するマップ
    SignalGroupVehicleMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

    % 初期化
    for i = 1:obj.signal_num
        SignalGroupVehicleMap(i) = 0;
    end

    if ~isfield(obj.route_vehs, 'north')
        for route = obj.route_vehs.east'
            SignalGroupVehicleMap(route) = SignalGroupVehicleMap(route) + 1;
        end

        for route = obj.route_vehs.south'
            SignalGroupVehicleMap(route + (obj.road_num -1)) = SignalGroupVehicleMap(route + (obj.road_num -1)) + 1;
        end

        for route = obj.route_vehs.west'
            SignalGroupVehicleMap(route + (obj.road_num -1) * 2) = SignalGroupVehicleMap(route + (obj.road_num -1) * 2) + 1;
        end
    end

    if ~isfield(obj.route_vehs, 'east')
        for route = obj.route_vehs.north'
            SignalGroupVehicleMap(route) = SignalGroupVehicleMap(route) + 1;
        end

        for route = obj.route_vehs.south'
            SignalGroupVehicleMap(route + (obj.road_num -1)) = SignalGroupVehicleMap(route + (obj.road_num -1)) + 1;
        end

        for route = obj.route_vehs.west'
            SignalGroupVehicleMap(route + (obj.road_num -1) * 2) = SignalGroupVehicleMap(route + (obj.road_num -1) * 2) + 1;
        end
    end

    if ~isfield(obj.route_vehs, 'south')
        for route = obj.route_vehs.north'
            SignalGroupVehicleMap(route) = SignalGroupVehicleMap(route) + 1;
        end

        for route = obj.route_vehs.east'
            SignalGroupVehicleMap(route + (obj.road_num -1)) = SignalGroupVehicleMap(route + (obj.road_num -1)) + 1;
        end

        for route = obj.route_vehs.west'
            SignalGroupVehicleMap(route + (obj.road_num -1) * 2) = SignalGroupVehicleMap(route + (obj.road_num -1) * 2) + 1;
        end
    end

    if ~isfield(obj.route_vehs, 'west')
        for route = obj.route_vehs.north'
            SignalGroupVehicleMap(route) = SignalGroupVehicleMap(route) + 1;
        end

        for route = obj.route_vehs.east'
            SignalGroupVehicleMap(route + (obj.road_num -1)) = SignalGroupVehicleMap(route + (obj.road_num -1)) + 1;
        end

        for route = obj.route_vehs.south'
            SignalGroupVehicleMap(route + (obj.road_num -1) * 2) = SignalGroupVehicleMap(route + (obj.road_num -1) * 2) + 1;
        end
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
    keys = PhaseVehicleMap.keys;
    values = PhaseVehicleMap.values;

    max_key = keys{1};
    max_value = values{1};

    for i = 2:length(keys)
        tmp_value = values{i};
        if tmp_value > max_value
            max_key = keys{i};
            max_value = tmp_value;
        end
    end

    obj.u_opt = [];

    u_future_data = obj.UResults.get('future_data');

    for step = 1: obj.fix_num
        obj.u_opt = [obj.u_opt, u_future_data(:,step)];
    end

    tmp_u = zeros(obj.signal_num, 1);
    tmp_u(obj.PhaseSignalGroupMap(max_key)) = ones(obj.road_num, 1);

    for step = obj.fix_num + 1: obj.N_p
        obj.u_opt = [obj.u_opt, tmp_u];
    end

    obj.phi_opt = zeros(1, obj.N_p-1);
end