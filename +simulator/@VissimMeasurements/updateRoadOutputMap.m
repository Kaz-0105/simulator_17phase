function updateRoadOutputMap(obj)
    % LinkInputOutputMapとLinkDataCollectionMeasurementMapを取得
    LinkInputOutputMap = obj.Vissim.get('LinkInputOutputMap');
    LinkDataCollectionMeasurementsMap = obj.Vissim.get('LinkDataCollectionMeasurementsMap');

    % LinkRoadMapを取得
    LinkRoadMap = obj.Vissim.get('LinkRoadMap');

    for link_id = cell2mat(keys(LinkInputOutputMap))
        if strcmp(LinkInputOutputMap(link_id),'output')
            road_id = LinkRoadMap(link_id);

            % tmp_output_dataの初期化
            tmp_output_data = 0;
            
            for data_collection_measurement_id = LinkDataCollectionMeasurementsMap(link_id)
                % DataCollectionMeasurementのCOMオブジェクトを取得
                DataCollectionMeasurement = obj.Com.Net.DataCollectionMeasurement.ItemByKey(data_collection_measurement_id);

                % tmp_output_dataにデータを追加
                tmp_output_data = tmp_output_data + DataCollectionMeasurement.get('AttValue', 'Vehs(Current, Last, All)');
            end
            
            % RoadOutputMapにプッシュ
            obj.RoadOutputMap(road_id) = [obj.RoadOutputMap(road_id), tmp_output_data];
            
        end
    end
end