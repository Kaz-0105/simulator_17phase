function makeB2(obj)
    % B2行列を初期化
    obj.mld_matrices.B2 = [];

    % 道路ごとに計算
    for road_id = 1: obj.road_num
        % 各道路のB2行列を初期化
        B2 = [];

        % パラメータの構造体を取得
        road_prms = obj.RoadPrmsMap(road_id);

        % 各パラメータを取得
        D_s = road_prms.D_s; % 信号の影響圏に入る距離
        d_s = road_prms.d_s; % 信号と信号の停止線の間の距離
        D_f = road_prms.D_f; % 先行車の影響圏に入る距離
        d_f = road_prms.d_f; % 先行車と最接近したときの距離
        v = road_prms.v;     % 速度[m/s]
        k_s = 1/(D_s - d_s); % モデルに登場する係数（その１）
        k_f = 1/(D_f - d_f); % モデルに登場する係数（その２）

        % B2行列を計算
        for veh_id = 1: obj.RoadNumVehsMap(road_id)
            if veh_id == 1
                % 先頭車
                b2 = -k_s*v*obj.dt;
            elseif veh_id == obj.RoadRouteFirstVehMap(road_id).right 
                % 右折先頭車
                b2 = [-k_s, k_f, -k_f]*v*obj.dt;
            elseif veh_id == obj.RoadRouteFirstVehMap(road_id).straight
                % 直進先頭車
                b2 = [-k_s, k_f, -k_f]*v*obj.dt;
            else
                % それ以外の場合
                b2 = [-k_s, k_f, -k_f, k_f, -k_f]*v*obj.dt;
            end

            % tmp_B2に追加
            B2 = blkdiag(B2, b2);
        end

        % B2行列に追加
        obj.mld_matrices.B2 = blkdiag(obj.mld_matrices.B2, B2);
    end
end