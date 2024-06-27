function makeLinkTypeMap(obj)
    % linkTypeMapの初期化
    obj.LinkTypeMap = containers.Map('KeyType', 'int32', 'ValueType', 'char');  
    
    % linkTypeMapの作成
    for group = obj.Config.groups
        group = group{1};
        
        for road = group.roads
            road = road{1};

            if length(road.link_ids) == 3
                % 道路が3つのリンクから構成される場合（ある交差点に対して流入道路となっている場合）
                for link_id = road.link_ids
                    if link_id >= 10000
                        % コネクターのリンクIDはVissim上で10000以上の値を持つようになっている
                        obj.LinkTypeMap(link_id) = 'connector';
                    elseif link_id == road.main_link_id
                        obj.LinkTypeMap(link_id) = 'main';
                    else
                        obj.LinkTypeMap(link_id) = 'sub';
                    end
                end
            else
                % 道路が1つのリンクから構成される場合（系外に流出する道路である場合）
                obj.LinkTypeMap(road.link_ids) = 'output';
            end
        end
    end
end