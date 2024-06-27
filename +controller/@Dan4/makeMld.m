function makeMld(obj)
    pos_vehs = obj.pos_vehs;
    route_vehs = obj.route_vehs;
    first_veh_ids = obj.first_veh_ids;
    road_prms = obj.road_prms;

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
    if isempty(pos_vehs.north)
        if isempty(pos_vehs.south)
            if isempty(pos_vehs.east)
                if isempty(pos_vehs.west)
                    return
                end
            end
        end
    end

    % Aの計算
    obj.makeA(pos_vehs.north);
    obj.makeA(pos_vehs.south);
    obj.makeA(pos_vehs.east);
    obj.makeA(pos_vehs.west);

    % B1の計算
    obj.makeB1(pos_vehs.north);
    obj.makeB1(pos_vehs.south);
    obj.makeB1(pos_vehs.east);
    obj.makeB1(pos_vehs.west);

    % B2の計算
    obj.makeB2(route_vehs.north, first_veh_ids.north, road_prms.north);
    obj.makeB2(route_vehs.south, first_veh_ids.south, road_prms.south);
    obj.makeB2(route_vehs.east, first_veh_ids.east, road_prms.east);
    obj.makeB2(route_vehs.west, first_veh_ids.west, road_prms.west);

    % B3の計算
    obj.makeB3(route_vehs.north, first_veh_ids.north, road_prms.north);
    obj.makeB3(route_vehs.south, first_veh_ids.south, road_prms.south);
    obj.makeB3(route_vehs.east, first_veh_ids.east, road_prms.east);
    obj.makeB3(route_vehs.west, first_veh_ids.west, road_prms.west);

    % Cの計算
    obj.makeC(route_vehs.north, first_veh_ids.north);
    obj.makeC(route_vehs.south, first_veh_ids.south);
    obj.makeC(route_vehs.east, first_veh_ids.east);
    obj.makeC(route_vehs.west, first_veh_ids.west);

    % D1の計算
    obj.makeD1(route_vehs.north, first_veh_ids.north, "north");
    obj.makeD1(route_vehs.south, first_veh_ids.south, "south");
    obj.makeD1(route_vehs.east, first_veh_ids.east, "east");
    obj.makeD1(route_vehs.west, first_veh_ids.west, "west");

    % D2の計算
    obj.makeD2(pos_vehs.north, first_veh_ids.north);
    obj.makeD2(pos_vehs.south, first_veh_ids.south);
    obj.makeD2(pos_vehs.east, first_veh_ids.east);
    obj.makeD2(pos_vehs.west, first_veh_ids.west);

    % D3の計算
    obj.makeD3(pos_vehs.north, first_veh_ids.north, road_prms.north);
    obj.makeD3(pos_vehs.south, first_veh_ids.south, road_prms.south);
    obj.makeD3(pos_vehs.east, first_veh_ids.east, road_prms.east);
    obj.makeD3(pos_vehs.west, first_veh_ids.west, road_prms.west);

    % Eの計算
    obj.makeE(pos_vehs.north, first_veh_ids.north, road_prms.north);
    obj.makeE(pos_vehs.south, first_veh_ids.south, road_prms.south);
    obj.makeE(pos_vehs.east, first_veh_ids.east, road_prms.east);
    obj.makeE(pos_vehs.west, first_veh_ids.west, road_prms.west);
end