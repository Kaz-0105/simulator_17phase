function makeZ1List(obj)
    route_vehs = obj.route_vehs;
    last_index = obj.signal_num;
    z1_list = [];

    if isfield(route_vehs, 'north')
        for veh_id = 1:length(route_vehs.north)
            if veh_id == 1
                z1_list = [z1_list, last_index + 1];
                last_index = last_index + 1;

                if route_vehs.north(veh_id) == 1 || route_vehs.north(veh_id) == 2
                    first_veh_route = 'straight';
                elseif route_vehs.north(veh_id) == 3
                    first_veh_route = 'right';
                end
            elseif route_vehs.north(veh_id) == 1 || route_vehs.north(veh_id) == 2
                if strcmp(first_veh_route, 'right')
                    z1_list = [z1_list, last_index + 1];
                    first_veh_route = 'done';
                    last_index = last_index + 3;
                else
                    z1_list = [z1_list, last_index + 1];
                    last_index = last_index + 5;
                end
            elseif route_vehs.north(veh_id) == 3
                if strcmp(first_veh_route, 'straight')
                    z1_list = [z1_list, last_index + 1];
                    first_veh_route = 'done';
                    last_index = last_index + 3;
                else
                    z1_list = [z1_list, last_index + 1];
                    last_index = last_index + 5;
                end
            end
        end
    end

    if isfield(route_vehs, 'south')
        for veh_id = 1:length(route_vehs.south)
            if veh_id == 1
                z1_list = [z1_list, last_index + 1];
                last_index = last_index + 1;

                if route_vehs.south(veh_id) == 1 || route_vehs.south(veh_id) == 2
                    first_veh_route = 'straight';
                elseif route_vehs.south(veh_id) == 3
                    first_veh_route = 'right';
                end
            elseif route_vehs.south(veh_id) == 1 || route_vehs.south(veh_id) == 2
                if strcmp(first_veh_route, 'right')
                    z1_list = [z1_list, last_index + 1];
                    first_veh_route = 'done';
                    last_index = last_index + 3;
                else
                    z1_list = [z1_list, last_index + 1];
                    last_index = last_index + 5;
                end
            elseif route_vehs.south(veh_id) == 3
                if strcmp(first_veh_route, 'straight')
                    z1_list = [z1_list, last_index + 1];
                    first_veh_route = 'done';
                    last_index = last_index + 3;
                else
                    z1_list = [z1_list, last_index + 1];
                    last_index = last_index + 5;
                end
            end
        end
    end

    if isfield(route_vehs, 'east')
        for veh_id = 1:length(route_vehs.east)
            if veh_id == 1
                z1_list = [z1_list, last_index + 1];
                last_index = last_index + 1;

                if route_vehs.east(veh_id) == 1 || route_vehs.east(veh_id) == 2
                    first_veh_route = 'straight';
                elseif route_vehs.east(veh_id) == 3
                    first_veh_route = 'right';
                end
            elseif route_vehs.east(veh_id) == 1 || route_vehs.east(veh_id) == 2
                if strcmp(first_veh_route, 'right')
                    z1_list = [z1_list, last_index + 1];
                    first_veh_route = 'done';
                    last_index = last_index + 3;
                else
                    z1_list = [z1_list, last_index + 1];
                    last_index = last_index + 5;
                end
            elseif route_vehs.east(veh_id) == 3
                if strcmp(first_veh_route, 'straight')
                    z1_list = [z1_list, last_index + 1];
                    first_veh_route = 'done';
                    last_index = last_index + 3;
                else
                    z1_list = [z1_list, last_index + 1];
                    last_index = last_index + 5;
                end
            end
        end
    end

    if isfield(route_vehs, 'west')
        for veh_id = 1:length(route_vehs.west)
            if veh_id == 1
                z1_list = [z1_list, last_index + 1];
                last_index = last_index + 1;

                if route_vehs.west(veh_id) == 1 || route_vehs.west(veh_id) == 2
                    first_veh_route = 'straight';
                elseif route_vehs.west(veh_id) == 3
                    first_veh_route = 'right';
                end
            elseif route_vehs.west(veh_id) == 1 || route_vehs.west(veh_id) == 2
                if strcmp(first_veh_route, 'right')
                    z1_list = [z1_list, last_index + 1];
                    first_veh_route = 'done';
                    last_index = last_index + 3;
                else
                    z1_list = [z1_list, last_index + 1];
                    last_index = last_index + 5;
                end
            elseif route_vehs.west(veh_id) == 3
                if strcmp(first_veh_route, 'straight')
                    z1_list = [z1_list, last_index + 1];
                    first_veh_route = 'done';
                    last_index = last_index + 3;
                else
                    z1_list = [z1_list, last_index + 1];
                    last_index = last_index + 5;
                end
            end
        end
    end

    obj.VariableListMap('z_1') = z1_list;
    

end