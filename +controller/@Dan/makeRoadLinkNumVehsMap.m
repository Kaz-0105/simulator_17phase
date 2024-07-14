function makeRoadLinkNumVehsMap(obj)
    % RoadLinkNumVehsMapとRoadNumVehsMapを初期化
    obj.RoadLinkNumVehsMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'int32');
    obj.RoadNumVehsMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

    for road_id = cell2mat(obj.RoadLinkPosVehsMap.outerKeys())
        % LinkPosVehsMapを取得
        LinkPosVehsMap = obj.RoadLinkPosVehsMap.getInnerMap(road_id);

        for link_id = cell2mat(LinkPosVehsMap.keys)
            % 車両数を取得
            num_vehs = length(LinkPosVehsMap(link_id));

            % RoadLinkNumVehsMapに追加
            obj.RoadLinkNumVehsMap.add(road_id, link_id, num_vehs);

            % RoadNumVehsMapに追加
            if obj.RoadNumVehsMap.isKey(road_id)
                obj.RoadNumVehsMap(road_id) = obj.RoadNumVehsMap(road_id) + num_vehs;
            else
                obj.RoadNumVehsMap(road_id) = num_vehs;
            end
        end
    end
end