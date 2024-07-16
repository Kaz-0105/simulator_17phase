function makePosVehsResult(obj)

    A = obj.mld_matrices.A;
    B1 = obj.mld_matrices.B1;
    B2 = obj.mld_matrices.B2;
    B3 = obj.mld_matrices.B3;
    B = [B1, B2, B3];
    pos_vehs_init = obj.pos_vehs_init;

    obj.pos_vehs_result = zeros(length(pos_vehs_init), obj.N_p + 1);
    for step = 0: obj.N_p
        if step == 0
            obj.pos_vehs_result(:, step + 1) = pos_vehs_init;
        else
            obj.pos_vehs_result(:, step + 1) = A*obj.pos_vehs_result(:, step) + B*obj.x_opt(1 + obj.v_length*(step-1) : obj.v_length*(step));
        end
    end

    figure;
    hold on;
    route_vehs = obj.RoadRouteVehsMap(2);
    for veh_id = 1: obj.RoadLinkNumVehsMap.get(road_id, link_id)
        if route_vehs(veh_id) ~= 3
            plot(0: obj.N_p, obj.pos_vehs_result(length(obj.RoadRouteVehsMap(1)) + veh_id, :));
        end
    end
    close all;

    delta3_list = obj.VariableListMap('delta_3');
    count = 0;

    for delta3_num = delta3_list
        for step = 1: obj.N_p
            if obj.x_opt(delta3_num + obj.v_length*(step-1)) == 1
                count = count + 1;
            end
        end
    end

    disp(count);
end