function makeConnectorSubLinkMap(obj)
    % ConnectorSubLinkMapとSubLinkConnectorMapを初期化
    obj.ConnectorSubLinkMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');
    obj.SubLinkConnectorMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

    for road_id = cell2mat(obj.RoadLinkMap.keys)
        for link_id = obj.RoadLinkMap(road_id)

            if strcmp(obj.LinkTypeMap(link_id), 'connector')
                % ConnectorのCOMオブジェクトを取得
                Connector = obj.Com.Net.Links.ItemByKey(link_id);

                % コネクタのIDとサブリンクのIDを取得
                connector_id = Connector.get('AttValue', 'No');
                sub_link_id = Connector.ToLink.get('AttValue', 'No');

                % Mapにプッシュ
                obj.ConnectorSubLinkMap(connector_id) = sub_link_id;
                obj.SubLinkConnectorMap(sub_link_id) = connector_id;
            end
        end
    end
end