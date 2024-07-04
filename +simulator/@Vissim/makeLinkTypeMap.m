function makeLinkTypeMap(obj)
    % linkTypeMapの初期化
    obj.LinkTypeMap = containers.Map('KeyType', 'int32', 'ValueType', 'char');  
    
    % linkTypeMapの作成

    for group_id = cell2mat(keys(obj.Config.network.GroupsMap))
        group = obj.Config.network.GroupsMap(group_id);
        
        for road_id = cell2mat(keys(group.RoadsMap))
            road = group.RoadsMap(road_id);

            if length(road.link_ids) >= 2
                for link_id = road.link_ids    
                    if link_id == getMainLink(obj, road.link_ids)
                        obj.LinkTypeMap(link_id) = 'main';
                    elseif obj.Com.Net.Links.ItemByKey(link_id).get('AttValue', 'isConn')
                        obj.LinkTypeMap(link_id) = 'connector';
                    else
                        obj.LinkTypeMap(link_id) = 'sub';
                    end
                end
            else
                obj.LinkTypeMap(road.link_ids) = 'output';
            end
        end
    end
end