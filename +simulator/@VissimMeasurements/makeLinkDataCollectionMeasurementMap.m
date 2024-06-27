function makeLinkDataCollectionMeasurementMap(obj)
    % Mapの初期化
    obj.LinkDataCollectionMeasurementMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');
    
    % キー：DataCollectionPointのID、バリュー：リンクIDのディクショナリを作成
    DataCollectionPointLinkMap = dictionary(int32.empty, int32.empty);

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

        obj.LinkDataCollectionMeasurementMap(DataCollectionPointLinkMap(data_collection_point_id)) = data_collection_measurement_id;
    end
end