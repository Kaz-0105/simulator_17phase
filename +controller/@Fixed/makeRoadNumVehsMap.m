function makeRoadNumVehsMap(obj)
    % VissimDataクラスを取得
    VissimData = obj.Vissim.get('VissimData');

    % RoadNumVehsMap（道路IDが順序IDではない）を取得
    tmp_RoadNumVehsMap = VissimData.get('RoadNumVehsMap');
    
    % IntersectionStructMapを取得
    IntersectionStructMap = obj.Vissim.get('IntersectionStructMap');

    % intersection構造体を取得
    intersection_struct = IntersectionStructMap(obj.id);

    % InputRoadOrderMapを取得
    InputRoadOrderMap = intersection_struct.InputRoadOrderMap;

    % RoadNumVehsMapを作成
    obj.RoadNumVehsMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

    % キーを順序IDに変更するための繰り返し処理
    for road_id = cell2mat(keys(InputRoadOrderMap))
        order_id = InputRoadOrderMap(road_id);
        obj.RoadNumVehsMap(order_id) = tmp_RoadNumVehsMap(road_id);
    end
end