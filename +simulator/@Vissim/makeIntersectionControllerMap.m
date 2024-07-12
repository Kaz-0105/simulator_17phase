function makeIntersectionControllerMap(obj)
    obj.IntersectionControllerMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    for intersection_id = cell2mat(keys(obj.IntersectionStructMap))
        % 交差点の構造体を取得
        intersection_struct = obj.IntersectionStructMap(intersection_id);

        % 制御方法を取得
        control_method = intersection_struct.control_method;

        % 制御器のオブジェクトを作成
        if strcmp(control_method, 'Dan')
            % 道路の数を取得
            road_num = length(intersection_struct.input_road_ids);

            % Danクラスのオブジェクトを作成
            obj.IntersectionControllerMap(intersection_struct.id) = controller.Dan(intersection_id, obj, road_num);
        elseif strcmp(control_method, 'Fix')
        end   
    end
end
