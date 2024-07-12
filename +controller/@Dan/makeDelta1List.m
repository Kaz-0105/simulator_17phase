function makeDelta1List(obj)
    % uとzの変数の最後のインデックスを取得
    last_index = obj.u_length + obj.z_length;

    % delta_1の変数のリストを作成
    delta1_list = [];

    for road_id = 1: obj.road_num
        route_vehs = obj.RoadRouteVehsMap(road_id);
        for veh_id = 1: length(route_vehs)
            if veh_id == 1
                delta1_list = [delta1_list, last_index + 3];
                last_index = last_index + 4;

                if route_vehs(veh_id) == 1 || route_vehs(veh_id) == 2
                    first_veh_route = '1-2';
                elseif route_vehs(veh_id) == 3
                    first_veh_route = '3';
                end
            elseif route_vehs(veh_id) == 1 || route_vehs(veh_id) == 2
                if strcmp(first_veh_route, '3')
                    delta1_list = [delta1_list, last_index + 5];
                    first_veh_route = '0';
                    last_index = last_index + 7;
                else
                    delta1_list = [delta1_list, last_index + 6];
                    last_index = last_index + 9;
                end
            elseif route_vehs(veh_id) == 3
                if strcmp(first_veh_route, '1-2')
                    delta1_list = [delta1_list, last_index + 5];
                    first_veh_route = '0';
                    last_index = last_index + 7;
                else
                    delta1_list = [delta1_list, last_index + 6];
                    last_index = last_index + 9;
                end
            end
        end
    end

    % VariableListMapにdelta_1の変数のリストを追加
    obj.VariableListMap('delta_1') = delta1_list;
end