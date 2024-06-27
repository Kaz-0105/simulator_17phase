function make_mld_matrices(obj)
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

    if ~isfield(pos_vehs, 'north')
        if isempty(pos_vehs.south)
            if isempty(pos_vehs.east)
                if isempty(pos_vehs.west)
                    return;
                end
            end
        end
    end

    if ~isfield(pos_vehs, 'south')
        if isempty(pos_vehs.north)
            if isempty(pos_vehs.east)
                if isempty(pos_vehs.west)
                    return;
                end
            end
        end
    end


    if ~isfield(pos_vehs, 'east')
        if isempty(pos_vehs.north)
            if isempty(pos_vehs.south)
                if isempty(pos_vehs.west)
                    return;
                end
            end
        end
    end

    if ~isfield(pos_vehs, 'west')
        if isempty(pos_vehs.north)
            if isempty(pos_vehs.south)
                if isempty(pos_vehs.east)
                    return;
                end
            end
        end
    end

    % Aの計算
    if isfield(pos_vehs, 'north')
        obj.makeA(pos_vehs.north);
    end
    if isfield(pos_vehs, 'south')
        obj.makeA(pos_vehs.south);
    end
    if isfield(pos_vehs, 'east')
        obj.makeA(pos_vehs.east);
    end
    if isfield(pos_vehs, 'west')
        obj.makeA(pos_vehs.west);
    end

    % B1の計算
    if isfield(pos_vehs, 'north')
        obj.makeB1(pos_vehs.north);
    end
    if isfield(pos_vehs, 'south')
        obj.makeB1(pos_vehs.south);
    end
    if isfield(pos_vehs, 'east')
        obj.makeB1(pos_vehs.east);
    end
    if isfield(pos_vehs, 'west')
        obj.makeB1(pos_vehs.west);
    end

    % B2の計算
    if isfield(route_vehs, 'north')
        obj.makeB2(route_vehs.north, first_veh_ids.north, road_prms.north);
    end
    if isfield(route_vehs, 'south')
        obj.makeB2(route_vehs.south, first_veh_ids.south, road_prms.south);
    end
    if isfield(route_vehs, 'east')
        obj.makeB2(route_vehs.east, first_veh_ids.east, road_prms.east);
    end
    if isfield(route_vehs, 'west')
        obj.makeB2(route_vehs.west, first_veh_ids.west, road_prms.west);
    end


    % B3の計算
    if isfield(route_vehs, 'north')
        obj.makeB3(route_vehs.north, first_veh_ids.north, road_prms.north);
    end
    if isfield(route_vehs, 'south')
        obj.makeB3(route_vehs.south, first_veh_ids.south, road_prms.south);
    end
    if isfield(route_vehs, 'east')
        obj.makeB3(route_vehs.east, first_veh_ids.east, road_prms.east);
    end
    if isfield(route_vehs, 'west')
        obj.makeB3(route_vehs.west, first_veh_ids.west, road_prms.west);
    end

    % Cの計算
    if isfield(route_vehs, 'north')
        obj.makeC(route_vehs.north, first_veh_ids.north);
    end
    if isfield(route_vehs, 'south')
        obj.makeC(route_vehs.south, first_veh_ids.south);
    end
    if isfield(route_vehs, 'east')
        obj.makeC(route_vehs.east, first_veh_ids.east);
    end
    if isfield(route_vehs, 'west')
        obj.makeC(route_vehs.west, first_veh_ids.west);
    end

    % D1の計算
    if isfield(route_vehs, 'north')
        obj.makeD1(route_vehs.north, first_veh_ids.north, "north");
    end
    if isfield(route_vehs, 'south')
        obj.makeD1(route_vehs.south, first_veh_ids.south, "south");
    end
    if isfield(route_vehs, 'east')
        obj.makeD1(route_vehs.east, first_veh_ids.east, "east");
    end
    if isfield(route_vehs, 'west')
        obj.makeD1(route_vehs.west, first_veh_ids.west, "west");
    end

    % D2の計算
    if isfield(pos_vehs, 'north')
        obj.makeD2(pos_vehs.north, first_veh_ids.north);
    end
    if isfield(pos_vehs, 'south')
        obj.makeD2(pos_vehs.south, first_veh_ids.south);
    end
    if isfield(pos_vehs, 'east')
        obj.makeD2(pos_vehs.east, first_veh_ids.east);
    end
    if isfield(pos_vehs, 'west')
        obj.makeD2(pos_vehs.west, first_veh_ids.west);
    end

    % D3の計算
    if isfield(pos_vehs, 'north')
        obj.makeD3(pos_vehs.north, first_veh_ids.north, road_prms.north);
    end
    if isfield(pos_vehs, 'south')
        obj.makeD3(pos_vehs.south, first_veh_ids.south, road_prms.south);
    end
    if isfield(pos_vehs, 'east')
        obj.makeD3(pos_vehs.east, first_veh_ids.east, road_prms.east);
    end
    if isfield(pos_vehs, 'west')
        obj.makeD3(pos_vehs.west, first_veh_ids.west, road_prms.west);
    end

    % Eの計算
    if isfield(pos_vehs, 'north')
        obj.makeE(pos_vehs.north, first_veh_ids.north, road_prms.north);
    end
    if isfield(pos_vehs, 'south')
        obj.makeE(pos_vehs.south, first_veh_ids.south, road_prms.south);
    end
    if isfield(pos_vehs, 'east')
        obj.makeE(pos_vehs.east, first_veh_ids.east, road_prms.east);
    end
    if isfield(pos_vehs, 'west')
        obj.makeE(pos_vehs.west, first_veh_ids.west, road_prms.west);
    end
end