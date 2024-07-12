function displayControlMethod(obj)
    fprintf('Control Method :\n')
    for group_id = cell2mat(keys(obj.network.GroupsMap))
        fprintf('\tArea %d :\n', group_id);
        group = obj.network.GroupsMap(group_id);
        for intersection_id = cell2mat(keys(group.IntersectionsMap))
            intersection_struct = group.IntersectionsMap(intersection_id);
            if strcmp(intersection_struct.control_method, 'Dan')
                fprintf('\t\tIntersection %d : MPC\n', intersection_struct.id);
            elseif strcmp(intersection_struct.control_method, 'Fix4')
                fprintf('\t\tIntersection %d : Fixed time\n', intersection_struct.id);
            elseif strcmp(intersection_struct.control_method, 'Dan3')
                fprintf('\t\tIntersection %d : MPC\n', intersection_struct.id);
            elseif strcmp(intersection_struct.control_method, 'Fix3')
                fprintf('\t\tIntersection %d : Fixed time\n', intersection_struct.id);
            end
        end
    end
end