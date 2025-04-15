function makeC(obj)
    % C行列を初期化
    obj.mld_matrices.C = [];

    % 各道路ごとに計算
    for road_id = 1: obj.road_num
        % 各リンクごとに計算
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % 各リンクのC行列を初期化
            C = [];

            % LankFirstVehsMapの取得
            LaneFirstVehsMap = obj.RoadLinkLaneFirstVehsMap.get(road_id, link_id);

            % リンク内の自動車数を取得
            num_vehs = obj.RoadLinkNumVehsMap.get(road_id, link_id);

            % 自動車ごとに計算
            for veh_id = 1: num_vehs
                if veh_id == 1
                    % 先頭車
                    c = zeros(10, num_vehs);

                    % 係数が0ではない要素に値を代入
                    c(3:4, veh_id) = [1; -1];
                    c(5:6, veh_id) = [-1; 1];
                    c(9:10, veh_id) = [1; -1];

                elseif veh_id == LaneFirstVehsMap(1) || veh_id == LaneFirstVehsMap(2) || veh_id == LaneFirstVehsMap(3)
                    % 分岐車線（左），メインの車線，分岐車線（右）の先頭車
                    c = zeros(24, num_vehs);

                    % 係数が0ではない要素に値を代入
                    c(5:6,veh_id) = [1;-1];                     
                    c(7:8,veh_id) = [-1;1];
                    c(9:10,(veh_id-1):veh_id) = [1,-1;-1,1];
                    c(11:12,veh_id) = [1;-1];
                    c(15:16,veh_id) = [1;-1];                    
                    c(19:20,veh_id-1) = [1;-1]; 
                    c(23:24,veh_id) = [1;-1];

                else
                    % それ以外の場合
                    c = zeros(38, num_vehs);

                    % 車線分岐後の先行車のIDを取得
                    front_veh_id = obj.getFrontVehicle(veh_id, road_id, link_id);

                    % 係数が0ではない要素に値を代入
                    c(9:18,veh_id) = [1;-1;-1;1;-1;1;-1;1;1;-1]; 
                    c(13:14,veh_id-1) = [1;-1];
                    c(15:16,front_veh_id) = [1;-1];
                    c(21:22,veh_id) = [1;-1];
                    c(25:26,veh_id-1) = [1;-1];                  
                    c(29:30,veh_id) = [1;-1];
                    c(33:34,front_veh_id) = [1;-1];
                    c(37:38,veh_id) = [1;-1];

                end

                % Cに追加
                C = [C; c];

            end

            % C行列に追加
            obj.mld_matrices.C = blkdiag(obj.mld_matrices.C, C);
        end
    end
end