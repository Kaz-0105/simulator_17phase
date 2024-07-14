function makeRoadNumLanesMap(obj)
    % RoadNumLanesMapの初期化
    obj.RoadNumLanesMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

    for group_id = cell2mat(obj.Config.network.GroupsMap.keys)
        % group構造体を取得
        group = obj.Config.network.GroupsMap(group_id);

        for road_id = cell2mat(group.RoadsMap.keys)
            % road構造体を取得
            road = group.RoadsMap(road_id);

            % 車線数の初期化
            num_lanes = 0;

            for link_id = road.link_ids
                % リンクのタイプを取得
                link_type = obj.LinkTypeMap(link_id);

                if strcmp(link_type, 'main')
                    % メインリンクのCOMオブジェクトを取得
                    MainLink = obj.Com.Net.Links.ItemByKey(link_id);

                    % メインリンクの車線数を取得
                    num_lanes = num_lanes + MainLink.Lanes.Count;
                elseif strcmp(link_type, 'sub')
                    % サブリンクのCOMオブジェクトを取得
                    SubLink = obj.Com.Net.Links.ItemByKey(link_id);

                    % サブリンクの車線数を取得
                    num_lanes = num_lanes + SubLink.Lanes.Count;
                end
            end

            % RoadNumLanesMapにプッシュ
            obj.RoadNumLanesMap(road_id) = num_lanes;
        end
    end
end