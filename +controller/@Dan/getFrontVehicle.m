% 分岐後の先行車を特定する関数
function value = getFrontVehicle(obj, veh_id, road_id, link_id)
    % lane_vehsの取得
    lane_vehs = obj.RoadLinkLaneVehsMap.get(road_id, link_id);

    % 先行車の探索
    for value = (veh_id-1) : -1 : 1
        if lane_vehs(veh_id) == 1
            if lane_vehs(value) == 1
                break;
            end
        elseif lane_vehs(veh_id) == 2
            if lane_vehs(value) == 2
                break;
            end
        elseif lane_vehs(veh_id) == 3
            if lane_vehs(value) == 3
                break;
            end
        end
    end
end