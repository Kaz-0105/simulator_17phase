function run(obj)
    for sim_count = 1:obj.Config.simulation.count
        fprintf('%d回目のシミュレーションを開始します。\n', sim_count);
        obj.clear_states();
    
        while obj.get('current_time') < obj.Config.simulation.time
            obj.prediction_count = obj.prediction_count + 1;
            fprintf('%d回目の最適化計算を行っています。\n', obj.prediction_count);
            obj.runSingleHorizon();
        end
    
        ResultVisualizer = tool.ResultVisualizer(obj, obj.Config);
    
        % 性能指標の表示
        fprintf("Queue Length: %f\n", ResultVisualizer.get_performance_index());
    
        ResultVisualizer.save_figure_structs();
    
        ResultVisualizer.compare_results();
    end
end