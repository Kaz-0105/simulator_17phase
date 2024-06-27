function makeRoadLinkMap(obj)
    obj.RoadLinkMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    for group = obj.Config.groups
        group = group{1};
        for road = group.roads
            road = road{1};
            obj.RoadLinkMap(road.id) = road.link_ids;
        end
    end
end