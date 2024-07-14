function makeRoadLaneFirstVehMap(obj)
    % RoadLaneFirstVehMapの初期化
    obj.RoadLaneFirstVehMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'int32');

    for road_id = cell2mat(obj.RoadLaneVehsDataMap.outerKeys())
end