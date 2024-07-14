function makeLinkTypeMap(obj)
    % LinkTypeMapの初期化
    obj.LinkTypeMap = containers.Map('KeyType', 'int32', 'ValueType', 'char');  

    % RoadMainLinkMapの作成
    obj.RoadMainLinkMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');
    
    % LinkTypeMapの作成
    for group_id = cell2mat(keys(obj.Config.network.GroupsMap))
        % group構造体を取得
        group = obj.Config.network.GroupsMap(group_id);
        
        for road_id = cell2mat(keys(group.RoadsMap))
            % road構造体を取得
            road = group.RoadsMap(road_id);
            
            
            for link_id = road.link_ids
                % リンクの種類を判別    
                if link_id == obj.getMainLink(road.link_ids)
                    % LinkTypeMapにプッシュ
                    obj.LinkTypeMap(link_id) = 'main';

                    % RoadMainLinkMapにプッシュ
                    obj.RoadMainLinkMap(road_id) = link_id;

                elseif obj.Com.Net.Links.ItemByKey(link_id).get('AttValue', 'isConn')
                    % LinkTypeMapにプッシュ
                    obj.LinkTypeMap(link_id) = 'connector';

                else
                    % LinkTypeMapにプッシュ
                    obj.LinkTypeMap(link_id) = 'sub';

                end
            end
        end
    end
end