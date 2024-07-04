function updateData(obj)
    % 計測データの更新を行う関数
    obj.updateInputOutputData();
    obj.updateQueueData();
    obj.updateCalcTimeData();
    obj.updateNumVehsData();
    
    % 時間の更新
    obj.time = [obj.time, obj.Vissim.get('current_time')];
end