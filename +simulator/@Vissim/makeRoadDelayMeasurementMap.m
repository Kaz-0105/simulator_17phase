function makeRoadDelayMeasurementMap(obj)
    % RoadDelayMeasurementMapの初期化
    obj.RoadDelayMeasurementMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    for DelayMeasurement = obj.Com.Net.DelayMeasurements.GetAll()'
        % DelayMeasurementのComオブジェクトを取得
        DelayMeasurement = DelayMeasurement{1};
        
        % VehicleTravelTimeMeasurementのComオブジェクトを取得
        VehicleTravelTimeMeasurements = DelayMeasurement.VehTravTmMeas;
        VehicleTravelTimeMeasurement = VehicleTravelTimeMeasurements.GetAll();
        VehicleTravelTimeMeasurement = VehicleTravelTimeMeasurement{1};

        % StartLinkのComオブジェクトを取得
        StartLink = VehicleTravelTimeMeasurement.StartLink;

        % road_idとdelay_measurement_idを取得
        road_id = obj.LinkRoadMap(StartLink.get('AttValue', 'No'));
        delay_measurement_id = DelayMeasurement.get('AttValue', 'No');

        % RoadDelayMeasurementMapに格納
        if isKey(obj.RoadDelayMeasurementMap, road_id)
            obj.RoadDelayMeasurementMap(road_id) = [obj.RoadDelayMeasurementMap(road_id), delay_measurement_id];
        else
            obj.RoadDelayMeasurementMap(road_id) = delay_measurement_id;
        end
    end
end