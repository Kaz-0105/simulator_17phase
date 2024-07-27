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
                    link.v = road.speed;

                elseif strcmp(link.type, 'connector')
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

            % LinkStructMapの取得
            LinkStructMap = obj.RoadLinkStructMap.getInnerMap(road_id);

            % メインリンクとサブリンクにも接続に関する情報を追加
            for link_id = cell2mat(LinkStructMap.keys)
                % link構造体を取得
                link = LinkStructMap(link_id);

                if strcmp(link.type, 'connector')
                    % 接続しているリンクの構造体を取得
                    to_link = LinkStructMap(link.to_link_id);
                    from_link = LinkStructMap(link.from_link_id);

                    % 接続情報を追加
                    to_link.from_link_id = link_id;
                    from_link.to_link_id = link_id;

                    % LinkStructMapにプッシュ
                    LinkStructMap(link.to_link_id) = to_link;
                    LinkStructMap(link.from_link_id) = from_link;
                end
            end
        end    
    end
end