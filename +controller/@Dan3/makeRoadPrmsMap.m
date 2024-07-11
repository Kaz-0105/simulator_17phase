function makeRoadPrmsMap(obj)
    % intersection構造体の取得
    IntersectionStructMap = obj.Vissim.get('IntersectionStructMap');
    intersection_struct = IntersectionStructMap(obj.id);

    % road構造体の辞書型配列を取得
    RoadStructMap = obj.Vissim.get('RoadStructMap');

    % RoadPrmsMapの初期化
    obj.RoadPrmsMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    % 各道路に対しそれぞれのパラメータを取得しMapにプッシュ
    for irid = intersection_struct.input_road_ids
        % road構造体を取得
        road_struct = RoadStructMap(irid);

        % 速度の単位変更（km/h -> m/s）
        road_struct.v = road_struct.v * 1000 / 3600;

        % 道路の順番を取得（交差点ごとに1,2,3,4にする）
        order = intersection_struct.InputRoadOrderMap(irid);

        % RoadPrmsMapに格納
        obj.RoadPrmsMap(order) = road_struct;
    end
end