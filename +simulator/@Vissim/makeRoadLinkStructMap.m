function makeRoadLinkStructMap(obj)
    % RoadLinkStructMapの初期化
    obj.RoadLinkStructMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'any');
    
    % RoadLinkStructMapの作成
    for group_id = cell2mat(keys(obj.Config.network.GroupsMap))
        group = obj.Config.network.GroupsMap(group_id);
        
        for road_id = cell2mat(keys(group.RoadsMap))
            road = group.RoadsMap(road_id);

            for  link_id = road.link_ids
                % link構造体の初期化
                link = [];

                % LinkのCOMオブジェクトを取得
                Link = obj.Com.Net.Links.ItemByKey(link_id);

                % リンクの長さを取得
                link.length = Link.get('AttValue', 'Length2D');

                % リンクの種類を取得
                link.type = obj.LinkTypeMap(link_id);

                % メインリンクのコネクタは追加の情報がある
                if strcmp(link.type, 'main') || strcmp(link.type, 'output')
                    % 速度を取得
                    link.v = road.v;

                if strcmp(link.type, 'connector')
                    % ToLinkとFromLinkのIDを取得
                    link.to_link_id = Link.ToLink.get('AttValue', 'No');
                    link.from_link_id = Link.FromLink.get('AttValue', 'No');

                    % 接続している位置を取得
                    link.to_pos = Link.get('AttValue', 'ToPos');
                    link.from_pos = Link.get('AttValue', 'FromPos');
                end

                % RoadLinkStructMapに追加
                obj.RoadLinkStructMap.add(road_id, link_id, link);
            end
        end    
    end
end