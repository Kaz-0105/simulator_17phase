function makeLinkLaneOrderMap(obj)
    % LinkLaneOrderMapを初期化
    obj.LinkLaneOrderMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'int32');

    for group_id = cell2mat(obj.Config.network.GroupsMap.keys)
        % group構造体を取得
        group_struct = obj.Config.network.GroupsMap(group_id);

        for road_id = cell2mat(group_struct.RoadsMap.keys)
            % road構造体を取得
            road_struct = group_struct.RoadsMap(road_id);

            % 車線の順序のIDを初期化
            count = 0;

            % 左折専用の車線について
            if road_struct.branch.left ~= 0
                % 車線IDを更新
                count = count + 1;

                % 左折専用のsub_linkとconnectorのIDを取得
                sub_link_id = road_struct.branch.left;
                connector_id = obj.SubLinkConnectorMap(sub_link_id);

                % Mapにプッシュ
                obj.LinkLaneOrderMap.add(sub_link_id, 1, count);
                obj.LinkLaneOrderMap.add(connector_id, 1, count);
            end

            % メインリンクの車線について
            
            % メインリンクのIDを取得
            main_link_id = obj.RoadMainLinkMap(road_id);

            % メインリンクのCOMオブジェクトを取得
            MainLink = obj.Com.Net.Links.ItemByKey(main_link_id);

            % メインリンクの車線数を取得
            num_lanes = MainLink.Lanes.Count;

            for lane_id = num_lanes:-1:1
                % 車線IDを更新
                count = count + 1;

                % Mapにプッシュ
                obj.LinkLaneOrderMap.add(main_link_id, lane_id, count);
            end

            % 右折専用の車線について
            if road_struct.branch.right ~= 0
                % 車線IDを更新
                count = count + 1;

                % 右折専用のsub_linkとconnectorのIDを取得
                sub_link_id = road_struct.branch.right;
                connector_id = obj.SubLinkConnectorMap(sub_link_id);

                % Mapにプッシュ
                obj.LinkLaneOrderMap.add(sub_link_id, 1, count);
                obj.LinkLaneOrderMap.add(connector_id, 1, count);
            end
        end
    end
end