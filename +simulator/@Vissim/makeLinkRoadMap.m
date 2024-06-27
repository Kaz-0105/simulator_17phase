function makeLinkRoadMap(obj)
    obj.LinkRoadMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32'); 
    for group = obj.Config.groups
        group = group{1};
        for road = group.roads
            road = road{1};
            for link_id = road.link_ids
                obj.LinkRoadMap(link_id) = road.id;
            end
        end
    end
end