function makeE(obj)
    % E行列を初期化
    obj.mld_matrices.E = [];

    % 道路ごとに計算
    for road_id = 1: obj.road_num
        % 各道路のE行列を初期化
        E = [];

        % パラメータの構造体を取得
        road_prms = obj.RoadPrmsMap(road_id);

        % 各パラメータを取得
        D_s = road_prms.D_s; % 信号の影響圏に入る距離
        d_s = road_prms.d_s; % 信号と信号の停止線の間の距離
        D_f = road_prms.D_f; % 先行車の影響圏に入る距離
        D_b = road_prms.D_b; % 車線の分岐点と信号の間の距離
        p_s  = road_prms.p_s; % 信号の位置
        v = road_prms.v; % 速度[m/s]

        % 自動車の位置のリストを取得
        pos_vehs = obj.RoadPosVehsMap(road_id);

        % 自動車が0台の場合はスキップ（pos_vehs(end)がエラー吐くため）
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

        % Eを計算
        for veh_id = 1: obj.RoadNumVehsMap(road_id)
            if veh_id == 1
                % 先頭車
                % eを初期化
                e = zeros(12, 1);

                % 非０要素を代入
                e(1) = -1;
                e(2) = 1;
                e(3) = 1;
                e(4) = 1;

                e(5) = p_s-h1_min-D_s;
                e(6) = -p_s+D_s-obj.eps;

                e(7) = -p_s+d_s-h2_min;
                e(8) = p_s-d_s-obj.eps;

                e(9) = 0;
                e(10) = 0;
                e(11) = p_max;
                e(12) = -p_min;

            elseif veh_id == obj.RoadFirstVehMap(road_id).right
                % 右折先頭車
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
            elseif veh_id == obj.RoadFirstVehMap(road_id).straight
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
            else
                % それ以外の場合
                % eを初期化
                e = zeros(42, 1);

                % 非０要素を代入
                e(1) = -1;
                e(2) = 1;
                e(3) = 1;
                e(4) = 1;

                e(5) = 1;
                e(6) = 1;
                e(7) = 0;
                e(8) = 0;

                e(9) = 0;
                e(10) = 1;
                e(11) = 1;
                e(12) = 0;

                e(13) = p_s - h1_min - D_s;
                e(14) = -p_s + D_s - obj.eps;

                e(15) = -p_s + d_s - h2_min;
                e(16) = p_s - d_s - obj.eps;

                e(17) = D_f - h3_min;
                e(18) = -D_f - obj.eps;

                e(19) = D_f - h4_min;
                e(20) = -D_f - obj.eps;

                e(21) = p_s - D_b - h5_min;
                e(22) = -p_s + D_b - obj.eps;

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

                e(39) = 0;
                e(40) = 0;
                e(41) = p_max;
                e(42) = -p_min;
            end

            % 道路ごとのE行列に追加
            E = [E; e];
        end

        % 全体のE行列に追加
        obj.mld_matrices.E = [obj.mld_matrices.E; E];
    end
end