function makeD2(obj)
    % D2行列を初期化
    obj.mld_matrices.D2 = [];

    % 道路ごとに計算
    for road_id = 1: obj.road_num
        % 各リンクごとに計算
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % 各リンクのD2行列を初期化
            D2 = [];

            % LaneFirstVehsMapを取得
            LaneFirstVehsMap = obj.RoadLinkLaneFirstVehsMap.get(road_id, link_id);

            % 自動車ごとに計算
            for veh_id = 1: obj.RoadLinkNumVehsMap.get(road_id, link_id)
                if veh_id == 1
                    % 先頭車
                    d2 = zeros(12, 1);
                    d2(9:12, 1) = [-1, 1, -1, 1]';

                elseif veh_id == LaneFirstVehsMap(1)
                    % 分岐車線（左）の先頭車
                    d2 = zeros(28, 3);
                    d2(17:20, 1) = [-1, 1, -1, 1]';
                    d2(21:24, 2) = [-1, 1, -1, 1]';
                    d2(25:28, 3) = [-1, 1, -1, 1]';

                elseif veh_id == LaneFirstVehsMap(2)
                    % メインの車線の先頭車
                    d2 = zeros(28, 3);
                    d2(17:20, 1) = [-1, 1, -1, 1]';
                    d2(21:24, 2) = [-1, 1, -1, 1]';
                    d2(25:28, 3) = [-1, 1, -1, 1]';

                elseif veh_id == LaneFirstVehsMap(3)
                    % 分岐車線（右）の先頭車
                    d2 = zeros(28, 3);
                    d2(17:20, 1) = [-1, 1, -1, 1]';
                    d2(21:24, 2) = [-1, 1, -1, 1]';
                    d2(25:28, 3) = [-1, 1, -1, 1]';

                else
                    % それ以外の場合
                    d2 = zeros(45, 5);
                    d2(26:29, 1) = [-1, 1, -1, 1]';
                    d2(30:33, 2) = [-1, 1, -1, 1]';
                    d2(34:37, 3) = [-1, 1, -1, 1]';
                    d2(38:41, 4) = [-1, 1, -1, 1]';
                    d2(42:45, 5) = [-1, 1, -1, 1]';

                end

                % D2に追加
                D2 = blkdiag(D2, d2);

            end

            % D2行列に追加
            obj.mld_matrices.D2 = blkdiag(obj.mld_matrices.D2, D2);
        end
    end
end