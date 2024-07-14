function makeIntersectionStructMap(obj)
    obj.IntersectionStructMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    obj.IntersectionNumRoadsMap = containers.Map('KeyType','int32','ValueType','int32');

    for group_id = cell2mat(keys(obj.Config.network.GroupsMap))
        group = obj.Config.network.GroupsMap(group_id);
        for intersection_id = cell2mat(keys(group.IntersectionsMap))
            intersection = group.IntersectionsMap(intersection_id);
            obj.IntersectionStructMap(intersection.id) = intersection;
            obj.IntersectionNumRoadsMap(intersection.id) = length(intersection.input_road_ids);
        end
    end
end