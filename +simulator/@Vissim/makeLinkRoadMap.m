function makeLinkRoadMap(obj)
    obj.LinkRoadMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32'); 
    for group_id = cell2mat(keys(obj.Config.network.GroupsMap))
        group = obj.Config.network.GroupsMap(group_id);
        for road_id = cell2mat(keys(group.RoadsMap))
            road = group.RoadsMap(road_id); 
            for link_id = road.link_ids
                obj.LinkRoadMap(link_id) = road.id;
            end
        end
    end
end