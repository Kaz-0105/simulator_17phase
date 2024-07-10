function updateIntersectionRoadQueueMap(obj)
    % IntesectionStructMap, RoadLinkMap, LinkQueueCounterMapを取得
    IntersectionStructMap = obj.Vissim.get('IntersectionStructMap');
    RoadLinkMap = obj.Vissim.get('RoadLinkMap');
    LinkQueueCounterMap = obj.Vissim.get('LinkQueueCounterMap');

    % 系内の平均を出力するための変数を初期化
    sum = 0;
    count = 0;
    
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
                if isKey(LinkQueueCounterMap, link_id)
                    queue_counter_id = LinkQueueCounterMap(link_id);
                    queue_counter_obj = obj.Com.Net.QueueCounters.ItemByKey(queue_counter_id);
                    tmp_queue_length = tmp_queue_length + queue_counter_obj.get('AttValue', 'QLen(Current, Last)');
                end
            end

            % キューの長さとカウンターを加算
            sum = sum + tmp_queue_length;
            count = count + 1;

            % キューの長さをマップに格納
            obj.IntersectionRoadQueueMap.set(intersection_struct.id, order, [obj.IntersectionRoadQueueMap.get(intersection_struct.id, order), tmp_queue_length]);
        end
    end

    % 平均を計算
    average = sum / count;

    % 表示
    fprintf('Queue Length: %f\n', average);
end