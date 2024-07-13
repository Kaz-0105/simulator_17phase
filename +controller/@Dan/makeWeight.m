function makeWeight(obj)
    % 空の重み行列を作成
    weight_matrix = [];

    % SignalGroupごとの重みのテンプレートを作成
    templete = obj.phase_num*ones(1, 3);
    for phase_id = 1: obj.phase_num
        for signal_group_id = obj.PhaseSignalGroupMap(phase_id)
            if signal_group_id  <= 3
                templete(signal_group_id) = templete(signal_group_id) - 1;
            end
        end
    end

    % 先頭車両に対する重みの倍率の設定
    first_veh_scale = 1; 

    % 重み行列を作成
    for road_id = 1: obj.road_num
        route_vehs = obj.RoadRouteVehsMap(road_id);
        first_veh_ids = obj.RoadRouteFirstVehMap(road_id);

        for veh_id = 1: length(route_vehs)
            if veh_id == first_veh_ids.straight
                weight_matrix = [weight_matrix, templete(route_vehs(veh_id))*first_veh_scale];
            elseif veh_id == first_veh_ids.right
                weight_matrix = [weight_matrix, templete(route_vehs(veh_id))*first_veh_scale];
            else
                weight_matrix = [weight_matrix, templete(route_vehs(veh_id))];
            end
        end
    end

    % 重み行列をmilp_matricesに追加
    obj.milp_matrices.w = weight_matrix;
end