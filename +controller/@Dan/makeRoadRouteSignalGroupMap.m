function makeRoadRouteSignalGroupMap(obj)
    % RoadRouteSignalGroupMapの初期化
    obj.RoadRouteSignalGroupMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'int32');

    % IntersectionStructMapの取得
    IntersectionStructMap = obj.Vissim.get('IntersectionStructMap');

    % intersection構造体を取得
    intersection = IntersectionStructMap(obj.id);

    % VissimクラスのRoadRouteSignalGroupMapを取得
    RoadRouteSignalGroupMap = obj.Vissim.get('RoadRouteSignalGroupMap');

    for road_id = intersection.input_road_ids
        % 道路の順番を示すIDを取得
        order_id = intersection.InputRoadOrderMap(road_id);

        % RouteSignalGroupMapの取得
        RouteSignalGroupMap = RoadRouteSignalGroupMap.getInnerMap(road_id);

        for route_id = cell2mat(RouteSignalGroupMap.keys)
            % SignalGroupのIDを取得
            signal_group_id = RouteSignalGroupMap(route_id);

            % RoadRouteSignalGroupMapにプッシュ
            obj.RoadRouteSignalGroupMap.add(order_id, route_id, signal_group_id);
        end
    end
end