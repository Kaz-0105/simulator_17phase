function updateCalcTimeData(obj, IntersectionControllerMap)
    % IntersectionControllerMapのキーを取得
    keys_intersection_controller_map = keys(IntersectionControllerMap);
    keys_intersection_controller_map = [keys_intersection_controller_map{:}];

    % それぞれのキー（交差点）ごとにデータを取得
    for intersection_id = keys_intersection_controller_map
        Controller = IntersectionControllerMap(intersection_id);
        if ~ismember(intersection_id, cell2mat(keys(obj.CalcTimeDataMap)))
            obj.CalcTimeDataMap(intersection_id) = [Controller.get('calc_time')];
        else
            tmp_calc_time_data = obj.CalcTimeDataMap(intersection_id);
            tmp_calc_time_data = [tmp_calc_time_data, Controller.get('calc_time')];

            obj.CalcTimeDataMap(intersection_id) = tmp_calc_time_data;
        end
    end

end