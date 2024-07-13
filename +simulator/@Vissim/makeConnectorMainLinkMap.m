function makeConnectorMainLinkMap(obj)
    % ConnectorMainLinkMapとMainLinkConnectorMapを初期化
    obj.ConnectorMainLinkMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');
    obj.MainLinkConnectorMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

    for road_id = cell2mat(obj.RoadLinkMap.keys)
        for link_id = obj.RoadLinkMap(road_id)

            if strcmp(obj.LinkTypeMap(link_id), 'connector')
                % ConnectorのCOMオブジェクトを取得
                Connector = obj.Com.Net.Links.ItemByKey(link_id);

                % コネクタのIDとサブリンクのIDを取得
                connector_id = Connector.get('AttValue', 'No');
                main_link_id = Connector.FromLink.get('AttValue', 'No');

                % Mapにプッシュ
                obj.ConnectorMainLinkMap(connector_id) = main_link_id;
                obj.MainLinkConnectorMap(main_link_id) = connector_id;
            end
        end
    end
end