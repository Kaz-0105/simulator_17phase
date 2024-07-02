function makeRoadPrmsMap(obj)
    % intersection構造体の取得
    IntersectionStructMap = obj.Maps('IntersectionStructMap');
    intersection_struct = IntersectionStructMap(obj.id);

    % road構造体の辞書型配列を取得
    RoadStructMap = obj.Maps('RoadStructMap');

    % RoadPrmsMapの初期化
    obj.RoadPrmsMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    % 東西南北の道路に対しそれぞれのパラメータを収納する
    for irid = intersection_struct.input_road_ids
        % road構造体を取得
        road_struct = RoadStructMap(irid);

        % 速度の単位変更（km/h -> m/s）
        road_struct.v = road_struct.v * 1000 / 3600;

        % 道路の順番を取得
        order = intersection_struct.InputRoadOrderMap(irid);

        % RoadPrmsMapに格納
        obj.RoadPrmsMap(order) = road_struct;
    end
end