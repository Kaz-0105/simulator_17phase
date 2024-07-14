function makeRoadLaneRouteVehsMap(obj)
    % RoadLaneRouteVehsMapの初期化
    obj.RoadLaneRouteVehsMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'any');

    for road_id = cell2mat(obj.RoadLaneVehsDataMap.outerKeys())
        % RoadNumLanesMapの取得
        RoadNumLanesMap = obj.Vissim.get('RoadNumLanesMap');

        for lane_id = 1: RoadNumLanesMap(road_id)
            % RoadLaneVehsDataMapから取得
            vehs_data = obj.RoadLaneVehsDataMap.get(road_id, lane_id);

            % RoadLaneRouteVehsMapにプッシュ
            if ~isempty(vehs_data)
                obj.RoadLaneRouteVehsMap.add(road_id, lane_id, vehs_data(:,2));
            else
                obj.RoadLaneRouteVehsMap.add(road_id, lane_id, []);
            end
        end
    end
end