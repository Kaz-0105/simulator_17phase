function makeVehicleData(obj)
    % RoadPosVehsMapを作成する
    obj.RoadPosVehsMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    % RoadRouteVehsMapを初期化
    obj.RoadRouteVehsMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    % RoadRouteFirstVehMapを初期化
    obj.RoadLaneFirstVehMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'int32');

    % RoadLinkMapとLinkTypeMapを取得
    RoadLinkMap = obj.Vissim.get('RoadLinkMap');
    RoadStructMap = obj.Vissim.get('RoadStructMap');
    LinkTypeMap = obj.Vissim.get('LinkTypeMap');
    ConnectorToLinkMap = obj.Vissim.get('ConnectorToLinkMap');

    for road_id = cell2mat(RoadLinkMap.keys)
        % データを格納する変数を定義
        tmp_data = [];

        % 道路の構造体を取得
        road_struct = RoadStructMap(road_id);

        for link_id = RoadLinkMap(road_id)
            % LinkのCOMオブジェクトを取得
            Link = obj.Com.Net.Links.ItemByKey(link_id);

            % VehsのCOMオブジェクトを取得
            Vehs = Link.Vehs;

            for Vehicle = Vehs.GetAll()'
                % セル配列から取り出す
                Vehicle = Vehicle{1};

                % Linkのタイプによって処理を分ける
                if strcmp(LinkTypeMap(link_id), 'main')
                    % 位置の取得
                    pos_veh = Vehicle.get('AttValue', 'Pos');

                    % 進行方向の取得
                    route_veh = Vehicle.get('AttValue', 'RouteNo');

                    % 信号待ちする車線を取得
                    % 次のリンクを取得
                    NextLink = Vehicle.NextLink;

                    % 次のリンクのIDを取得
                    next_link_id = NextLink.get('AttValue', 'No');

                    % 分岐車線に入るか確認
                    if ismember(next_link_id, RoadLinkMap(road_id))
                        % 分岐したリンクのIDを取得
                        sub_link_id = ConnectorToLinkMap(next_link_id);

                        % lane_vehを取得
                        lane_veh = obj.SubLinkLaneMap(sub_link_id);
                    else
                        % 現在のレーンを取得
                        lane_veh = Vehicle.get('AttValue', 'Lane');
                    end
                    % tmp_dataにプッシュ
                    tmp_data(end + 1, :) = [pos_veh, route_veh, lane_veh];
                    
                elseif strcmp(LinkTypeMap(link_id), 'sub')
                    % 位置の取得
                    pos_veh = Vehicle.get('AttValue', 'Pos') + road_struct.from_pos;

                    % 進行方向の取得
                    route_veh = Vehicle.get('AttValue', 'RouteNo');

                    % 信号待ちする車線を取得
                    lane_veh = SubLinkLaneMap(Vehicle.Lane.get('AttValue', 'Index'));

                elseif strcmp(LinkTypeMap(link_id), 'connector')
                elseif strcmp(LinkTypeMap(link_id), 'output')
                end
            end
        end
    end

    
end