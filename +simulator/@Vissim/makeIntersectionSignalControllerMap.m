function makeIntersectionSignalControllerMap(obj)
    obj.IntersectionSignalControllerMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    for group_id = cell2mat(keys(obj.Config.network.GroupsMap))
        group = obj.Config.network.GroupsMap(group_id);
        for intersection_id = cell2mat(keys(group.IntersectionsMap))
            intersection = group.IntersectionsMap(intersection_id);
            obj.IntersectionSignalControllerMap(intersection.id) = obj.Com.Net.SignalControllers.ItemByKey(intersection.id);
        end
    end
end