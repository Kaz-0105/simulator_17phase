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
                    d2 = zeros(10, 1);
                    d2(7:10, 1) = [-1, 1, -1, 1]';

                elseif veh_id == LaneFirstVehsMap(1) || veh_id == LaneFirstVehsMap(2) || veh_id == LaneFirstVehsMap(3)
                    % 分岐車線（左），メインの車線，分岐車線（右）の先頭車
                    d2 = zeros(24, 3);
                    d2(13:16, 1) = [-1, 1, -1, 1]';
                    d2(17:20, 2) = [-1, 1, -1, 1]';
                    d2(21:24, 3) = [-1, 1, -1, 1]';

                else
                    % それ以外の場合
                    d2 = zeros(47, 5);
                    d2(28:31, 1) = [-1, 1, -1, 1]';
                    d2(32:35, 2) = [-1, 1, -1, 1]';
                    d2(36:39, 3) = [-1, 1, -1, 1]';
                    d2(40:43, 4) = [-1, 1, -1, 1]';
                    d2(44:47, 5) = [-1, 1, -1, 1]';

                end

                % D2に追加
                D2 = blkdiag(D2, d2);

            end

            % D2行列に追加
            obj.mld_matrices.D2 = blkdiag(obj.mld_matrices.D2, D2);
        end
    end
end