function makeDeltaPList(obj)
    % uとzの変数を合わせたときの最後のインデックスを取得
    last_index = obj.u_length + obj.z_length;

    % delta_pの変数のリストを作成
    deltap_list = [];

    for road_id = 1: obj.road_num
        route_vehs = obj.RoadRouteVehsMap(road_id);
        for veh_id = 1: length(route_vehs)
            if veh_id == 1
                deltap_list = [deltap_list, last_index + 2];
                last_index = last_index + 4;

                if route_vehs(veh_id) == 1 || route_vehs(veh_id) == 2
                    first_veh_route = '1-2';
                elseif route_vehs(veh_id) == 3
                    first_veh_route = '3';
                end
            elseif route_vehs(veh_id) == 1 || route_vehs(veh_id) == 2
                if strcmp(first_veh_route, '3')
                    deltap_list = [deltap_list, last_index + 2];
                    first_veh_route = '0';
                    last_index = last_index + 7;
                else
                    deltap_list = [deltap_list, last_index + 2];
                    last_index = last_index + 9;
                end
            elseif route_vehs(veh_id) == 3
                if strcmp(first_veh_route, '1-2')
                    deltap_list = [deltap_list, last_index + 2];
                    first_veh_route = '0';
                    last_index = last_index + 7;
                else
                    deltap_list = [deltap_list, last_index + 2];
                    last_index = last_index + 9;
                end
            end
        end
    end

    % VariableListMapにdelta_pの変数のリストを追加
    obj.VariableListMap('delta_p') = deltap_list;
end