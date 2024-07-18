function makeD3(obj)
    % D3行列を初期化
    obj.mld_matrices.D3 = [];

    % 道路ごとに計算
    for road_id = 1: obj.road_num
        % 道路パラメータの構造体を取得
        road_prms = obj.RoadPrmsMap(road_id);

        % 各パラメータを取得
        D_s = road_prms.D_s; % 信号の影響圏に入る距離
        d_s = road_prms.d_s; % 信号と信号の停止線の間の距離
        D_f = road_prms.D_f; % 先行車の影響圏に入る距離
        D_b = road_prms.D_b; % 車線の分岐点と信号の間の距離
        p_s = road_prms.p_s; % 信号の位置
        v = road_prms.v; % 速度[m/s]

        % 各リンクごとに計算
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % 各リンクのD3行列を初期化
            D3 = [];

            % LaneFirstVehsMapの取得
            LaneFirstVehsMap = obj.RoadLinkLaneFirstVehsMap.get(road_id, link_id);

            % pos_vehsを取得
            pos_vehs = obj.RoadLinkPosVehsMap.get(road_id, link_id);

            % pos_vehsが空の場合はスキップ（pos_vehs(end)がエラー吐くため）
            if isempty(pos_vehs)
                continue;
            end

            % 自動車の位置を評価
            p_min = pos_vehs(end);
            p_max = pos_vehs(1) + v*obj.dt*obj.N_p;

            % hの評価
            h1_min = p_s-p_max-D_s;
            h1_max = p_s-p_min-D_s;
            h2_min = p_min-p_s+d_s;
            h2_max = p_max-p_s+d_s;
            h3_min = D_f-p_max+p_min;
            h3_max = D_f-p_min+p_max;
            h4_min = D_f-p_max+p_min;
            h4_max = D_f-p_min+p_max;
            h5_min = p_s-p_max-D_b;
            h5_max = p_s-p_min-D_b;

            % VehicleDelta4ConstraintMapの初期化
            VehicleDelta4ConstraintMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

            % constraints_counterの初期化
            constraints_counter = 0;

            % 自動車ごとに計算
            for veh_id = 1: obj.RoadLinkNumVehsMap.get(road_id, link_id)
                if veh_id == 1
                    % 先頭車
                    % d3を初期化
                    d3 = zeros(12, 4);

                    % 非０要素を代入
                    d3(1, [1, 2, 3]) = [-1, -1, -1];
                    d3(2, [1, 2, 3]) = [0, 0, 1];
                    d3(3, [1, 2, 3]) = [1, 0, 1];
                    d3(4, [1, 2, 3]) = [0, 1, 1];

                    d3(5, 1) = -h1_min;
                    d3(6, 1) = -h1_max-obj.eps;

                    d3(7, 2) = -h2_min;
                    d3(8, 2) = -h2_max-obj.eps;

                    d3(9, 3) = p_min;
                    d3(10, 3) = -p_max;
                    d3(11, 3) = p_max;
                    d3(12, 3) = -p_min;

                    % constraints_counterを更新
                    constraints_counter = constraints_counter + 12;

                elseif veh_id == LaneFirstVehsMap(1)
                    % 分岐車線（左）の先頭車
                    % d3を初期化
                    d3 = zeros(28, 7);

                    % 非０要素を代入
                    d3(1, [1, 2, 5]) = [-1, -1, -1];
                    d3(2, [1, 2, 5]) = [0, 0, 1];
                    d3(3, [1, 2, 5]) = [1, 0, 1];
                    d3(4, [1, 2, 5]) = [0, 1, 1];

                    d3(5, [3, 4, 5, 6]) = [1, 1, -1, -1];
                    d3(6, [3, 4, 5, 6]) = [0, 0, 1, 1];
                    d3(7, [3, 4, 5, 6]) = [-1, 0, 0, 1];
                    d3(8, [3, 4, 5, 6]) = [0, -1, 0, 1];

                    d3(9, 1) = -h1_min;
                    d3(10, 1) = -h1_max-obj.eps;

                    d3(11, 2) = -h2_min;
                    d3(12, 2) = -h2_max-obj.eps;

                    d3(13, 3) = -h3_min;
                    d3(14, 3) = -h3_max-obj.eps;

                    d3(15, 4) = -h5_min;
                    d3(16, 4) = -h5_max-obj.eps;

                    d3(17, 5) = p_min;
                    d3(18, 5) = -p_max;
                    d3(19, 5) = p_max;
                    d3(20, 5) = -p_min;

                    d3(21, 6) = p_min;
                    d3(22, 6) = -p_max;
                    d3(23, 6) = p_max;
                    d3(24, 6) = -p_min;

                    d3(25, 6) = p_min;
                    d3(26, 6) = -p_max;
                    d3(27, 6) = p_max;
                    d3(28, 6) = -p_min;

                    % variables_counterを更新
                    constraints_counter = constraints_counter + 28;

                elseif veh_id == LaneFirstVehsMap(2)
                    % メインの車線の先頭車
                    % d3を初期化
                    d3 = zeros(28, 7);

                    % 非０要素を代入
                    d3(1, [1, 2, 5]) = [-1, -1, -1];
                    d3(2, [1, 2, 5]) = [0, 0, 1];
                    d3(3, [1, 2, 5]) = [1, 0, 1];
                    d3(4, [1, 2, 5]) = [0, 1, 1];

                    d3(5, [3, 4, 5, 6]) = [1, 1, -1, -1];
                    d3(6, [3, 4, 5, 6]) = [0, 0, 1, 1];
                    d3(7, [3, 4, 5, 6]) = [-1, 0, 0, 1];
                    d3(8, [3, 4, 5, 6]) = [0, -1, 0, 1];

                    d3(9, 1) = -h1_min;
                    d3(10, 1) = -h1_max-obj.eps;

                    d3(11, 2) = -h2_min;
                    d3(12, 2) = -h2_max-obj.eps;

                    d3(13, 3) = -h3_min;
                    d3(14, 3) = -h3_max-obj.eps;

                    d3(15, 4) = -h5_min;
                    d3(16, 4) = -h5_max-obj.eps;

                    d3(17, 5) = p_min;
                    d3(18, 5) = -p_max;
                    d3(19, 5) = p_max;
                    d3(20, 5) = -p_min;

                    d3(21, 6) = p_min;
                    d3(22, 6) = -p_max;
                    d3(23, 6) = p_max;
                    d3(24, 6) = -p_min;

                    d3(25, 6) = p_min;
                    d3(26, 6) = -p_max;
                    d3(27, 6) = p_max;
                    d3(28, 6) = -p_min;

                    % variables_counterを更新
                    constraints_counter = constraints_counter + 28;

                elseif veh_id == LaneFirstVehsMap(3)
                    % 分岐車線（右）の先頭車
                    % d3を初期化
                    d3 = zeros(28, 7);

                    % 非０要素を代入
                    d3(1, [1, 2, 5]) = [-1, -1, -1];
                    d3(2, [1, 2, 5]) = [0, 0, 1];
                    d3(3, [1, 2, 5]) = [1, 0, 1];
                    d3(4, [1, 2, 5]) = [0, 1, 1];

                    d3(5, [3, 4, 5, 6]) = [1, 1, -1, -1];
                    d3(6, [3, 4, 5, 6]) = [0, 0, 1, 1];
                    d3(7, [3, 4, 5, 6]) = [-1, 0, 0, 1];
                    d3(8, [3, 4, 5, 6]) = [0, -1, 0, 1];

                    d3(9, 1) = -h1_min;
                    d3(10, 1) = -h1_max-obj.eps;

                    d3(11, 2) = -h2_min;
                    d3(12, 2) = -h2_max-obj.eps;

                    d3(13, 3) = -h3_min;
                    d3(14, 3) = -h3_max-obj.eps;

                    d3(15, 4) = -h5_min;
                    d3(16, 4) = -h5_max-obj.eps;

                    d3(17, 5) = p_min;
                    d3(18, 5) = -p_max;
                    d3(19, 5) = p_max;
                    d3(20, 5) = -p_min;

                    d3(21, 6) = p_min;
                    d3(22, 6) = -p_max;
                    d3(23, 6) = p_max;
                    d3(24, 6) = -p_min;

                    d3(25, 6) = p_min;
                    d3(26, 6) = -p_max;
                    d3(27, 6) = p_max;
                    d3(28, 6) = -p_min;

                    % variables_counterを更新
                    constraints_counter = constraints_counter + 28;

                else
                    % それ以外の場合
                    % d3を初期化
                    d3 = zeros(47, 10);

                    % 非０要素を代入
                    d3(1, [1, 2, 6]) = [-1, -1, -1];
                    d3(2, [1, 2, 6]) = [0, 0, 1];
                    d3(3, [1, 2, 6]) = [1, 0, 1];
                    d3(4, [1, 2, 6]) = [0, 1, 1];

                    d3(5, [3, 5, 6, 7]) = [1, 1, -1, -1];
                    d3(6, [3, 5, 6, 7]) = [0, 0, 1, 1];
                    d3(7, [3, 5, 6, 7]) = [-1, 0, 0, 1];
                    d3(8, [3, 5, 6, 7]) = [0, -1, 0, 1];

                    d3(9, [4, 5, 6, 8]) = [1, -1, -1, -1];
                    d3(10, [4, 5, 6, 8]) = [0, 0, 1, 1];
                    d3(11, [4, 5, 6, 8]) = [0, 1, 0, 1];
                    d3(12, [4, 5, 6, 8]) = [-1, 0, 0, 1];

                    d3(13, [1, 2, 6, 9]) = [0, 0, 0, 1];
                    d3(14, [1, 2, 6, 9]) = [0, 0, 1, 1];
                    d3(15, [1, 2, 6, 9]) = [1, 0, 0, 1];
                    d3(16, [1, 2, 6, 9]) = [0, 1, 0, 1];
                    d3(17, [1, 2, 6, 9]) = [-1, -1, -1, -1];

                    d3(18, 1) = -h1_min;
                    d3(19, 1) = -h1_max-obj.eps;

                    d3(20, 2) = -h2_min;
                    d3(21, 2) = -h2_max-obj.eps;

                    d3(22, 3) = -h3_min;
                    d3(23, 3) = -h3_max-obj.eps;

                    d3(24, 4) = -h4_min;
                    d3(25, 4) = -h4_max-obj.eps;

                    d3(26, 5) = -h5_min;
                    d3(27, 5) = -h5_max-obj.eps;

                    d3(28, 6) = p_min;
                    d3(29, 6) = -p_max;
                    d3(30, 6) = p_max;
                    d3(31, 6) = -p_min;

                    d3(32, 7) = p_min;
                    d3(33, 7) = -p_max;
                    d3(34, 7) = p_max;
                    d3(35, 7) = -p_min;

                    d3(36, 7) = p_min;
                    d3(37, 7) = -p_max;
                    d3(38, 7) = p_max;
                    d3(39, 7) = -p_min;

                    d3(40, 8) = p_min;
                    d3(41, 8) = -p_max;
                    d3(42, 8) = p_max;
                    d3(43, 8) = -p_min;

                    d3(44, 8) = p_min;
                    d3(45, 8) = -p_max;
                    d3(46, 8) = p_max;
                    d3(47, 8) = -p_min;

                    % VehicleDelta4ConstraintMapに追加
                    VehicleDelta4ConstraintMap(veh_id) = constraints_counter + 13;

                    % variables_counterを更新
                    constraints_counter = constraints_counter + 47;
                end

                % 道路ごとのD3行列に追加
                D3 = blkdiag(D3, d3);
            end

            % δ1の変数のリストを取得
            delta1_list = obj.RoadLinkDelta1ListMap.get(road_id, link_id);

            % 先頭車でない場合δ4の制約を追加
            for veh_id = 1: obj.RoadLinkNumVehsMap.get(road_id, link_id)
                if veh_id == 1
                    continue;

                elseif veh_id == LaneFirstVehsMap(1)
                    continue;

                elseif veh_id == LaneFirstVehsMap(2)
                    continue;

                elseif veh_id == LaneFirstVehsMap(3)
                    continue;

                else
                    % 車線が同じでかつルートが異なる一番近い車両のIDを取得
                    diff_route_veh_id = obj.getDifferentRouteVehicle(veh_id, road_id, link_id);

                    % δ4の制約における先行車のδ1の変数に関する部分の作成
                    D3(VehicleDelta4ConstraintMap(veh_id), delta1_list(diff_route_veh_id)) = -1;
                    D3(VehicleDelta4ConstraintMap(veh_id) + 4, delta1_list(diff_route_veh_id)) = 1;
                    
                end
            end

            % 全体のD3行列に追加
            obj.mld_matrices.D3 = blkdiag(obj.mld_matrices.D3, D3);
            
        end
    end
end
                