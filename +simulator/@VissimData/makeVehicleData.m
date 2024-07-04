function makeVehicleData(obj)
    % RoadVehsMap を作成する
    obj.RoadVehsMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    % RoadFirstVehMap を作成する
    obj.RoadFirstVehMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    % RoadStructMapを取得
    RoadStructMap = obj.Vissim.get('RoadStructMap');

    % RoadLinkMapを取得
    RoadLinkMap = obj.Vissim.get('RoadLinkMap');

    % RoadLinkMapのキーを取得
    keys_road_link_map = keys(RoadLinkMap);
    keys_road_link_map = [keys_road_link_map{:}];

    % LinkTypeMapを取得
    LinkTypeMap = obj.Vissim.get('LinkTypeMap');

    for road_id = keys_road_link_map

        % RoadVehsMap の作成
        road_struct = RoadStructMap(road_id);
        link_ids = RoadLinkMap(road_id);

        vehs_data = [];

        for link_id = link_ids
            link_obj = obj.Com.Net.Links.ItemByKey(link_id);
            vehs_pos = link_obj.Vehs.GetMultiAttValues('Pos');
            vehs_route = link_obj.Vehs.GetMultiAttValues('RouteNo');
            [num_veh,~] = size(vehs_pos);


            link_type = LinkTypeMap(link_id);

            if strcmp(link_type, 'main') || strcmp(link_type, 'out')
                for veh_id = 1:num_veh
                    vehs_data = [vehs_data; vehs_pos{veh_id,2}, cast(vehs_route{veh_id,2},'double')];
                end
            elseif strcmp(link_type, 'sub')
                for veh_id = 1:num_veh
                    vehs_data = [vehs_data; vehs_pos{veh_id,2} + road_struct.from_pos + road_struct.con - road_struct.to_pos, cast(vehs_route{veh_id,2}, 'double')];
                end
            elseif strcmp(link_type, 'connector')
                for veh_id = 1:num_veh
                    vehs_data = [vehs_data; vehs_pos{veh_id,2} + road_struct.from_pos, cast(vehs_route{veh_id,2}, 'double')];
                end
            end

            if ~isempty(vehs_data)
                vehs_data = sortrows(vehs_data, 1, 'descend');
            end

        end

        vehs_data(isnan(vehs_data)) = 1; % NaNを1に変換
        
        obj.RoadVehsMap(road_id) = vehs_data;

        % RoadFirstVehMap の作成

        try
            % 注目しているRoadが流入道路となっている交差点の流入道路の数を取得
            intersection_id = obj.RoadIntersectionMap(road_id);
            road_num = obj.IntersectionNumRoadMap(intersection_id);

            if road_num == 3
                first_left_id = 0;
                first_right_id = 0;
                first_ids = [];

                if ~isempty(vehs_data)
                    for veh_id = 1: length(vehs_data(:,2))
                        route = vehs_data(veh_id,2);
                        if route == 1
                            if first_left_id == 0
                                first_left_id = veh_id;
                            end
                        elseif route == 2
                            if first_right_id == 0
                                first_right_id = veh_id;
                            end
                        end
                    end
                end

                first_ids.left = first_left_id;
                first_ids.right = first_right_id;

                obj.RoadFirstVehMap(road_id) = first_ids;
            elseif road_num == 4
                first_straight_id = 0;
                first_right_id = 0;
                first_ids = [];

                if ~isempty(vehs_data)
                    for veh_id = 1: length(vehs_data(:,2))
                        route = vehs_data(veh_id,2);
                        if route == 1 || route == 2
                            if first_straight_id == 0
                                first_straight_id = veh_id;
                            end
                        elseif route == 3
                            if first_right_id == 0
                                first_right_id = veh_id;
                            end
                        end
                    end
                end

                first_ids.straight = first_straight_id;
                first_ids.right = first_right_id;
            end

            obj.RoadFirstVehMap(road_id) = first_ids;
        catch
            obj.RoadFirstVehMap(road_id) = [];
        end
    end

end