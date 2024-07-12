function makeVehiclesData(obj, IntersectionStructMap, VissimData)
    % RoadPosVehsMap、RoadRouteVehsMap、RoadRouteFirstVehMapの初期化
    obj.RoadPosVehsMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    obj.RoadRouteVehsMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    obj.RoadRouteFirstVehMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'int32');

    % VissimData から RoadPosVehsMap と RoadRouteVehsMap と RoadRouteFirstVehMap を取得
    RoadPosVehsMap = VissimData.get('RoadPosVehsMap');
    RoadRouteVehsMap = VissimData.get('RoadRouteVehsMap');
    RoadRouteFirstVehMap = VissimData.get('RoadRouteFirstVehMap');

    % intersection構造体を取得
    intersection_struct = IntersectionStructMap(obj.id);

    % 流入道路ごとに情報を取得（全体の道路IDから交差点ごとの道路IDに変換したMapを作成）
    for irid = intersection_struct.input_road_ids
        % 道路の順番を取得
        order = intersection_struct.InputRoadOrderMap(irid);

        % 道路ごとの自動車の位置を取得
        obj.RoadPosVehsMap(order) = RoadPosVehsMap(irid);

        % 道路ごとの自動車の進路を取得
        obj.RoadRouteVehsMap(order) = RoadRouteVehsMap(irid);

        % 道路ごとの先頭車に関する情報を取得
        RouteFirstVehMap = RoadRouteFirstVehMap.getInnerMap(irid);

        for route_id = cell2mat(keys(RouteFirstVehMap))
            obj.RoadRouteFirstVehMap.add(order, route_id, RouteFirstVehMap(route_id));
        end

        % num_vehsを計算
        obj.RoadNumVehsMap(order) = length(obj.RoadPosVehsMap(order));
    end
end