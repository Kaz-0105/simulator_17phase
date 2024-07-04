function updateIntersectionCalcTimeMap(obj)
    % IntesectionControllerMapを取得
    IntersectionControllerMap = obj.Vissim.get('IntersectionControllerMap');

    % それぞれのキー（交差点）ごとにデータを取得
    for intersection_id = cell2mat(keys(IntersectionControllerMap))
        Controller = IntersectionControllerMap(intersection_id);
        
        % データを追加
        tmp_calc_time_data = Controller.get('calc_time');
        obj.IntersectionCalcTimeMap(intersection_id) = [obj.IntersectionCalcTimeMap(intersection_id), tmp_calc_time_data];
    end
end