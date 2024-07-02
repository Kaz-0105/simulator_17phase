function makeLinkInputOutputMap(obj)
    obj.LinkInputOutputMap = containers.Map('KeyType', 'int32', 'ValueType', 'char');
    
    % 流入末端リンクを調べる
    for group = obj.Config.groups
        group = group{1};
        for road_id = cell2mat(keys(group.RoadsMap))
            road = group.RoadsMap(road_id);
            if isfield(road, 'input')
                obj.LinkInputOutputMap(road.main_link_id) = 'input';
            end
        end
    end

    % 流出末端リンクを調べる
    for link_id = keys(obj.LinkTypeMap)
        link_id = link_id{1};
        if strcmp(obj.LinkTypeMap(link_id), 'output')
            obj.LinkInputOutputMap(link_id) = 'output';
        end
    end
        
end