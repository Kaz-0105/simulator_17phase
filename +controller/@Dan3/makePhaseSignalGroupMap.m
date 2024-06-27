function makePhaseSignalGroupMap(obj)
    % Mapを初期化
    obj.PhaseSignalGroupMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    % PhaseとSignalGroupの対応を設定
    obj.PhaseSignalGroupMap(1) = [1, 2, 5];
    obj.PhaseSignalGroupMap(2) = [3, 4, 1];
    obj.PhaseSignalGroupMap(3) = [5, 6, 3];

    obj.PhaseSignalGroupMap(4) = [1, 3, 5];
end