function updateIntersectionRoadNumVehsMap(obj)
    % IntesectionControllerMapを取得
    IntersectionControllerMap = obj.Vissim.get('IntersectionControllerMap');

    for intersection_id = cell2mat(keys(IntersectionControllerMap))
        % Controllerクラスを取得
        Controller = IntersectionControllerMap(intersection_id);

        % RoadNumVehsMapを取得
        RoadNumVehsMap = Controller.get('RoadNumVehsMap');

        for road_id = cell2mat(keys(RoadNumVehsMap))
            % 現在のデータを取得
            tmp_data = obj.IntersectionRoadNumVehsMap.get(intersection_id, road_id);

            % データを追加
            tmp_data(end+1) = RoadNumVehsMap(road_id);

            % マップに格納
            obj.IntersectionRoadNumVehsMap.set(intersection_id, road_id, tmp_data);
        end 
    end
end