function makeWeight(obj)
    weight_matrix = [];

    templete = zeros(1, 3);
    templete(1) = (obj.phase_num-11);
    templete(2) = (obj.phase_num-3);
    templete(3) = (obj.phase_num-3);

    first_veh_scaling_factor = 1; 


    for i = 1: length(obj.route_vehs.north)
        if i == obj.first_veh_ids.north.straight
            weight_matrix = [weight_matrix, templete(obj.route_vehs.north(i))*first_veh_scaling_factor];
        elseif i == obj.first_veh_ids.north.right
            weight_matrix = [weight_matrix, templete(obj.route_vehs.north(i))*first_veh_scaling_factor];
        else
            weight_matrix = [weight_matrix, templete(obj.route_vehs.north(i))];
        end
    end

    for i = 1: length(obj.route_vehs.south)
        if i == obj.first_veh_ids.south.straight
            weight_matrix = [weight_matrix, templete(obj.route_vehs.south(i))*first_veh_scaling_factor];
        elseif i == obj.first_veh_ids.south.right
            weight_matrix = [weight_matrix, templete(obj.route_vehs.south(i))*first_veh_scaling_factor];
        else
            weight_matrix = [weight_matrix, templete(obj.route_vehs.south(i))];
        end
    end

    for i = 1: length(obj.route_vehs.east)
        if i == obj.first_veh_ids.east.straight
            weight_matrix = [weight_matrix, templete(obj.route_vehs.east(i))*first_veh_scaling_factor];
        elseif i == obj.first_veh_ids.east.right
            weight_matrix = [weight_matrix, templete(obj.route_vehs.east(i))*first_veh_scaling_factor];
        else
            weight_matrix = [weight_matrix, templete(obj.route_vehs.east(i))];
        end
    end

    for i = 1: length(obj.route_vehs.west)
        if i == obj.first_veh_ids.west.straight
            weight_matrix = [weight_matrix, templete(obj.route_vehs.west(i))*first_veh_scaling_factor];
        elseif i == obj.first_veh_ids.west.right
            weight_matrix = [weight_matrix, templete(obj.route_vehs.west(i))*first_veh_scaling_factor];
        else
            weight_matrix = [weight_matrix, templete(obj.route_vehs.west(i))];
        end
    end

    obj.milp_matrices.w = weight_matrix;
end