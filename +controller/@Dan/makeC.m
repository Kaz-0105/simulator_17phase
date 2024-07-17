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

            % 自動車ごとに計算
            for veh_id = 1: obj.RoadLinkNumVehsMap.get(road_id, link_id)
                if veh_id == 1
                    % 先頭車
                    c = zeros(12, obj.RoadNumVehsMap(road_id));

                    % 係数が0ではない要素に値を代入
                    c(5:6, veh_id) = [1; -1];
                    c(7:8, veh_id) = [-1; 1];
                    c(11:12, veh_id) = [1; -1];

                elseif veh_id == LaneFirstVehsMap(1)
                    % 分岐車線（左）の先頭車
                    c = zeros(28, obj.RoadNumVehsMap(road_id));

                    % 係数が0ではない要素に値を代入
                    c(9:10,veh_id) = [1;-1];                     
                    c(11:12,veh_id) = [-1;1];
                    c(13:14,(veh_id-1):veh_id) = [1,-1;-1,1];
                    c(15:16,veh_id) = [1;-1];
                    c(19:20,veh_id) = [1;-1];                    
                    c(23:24,veh_id-1) = [1;-1]; 
                    c(27:28,veh_id) = [1;-1];

                elseif veh_id == LaneFirstVehsMap(2)
                    % メインの車線の先頭車
                    c = zeros(28, obj.RoadNumVehsMap(road_id));

                    % 係数が0ではない要素に値を代入
                    c(9:10,veh_id) = [1;-1];                     
                    c(11:12,veh_id) = [-1;1];
                    c(13:14,(veh_id-1):veh_id) = [1,-1;-1,1];
                    c(15:16,veh_id) = [1;-1];
                    c(19:20,veh_id) = [1;-1];                    
                    c(23:24,veh_id-1) = [1;-1]; 
                    c(27:28,veh_id) = [1;-1];

                elseif veh_id == LaneFirstVehsMap(3)
                    % 分岐車線（右）の先頭車
                    c = zeros(28, obj.RoadNumVehsMap(road_id));

                    % 係数が0ではない要素に値を代入
                    c(9:10,veh_id) = [1;-1];                     
                    c(11:12,veh_id) = [-1;1];
                    c(13:14,(veh_id-1):veh_id) = [1,-1;-1,1];
                    c(15:16,veh_id) = [1;-1];
                    c(19:20,veh_id) = [1;-1];                    
                    c(23:24,veh_id-1) = [1;-1]; 
                    c(27:28,veh_id) = [1;-1];

                else
                    % それ以外の場合
                    c = zeros(45, obj.RoadNumVehsMap(road_id));

                    % 車線分岐後の先行車のIDを取得
                    front_veh_id = obj.getFrontVehicle(veh_id, road_id, link_id);

                    % 係数が0ではない要素に値を代入
                    c(16:25,veh_id) = [1;-1;-1;1;-1;1;-1;1;1;-1]; 
                    c(20:21,veh_id-1) = [1;-1];
                    c(22:23,front_veh_id) = [1;-1];
                    c(28:29,veh_id) = [1;-1];
                    c(32:33,veh_id-1) = [1;-1];                  
                    c(36:37,veh_id) = [1;-1];
                    c(40:41,front_veh_id) = [1;-1];
                    c(44:45,veh_id) = [1;-1];

                end

                % Cに追加
                C = [C; c];

            end

            % C行列に追加
            obj.mld_matrices.C = blkdiag(obj.mld_matrices.C, C);
        end
    end
end