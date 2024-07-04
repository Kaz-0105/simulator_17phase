function run(obj)
    % 今回の結果を表示
    obj.showResult(obj.isCompare);

    % 結果を保存
    if obj.isSave
        obj.VissimMeasurements.save();
    end
    
end