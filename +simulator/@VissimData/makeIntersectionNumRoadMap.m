function makeIntersectionNumRoadMap(obj)
    % IntersectionStructMapを初期化
    obj.IntersectionNumRoadMap = containers.Map('KeyType','int32','ValueType','int32');
    % IntersectionStructMapを取得
    IntersectionStructMap = obj.Vissim.get('IntersectionStructMap');

    % IntersectionNumRoadMapを作成
    for intersection_id = cell2mat(keys(IntersectionStructMap))
        intersection_struct = IntersectionStructMap(intersection_id);
        obj.IntersectionNumRoadMap(intersection_id) = length(intersection_struct.input_road_ids);
    end
end