function makeLinkInputOutputMap(obj)
    obj.LinkInputOutputMap = containers.Map('KeyType', 'int32', 'ValueType', 'char');
    
    % Mapの初期化
    for Link = obj.Com.Net.Links.GetAll()'
        Link = Link{1};
        obj.LinkInputOutputMap(Link.get('AttValue', 'No')) = 'nan';
    end

    for Link = obj.Com.Net.Links.GetAll()'
        Link = Link{1};
        if Link.get('AttValue', 'isConn')
            from_link_id = Link.FromLink.get('AttValue', 'No');
            to_link_id = Link.ToLink.get('AttValue', 'No');
            
            % from_linkについて
            if strcmp(obj.LinkInputOutputMap(from_link_id),'nan')
                obj.LinkInputOutputMap(from_link_id) = 'input';
            elseif strcmp(obj.LinkInputOutputMap(from_link_id),'output')
                obj.LinkInputOutputMap(from_link_id) = 'neither';
            end

            % to_linkについて
            if strcmp(obj.LinkInputOutputMap(to_link_id),'nan')
                obj.LinkInputOutputMap(to_link_id) = 'output';
            elseif strcmp(obj.LinkInputOutputMap(to_link_id),'input')
                obj.LinkInputOutputMap(to_link_id) = 'neither';
            end
        end
    end 

    % 関係ないリンクを削除
    for link_id = cell2mat(obj.LinkInputOutputMap.keys)
        if strcmp(obj.LinkInputOutputMap(link_id),'neither')
            remove(obj.LinkInputOutputMap, link_id);
        elseif strcmp(obj.LinkInputOutputMap(link_id),'nan')
            remove(obj.LinkInputOutputMap, link_id);
        end
    end
end