% 分岐後の先行車を特定する関数
function value = getFrontVehicle(obj, veh_id, road_id)
    % route_vehsの取得
    route_vehs = obj.RoadRouteVehsMap(road_id);

    % 先行車の探索
    for value = (veh_id-1) : -1 : 1
        if route_vehs(veh_id) == 1 || route_vehs(veh_id) == 2
            if route_vehs(value) == 1 || route_vehs(value) == 2
                break;
            end
        else
            if route_vehs(value) == 3
                break;
            end
        end
    end
end