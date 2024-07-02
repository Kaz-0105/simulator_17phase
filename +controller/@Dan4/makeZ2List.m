function makeZ2List(obj)
    % 信号機の変数の最後のインデックスを取得
    last_index = obj.signal_num;

    % z_2の変数のリストを作成
    z2_list = [];

    for road_id = 1: obj.road_num
        route_vehs = obj.RoadRouteVehsMap(road_id);
        for veh_id = 1: length(route_vehs)
            if veh_id == 1
                z2_list = [z2_list, last_index + 1];
                last_index = last_index + 1;

                if route_vehs(veh_id) == 1 || route_vehs(veh_id) == 2
                    first_veh_route = '1-2';
                elseif route_vehs(veh_id) == 3
                    first_veh_route = '3';
                end
            elseif route_vehs(veh_id) == 1 || route_vehs(veh_id) == 2
                if strcmp(first_veh_route, '3')
                    z2_list = [z2_list, last_index + 1];
                    first_veh_route = '0';
                    last_index = last_index + 3;
                else
                    z2_list = [z2_list, last_index + 1];
                    last_index = last_index + 5;
                end
            elseif route_vehs(veh_id) == 3
                if strcmp(first_veh_route, '1-2')
                    z2_list = [z2_list, last_index + 1];
                    first_veh_route = '0';
                    last_index = last_index + 3;
                else
                    z2_list = [z2_list, last_index + 1];
                    last_index = last_index + 5;
                end
            end
        end
    end

    % VariableListMapにz_2の変数のリストを追加
    obj.VariableListMap('z_2') = z2_list;


end