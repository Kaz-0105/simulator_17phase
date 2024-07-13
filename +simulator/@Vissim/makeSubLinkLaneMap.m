function makeSubLinkLaneMap(obj)
    % SubLinkLaneMapを初期化
    obj.SubLinkLaneMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

    for road_id = cell2mat(obj.InputRoadLaneStructMap.outerKeys())
        % LaneStructMapを取得
        LaneStructMap = obj.InputRoadLaneStructMap.getInnerMap(road_id);

        for lane_id = cell2mat(LaneStructMap.keys())
            % LaneStructを取得
            lane_struct = LaneStructMap(lane_id);

            % SubLinkLaneMapにプッシュ
            obj.SubLinkLaneMap(lane_struct.link_id) = lane_id;
        end
    end
end