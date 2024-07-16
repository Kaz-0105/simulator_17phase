function makeRoadLinkLaneFirstVehsMap(obj)
    % RoadLinkLaneFirstVehsMapを初期化
    obj.RoadLinkLaneFirstVehsMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'any');

    for road_id = cell2mat(obj.RoadLinkLaneVehsMap.outerKeys())
        % LinkLaneVehsMapを取得
        LinkLaneVehsMap = obj.RoadLinkLaneVehsMap.getInnerMap(road_id);

        for link_id = cell2mat(LinkLaneVehsMap.keys)
            % キー：車線のID、値：先頭車のIDのマップを初期化
            LaneFirstVehsMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

            % 初期化（１車線道路のときで分岐が２つあるときが最大なので3まで用意）
            for lane_id = 1:3
                LaneFirstVehsMap(lane_id) = 0;
            end

            % 自動車の車線情報を取得
            lane_vehs = LinkLaneVehsMap(link_id);

            % 先頭車が見つかったことを示すフラグを初期化
            found_flag = [false, false, false];

            for veh_id = 1: length(lane_vehs)
                % 車線のIDを取得
                lane_id = lane_vehs(veh_id);

                if ~found_flag(lane_id)
                    % LaneFirstVehsMapにveh_idをプッシュ
                    LaneFirstVehsMap(lane_id) = veh_id;

                    % フラグをtrueに変更
                    found_flag(lane_id) = true;
                end
            end

            % RoadLinkLaneFirstVehsMapにLaneFirstVehsMapをプッシュ
            obj.RoadLinkLaneFirstVehsMap.add(road_id, link_id, LaneFirstVehsMap);
        end
    end
end