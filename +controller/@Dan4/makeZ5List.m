function makeZ5List(obj)
    route_vehs = obj.route_vehs;
    last_index = obj.signal_num;
    z5_list = [];

    for veh_id = 1:length(route_vehs.north)
        if veh_id == 1
            last_index = last_index + 1;

            if route_vehs.north(veh_id) == 1 || route_vehs.north(veh_id) == 2
                first_veh_route = '1-2';
            elseif route_vehs.north(veh_id) == 3
                first_veh_route = '3';
            end
        elseif route_vehs.north(veh_id) == 1 || route_vehs.north(veh_id) == 2
            if strcmp(first_veh_route, '3')
                first_veh_route = '0';
                last_index = last_index + 3;
            else
                z5_list = [z5_list, last_index + 5];
                last_index = last_index + 5;
            end
        elseif route_vehs.north(veh_id) == 3
            if strcmp(first_veh_route, '1-2')
                first_veh_route = '0';
                last_index = last_index + 3;
            else
                z5_list = [z5_list, last_index + 5];
                last_index = last_index + 5;
            end
        end
    end

    for veh_id = 1:length(route_vehs.south)
        if veh_id == 1
            last_index = last_index + 1;

            if route_vehs.south(veh_id) == 1 || route_vehs.south(veh_id) == 2
                first_veh_route = '1-2';
            elseif route_vehs.south(veh_id) == 3
                first_veh_route = '3';
            end
        elseif route_vehs.south(veh_id) == 1 || route_vehs.south(veh_id) == 2
            if strcmp(first_veh_route, '3')
                first_veh_route = '0';
                last_index = last_index + 3;
            else
                z5_list = [z5_list, last_index + 5];
                last_index = last_index + 5;
            end
        elseif route_vehs.south(veh_id) == 3
            if strcmp(first_veh_route, '1-2')
                first_veh_route = '0';
                last_index = last_index + 3;
            else
                z5_list = [z5_list, last_index + 5];
                last_index = last_index + 5;
            end
        end
    end

    for veh_id = 1:length(route_vehs.east)
        if veh_id == 1
            last_index = last_index + 1;

            if route_vehs.east(veh_id) == 1 || route_vehs.east(veh_id) == 2
                first_veh_route = '1-2';
            elseif route_vehs.east(veh_id) == 3
                first_veh_route = '3';
            end
        elseif route_vehs.east(veh_id) == 1 || route_vehs.east(veh_id) == 2
            if strcmp(first_veh_route, '3')
                first_veh_route = '0';
                last_index = last_index + 3;
            else
                z5_list = [z5_list, last_index + 5];
                last_index = last_index + 5;
            end
        elseif route_vehs.east(veh_id) == 3
            if strcmp(first_veh_route, '1-2')
                first_veh_route = '0';
                last_index = last_index + 3;
            else
                z5_list = [z5_list, last_index + 5];
                last_index = last_index + 5;
            end
        end
    end

    for veh_id = 1:length(route_vehs.west)
        if veh_id == 1
            last_index = last_index + 1;

            if route_vehs.west(veh_id) == 1 || route_vehs.west(veh_id) == 2
                first_veh_route = '1-2';
            elseif route_vehs.west(veh_id) == 3
                first_veh_route = '3';
            end
        elseif route_vehs.west(veh_id) == 1 || route_vehs.west(veh_id) == 2
            if strcmp(first_veh_route, '3')
                first_veh_route = '0';
                last_index = last_index + 3;
            else
                z5_list = [z5_list, last_index + 5];
                last_index = last_index + 5;
            end
        elseif route_vehs.west(veh_id) == 3
            if strcmp(first_veh_route, '1-2')
                first_veh_route = '0';
                last_index = last_index + 3;
            else
                z5_list = [z5_list, last_index + 5];
                last_index = last_index + 5;
            end
        end
    end

    obj.VariableListMap('z_5') = z5_list;
    obj.z_length = last_index - obj.signal_num;


end