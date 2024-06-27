function updateStates(obj)
    obj.VissimData = simulator.VissimData(obj.Com, obj.Maps);
    
    for Controller = values(obj.IntersectionControllerMap)'
        Controller = Controller{1};
        Controller.updateStates(obj.IntersectionStructMap, obj.VissimData);
    end
end