function updateCalcTimeData(obj)
    % IntesectionControllerMapを取得
    IntersectionControllerMap = obj.Vissim.get('IntersectionControllerMap');

    % それぞれのキー（交差点）ごとにデータを取得
    for intersection_id = cell2mat(keys(IntersectionControllerMap))
        Controller = IntersectionControllerMap(intersection_id);
        if ~ismember(intersection_id, cell2mat(keys(obj.IntersectionCalcTimeMap)))
            obj.IntersectionCalcTimeMap(intersection_id) = [Controller.get('calc_time')];
        else
            tmp_calc_time_data = obj.IntersectionCalcTimeMap(intersection_id);
            tmp_calc_time_data = [tmp_calc_time_data, Controller.get('calc_time')];

            obj.IntersectionCalcTimeMap(intersection_id) = tmp_calc_time_data;
        end
    end

end