function run(obj)
    for sim_count = 1:obj.Config.simulation.count
        fprintf('%d回目のシミュレーションを開始します。\n', sim_count);
        obj.clear_states();
        
        count = 0;
        while obj.get('current_time') < obj.Config.simulation.time
            count = count + 1;
            fprintf('%d回目の最適化計算を行っています。\n', count);
            obj.runSingleHorizon(count);
        end
    
        ResultVisualizer = tool.ResultVisualizer(obj.get('VissimMeasurements'), Config);
    
        % 性能指標の表示
        fprintf("Queue Length: %f\n", ResultVisualizer.get_performance_index());
    
        ResultVisualizer.save_figure_structs();
    
        ResultVisualizer.compare_results();
    end
end