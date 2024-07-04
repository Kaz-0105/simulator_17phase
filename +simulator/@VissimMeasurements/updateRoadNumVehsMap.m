function updateRoadNumVehsMap(obj)
    % IntesectionControllerMapを取得
    IntersectionControllerMap = obj.Vissim.get('IntersectionControllerMap');

    for intersection_id = cell2mat(keys(IntersectionControllerMap))
        % Controllerクラスを取得
        Controller = IntersectionControllerMap(intersection_id);

        % RoadNumVehsMapを取得
        RoadNumVehsMap = Controller.get('RoadNumVehsMap');

        % システム内に存在する自動車の数を計算
        sum = 0;
        for road_id = cell2mat(keys(RoadNumVehsMap))
            sum = sum + RoadNumVehsMap(road_id);
        end

        % データを追加
        obj.RoadNumVehsMap(intersection_id) = [obj.RoadNumVehsMap(intersection_id), sum]; 
    end
end