function makeRoadLinkMap(obj)
    obj.RoadLinkMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    for group_id = cell2mat(keys(obj.Config.network.GroupsMap))
        group = obj.Config.network.GroupsMap(group_id);
        for road_id = cell2mat(keys(group.RoadsMap))
            road = group.RoadsMap(road_id);
            obj.RoadLinkMap(road.id) = road.link_ids;
        end
    end
end