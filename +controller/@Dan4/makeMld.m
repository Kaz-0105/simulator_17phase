function makeMld(obj)

    obj.mld_matrices.A = [];
    obj.mld_matrices.B1 = [];
    obj.mld_matrices.B2 = [];
    obj.mld_matrices.B3 = [];
    obj.mld_matrices.C = [];
    obj.mld_matrices.D1 = [];
    obj.mld_matrices.D2 = [];
    obj.mld_matrices.D3 = [];
    obj.mld_matrices.E = [];

    % どの方向にも車両が存在しない場合は何もしない
    isVehicle = false;
    for road_id = 1: obj.road_num
        if ~isempty(obj.RoadPosVehsMap(road_id))
            isVehicle = true;
            break;
        end
    end

    if ~isVehicle
        return
    end

    % Aの計算
    for road_id = 1: obj.road_num
        pos_vehs = obj.RoadPosVehsMap(road_id);
        obj.makeA(pos_vehs);
    end

    % B1の計算
    for road_id = 1: obj.road_num
        pos_vehs = obj.RoadPosVehsMap(road_id);
        obj.makeB1(pos_vehs);
    end

    % B2の計算
    for road_id = 1: obj.road_num
        route_vehs = obj.RoadRouteVehsMap(road_id);
        first_veh_ids = obj.RoadFirstVehStructMap(road_id);
        road_prms = obj.RoadPrmsMap(road_id);
        obj.makeB2(route_vehs, first_veh_ids, road_prms);
    end

    % B3の計算
    for road_id = 1: obj.road_num
        route_vehs = obj.RoadRouteVehsMap(road_id);
        first_veh_ids = obj.RoadFirstVehStructMap(road_id);
        road_prms = obj.RoadPrmsMap(road_id);
        obj.makeB3(route_vehs, first_veh_ids, road_prms);
    end

    % Cの計算
    for road_id = 1: obj.road_num
        route_vehs = obj.RoadRouteVehsMap(road_id);
        first_veh_ids = obj.RoadFirstVehStructMap(road_id);
        obj.makeC(route_vehs, first_veh_ids);
    end

    % D1の計算
    for road_id = 1: obj.road_num
        route_vehs = obj.RoadRouteVehsMap(road_id);
        first_veh_ids = obj.RoadFirstVehStructMap(road_id);
        obj.makeD1(route_vehs, first_veh_ids, road_id);
    end

    % D2の計算
    for road_id = 1: obj.road_num
        pos_vehs = obj.RoadPosVehsMap(road_id);
        first_veh_ids = obj.RoadFirstVehStructMap(road_id);
        obj.makeD2(pos_vehs, first_veh_ids);
    end

    % D3の計算
    for road_id = 1: obj.road_num
        pos_vehs = obj.RoadPosVehsMap(road_id);
        first_veh_ids = obj.RoadFirstVehStructMap(road_id);
        road_prms = obj.RoadPrmsMap(road_id);
        obj.makeD3(pos_vehs, first_veh_ids, road_prms);
    end

    % Eの計算
    for road_id = 1: obj.road_num
        pos_vehs = obj.RoadPosVehsMap(road_id);
        first_veh_ids = obj.RoadFirstVehStructMap(road_id);
        road_prms = obj.RoadPrmsMap(road_id);
        obj.makeE(pos_vehs, first_veh_ids, road_prms);
    end
end