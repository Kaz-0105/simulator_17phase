function updateQueueData(obj, Maps)
    % IntesectionStructMapを取得
    IntersectionStructMap = Maps('IntersectionStructMap');

    % RoadLinkMapを取得
    RoadLinkMap = Maps('RoadLinkMap');

    % LinkQueueMapを取得
    LinkQueueMap = Maps('LinkQueueMap');
    
    for intersection_struct = values(IntersectionStructMap)
        intersection_struct = intersection_struct{1};
        
        tmp_queue_struct = [];
        for input_road_id = intersection_struct.input_road_ids
            input_road_direction = intersection_struct.input_road_directions(input_road_id);


            tmp_queue_length = 0;
            input_road_link_ids = RoadLinkMap(input_road_id);
            for link_id = input_road_link_ids
                if isKey(LinkQueueMap, link_id)
                    queue_counter_id = LinkQueueMap(link_id);
                    queue_counter_obj = obj.Com.Net.QueueCounters.ItemByKey(queue_counter_id);
                    tmp_queue_length = tmp_queue_length + queue_counter_obj.get('AttValue', 'QLen(Current, Last)');
                end
            end

            if ~ismember(intersection_struct.id, cell2mat(keys(obj.QueueDataMap)))
                if strcmp(input_road_direction, 'north')
                    tmp_queue_struct.north = [tmp_queue_length];
                elseif strcmp(input_road_direction, 'south')
                    tmp_queue_struct.south = [tmp_queue_length];
                elseif strcmp(input_road_direction, 'east')
                    tmp_queue_struct.east = [tmp_queue_length];
                elseif strcmp(input_road_direction, 'west')
                    tmp_queue_struct.west = [tmp_queue_length];
                end

            else
                if strcmp(input_road_direction, 'north')
                    tmp_queue_struct.north = [obj.QueueDataMap(intersection_struct.id).north, tmp_queue_length];
                elseif strcmp(input_road_direction, 'south')
                    tmp_queue_struct.south = [obj.QueueDataMap(intersection_struct.id).south, tmp_queue_length];
                elseif strcmp(input_road_direction, 'east')
                    tmp_queue_struct.east = [obj.QueueDataMap(intersection_struct.id).east, tmp_queue_length];
                elseif strcmp(input_road_direction, 'west')
                    tmp_queue_struct.west = [obj.QueueDataMap(intersection_struct.id).west, tmp_queue_length];
                end
            end
        end
        

        obj.QueueDataMap(intersection_struct.id) = tmp_queue_struct;
    end

    
end