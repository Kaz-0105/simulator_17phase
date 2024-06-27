function makeDeltaF2List(obj)
    route_vehs = obj.route_vehs;
    last_index = obj.u_length + obj.z_length;
    delltaf2_list = [];

    if isfield(route_vehs, 'north')
        for veh_id = 1:length(route_vehs.north)
            if veh_id == 1
                last_index = last_index + 4;

                if route_vehs.north(veh_id) == 1 || route_vehs.north(veh_id) == 2
                    first_veh_route = 'straight';
                elseif route_vehs.north(veh_id) == 3
                    first_veh_route = 'right';
                end
            elseif route_vehs.north(veh_id) == 1 || route_vehs.north(veh_id) == 2
                if strcmp(first_veh_route, 'right')
                    delltaf2_list = [delltaf2_list, last_index + 3];
                    first_veh_route = 'done';
                    last_index = last_index + 7;
                else
                    delltaf2_list = [delltaf2_list, last_index + 3];
                    last_index = last_index + 9;
                end
            elseif route_vehs.north(veh_id) == 3
                if strcmp(first_veh_route, 'straight')
                    delltaf2_list = [delltaf2_list, last_index + 3];
                    first_veh_route = 'done';
                    last_index = last_index + 7;
                else
                    delltaf2_list = [delltaf2_list, last_index + 3];
                    last_index = last_index + 9;
                end
            end
        end
    end

    if isfield(route_vehs, 'south')
        for veh_id = 1:length(route_vehs.south)
            if veh_id == 1
                last_index = last_index + 4;

                if route_vehs.south(veh_id) == 1 || route_vehs.south(veh_id) == 2
                    first_veh_route = 'straight';
                elseif route_vehs.south(veh_id) == 3
                    first_veh_route = 'right';
                end
            elseif route_vehs.south(veh_id) == 1 || route_vehs.south(veh_id) == 2
                if strcmp(first_veh_route, 'right')
                    delltaf2_list = [delltaf2_list, last_index + 3];
                    first_veh_route = 'done';
                    last_index = last_index + 7;
                else
                    delltaf2_list = [delltaf2_list, last_index + 3];
                    last_index = last_index + 9;
                end
            elseif route_vehs.south(veh_id) == 3
                if strcmp(first_veh_route, 'straight')
                    delltaf2_list = [delltaf2_list, last_index + 3];
                    first_veh_route = 'done';
                    last_index = last_index + 7;
                else
                    delltaf2_list = [delltaf2_list, last_index + 3];
                    last_index = last_index + 9;
                end
            end
        end
    end

    if isfield(route_vehs, 'east')
        for veh_id = 1:length(route_vehs.east)
            if veh_id == 1
                last_index = last_index + 4;

                if route_vehs.east(veh_id) == 1 || route_vehs.east(veh_id) == 2
                    first_veh_route = 'straight';
                elseif route_vehs.east(veh_id) == 3
                    first_veh_route = 'right';
                end
            elseif route_vehs.east(veh_id) == 1 || route_vehs.east(veh_id) == 2
                if strcmp(first_veh_route, 'right')
                    delltaf2_list = [delltaf2_list, last_index + 3];
                    first_veh_route = 'done';
                    last_index = last_index + 7;
                else
                    delltaf2_list = [delltaf2_list, last_index + 3];
                    last_index = last_index + 9;
                end
            elseif route_vehs.east(veh_id) == 3
                if strcmp(first_veh_route, 'straight')
                    delltaf2_list = [delltaf2_list, last_index + 3];
                    first_veh_route = 'done';
                    last_index = last_index + 7;
                else
                    delltaf2_list = [delltaf2_list, last_index + 3];
                    last_index = last_index + 9;
                end
            end
        end
    end

    if isfield(route_vehs, 'west')
        for veh_id = 1:length(route_vehs.west)
            if veh_id == 1
                last_index = last_index + 4;

                if route_vehs.west(veh_id) == 1 || route_vehs.west(veh_id) == 2
                    first_veh_route = 'straight';
                elseif route_vehs.west(veh_id) == 3
                    first_veh_route = 'right';
                end
            elseif route_vehs.west(veh_id) == 1 || route_vehs.west(veh_id) == 2
                if strcmp(first_veh_route, 'right')
                    delltaf2_list = [delltaf2_list, last_index + 3];
                    first_veh_route = 'done';
                    last_index = last_index + 7;
                else
                    delltaf2_list = [delltaf2_list, last_index + 3];
                    last_index = last_index + 9;
                end
            elseif route_vehs.west(veh_id) == 3
                if strcmp(first_veh_route, 'straight')
                    delltaf2_list = [delltaf2_list, last_index + 3];
                    first_veh_route = 'done';
                    last_index = last_index + 7;
                else
                    delltaf2_list = [delltaf2_list, last_index + 3];
                    last_index = last_index + 9;
                end
            end
        end
    end

    obj.VariableListMap('delta_f2') = {delltaf2_list};


end