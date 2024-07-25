function makePhaseSignalGroupMap(obj)
    % Mapを初期化
    obj.PhaseSignalGroupMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    % 道路の数ごとに作成
    if obj.road_num == 4
        % Symmetric型
        obj.PhaseSignalGroupMap(1) = [1, 2, 7, 8];
        obj.PhaseSignalGroupMap(2) = [3, 4, 9, 10];
        obj.PhaseSignalGroupMap(3) = [4, 5, 10, 11];
        obj.PhaseSignalGroupMap(4) = [1, 6, 7, 12];

        % Standard型
        obj.PhaseSignalGroupMap(5) = [1, 2, 3, 10];
        obj.PhaseSignalGroupMap(6) = [4, 5, 6, 1];
        obj.PhaseSignalGroupMap(7) = [7, 8, 9, 4];
        obj.PhaseSignalGroupMap(8) = [10, 11, 12, 7];

        % 特殊型（１）
        obj.PhaseSignalGroupMap(9) = [1, 3, 4, 10];
        obj.PhaseSignalGroupMap(10) = [4, 6, 7, 1];
        obj.PhaseSignalGroupMap(11) = [7, 9, 10, 4];
        obj.PhaseSignalGroupMap(12) = [10, 12, 1, 7];

        % 特殊型（２）
        obj.PhaseSignalGroupMap(13) = [1, 2, 7, 10];
        obj.PhaseSignalGroupMap(14) = [4, 5, 10, 1];
        obj.PhaseSignalGroupMap(15) = [7, 8, 1, 4];
        obj.PhaseSignalGroupMap(16) = [10, 11, 4, 7];

        % 全左折型
        obj.PhaseSignalGroupMap(17) = [1, 4, 7, 10];
    elseif obj.road_num == 3
        % 各方向全出し型
        obj.PhaseSignalGroupMap(1) = [1, 2, 5];
        obj.PhaseSignalGroupMap(2) = [3, 4, 1];
        obj.PhaseSignalGroupMap(3) = [5, 6, 3];

        % 全左折型
        obj.PhaseSignalGroupMap(4) = [1, 3, 5];

    elseif obj.road_num == 5
        % 各方向全出し型
        obj.PhaseSignalGroupMap(1) = [1, 2, 3, 4, 17];
        obj.PhaseSignalGroupMap(2) = [5, 6, 7, 8, 1];
        obj.PhaseSignalGroupMap(3) = [9, 10, 11, 12, 5];
        obj.PhaseSignalGroupMap(4) = [13, 14, 15, 16, 9];
        obj.PhaseSignalGroupMap(5) = [17, 18, 19, 20, 13];

        % 3-2型
        obj.PhaseSignalGroupMap(6) = [1, 2, 3, 13, 14];
        obj.PhaseSignalGroupMap(7) = [5, 6, 7, 17, 18];
        obj.PhaseSignalGroupMap(8) = [9, 10, 11, 1, 2];
        obj.PhaseSignalGroupMap(9) = [13, 14, 15, 5, 6];
        obj.PhaseSignalGroupMap(10) = [17, 18, 19, 9, 10];

        % 3-1-1型
        obj.PhaseSignalGroupMap(11) = [1, 2, 3, 13, 17];
        obj.PhaseSignalGroupMap(12) = [5, 6, 7, 17, 1];
        obj.PhaseSignalGroupMap(13) = [9, 10, 11, 1, 5];
        obj.PhaseSignalGroupMap(14) = [13, 14, 15, 5, 9];
        obj.PhaseSignalGroupMap(15) = [17, 18, 19, 9, 13];

        % 3-1-1型（２）
        obj.PhaseSignalGroupMap(16) = [1, 2, 4, 9, 17];
        obj.PhaseSignalGroupMap(17) = [5, 6, 8, 13, 1];
        obj.PhaseSignalGroupMap(18) = [9, 10, 12, 17, 5];
        obj.PhaseSignalGroupMap(19) = [13, 14, 16, 1, 9];
        obj.PhaseSignalGroupMap(20) = [17, 18, 20, 5, 13];

        % 3-1-1型（３）
        obj.PhaseSignalGroupMap(21) = [1, 3, 4, 5, 17];
        obj.PhaseSignalGroupMap(22) = [5, 7, 8, 9, 1];
        obj.PhaseSignalGroupMap(23) = [9, 11, 12, 13, 5];
        obj.PhaseSignalGroupMap(24) = [13, 15, 16, 17, 9];
        obj.PhaseSignalGroupMap(25) = [17, 19, 20, 1, 13];

        % 2-2-1型
        obj.PhaseSignalGroupMap(26) = [1, 2, 9, 10, 17];
        obj.PhaseSignalGroupMap(27) = [5, 6, 13, 14, 1];
        obj.PhaseSignalGroupMap(28) = [9, 10, 17, 18, 5];
        obj.PhaseSignalGroupMap(29) = [13, 14, 1, 2, 9];
        obj.PhaseSignalGroupMap(30) = [17, 18, 5, 6, 13];

        % 2-2-1型（２）
        obj.PhaseSignalGroupMap(31) = [1, 2, 9, 11, 13];
        obj.PhaseSignalGroupMap(32) = [5, 6, 13, 15, 17];
        obj.PhaseSignalGroupMap(33) = [9, 10, 17, 19, 1];
        obj.PhaseSignalGroupMap(34) = [13, 14, 1, 3, 5];
        obj.PhaseSignalGroupMap(35) = [17, 18, 5, 7, 9];

        % 2-2-1型（３）
        obj.PhaseSignalGroupMap(36) = [1, 2, 13, 17, 20];
        obj.PhaseSignalGroupMap(37) = [5, 6, 17, 1, 4];
        obj.PhaseSignalGroupMap(38) = [9, 10, 1, 5, 8];
        obj.PhaseSignalGroupMap(39) = [13, 14, 5, 9, 12];
        obj.PhaseSignalGroupMap(40) = [17, 18, 9, 13, 16];

        % 2-1-1-1型
        obj.PhaseSignalGroupMap(41) = [1, 2, 11, 13, 20];
        obj.PhaseSignalGroupMap(42) = [5, 6, 15, 17, 4];
        obj.PhaseSignalGroupMap(43) = [9, 10, 19, 1, 8];
        obj.PhaseSignalGroupMap(44) = [13, 14, 3, 5, 12];
        obj.PhaseSignalGroupMap(45) = [17, 18, 7, 9, 16];

        % 2-1-1-1型（２）
        obj.PhaseSignalGroupMap(46) = [1, 2, 9, 13, 17];
        obj.PhaseSignalGroupMap(47) = [5, 6, 13, 17, 1];
        obj.PhaseSignalGroupMap(48) = [9, 10, 17, 1, 5];
        obj.PhaseSignalGroupMap(49) = [13, 14, 1, 5, 9];
        obj.PhaseSignalGroupMap(50) = [17, 18, 5, 9, 13];
        
        % 2-1-1-1型（３）
        obj.PhaseSignalGroupMap(51) = [1, 3, 5, 13, 17];
        obj.PhaseSignalGroupMap(52) = [5, 7, 9, 17, 1];
        obj.PhaseSignalGroupMap(53) = [9, 11, 13, 1, 5];
        obj.PhaseSignalGroupMap(54) = [13, 15, 17, 5, 9];
        obj.PhaseSignalGroupMap(55) = [17, 19, 1, 9, 13];

        % 2-1-1-1型（４）
        obj.PhaseSignalGroupMap(56) = [1, 4, 9, 16, 17];
        obj.PhaseSignalGroupMap(57) = [5, 8, 13, 20, 1];
        obj.PhaseSignalGroupMap(58) = [9, 12, 17, 4, 5];
        obj.PhaseSignalGroupMap(59) = [13, 16, 1, 8, 9];
        obj.PhaseSignalGroupMap(60) = [17, 20, 5, 12, 13];

        % 2-1-1-1型（５）
        obj.PhaseSignalGroupMap(61) = [1, 4, 5, 9, 17];
        obj.PhaseSignalGroupMap(62) = [5, 8, 9, 13, 1];
        obj.PhaseSignalGroupMap(63) = [9, 12, 13, 17, 5];
        obj.PhaseSignalGroupMap(64) = [13, 16, 17, 1, 9];
        obj.PhaseSignalGroupMap(65) = [17, 20, 1, 5, 13];

        % 2-1-1-1型（６）
        obj.PhaseSignalGroupMap(66) = [3, 4, 5, 12, 17];
        obj.PhaseSignalGroupMap(67) = [7, 8, 9, 16, 1];
        obj.PhaseSignalGroupMap(68) = [11, 12, 13, 20, 5];
        obj.PhaseSignalGroupMap(69) = [15, 16, 17, 4, 9];
        obj.PhaseSignalGroupMap(70) = [19, 20, 1, 8, 13];

        % 1-1-1-1-1型
        obj.PhaseSignalGroupMap(71) = [3, 5, 12, 13, 17];
        obj.PhaseSignalGroupMap(72) = [7, 9, 16, 17, 1];
        obj.PhaseSignalGroupMap(73) = [11, 13, 20, 1, 5];
        obj.PhaseSignalGroupMap(74) = [15, 17, 4, 5, 9];
        obj.PhaseSignalGroupMap(75) = [19, 1, 8, 9, 13];

        % 1-1-1-1-1型（２）
        obj.PhaseSignalGroupMap(76) = [1, 5, 9, 13, 17];



    end
end
            