function makeB2(obj)
    % B2行列を初期化
    obj.mld_matrices.B2 = [];

    % 道路ごとに計算
    for road_id = 1: obj.road_num
        % リンクごとに計算
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % 各リンクのB2行列を初期化
            B2 = [];

            % LinkFirstVehsMapの取得
            LaneFirstVehsMap = obj.RoadLinkLaneFirstVehsMap.get(road_id, link_id);

            % パラメータの構造体を取得
            link_prms = obj.RoadLinkPrmsMap.get(road_id, link_id);

            % 各パラメータを取得
            D_s = link_prms.D_s; % 信号の影響圏に入る距離
            d_s = link_prms.d_s; % 信号と信号の停止線の間の距離
            D_f = link_prms.D_f; % 先行車の影響圏に入る距離
            d_f = link_prms.d_f; % 先行車と最接近したときの距離
            v = link_prms.v;     % 速度[m/s]
            k_s = 1/(D_s - d_s); % モデルに登場する係数（その１）
            k_f = 1/(D_f - d_f); % モデルに登場する係数（その２）

            % 自動車ごとに計算
            for veh_id = 1: obj.RoadLinkNumVehsMap.get(road_id, link_id)
                if veh_id == 1
                    % 先頭車
                    b2 = -k_s*v*obj.dt;

                elseif veh_id == LaneFirstVehsMap(1)
                    % 分岐車線（左）の先頭車
                    b2 = [-k_s, k_f, -k_f]*v*obj.dt;

                elseif veh_id == LaneFirstVehsMap(2)
                    % メインの車線の先頭車
                    b2 = [-k_s, k_f, -k_f]*v*obj.dt;

                elseif veh_id == LaneFirstVehsMap(3)
                    % 分岐車線（右）の先頭車
                    b2 = [-k_s, k_f, -k_f]*v*obj.dt;

                else
                    % それ以外の場合
                    b2 = [-k_s, k_f, -k_f, k_f, -k_f]*v*obj.dt;

                end

                % B2行列に追加
                B2 = blkdiag(B2, b2);
            end

            % B2行列に追加
            obj.mld_matrices.B2 = blkdiag(obj.mld_matrices.B2, B2);

        end

        
    end
end