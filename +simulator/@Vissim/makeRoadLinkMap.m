function makeRoadLinkMap(obj)
    % RoadLinkMapとLinkRoadMapを初期化
    obj.RoadLinkMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    obj.LinkRoadMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

    for group_id = cell2mat(keys(obj.Config.network.GroupsMap))
        % group構造体を取得
        group = obj.Config.network.GroupsMap(group_id);

        for road_id = cell2mat(keys(group.RoadsMap))
            % road構造体を取得
            road = group.RoadsMap(road_id);

            % RoadLinkMapにプッシュ
            obj.RoadLinkMap(road_id) = road.link_ids;

            % LinkRoadMapにプッシュ
            for link_id = road.link_ids
                obj.LinkRoadMap(link_id) = road_id;
            end
        end
    end
end