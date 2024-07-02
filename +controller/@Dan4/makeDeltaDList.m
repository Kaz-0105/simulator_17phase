function makeDeltaDList(obj)
    route_vehs = obj.route_vehs;
    last_index = obj.u_length + obj.z_length;
    deltad_list = [];

    for veh_id = 1:length(route_vehs.north)
        if veh_id == 1
            deltad_list = [deltad_list, last_index + 1];
            last_index = last_index + 4;

            if route_vehs.north(veh_id) == 1 || route_vehs.north(veh_id) == 2
                first_veh_route = '1-2';
            elseif route_vehs.north(veh_id) == 3
                first_veh_route = '3';
            end
        elseif route_vehs.north(veh_id) == 1 || route_vehs.north(veh_id) == 2
            if strcmp(first_veh_route, '3')
                deltad_list = [deltad_list, last_index + 1];
                first_veh_route = '0';
                last_index = last_index + 7;
            else
                deltad_list = [deltad_list, last_index + 1];
                last_index = last_index + 9;
            end
        elseif route_vehs.north(veh_id) == 3
            if strcmp(first_veh_route, '1-2')
                deltad_list = [deltad_list, last_index + 1];
                first_veh_route = '0';
                last_index = last_index + 7;
            else
                deltad_list = [deltad_list, last_index + 1];
                last_index = last_index + 9;
            end
        end
    end

    for veh_id = 1:length(route_vehs.south)
        if veh_id == 1
            deltad_list = [deltad_list, last_index + 1];
            last_index = last_index + 4;

            if route_vehs.south(veh_id) == 1 || route_vehs.south(veh_id) == 2
                first_veh_route = '1-2';
            elseif route_vehs.south(veh_id) == 3
                first_veh_route = '3';
            end
        elseif route_vehs.south(veh_id) == 1 || route_vehs.south(veh_id) == 2
            if strcmp(first_veh_route, '3')
                deltad_list = [deltad_list, last_index + 1];
                first_veh_route = '0';
                last_index = last_index + 7;
            else
                deltad_list = [deltad_list, last_index + 1];
                last_index = last_index + 9;
            end
        elseif route_vehs.south(veh_id) == 3
            if strcmp(first_veh_route, '1-2')
                deltad_list = [deltad_list, last_index + 1];
                first_veh_route = '0';
                last_index = last_index + 7;
            else
                deltad_list = [deltad_list, last_index + 1];
                last_index = last_index + 9;
            end
        end
    end

    for veh_id = 1:length(route_vehs.east)
        if veh_id == 1
            deltad_list = [deltad_list, last_index + 1];
            last_index = last_index + 4;

            if route_vehs.east(veh_id) == 1 || route_vehs.east(veh_id) == 2
                first_veh_route = '1-2';
            elseif route_vehs.east(veh_id) == 3
                first_veh_route = '3';
            end
        elseif route_vehs.east(veh_id) == 1 || route_vehs.east(veh_id) == 2
            if strcmp(first_veh_route, '3')
                deltad_list = [deltad_list, last_index + 1];
                first_veh_route = '0';
                last_index = last_index + 7;
            else
                deltad_list = [deltad_list, last_index + 1];
                last_index = last_index + 9;
            end
        elseif route_vehs.east(veh_id) == 3
            if strcmp(first_veh_route, '1-2')
                deltad_list = [deltad_list, last_index + 1];
                first_veh_route = '0';
                last_index = last_index + 7;
            else
                deltad_list = [deltad_list, last_index + 1];
                last_index = last_index + 9;
            end
        end
    end

    for veh_id = 1:length(route_vehs.west)
        if veh_id == 1
            deltad_list = [deltad_list, last_index + 1];
            last_index = last_index + 4;

            if route_vehs.west(veh_id) == 1 || route_vehs.west(veh_id) == 2
                first_veh_route = '1-2';
            elseif route_vehs.west(veh_id) == 3
                first_veh_route = '3';
            end
        elseif route_vehs.west(veh_id) == 1 || route_vehs.west(veh_id) == 2
            if strcmp(first_veh_route, '3')
                deltad_list = [deltad_list, last_index + 1];
                first_veh_route = '0';
                last_index = last_index + 7;
            else
                deltad_list = [deltad_list, last_index + 1];
                last_index = last_index + 9;
            end
        elseif route_vehs.west(veh_id) == 3
            if strcmp(first_veh_route, '1-2')
                deltad_list = [deltad_list, last_index + 1];
                first_veh_route = '0';
                last_index = last_index + 7;
            else
                deltad_list = [deltad_list, last_index + 1];
                last_index = last_index + 9;
            end
        end
    end

    obj.VariableListMap('delta_d') = deltad_list;
    

end