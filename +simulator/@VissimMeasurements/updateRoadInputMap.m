function updateRoadInputMap(obj)
    % LinkInputOutputMapとLinkDataCollectionMeasurementMapを取得
    LinkInputOutputMap = obj.Vissim.get('LinkInputOutputMap');
    LinkDataCollectionMeasurementsMap = obj.Vissim.get('LinkDataCollectionMeasurementsMap');

    % LinkRoadMapを取得
    LinkRoadMap = obj.Vissim.get('LinkRoadMap');

    for link_id = cell2mat(keys(LinkInputOutputMap))
        if strcmp(LinkInputOutputMap(link_id),'input')
            road_id = LinkRoadMap(link_id);

            % tmp_input_dataの初期化
            tmp_input_data = 0;
            
            for data_collection_measurement_id = LinkDataCollectionMeasurementsMap(link_id)
                % DataCollectionMeasurementのCOMオブジェクトを取得
                DataCollectionMeasurement = obj.Com.Net.DataCollectionMeasurement.ItemByKey(data_collection_measurement_id);

                % tmp_input_dataにデータを追加
                tmp_input_data = tmp_input_data + DataCollectionMeasurement.get('AttValue', 'Vehs(Current, Last, All)');
            end
            
            % RoadInputMapにプッシュ
            obj.RoadInputMap(road_id) = [obj.RoadInputMap(road_id), tmp_input_data];
        end
    end
end