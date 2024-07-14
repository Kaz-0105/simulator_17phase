function makeVehiclesData(obj, IntersectionStructMap, VissimData)
    % RoadLinkPosVehsMapとRoadLinkRouteVehsMapとRoadLinkLaneVehsMapを作成
    obj.makeRoadLinkVehsDataMap();

    % RoadLinkFirstVehsMapを作成
    obj.makeRoadLinkFirstVehsMap();

    % RoadLinkNumVehsMapとRoadNumVehsMapを作成
    obj.makeRoadLinkNumVehsMap();
end