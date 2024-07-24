function makeRoadRouteSignalGroupMap(obj)
    % RoadRouteSignalGroupMapの作成
    obj.RoadRouteSignalGroupMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'int32');

    for intersection_id = cell2mat(obj.IntersectionStructMap.keys)
        % intersection構造体を取得
        intersection = obj.IntersectionStructMap(intersection_id);

        % 道路の数を取得
        num_roads = length(intersection.input_road_ids);

        for road_id = intersection.input_road_ids
            % メインリンクのIDを取得
            main_link_id = obj.RoadMainLinkMap(road_id);

            % メインリンクのCOMオブジェクトを取得
            MainLink = obj.Com.Net.Links.ItemByKey(main_link_id);

            % VehicleRoutesStaticのCOMオブジェクトを取得
            VehicleRoutesStatic = MainLink.VehRoutSta;

            % 道路の順番を示すIDを取得
            order_id = intersection.InputRoadOrderMap(road_id);

            % order_id + 1をスタートとした循環するリストを作成
            order_list = [(order_id + 1): num_roads, 1:(order_id -1)];

            for VehicleRouteStatic = VehicleRoutesStatic.GetAll()'
                % セル配列から取り出す
                VehicleRouteStatic = VehicleRouteStatic{1};

                % VehicleRouteStaticのIDを取得
                vehicle_route_static_id = VehicleRouteStatic.get('AttValue', 'No');

                % DestLink（交差点内のコネクタ）を取得
                DestLink = VehicleRouteStatic.DestLink;
                
                % ToLink（流出道路のメインリンク）を取得
                ToLink = DestLink.ToLink;

                % ToLinkのIDを取得
                to_link_id = ToLink.get('AttValue', 'No');

                % 道路IDを取得
                tmp_road_id = obj.LinkRoadMap(to_link_id);

                % 道路の順番を示すIDを取得
                tmp_order_id = intersection.OutputRoadOrderMap(tmp_road_id);

                % SignalGroupのIDを取得
                signal_group_id = find(order_list == tmp_order_id);

                % RoadRouteSignalGroupMapにプッシュ
                obj.RoadRouteSignalGroupMap.add(road_id, vehicle_route_static_id, signal_group_id);
            end
        end 
    end
end