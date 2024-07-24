function makeLinkDataCollectionMeasurementsMap(obj)
    % Mapの初期化
    obj.LinkDataCollectionMeasurementsMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    
    % キー：DataCollectionPointのID、バリュー：リンクIDのマップを作成
    DataCollectionPointLinkMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

    DataCollectionPoints = obj.Com.Net.DataCollectionPoints;

    for DataCollectionPoint = DataCollectionPoints.GetAll()'
        DataCollectionPoint = DataCollectionPoint{1};

        data_collection_point_id = DataCollectionPoint.get('AttValue','No');

        link_id = DataCollectionPoint.Lane.Link.get('AttValue','No');

        DataCollectionPointLinkMap(data_collection_point_id) = link_id;
    end

    % キー：リンクID、バリュー：DataCollectionMeasurementのIDのディクショナリを作成
    DataCollectionMeasurements = obj.Com.Net.DataCollectionMeasurements;

    for DataCollectionMeasurement = DataCollectionMeasurements.GetAll()'
        DataCollectionMeasurement = DataCollectionMeasurement{1};

        data_collection_measurement_id = DataCollectionMeasurement.get('AttValue','No');

        DataCollectionPoints = DataCollectionMeasurement.DataCollectionPoints.GetAll();
        DataCollectionPoint = DataCollectionPoints{1};
        data_collection_point_id = DataCollectionPoint.get('AttValue', 'No');

        link_id = DataCollectionPointLinkMap(data_collection_point_id);

        if isKey(obj.LinkDataCollectionMeasurementsMap, link_id)
            obj.LinkDataCollectionMeasurementsMap(link_id) = [obj.LinkDataCollectionMeasurementsMap(link_id), data_collection_measurement_id];
        else
            obj.LinkDataCollectionMeasurementsMap(link_id) = data_collection_measurement_id;
        end
    end
end