function optimize(obj)
    obj.IntersectionOptStateMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    
    % IntersectionControllerMapのkeyを取得
    keys_intersection_controller_map = keys(obj.IntersectionControllerMap);
    keys_intersection_controller_map = [keys_intersection_controller_map{:}];

    for intersection_id = keys_intersection_controller_map
        % コントローラのオブジェクトを取得
        Controller = obj.IntersectionControllerMap(intersection_id);

        % 最適化計算を行う
        Controller.optimize();

        % 最適化結果を取得
        u_opt = Controller.get('u_opt');

        % 最適化結果をマップに格納
        obj.IntersectionOptStateMap(intersection_id) = u_opt;
    end
end