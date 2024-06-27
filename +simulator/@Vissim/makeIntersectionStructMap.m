function makeIntersectionStructMap(obj)
    obj.IntersectionStructMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    for group = obj.Config.groups
        group = group{1};
        for intersection = group.intersections
            intersection = intersection{1};
            obj.IntersectionStructMap(intersection.id) = intersection;
        end
    end
end