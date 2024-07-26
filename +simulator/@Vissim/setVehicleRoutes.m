function setVehicleRoutes(obj)
    % GroupsMapの取得
    GroupsMap = obj.Config.network.GroupsMap;

    for group_id = cell2mat(GroupsMap.keys)
        % group構造体の取得
        group = GroupsMap(group_id);

        % VehicleRoutesMapの取得
        VehicleRoutesMap = group.PrmsMap('vehicle_routes');

        % VISSIMにパラメータを設定
        for intersection_id = cell2mat(VehicleRoutesMap.keys)
            % intersection構造体を取得
            intersection = group.IntersectionsMap(intersection_id);

            % vehicle_routes構造体を取得
            vehicle_routes = VehicleRoutesMap(intersection_id);

            % 流入道路ごとに旋回率を設定
            for road_id = intersection.input_road_ids
                % メインリンクのIDを取得
                main_link_id = obj.RoadMainLinkMap(road_id);

                % メインリンクのCOMオブジェクトを取得
                MainLink = obj.Com.Net.Links.ItemByKey(main_link_id);

                % VehicleRoutesStaticのCOMオブジェクトを取得
                VehicleRoutesStatic = MainLink.VehRoutSta;

                % rel_flowsを取得
                rel_flows = vehicle_routes.RoadRelFlowsMap(road_id);

                % 旋回率を設定
                for VehicleRouteStatic = VehicleRoutesStatic.GetAll()'
                    % セル配列から取り出し
                    VehicleRouteStatic = VehicleRouteStatic{1};

                    % VehicleRouteStaticのIDを取得
                    vehicle_route_static_id = VehicleRouteStatic.get('AttValue', 'No');

                    % 旋回率を設定
                    VehicleRouteStatic.set('AttValue', 'RelFlow(1)', rel_flows(vehicle_route_static_id));
                end
            end
        end
    end
end