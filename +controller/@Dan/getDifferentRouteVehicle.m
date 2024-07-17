function value = getDifferentRouteVehicle(obj, veh_id, road_id, link_id)
    % lane_vehsの取得
    lane_vehs = obj.RoadLinkLaneVehsMap.get(road_id, link_id);

    % route_vehsを取得
    route_vehs = obj.RoadLinkRouteVehsMap.get(road_id, link_id);

    % 車線が一緒で進路が異なる先行車の探索
    for value = (veh_id-1) : -1 : 1
        if route_vehs(veh_id) ~= route_vehs(value) 
            if lane_vehs(veh_id) == lane_vehs(value)
                break;
            end
        end
    end
end