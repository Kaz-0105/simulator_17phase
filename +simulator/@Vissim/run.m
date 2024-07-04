function run(obj)
    for sim_count = 1:obj.Config.simulation.count
        fprintf('%d回目のシミュレーションを開始します。\n', sim_count);
        obj.clear_states();
    
        while obj.get('current_time') < obj.Config.simulation.time
            obj.prediction_count = obj.prediction_count + 1;
            fprintf('%d回目の最適化計算を行っています。\n', obj.prediction_count);
            obj.runSingleHorizon();
        end
    
        % 結果を表示するクラスを初期化
        ResultVisualizer = tool.ResultVisualizer(obj, obj.Config);
        ResultVisualizer.run();
    end
end