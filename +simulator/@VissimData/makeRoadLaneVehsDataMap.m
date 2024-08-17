function makeRoadLaneVehsDataMap(obj)
    % RoadLaneVehsDataMapの初期化
    obj.RoadLaneVehsDataMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'any');
    
    % RoadNumVehsMapの初期化
    obj.RoadNumVehsMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

    % RoadLinkMapの取得
    RoadLinkMap = obj.Vissim.get('RoadLinkMap');
    LinkTypeMap = obj.Vissim.get('LinkTypeMap');
    LinkLaneOrderMap = obj.Vissim.get('LinkLaneOrderMap');
    RoadNumLanesMap = obj.Vissim.get('RoadNumLanesMap');
    RoadStructMap = obj.Vissim.get('RoadStructMap');

    % RoadLaneVehsDataMapの初期化
    for road_id = cell2mat(RoadLinkMap.keys)
        for lane_id = 1: RoadNumLanesMap(road_id)
            obj.RoadLaneVehsDataMap.add(road_id, lane_id, []);
        end
    end

    for road_id = cell2mat(RoadLinkMap.keys)
        % その道路を構成するリンクのIDを取得
        link_ids = RoadLinkMap(road_id);

        % road構造体を取得
        road_struct = RoadStructMap(road_id);

        for link_id = link_ids
            % リンクの種類を取得
            link_type = LinkTypeMap(link_id);

            if strcmp(link_type, 'main')
                % メインリンクのCOMオブジェクトを取得
                MainLink = obj.Com.Net.Links.ItemByKey(link_id);

                % 自動車のコンテナのCOMオブジェクトを取得
                Vehicles = MainLink.Vehs;

                % VehicleNumVehsMapにプッシュ
                if isKey(obj.RoadNumVehsMap, road_id)
                    obj.RoadNumVehsMap(road_id) = obj.RoadNumVehsMap(road_id) + Vehicles.Count;
                else
                    obj.RoadNumVehsMap(road_id) = Vehicles.Count;
                end

                for Vehicle = Vehicles.GetAll()'
                    % セル配列から取り出し
                    Vehicle = Vehicle{1};

                    % NextLinkのCOMオブジェクトを取得
                    NextLink = Vehicle.NextLink; 

                    if isempty(NextLink)
                        break;
                    else
                        % 次のリンクのIDを取得
                        next_link_id = Vehicle.NextLink.get('AttValue', 'No');

                        if ismember(next_link_id, link_ids)
                            % 位置を取得
                            pos_veh = Vehicle.get('AttValue', 'Pos');

                            % 進路を取得
                            route_veh = double(Vehicle.get('AttValue', 'RouteNo'));

                            % 信号待ちする車線のIDを取得
                            lane_id = LinkLaneOrderMap.get(next_link_id, 1);
                        else
                            % 位置を取得
                            pos_veh = Vehicle.get('AttValue', 'Pos');

                            % 進路を取得
                            route_veh = double(Vehicle.get('AttValue', 'RouteNo'));

                            % 信号待ちする車線のIDを取得
                            lane_id = LinkLaneOrderMap.get(link_id, Vehicle.Lane.get('AttValue', 'Index'));
                        end

                        % RoadLaneVehsDataMapにプッシュ
                        obj.RoadLaneVehsDataMap.set(road_id, lane_id, [obj.RoadLaneVehsDataMap.get(road_id, lane_id); pos_veh, route_veh]);
                    end
                end
            elseif strcmp(link_type, 'connector')
                % ConnectorのCOMオブジェクトを取得
                Connector = obj.Com.Net.Links.ItemByKey(link_id);

                % 自動車のコンテナのCOMオブジェクトを取得
                Vehicles = Connector.Vehs;

                % VehicleNumVehsMapにプッシュ
                if isKey(obj.RoadNumVehsMap, road_id)
                    obj.RoadNumVehsMap(road_id) = obj.RoadNumVehsMap(road_id) + Vehicles.Count;
                else
                    obj.RoadNumVehsMap(road_id) = Vehicles.Count;
                end

                for Vehicle = Vehicles.GetAll()'
                    % セル配列から取り出し
                    Vehicle = Vehicle{1};

                    % 位置を取得
                    pos_veh = Vehicle.get('AttValue', 'Pos') + road_struct.from_pos;

                    % 進路を取得
                    route_veh = double(Vehicle.get('AttValue', 'RouteNo'));

                    % 信号待ちする車線のIDを取得
                    lane_id = LinkLaneOrderMap.get(link_id, 1);

                    % RoadLaneVehsDataMapにプッシュ
                    obj.RoadLaneVehsDataMap.set(road_id, lane_id, [obj.RoadLaneVehsDataMap.get(road_id, lane_id); pos_veh, route_veh]);
                end

            elseif strcmp(link_type, 'sub')
                % SubLinkのCOMオブジェクトを取得
                SubLink = obj.Com.Net.Links.ItemByKey(link_id);

                % 自動車のコンテナのCOMオブジェクトを取得
                Vehicles = SubLink.Vehs;

                % VehicleNumVehsMapにプッシュ
                if isKey(obj.RoadNumVehsMap, road_id)
                    obj.RoadNumVehsMap(road_id) = obj.RoadNumVehsMap(road_id) + Vehicles.Count;
                else
                    obj.RoadNumVehsMap(road_id) = Vehicles.Count;
                end

                for Vehicle = Vehicles.GetAll()'
                    % セル配列から取り出し
                    Vehicle = Vehicle{1};

                    % 位置を取得
                    pos_veh = Vehicle.get('AttValue', 'Pos') + road_struct.from_pos + road_struct.con - road_struct.to_pos;

                    % 進路を取得
                    route_veh = double(Vehicle.get('AttValue', 'RouteNo'));

                    % 信号待ちする車線のIDを取得
                    lane_id = LinkLaneOrderMap.get(link_id, 1);

                    % RoadLaneVehsDataMapにプッシュ
                    obj.RoadLaneVehsDataMap.set(road_id, lane_id, [obj.RoadLaneVehsDataMap.get(road_id, lane_id); pos_veh, route_veh]);
                end
            end
        end
    end
end