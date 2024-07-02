function makeIntersectionStructMap(obj)
    obj.IntersectionStructMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    for group = obj.Config.groups
        group = group{1};
        for intersection_id = cell2mat(keys(group.IntersectionsMap))
            intersection = group.IntersectionsMap(intersection_id);
            obj.IntersectionStructMap(intersection.id) = intersection;
        end
    end
end