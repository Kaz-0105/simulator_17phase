function optimize(obj)
    obj.IntersectionOptStateMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    for intersection_id = cell2mat(obj.IntersectionControllerMap.keys)
        % 制御方法を取得
        intersection_struct = obj.IntersectionStructMap(intersection_id);
        control_method = intersection_struct.control_method;

        % コントローラのオブジェクトを取得
        Controller = obj.IntersectionControllerMap(intersection_id);

        % 制御方法で処理を分ける（固定式の場合は予測回数だけ設定）
        if strcmp(control_method, 'Fixed')
            Controller.set('prediction_count', obj.prediction_count);
            continue;
        end

        % 最適化計算を行う
        Controller.optimize();

        % 最適化結果を取得
        u_opt = Controller.get('u_opt');

        % 最適化結果をマップに格納
        obj.IntersectionOptStateMap(intersection_id) = u_opt;
    end
end