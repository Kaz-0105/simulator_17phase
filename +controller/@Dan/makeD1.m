% D1行列を作成する関数
function makeD1(obj)
    % D1行列を初期化
    obj.mld_matrices.D1 = [];

    % 道路ごとに計算
    for road_id = 1: obj.road_num
        % 道路IDに対応するSignalGroupのIDを取得
        signal_ids = ((road_id-1)*(obj.road_num-1) + 1): (road_id*(obj.road_num-1));

        % リンクごとに計算
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % 各リンクのD1行列を初期化
            D1 = [];

            % route_vehsを取得
            route_vehs = obj.RoadLinkRouteVehsMap.get(road_id, link_id);

            % LaneFirstVehsMapを取得
            LaneFirstVehsMap = obj.RoadLinkLaneFirstVehsMap.get(road_id, link_id);

            % 自動車ごとに計算
            for veh_id = 1: obj.RoadLinkNumVehsMap.get(road_id, link_id)
                if veh_id == 1
                    % 先頭車
                    d1 = zeros(12, obj.signal_num);
                    d1(1:2, signal_ids(route_vehs(veh_id))) = [-1; 1];

                elseif veh_id == LaneFirstVehsMap(1)
                    % 分岐車線（左）の先頭車
                    d1 = zeros(28, obj.signal_num);
                    d1(1:2, signal_ids(route_vehs(veh_id))) = [-1; 1];

                elseif veh_id == LaneFirstVehsMap(2)
                    % メインの車線の先頭車
                    d1 = zeros(28, obj.signal_num);
                    d1(1:2, signal_ids(route_vehs(veh_id))) = [-1; 1];

                elseif veh_id == LaneFirstVehsMap(3)
                    % 分岐車線（右）の先頭車
                    d1 = zeros(28, obj.signal_num);
                    d1(1:2, signal_ids(route_vehs(veh_id))) = [-1; 1];

                else
                    % それ以外の場合
                    d1 = zeros(47, obj.signal_num);
                    d1(1:2, signal_ids(route_vehs(veh_id))) = [-1; 1];

                end

                % D1に追加
                D1 = [D1; d1];

            end

            % D1行列に追加
            obj.mld_matrices.D1 = [obj.mld_matrices.D1; D1];
        end
    end
end
