function update(obj)
    % 計測データの更新を行う関数
    obj.updateRoadInputMap();
    obj.updateRoadOutputMap();
    obj.updateIntersectionRoadQueueMap();
    obj.updateIntersectionCalcTimeMap();
    obj.updateIntersectionRoadNumVehsMap();
    obj.updateIntersectionRoadDelayMap();
    obj.updateVehicleSpeedsMap();
    obj.updateIntersectionRoadNumQueuesMap();
    
    % 時間の更新
    obj.time = [obj.time, obj.Vissim.get('current_time')];
end