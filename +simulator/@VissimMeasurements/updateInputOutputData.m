function updateInputOutputData(obj)
    % LinkInputOutputMapを取得
    LinkInputOutputMap = obj.Vissim.get('LinkInputOutputMap');

    % LinkRoadMapを取得
    LinkRoadMap = obj.Vissim.get('LinkRoadMap');


    for link_id = cell2mat(keys(LinkInputOutputMap))
        if strcmp(LinkInputOutputMap(link_id),'input')
            road_id = LinkRoadMap(link_id);

            data_collection_measurement_id = obj.LinkDataCollectionMeasurementMap(link_id);
            DataCollectionMeasurement = obj.Com.Net.DataCollectionMeasurement.ItemByKey(data_collection_measurement_id);

            if ~ismember(road_id, cell2mat(keys(obj.RoadInputMap)))
                obj.RoadInputMap(road_id) = [DataCollectionMeasurement.get('AttValue', 'Vehs(Current, Last, All)')];
            else
                tmp_input_data = obj.RoadInputMap(road_id);
                tmp_input_data = [tmp_input_data, DataCollectionMeasurement.get('AttValue', 'Vehs(Current, Last, All)')];
                obj.RoadInputMap(road_id) = tmp_input_data;
            end

        elseif strcmp(LinkInputOutputMap(link_id),'output')
            road_id = LinkRoadMap(link_id);

            data_collection_measurement_id = obj.LinkDataCollectionMeasurementMap(link_id);
            DataCollectionMeasurement = obj.Com.Net.DataCollectionMeasurement.ItemByKey(data_collection_measurement_id);

            if ~ismember(road_id, cell2mat(keys(obj.RoadOutputMap)))
                obj.RoadOutputMap(road_id) = [DataCollectionMeasurement.get('AttValue', 'Vehs(Current, Last, All)')];
            else
                tmp_output_data = obj.RoadOutputMap(road_id);
                tmp_output_data = [tmp_output_data, DataCollectionMeasurement.get('AttValue', 'Vehs(Current, Last, All)')];
                obj.RoadOutputMap(road_id) = tmp_output_data;
            end
        end
    end
end