function updateIntersectionRoadQueueMap(obj)
    % IntesectionStructMap, RoadLinkMap, LinkQueueMapを取得
    IntersectionStructMap = obj.Vissim.get('IntersectionStructMap');
    RoadLinkMap = obj.Vissim.get('RoadLinkMap');
    LinkQueueMap = obj.Vissim.get('LinkQueueMap');
    
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
            obj.IntersectionRoadQueueMap.set(intersection_struct.id, order, [obj.IntersectionRoadQueueMap.get(intersection_struct.id, order), tmp_queue_length]);
        end
    end
end