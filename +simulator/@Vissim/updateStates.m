function updateStates(obj)
    obj.VissimData = simulator.VissimData(obj);
    
    for intersection_id = cell2mat(keys(obj.IntersectionControllerMap))
        Controller = obj.IntersectionControllerMap(intersection_id);
        Controller.updateStates();
    end
end