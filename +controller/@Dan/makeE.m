function makeE(obj)
    % E行列を初期化
    obj.mld_matrices.E = [];

    % 道路ごとに計算
    for road_id = 1: obj.road_num
        % パラメータの構造体を取得
        road_prms = obj.RoadPrmsMap(road_id);

        % 各パラメータを取得
        D_s = road_prms.D_s; % 信号の影響圏に入る距離
        d_s = road_prms.d_s; % 信号と信号の停止線の間の距離
        D_f = road_prms.D_f; % 先行車の影響圏に入る距離
        D_b = road_prms.D_b; % 車線の分岐点と信号の間の距離
        p_s  = road_prms.p_s; % 信号の位置
        v = road_prms.v; % 速度[m/s]

        % 各リンクごとに計算
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % 各リンクのE行列を初期化
            E = [];

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
            h1_min = p_s - p_max - D_s;
            h2_min = p_min - p_s + d_s;
            h3_min = D_f - p_max + p_min;
            h4_min = D_f - p_max + p_min;
            h5_min = p_s - p_max - D_b;

            % 自動車ごとに計算
            for veh_id = 1: obj.RoadLinkNumVehsMap.get(road_id, link_id)
                if veh_id == 1
                    % 先頭車
                    % eを初期化
                    e = zeros(10, 1);

                    % 非０要素を代入
                    e(1) = 3;
                    e(2) = -1;

                    e(3) = p_s-h1_min-D_s;
                    e(4) = -p_s+D_s;

                    e(5) = -p_s+d_s-h2_min;
                    e(6) = p_s-d_s;

                    e(7) = 0;
                    e(8) = 0;
                    e(9) = p_max;
                    e(10) = -p_min;

                elseif veh_id == LaneFirstVehsMap(1) || veh_id == LaneFirstVehsMap(2) || veh_id == LaneFirstVehsMap(3)
                    % 分岐車線（左），メインの車線，分岐車線（右）の先頭車
                    % eを初期化
                    e = zeros(24, 1);

                    % 非０要素を代入
                    e(1) = 3;
                    e(2) = -1;

                    e(3) = 1;
                    e(4) = 1;

                    e(5) = p_s - h1_min - D_s;
                    e(6) = -p_s + D_s;

                    e(7) = -p_s + d_s - h2_min;
                    e(8) = p_s - d_s;

                    e(9) = D_f - h3_min;
                    e(10) = -D_f;

                    e(11) = p_s - D_b - h5_min;
                    e(12) = -p_s + D_b;

                    e(13) = 0;
                    e(14) = 0;
                    e(15) = p_max;
                    e(16) = -p_min;

                    e(17) = 0;
                    e(18) = 0;
                    e(19) = p_max;
                    e(20) = -p_min;

                    e(21) = 0;
                    e(22) = 0;
                    e(23) = p_max;
                    e(24) = -p_min;

                elseif veh_id == LaneFirstVehsMap(2)
                    % 直進先頭車
                    % eを初期化
                    e = zeros(28, 1);

                    % 非０要素を代入
                    e(1) = -1;
                    e(2) = 1;
                    e(3) = 1;
                    e(4) = 1;

                    e(5) = 1;
                    e(6) = 1;
                    e(7) = 0;
                    e(8) = 0;

                    e(9) = p_s - h1_min - D_s;
                    e(10) = -p_s + D_s - obj.eps;

                    e(11) = -p_s + d_s - h2_min;
                    e(12) = p_s - d_s - obj.eps;

                    e(13) = D_f - h3_min;
                    e(14) = -D_f - obj.eps;

                    e(15) = p_s - D_b - h5_min;
                    e(16) = -p_s + D_b - obj.eps;

                    e(17) = 0;
                    e(18) = 0;
                    e(19) = p_max;
                    e(20) = -p_min;

                    e(21) = 0;
                    e(22) = 0;
                    e(23) = p_max;
                    e(24) = -p_min;

                    e(25) = 0;
                    e(26) = 0;
                    e(27) = p_max;
                    e(28) = -p_min;
                elseif veh_id == LaneFirstVehsMap(3)
                    % 分岐車線（右）の先頭車
                    % eを初期化
                    e = zeros(28, 1);

                    % 非０要素を代入
                    e(1) = -1;
                    e(2) = 1;
                    e(3) = 1;
                    e(4) = 1;

                    e(5) = 1;
                    e(6) = 1;
                    e(7) = 0;
                    e(8) = 0;

                    e(9) = p_s - h1_min - D_s;
                    e(10) = -p_s + D_s - obj.eps;

                    e(11) = -p_s + d_s - h2_min;
                    e(12) = p_s - d_s - obj.eps;

                    e(13) = D_f - h3_min;
                    e(14) = -D_f - obj.eps;

                    e(15) = p_s - D_b - h5_min;
                    e(16) = -p_s + D_b - obj.eps;

                    e(17) = 0;
                    e(18) = 0;
                    e(19) = p_max;
                    e(20) = -p_min;

                    e(21) = 0;
                    e(22) = 0;
                    e(23) = p_max;
                    e(24) = -p_min;

                    e(25) = 0;
                    e(26) = 0;
                    e(27) = p_max;
                    e(28) = -p_min;
                    
                else
                    % それ以外の場合
                    % eを初期化
                    e = zeros(38, 1);

                    % 非０要素を代入
                    e(1) = 3;
                    e(2) = -1;

                    e(3) = 1;
                    e(4) = 1;

                    e(5) = 2;
                    e(6) = 0;

                    e(7) = 3;
                    e(8) = 0;

                    e(9) = p_s - h1_min - D_s;
                    e(10) = -p_s + D_s;

                    e(11) = -p_s + d_s - h2_min;
                    e(12) = p_s - d_s;

                    e(13) = D_f - h3_min;
                    e(14) = -D_f;

                    e(15) = D_f - h4_min;
                    e(16) = -D_f;

                    e(17) = p_s - D_b - h5_min;
                    e(18) = -p_s + D_b;

                    e(19) = 0;
                    e(20) = 0;
                    e(21) = p_max;
                    e(22) = -p_min;

                    e(23) = 0;
                    e(24) = 0;
                    e(25) = p_max;
                    e(26) = -p_min;

                    e(27) = 0;
                    e(28) = 0;
                    e(29) = p_max;
                    e(30) = -p_min;

                    e(31) = 0;
                    e(32) = 0;
                    e(33) = p_max;
                    e(34) = -p_min;

                    e(35) = 0;
                    e(36) = 0;
                    e(37) = p_max;
                    e(38) = -p_min;
                end

                % 道路ごとのE行列に追加
                E = [E; e];
            end

            % 全体のE行列に追加
            obj.mld_matrices.E = [obj.mld_matrices.E; E];

        end
    end
end