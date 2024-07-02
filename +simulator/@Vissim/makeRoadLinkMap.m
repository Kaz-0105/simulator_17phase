function makeRoadLinkMap(obj)
    obj.RoadLinkMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    for group = obj.Config.groups
        group = group{1};
        for road_id = cell2mat(keys(group.RoadsMap))
            road = group.RoadsMap(road_id);
            obj.RoadLinkMap(road.id) = road.link_ids;
        end
    end
end