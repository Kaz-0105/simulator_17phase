function makeRoadLanePosVehsMap(obj)
    % RoadLanePosVehsMapの初期化
    obj.RoadLanePosVehsMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'any');
    
    for road_id = cell2mat(obj.RoadLaneVehsDataMap.outerKeys())
        % RoadNumLanesMapの取得
        RoadNumLanesMap = obj.Vissim.get('RoadNumLanesMap');

        for lane_id = 1: RoadNumLanesMap(road_id)
            % RoadLaneVehsDataMapから取得
            vehs_data = obj.RoadLaneVehsDataMap.get(road_id, lane_id);

            % RoadLanePosVehsMapにプッシュ
            if ~isempty(vehs_data)
                obj.RoadLanePosVehsMap.add(road_id, lane_id, vehs_data(:,1));
            else
                obj.RoadLanePosVehsMap.add(road_id, lane_id, []);
            end
        end
    end
end