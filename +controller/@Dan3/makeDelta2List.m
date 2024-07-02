function makeDelta2List(obj)
    route_vehs = obj.route_vehs;
    last_index = obj.u_length + obj.z_length;
    delta2_list = [];

    if isfield(route_vehs, 'north')
        for veh_id = 1:length(route_vehs.north)
            if veh_id == 1
                last_index = last_index + 4;

                if route_vehs.north(veh_id) == 1 
                    first_veh_route = '1';
                elseif route_vehs.north(veh_id) == 2
                    first_veh_route = '2';
                end
            elseif route_vehs.north(veh_id) == 1 
                if strcmp(first_veh_route, '2')
                    delta2_list = [delta2_list, last_index + 6];
                    first_veh_route = '0';
                    last_index = last_index + 7;
                else
                    delta2_list = [delta2_list, last_index + 7];
                    last_index = last_index + 9;
                end
            elseif route_vehs.north(veh_id) == 2
                if strcmp(first_veh_route, '1')
                    delta2_list = [delta2_list, last_index + 6];
                    first_veh_route = '0';
                    last_index = last_index + 7;
                else
                    delta2_list = [delta2_list, last_index + 7];
                    last_index = last_index + 9;
                end
            end
        end
    end

    if isfield(route_vehs, 'south')
        for veh_id = 1:length(route_vehs.south)
            if veh_id == 1
                last_index = last_index + 4;

                if route_vehs.south(veh_id) == 1 
                    first_veh_route = '1';
                elseif route_vehs.south(veh_id) == 2
                    first_veh_route = '2';
                end
            elseif route_vehs.south(veh_id) == 1 
                if strcmp(first_veh_route, '2')
                    delta2_list = [delta2_list, last_index + 6];
                    first_veh_route = '0';
                    last_index = last_index + 7;
                else
                    delta2_list = [delta2_list, last_index + 7];
                    last_index = last_index + 9;
                end
            elseif route_vehs.south(veh_id) == 2
                if strcmp(first_veh_route, '1')
                    delta2_list = [delta2_list, last_index + 6];
                    first_veh_route = '0';
                    last_index = last_index + 7;
                else
                    delta2_list = [delta2_list, last_index + 7];
                    last_index = last_index + 9;
                end
            end
        end
    end

    if isfield(route_vehs, 'east')
        for veh_id = 1:length(route_vehs.east)
            if veh_id == 1
                last_index = last_index + 4;

                if route_vehs.east(veh_id) == 1 
                    first_veh_route = '1';
                elseif route_vehs.east(veh_id) == 2
                    first_veh_route = '2';
                end
            elseif route_vehs.east(veh_id) == 1 
                if strcmp(first_veh_route, '2')
                    delta2_list = [delta2_list, last_index + 6];
                    first_veh_route = '0';
                    last_index = last_index + 7;
                else
                    delta2_list = [delta2_list, last_index + 7];
                    last_index = last_index + 9;
                end
            elseif route_vehs.east(veh_id) == 2
                if strcmp(first_veh_route, '1')
                    delta2_list = [delta2_list, last_index + 6];
                    first_veh_route = '0';
                    last_index = last_index + 7;
                else
                    delta2_list = [delta2_list, last_index + 7];
                    last_index = last_index + 9;
                end
            end
        end
    end

    if isfield(route_vehs, 'west')
        for veh_id = 1:length(route_vehs.west)
            if veh_id == 1
                last_index = last_index + 4;

                if route_vehs.west(veh_id) == 1 
                    first_veh_route = '1';
                elseif route_vehs.west(veh_id) == 2
                    first_veh_route = '2';
                end
            elseif route_vehs.west(veh_id) == 1 
                if strcmp(first_veh_route, '2')
                    delta2_list = [delta2_list, last_index + 6];
                    first_veh_route = '0';
                    last_index = last_index + 7;
                else
                    delta2_list = [delta2_list, last_index + 7];
                    last_index = last_index + 9;
                end
            elseif route_vehs.west(veh_id) == 2
                if strcmp(first_veh_route, '1')
                    delta2_list = [delta2_list, last_index + 6];
                    first_veh_route = '0';
                    last_index = last_index + 7;
                else
                    delta2_list = [delta2_list, last_index + 7];
                    last_index = last_index + 9;
                end
            end
        end
    end

    obj.VariableListMap('delta_2') = delta2_list;


end