% D1行列を作成する関数
function makeD1(obj)
    % D1行列を初期化
    obj.mld_matrices.D1 = [];

    % 道路ごとに計算
    for road_id = 1: obj.road_num
        % 各道路のD1行列を初期化
        D1 = [];

        % 道路IDに対応するSignalGroupのIDを取得
        if road_id == 1
            signal_id = [1, 2, 3];
        elseif road_id == 2
            signal_id = [4, 5, 6];
        elseif road_id == 3
            signal_id = [7, 8, 9];
        elseif road_id == 4
            signal_id = [10, 11, 12];
        end

        % route_vehsを取得
        route_vehs = obj.RoadRouteVehsMap(road_id);

        % D1行列を計算
        for veh_id = 1: obj.RoadNumVehsMap(road_id)
            if veh_id == 1
                % 先頭車
                d1 = zeros(12, obj.signal_num);
                d1(1:2, signal_id(route_vehs(veh_id))) = [1; -1];
            elseif veh_id == obj.RoadFirstVehMap(road_id).right
                % 右折先頭車
                d1 = zeros(28, obj.signal_num);
                d1(1:2, signal_id(route_vehs(veh_id))) = [1; -1];
            elseif veh_id == obj.RoadFirstVehMap(road_id).straight
                % 直進先頭車
                d1 = zeros(28, obj.signal_num);
                d1(1:2, signal_id(route_vehs(veh_id))) = [1; -1];
            else
                % それ以外の場合
                d1 = zeros(42, obj.signal_num);
                d1(1:2, signal_id(route_vehs(veh_id))) = [1; -1];
            end

            % D1に追加
            D1 = [D1; d1];
        end
        
        % D1行列に追加
        obj.mld_matrices.D1 = [obj.mld_matrices.D1; D1];
    end
end
