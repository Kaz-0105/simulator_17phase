function updateQueueData(obj, Maps)
    % IntesectionStructMapを取得
    IntersectionStructMap = Maps('IntersectionStructMap');

    % RoadLinkMapを取得
    RoadLinkMap = Maps('RoadLinkMap');

    % LinkQueueMapを取得
    LinkQueueMap = Maps('LinkQueueMap');
    
    for intersection_id = cell2mat(keys(IntersectionStructMap))
        % intersection構造体の取得
        intersection_struct = IntersectionStructMap(intersection_id);

        for road_id = intersection_struct.input_road_ids
            % 道路の順番を取得（時計回りで設定するのがルール）
            order = intersection_struct.InputRoadOrderMap(road_id);

            % キューの長さを計算
            tmp_queue_length = 0;
            link_ids = RoadLinkMap(road_id);
            for link_id = link_ids
                if isKey(LinkQueueMap, link_id)
                    queue_counter_id = LinkQueueMap(link_id);
                    queue_counter_obj = obj.Com.Net.QueueCounters.ItemByKey(queue_counter_id);
                    tmp_queue_length = tmp_queue_length + queue_counter_obj.get('AttValue', 'QLen(Current, Last)');
                end
            end

            % キューの長さをマップに格納
            if ~obj.QueueDataMap.isKey(intersection_struct.id, order)
                obj.QueueDataMap.add(intersection_struct.id, order, tmp_queue_length);
            else
                obj.QueueDataMap.set(intersection_struct.id, order, [obj.QueueDataMap.get(intersection_struct.id, order), tmp_queue_length]);
            end
        end
    end
end