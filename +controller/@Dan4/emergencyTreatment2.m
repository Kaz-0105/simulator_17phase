function emergencyTreatment(obj)

    route_vehs_north = obj.route_vehs.north;
    route_vehs_south = obj.route_vehs.south;
    route_vehs_east = obj.route_vehs.east;
    route_vehs_west = obj.route_vehs.west;

    north_south_straight = 0;
    north_south_right = 0;

    east_west_straight = 0;
    east_west_right = 0;

    north_straight_right = 0;
    south_straight_right = 0;
    east_straight_right = 0;
    west_straight_right = 0;

    if ~isempty(route_vehs_north)
        for veh_id = 1:length(route_vehs_north)
            if route_vehs_north(veh_id) == 1 || route_vehs_north(veh_id) == 2
                north_south_straight = north_south_straight + 1;
                north_straight_right = north_straight_right + 1;
            elseif route_vehs_north(veh_id) == 3
                north_south_right = north_south_right + 1;
                north_straight_right = north_straight_right + 1;
            end
        end
    end

    if ~isempty(route_vehs_south)
        for veh_id = 1:length(route_vehs_south)
            if route_vehs_south(veh_id) == 1 || route_vehs_south(veh_id) == 2
                north_south_straight = north_south_straight + 1;
                south_straight_right = south_straight_right + 1;
            elseif route_vehs_south(veh_id) == 3
                north_south_right = north_south_right + 1;
                south_straight_right = south_straight_right + 1;
            end
        end
    end

    if ~isempty(route_vehs_east)
        for veh_id = 1:length(route_vehs_east)
            if route_vehs_east(veh_id) == 1 || route_vehs_east(veh_id) == 2
                east_west_straight = east_west_straight + 1;
                east_straight_right = east_straight_right + 1;
            elseif route_vehs_east(veh_id) == 3
                east_west_right = east_west_right + 1;
                east_straight_right = east_straight_right + 1;
            end
        end
    end

    if ~isempty(route_vehs_west)
        for veh_id = 1:length(route_vehs_west)
            if route_vehs_west(veh_id) == 1 || route_vehs_west(veh_id) == 2
                east_west_straight = east_west_straight + 1;
                west_straight_right = west_straight_right + 1;
            elseif route_vehs_west(veh_id) == 3
                east_west_right = east_west_right + 1;
                west_straight_right = west_straight_right + 1;
            end
        end
    end



    [~, phase_id] = max([north_south_straight, north_south_right, east_west_straight, east_west_right, ...
        north_straight_right, east_straight_right, south_straight_right, west_straight_right]);


    obj.u_opt = [];
    u_future_data = obj.UResults.get('future_data');
    for step = 1: obj.fix_num
        obj.u_opt = [obj.u_opt, u_future_data(:,step)];
    end

    tmp_u = zeros(obj.signal_num, 1);
    tmp_u(obj.PhaseSignalGroupMap(phase_id), 1) = ones(4, 1);

    for step = obj.fix_num + 1: obj.N_p
        obj.u_opt = [obj.u_opt, tmp_u];
    end
    
    obj.phi_opt = zeros(1, obj.N_p-1);
end