function updateNumVehsData(obj)
    IntersectionControllerMap = obj.Vissim.get('IntersectionControllerMap');

    for intersection_id = cell2mat(keys(IntersectionControllerMap))
        Controller = IntersectionControllerMap(intersection_id);
        RoadNumVehsMap = Controller.get('RoadNumVehsMap');

        sum = 0;
        for road_id = cell2mat(keys(RoadNumVehsMap))
            sum = sum + RoadNumVehsMap(road_id);
        end

        if ~ismember(intersection_id, cell2mat(keys(obj.RoadNumVehsMap)))
            obj.RoadNumVehsMap(intersection_id) = sum;
        else
            obj.RoadNumVehsMap(intersection_id) = [obj.RoadNumVehsMap(intersection_id), sum];
        end
    end
    
end