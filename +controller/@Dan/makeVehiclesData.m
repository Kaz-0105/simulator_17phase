function makeVehiclesData(obj, IntersectionStructMap, VissimData)
    % RoadLinkPosVehsMapとRoadLinkRouteVehsMapとRoadLinkLaneVehsMapを作成
    obj.makeRoadLinkVehsDataMap();

    % RoadLinkLaneFirstVehsMapを作成
    obj.makeRoadLinkLaneFirstVehsMap();

    % RoadLinkNumVehsMapとRoadNumVehsMapを作成
    obj.makeRoadLinkNumVehsMap();
end