function makePhaseSignalGroupMap(obj)
    % Mapを初期化
    obj.PhaseSignalGroupMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    % PhaseとSignalGroupの対応を設定
    obj.PhaseSignalGroupMap(1) = [1, 2, 7, 8];
    obj.PhaseSignalGroupMap(2) = [3, 4, 9, 10];
    obj.PhaseSignalGroupMap(3) = [4, 5, 10, 11];
    obj.PhaseSignalGroupMap(4) = [1, 6, 7, 12];
    obj.PhaseSignalGroupMap(5) = [1, 2, 3, 10];
    obj.PhaseSignalGroupMap(6) = [4, 5, 6, 1];
    obj.PhaseSignalGroupMap(7) = [7, 8, 9, 4];
    obj.PhaseSignalGroupMap(8) = [10, 11, 12, 7];
    obj.PhaseSignalGroupMap(9) = [1, 3, 4, 10];
    obj.PhaseSignalGroupMap(10) = [4, 6, 7, 1];
    obj.PhaseSignalGroupMap(11) = [7, 9, 10, 4];
    obj.PhaseSignalGroupMap(12) = [10, 12, 1, 7];
    obj.PhaseSignalGroupMap(13) = [1, 2, 7, 10];
    obj.PhaseSignalGroupMap(14) = [4, 5, 10, 1];
    obj.PhaseSignalGroupMap(15) = [7, 8, 1, 4];
    obj.PhaseSignalGroupMap(16) = [10, 11, 4, 7];
    obj.PhaseSignalGroupMap(17) = [1, 4, 7, 10];
end
            