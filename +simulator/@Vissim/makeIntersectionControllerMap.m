function makeIntersectionControllerMap(obj)
    obj.IntersectionControllerMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    for intersection_id = cell2mat(keys(obj.IntersectionStructMap))
        intersection_struct = obj.IntersectionStructMap(intersection_id);
        switch intersection_struct.control_method
            case 'Dan'
                obj.IntersectionControllerMap(intersection_struct.id) = controller.Dan(intersection_struct.id, obj);
            case 'Dan3'
                obj.IntersectionControllerMap(intersection_struct.id) = controller.Dan3(intersection_struct.id, obj);
            case 'DanOld4'
                obj.IntersectionControllerMap(intersection_struct.id) = controller.DanOld4(intersection_struct.id, obj);
            case 'Fix3'
                obj.IntersectionControllerMap(intersection_struct.id) = controller.Fix3(intersection_struct.id, obj);
            case 'Fix4'
                obj.IntersectionControllerMap(intersection_struct.id) = controller.Fix4(intersection_struct.id, obj);

        end    
    end
end
