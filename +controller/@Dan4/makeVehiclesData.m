function makeVehiclesData(obj, IntersectionStructMap, VissimData)
    % RoadPosVehsMap、RoadRouteVehsMap、RoadFirstVehStructMapの初期化
    obj.RoadPosVehsMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    obj.RoadRouteVehsMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    obj.RoadFirstVehStructMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    % VissimDataからRoadVehsMapとRoadFirstVehMapを取得
    RoadVehsMap = VissimData.get('RoadVehsMap');
    RoadFirstVehMap = VissimData.get('RoadFirstVehMap');

    % intersection構造体を取得
    intersection_struct = IntersectionStructMap(obj.id);

    % 流入道路ごとに情報を取得
    for irid = intersection_struct.input_road_ids
        % RoadVehsMapから注目している道路の自動車情報を取得
        vehs_data = RoadVehsMap(irid);

        % 道路の順番を取得
        order = intersection_struct.InputRoadOrderMap(irid);

        % 自動車が存在するかどうかで場合分け
        if ~isempty(vehs_data)
            % 自動車の位置
            obj.RoadPosVehsMap(order) = vehs_data(:, 1);
            
            % 自動車の進路
            obj.RoadRouteVehsMap(order) = vehs_data(:, 2);

        else
            % 自動車の位置
            obj.RoadPosVehsMap(order) = [];

            % 自動車の進路
            obj.RoadRouteVehsMap(order) = [];
        end

        % 道路ごとの先頭車に関する情報を取得
        obj.RoadFirstVehStructMap(order) = RoadFirstVehMap(irid);

        % num_vehsを計算
        obj.RoadNumVehsMap(order) = length(obj.RoadPosVehsMap(order));
    end
end