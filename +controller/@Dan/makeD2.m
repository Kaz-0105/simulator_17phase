function makeD2(obj)
    % D2行列を初期化
    obj.mld_matrices.D2 = [];

    % 道路ごとに計算
    for road_id = 1: obj.road_num
        % 各道路のD2行列を初期化
        D2 = [];

        for veh_id = 1: obj.RoadNumVehsMap(road_id)
            if veh_id == 1
                % 先頭車
                d2 = zeros(12, 1);
                d2(9:12, 1) = [-1, 1, -1, 1]';
            elseif veh_id == obj.RoadRouteFirstVehMap(road_id).right
                % 右折先頭車
                d2 = zeros(28, 3);
                d2(17:20, 1) = [-1, 1, -1, 1]';
                d2(21:24, 2) = [-1, 1, -1, 1]';
                d2(25:28, 3) = [-1, 1, -1, 1]';
            elseif veh_id == obj.RoadRouteFirstVehMap(road_id).straight
                % 直進先頭車
                d2 = zeros(28, 3);
                d2(17:20, 1) = [-1, 1, -1, 1]';
                d2(21:24, 2) = [-1, 1, -1, 1]';
                d2(25:28, 3) = [-1, 1, -1, 1]';
            else
                % それ以外の場合
                d2 = zeros(42, 5);
                d2(23:26, 1) = [-1, 1, -1, 1]';
                d2(27:30, 2) = [-1, 1, -1, 1]';
                d2(31:34, 3) = [-1, 1, -1, 1]';
                d2(35:38, 4) = [-1, 1, -1, 1]';
                d2(39:42, 5) = [-1, 1, -1, 1]';
            end

            % 道路ごとのD2行列に追加
            D2 = blkdiag(D2, d2);
        end

        % 全体のD2行列に追加
        obj.mld_matrices.D2 = blkdiag(obj.mld_matrices.D2, D2);
    end
end