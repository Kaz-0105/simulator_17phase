function updateInputOutputData(obj, Maps)
    % LinkInputOutputMapを取得
    LinkInputOutputMap = Maps('LinkInputOutputMap');

    % LinkInputOutputMapのキーを取得
    keys_link_input_output_map = keys(LinkInputOutputMap);
    keys_link_input_output_map = [keys_link_input_output_map{:}];

    % LinkRoadMapを取得
    LinkRoadMap = Maps('LinkRoadMap');

    % LinkRoadMapのキーを取得
    keys_link_road_map = keys(LinkRoadMap);
    keys_link_road_map = [keys_link_road_map{:}];


    for link_id = keys_link_input_output_map
        if strcmp(LinkInputOutputMap(link_id),'input')
            road_id = LinkRoadMap(link_id);

            data_collection_measurement_id = obj.LinkDataCollectionMeasurementMap(link_id);
            DataCollectionMeasurement = obj.Com.Net.DataCollectionMeasurement.ItemByKey(data_collection_measurement_id);

            if ~ismember(road_id, cell2mat(keys(obj.InputDataMap)))
                obj.InputDataMap(road_id) = [DataCollectionMeasurement.get('AttValue', 'Vehs(Current, Last, All)')];
            else
                tmp_input_data = obj.InputDataMap(road_id);
                tmp_input_data = [tmp_input_data, DataCollectionMeasurement.get('AttValue', 'Vehs(Current, Last, All)')];
                obj.InputDataMap(road_id) = tmp_input_data;
            end

        elseif strcmp(LinkInputOutputMap(link_id),'output')
            road_id = LinkRoadMap(link_id);

            data_collection_measurement_id = obj.LinkDataCollectionMeasurementMap(link_id);
            DataCollectionMeasurement = obj.Com.Net.DataCollectionMeasurement.ItemByKey(data_collection_measurement_id);

            if ~ismember(road_id, cell2mat(keys(obj.OutputDataMap)))
                obj.OutputDataMap(road_id) = [DataCollectionMeasurement.get('AttValue', 'Vehs(Current, Last, All)')];
            else
                tmp_output_data = obj.OutputDataMap(road_id);
                tmp_output_data = [tmp_output_data, DataCollectionMeasurement.get('AttValue', 'Vehs(Current, Last, All)')];
                obj.OutputDataMap(road_id) = tmp_output_data;
            end
        end
    end
end