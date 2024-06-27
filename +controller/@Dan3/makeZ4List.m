function makeZ4List(obj)
    route_vehs = obj.route_vehs;
    last_index = obj.signal_num;
    z4_list = [];

    if isfield(route_vehs, 'north')
        for veh_id = 1:length(route_vehs.north)
            if veh_id == 1
                last_index = last_index + 1;

                if route_vehs.north(veh_id) == 1 
                    first_veh_route = 'left';
                elseif route_vehs.north(veh_id) == 2
                    first_veh_route = 'right';
                end
            elseif route_vehs.north(veh_id) == 1 
                if strcmp(first_veh_route, 'right')
                    first_veh_route = 'done';
                    last_index = last_index + 3;
                else
                    z4_list = [z4_list, last_index + 4];
                    last_index = last_index + 5;
                end
            elseif route_vehs.north(veh_id) == 2
                if strcmp(first_veh_route, 'left')
                    first_veh_route = 'done';
                    last_index = last_index + 3;
                else
                    z4_list = [z4_list, last_index + 4];
                    last_index = last_index + 5;
                end
            end
        end
    end

    if isfield(route_vehs, 'south')
        for veh_id = 1:length(route_vehs.south)
            if veh_id == 1
                last_index = last_index + 1;

                if route_vehs.south(veh_id) == 1 
                    first_veh_route = 'left';
                elseif route_vehs.south(veh_id) == 2
                    first_veh_route = 'right';
                end
            elseif route_vehs.south(veh_id) == 1 
                if strcmp(first_veh_route, 'right')
                    first_veh_route = 'done';
                    last_index = last_index + 3;
                else
                    z4_list = [z4_list, last_index + 4];
                    last_index = last_index + 5;
                end
            elseif route_vehs.south(veh_id) == 2
                if strcmp(first_veh_route, 'left')
                    first_veh_route = 'done';
                    last_index = last_index + 3;
                else
                    z4_list = [z4_list, last_index + 4];
                    last_index = last_index + 5;
                end
            end
        end
    end

    if isfield(route_vehs, 'east')
        for veh_id = 1:length(route_vehs.east)
            if veh_id == 1
                last_index = last_index + 1;

                if route_vehs.east(veh_id) == 1 
                    first_veh_route = 'left';
                elseif route_vehs.east(veh_id) == 2
                    first_veh_route = 'right';
                end
            elseif route_vehs.east(veh_id) == 1 
                if strcmp(first_veh_route, 'right')
                    first_veh_route = 'done';
                    last_index = last_index + 3;
                else
                    z4_list = [z4_list, last_index + 4];
                    last_index = last_index + 5;
                end
            elseif route_vehs.east(veh_id) == 2
                if strcmp(first_veh_route, 'left')
                    first_veh_route = 'done';
                    last_index = last_index + 3;
                else
                    z4_list = [z4_list, last_index + 4];
                    last_index = last_index + 5;
                end
            end
        end
    end

    if isfield(route_vehs, 'west')
        for veh_id = 1:length(route_vehs.west)
            if veh_id == 1
                last_index = last_index + 1;

                if route_vehs.west(veh_id) == 1 
                    first_veh_route = 'left';
                elseif route_vehs.west(veh_id) == 2
                    first_veh_route = 'right';
                end
            elseif route_vehs.west(veh_id) == 1 
                if strcmp(first_veh_route, 'right')
                    first_veh_route = 'done';
                    last_index = last_index + 3;
                else
                    z4_list = [z4_list, last_index + 4];
                    last_index = last_index + 5;
                end
            elseif route_vehs.west(veh_id) == 2
                if strcmp(first_veh_route, 'left')
                    first_veh_route = 'done';
                    last_index = last_index + 3;
                else
                    z4_list = [z4_list, last_index + 4];
                    last_index = last_index + 5;
                end
            end
        end
    end

    obj.VariableListMap('z_4') = z4_list;


end