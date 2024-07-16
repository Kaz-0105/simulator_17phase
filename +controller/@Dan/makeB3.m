function makeB3(obj)
    % B3行列を初期化
    obj.mld_matrices.B3 = [];

    % 道路ごとに計算
    for road_id = 1: obj.road_num
        % 道路パラメータの構造体を取得
        road_prms = obj.RoadPrmsMap(road_id);

        % 各パラメータを取得
        D_s = road_prms.D_s; % 信号の影響圏に入る距離
        d_s = road_prms.d_s; % 信号と信号の停止線の間の距離
        D_f = road_prms.D_f; % 先行車の影響圏に入る距離
        d_f = road_prms.d_f; % 先行車と最接近したときの距離
        p_s = road_prms.p_s; % 信号の位置
        v = road_prms.v; % 速度[m/s]
        k_s = 1/(D_s - d_s); % モデルに登場する係数（その１）
        k_f = 1/(D_f - d_f); % モデルに登場する係数（その２）

        % リンクごとで計算
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % 各リンクのB3行列を初期化
            B3 = [];

            % LinkFirstVehsMapの取得
            LaneFirstVehsMap = obj.RoadLinkLaneFirstVehsMap.get(road_id, link_id);

            % 自動車ごとに計算
            for veh_id = 1: obj.RoadLinkNumVehsMap.get(road_id, link_id)
                if veh_id == 1
                    % 先頭車
                    b3 = [0, 0, k_s*(p_s-d_s)-1, 1]*v*obj.dt;

                elseif veh_id == LaneFirstVehsMap(1)
                    % 分岐車線（左）の先頭車
                    b3 = [0, 0, 0, 0, k_s*(p_s-d_s)-1, -k_f*d_f-1, 1]*v*obj.dt;

                elseif veh_id == LaneFirstVehsMap(2)
                    % メインの車線の先頭車
                    b3 = [0, 0, 0, 0, k_s*(p_s-d_s)-1, -k_f*d_f-1, 1]*v*obj.dt;

                elseif veh_id == LaneFirstVehsMap(3)
                    % 分岐車線（右）の先頭車
                    b3 = [0, 0, 0, 0, k_s*(p_s-d_s)-1, -k_f*d_f-1, 1]*v*obj.dt;

                else
                    % それ以外の場合
                    b3 = [0, 0, 0, 0, 0, k_s*(p_s-d_s)-1, -k_f*d_f-1, -k_f*d_f-1, 1]*v*obj.dt;

                end

                % B3に追加
                B3 = blkdiag(B3, b3);
            end

            % B3行列に追加
            obj.mld_matrices.B3 = blkdiag(obj.mld_matrices.B3, B3);
        end
    end
end