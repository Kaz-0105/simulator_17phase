function makeVehicleData(obj)
    % RoadPosVehsMapを作成する
    obj.RoadPosVehsMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    % RoadRouteVehsMapを初期化
    obj.RoadRouteVehsMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    % RoadRouteFirstVehMapを初期化
    obj.RoadRouteFirstVehMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'int32');

    % RoadStructMapを取得
    RoadStructMap = obj.Vissim.get('RoadStructMap');

    % RoadLinkMapを取得
    RoadLinkMap = obj.Vissim.get('RoadLinkMap');

    % LinkTypeMapを取得
    LinkTypeMap = obj.Vissim.get('LinkTypeMap');

    % IntersectionStructMapを取得
    IntersectionStructMap = obj.Vissim.get('IntersectionStructMap');

    for road_id = cell2mat(RoadLinkMap.keys)
        % RoadVehsMap の作成
        road_struct = RoadStructMap(road_id);

        vehs_data = [];

        for link_id = RoadLinkMap(road_id)
            % LinkのCOMオブジェクトを取得
            Link = obj.Com.Net.Links.ItemByKey(link_id);

            % VehiclesのCOMオブジェクトを取得
            Vehicles = Link.Vehs;

            if Vehicles.Count == 0
                continue;
            end

            % 自動車の位置と進路を取得
            pos_vehs = Vehicles.GetMultiAttValues('Pos');
            route_vehs = Vehicles.GetMultiAttValues('RouteNo');

            % 2列目を取得
            pos_vehs = pos_vehs{:, 2};
            route_vehs = route_vehs{:, 2};

            % 数値行列に変換
            if iscell(pos_vehs)
                pos_vehs = cell2mat(pos_vehs);
            end
            if iscell(route_vehs)
                route_vehs = cell2mat(route_vehs);
            end

            % 進路の値をdouble型に変換
            route_vehs = cast(route_vehs, 'double');

            % 車両数を取得
            num_vehs = length(pos_vehs);

            % Linkの種類を取得
            link_type = LinkTypeMap(link_id);

            % Linkの種類によって車両の位置を追加
            if strcmp(link_type, 'main') || strcmp(link_type, 'out')
                for veh_id = 1:num_vehs
                    vehs_data = [vehs_data; pos_vehs(veh_id), route_vehs(veh_id)];
                end
            elseif strcmp(link_type, 'sub')
                for veh_id = 1:num_vehs
                    vehs_data = [vehs_data; pos_vehs(veh_id) + road_struct.from_pos + road_struct.con - road_struct.to_pos, route_vehs(veh_id)];
                end
            elseif strcmp(link_type, 'connector')
                for veh_id = 1:num_vehs
                    vehs_data = [vehs_data; pos_vehs(veh_id) + road_struct.from_pos, route_vehs(veh_id)];
                end
            end

            % 降順にソート
            if ~isempty(vehs_data)
                vehs_data = sortrows(vehs_data, 1, 'descend');
            end
        end

        % NaNを1に変換
        vehs_data(isnan(vehs_data)) = 1;
        
        % RoadPosVehsMapとRoadRouteVehsMapに追加
        if isempty(vehs_data)
            obj.RoadPosVehsMap(road_id) = [];
            obj.RoadRouteVehsMap(road_id) = [];
        else
            obj.RoadPosVehsMap(road_id) = vehs_data(:,1);
            obj.RoadRouteVehsMap(road_id) = vehs_data(:,2);
        end
        
        % 流入道路かチェックする
        is_input_road = true;
        try 
            % 交差点のIDを取得
            intersection_id = obj.RoadIntersectionMap(road_id);

            % 交差点の構造体を取得
            intersection_struct = IntersectionStructMap(intersection_id);

            % 道路の数を取得
            road_num = length(intersection_struct.input_road_ids);

            % RoadRouteFirstVehMapの初期化
            for route_id = 1: road_num-1
                obj.RoadRouteFirstVehMap.add(road_id, route_id, 0);
            end
        catch
            % フラグをfalseにする
            is_input_road = false;
        end

        % RoadRouteFirstVehMapの作成
        if is_input_road
            if ~isempty(vehs_data)
                veh_count = 0;
                for route_id = vehs_data(:,2)'
                    veh_count = veh_count + 1;
                    if obj.RoadRouteFirstVehMap.get(road_id, route_id) == 0
                        obj.RoadRouteFirstVehMap.set(road_id, route_id, veh_count);
                    end
                end
            end
        end
    end
end