function makeRoadIntersectionMap(obj, Maps)
    % RoadIntersectionMapを初期化
    obj.RoadIntersectionMap = containers.Map('KeyType','int32','ValueType','int32');
    
    % IntersectionStructMapを取得
    IntersectionStructMap = Maps('IntersectionStructMap');

    for intersection_id = cell2mat(keys(IntersectionStructMap))
        intersection_struct = IntersectionStructMap(intersection_id);
        for irid = intersection_struct.input_road_ids
            obj.RoadIntersectionMap(irid) = intersection_id;
        end
    end
end