function makeWeight(obj)
    % 空の重み行列を作成
    weight_matrix.delta1 = [];
    weight_matrix.delta4 = [];

    % SignalGroupごとの重みのテンプレートを作成
    template = obj.tmp_phase_num*ones(1, obj.road_num-1);
    for phase_id = 1: obj.tmp_phase_num
        for signal_group_id = obj.PhaseSignalGroupMap(phase_id)
            if signal_group_id  <= obj.road_num-1
                template(signal_group_id) = template(signal_group_id) - 1;
            end
        end
    end

    % 先頭車両に対する重みの倍率の設定
    first_veh_scale = 1; 

    % 重み行列を作成
    for road_id = 1: obj.road_num
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % LaneFirstVehsMapを取得
            LaneFirstVehsMap = obj.RoadLinkLaneFirstVehsMap.get(road_id, link_id);

            % route_vehsを取得
            route_vehs = obj.RoadLinkRouteVehsMap.get(road_id, link_id);

            for veh_id = 1: obj.RoadLinkNumVehsMap.get(road_id, link_id)
                % signal_group_idを取得
                signal_group_id = obj.RoadRouteSignalGroupMap.get(road_id, route_vehs(veh_id));

                if veh_id == LaneFirstVehsMap(1)
                    weight_matrix.delta1 = [weight_matrix.delta1, template(signal_group_id)*first_veh_scale];

                elseif veh_id == LaneFirstVehsMap(2)
                    weight_matrix.delta1 = [weight_matrix.delta1, template(signal_group_id)*first_veh_scale];

                elseif veh_id == LaneFirstVehsMap(3)
                    weight_matrix.delta1 = [weight_matrix.delta1, template(signal_group_id)*first_veh_scale];

                else
                    weight_matrix.delta1 = [weight_matrix.delta1, template(signal_group_id)];
                    weight_matrix.delta4 = [weight_matrix.delta4, template(signal_group_id)];

                end
            end
        end
    end

    % 重み行列をmilp_matricesにプッシュ
    obj.milp_matrices.w = weight_matrix;
end