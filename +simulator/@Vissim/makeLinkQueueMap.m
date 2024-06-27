function makeLinkQueueMap(obj)
    obj.LinkQueueMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');
    for group = obj.Config.groups
        group = group{1};
        for road = group.roads
            road = road{1};
            for link_id = road.link_ids
                if link_id == road.main_link_id
                    obj.LinkQueueMap(link_id) = road.queue_counter_ids(1);
                elseif link_id < 10000
                    obj.LinkQueueMap(link_id) = road.queue_counter_ids(2);
                end
            end
        end
    end
end