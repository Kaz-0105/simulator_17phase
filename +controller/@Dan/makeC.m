function makeC(obj)
    % C行列を初期化
    obj.mld_matrices.C = [];

    % 各道路ごとに計算
    for road_id = 1: obj.road_num
        % 各道路のC行列を初期化
        C = [];

        for veh_id = 1: obj.RoadNumVehsMap(road_id)
            if veh_id == 1
                % 先頭車
                c = zeros(12, obj.RoadNumVehsMap(road_id));

                % 係数が0ではない要素に値を代入
                c(5:6, veh_id) = [1; -1];
                c(7:8, veh_id) = [-1; 1];
                c(11:12, veh_id) = [1; -1];
            elseif veh_id == obj.RoadRouteFirstVehMap(road_id).right
                % 右折先頭車
                c = zeros(28, obj.RoadNumVehsMap(road_id));

                % 係数が0ではない要素に値を代入
                c(9:10,veh_id) = [1;-1];                     
                c(11:12,veh_id) = [-1;1];
                c(13:14,(veh_id-1):veh_id) = [1,-1;-1,1];
                c(15:16,veh_id) = [1;-1];
                c(19:20,veh_id) = [1;-1];                    
                c(23:24,veh_id-1) = [1;-1]; 
                c(27:28,veh_id) = [1;-1];
            elseif veh_id == obj.RoadRouteFirstVehMap(road_id).straight
                % 直進先頭車
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
                c = zeros(42, obj.RoadNumVehsMap(road_id));

                % 車線分岐後の先行車のIDを取得
                front_veh_id = obj.getFrontVehicle(veh_id, road_id);

                % 係数が0ではない要素に値を代入
                c(13:22,veh_id) = [1;-1;-1;1;-1;1;-1;1;1;-1]; 
                c(17:18,veh_id-1) = [1;-1];
                c(19:20,front_veh_id) = [1;-1];
                c(25:26,veh_id) = [1;-1];
                c(29:30,veh_id-1) = [1;-1];                  
                c(33:34,veh_id) = [1;-1];
                c(37:38,front_veh_id) = [1;-1];
                c(41:42,veh_id) = [1;-1];
            end

            % Cに追加
            C = [C; c];
        end

        % C行列に追加
        obj.mld_matrices.C = blkdiag(obj.mld_matrices.C, C);
    end
end