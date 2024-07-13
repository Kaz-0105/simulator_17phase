function makeRoadBranchMap(obj)
    % Mapの初期化
    obj.RoadBranchMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    % 各Groupに対して
    for group_id = cell2mat(obj.Config.network.GroupsMap.keys)
        % RoadsMapを取得
        RoadsMap = obj.Config.network.GroupsMap(group_id).RoadsMap;

        % 各Roadに対して
        for road_id = cell2mat(RoadsMap.keys)
            % road構造体を取得
            road_struct = RoadsMap(road_id);

            % 分岐情報をMapにプッシュ
            if isfield(road_struct, 'branch')
                obj.RoadBranchMap(road_id) = road_struct.branch;
            end
        end
    end
end