function makeLinkRoadMap(obj)
    obj.LinkRoadMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32'); 
    for group = obj.Config.groups
        group = group{1};
        for road_id = cell2mat(keys(group.RoadsMap))
            road = group.RoadsMap(road_id); 
            for link_id = road.link_ids
                obj.LinkRoadMap(link_id) = road.id;
            end
        end
    end
end