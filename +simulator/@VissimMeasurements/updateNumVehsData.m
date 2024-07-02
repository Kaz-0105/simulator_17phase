function updateNumVehsData(obj, IntersectionControllerMap)
    % IntersectionControllerMapのキーを取得
    keys_intersection_controller_map = keys(IntersectionControllerMap);
    keys_intersection_controller_map = [keys_intersection_controller_map{:}];
    
    for intersection_id = keys_intersection_controller_map
        Controller = IntersectionControllerMap(intersection_id);
        RoadNumVehsMap = Controller.get('RoadNumVehsMap');

        sum = 0;
        for road_id = cell2mat(keys(RoadNumVehsMap))
            sum = sum + RoadNumVehsMap(road_id);
        end

        if ~ismember(intersection_id, cell2mat(keys(obj.NumVehsDataMap)))
            obj.NumVehsDataMap(intersection_id) = sum;
        else
            obj.NumVehsDataMap(intersection_id) = [obj.NumVehsDataMap(intersection_id), sum];
        end
    end
    
end