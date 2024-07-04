function updateRoadOutputMap(obj)
    % LinkInputOutputMapを取得
    LinkInputOutputMap = obj.Vissim.get('LinkInputOutputMap');

    % LinkRoadMapを取得
    LinkRoadMap = obj.Vissim.get('LinkRoadMap');

    for link_id = cell2mat(keys(LinkInputOutputMap))
        if strcmp(LinkInputOutputMap(link_id),'output')
            road_id = LinkRoadMap(link_id);

            % DataCollectionMeasurementのCOMオブジェクトを取得
            data_collection_measurement_id = obj.LinkDataCollectionMeasurementMap(link_id);
            DataCollectionMeasurement = obj.Com.Net.DataCollectionMeasurement.ItemByKey(data_collection_measurement_id);
            
            % データを追加
            tmp_output_data = DataCollectionMeasurement.get('AttValue', 'Vehs(Current, Last, All)');
            obj.RoadOutputMap(road_id) = [obj.RoadOutputMap(road_id), tmp_output_data];
        end
    end
end