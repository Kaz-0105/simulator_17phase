function run(obj)
    for sim_count = 1:obj.Config.simulation.count
        % シミュレーションの開始を表示
        if mod(sim_count, 10) == 1
            fprintf('Start the %dst simulation.\n', sim_count);
        elseif mod(sim_count, 10) == 2
            fprintf('Start the %dnd simulation.\n', sim_count);
        elseif mod(sim_count, 10) == 3
            fprintf('Start the %drd simulation.\n', sim_count);
        else
            fprintf('Start the %dth simulation.\n', sim_count);
        end

        % Vissimクラスの再初期化
        obj.clear_states();
    
        while obj.get('current_time') < obj.Config.simulation.time
            % 最適化の予測の回数をインクリメント
            obj.prediction_count = obj.prediction_count + 1;

            % 何回目の最適化計算かを表示
            if mod(obj.prediction_count, 10) == 1
                fprintf('The %dst optimization calculation is performed.\n', obj.prediction_count);
            elseif mod(obj.prediction_count, 10) == 2
                fprintf('The %dnd optimization calculation is performed.\n', obj.prediction_count);
            elseif mod(obj.prediction_count, 10) == 3
                fprintf('The %drd optimization calculation is performed.\n', obj.prediction_count);
            else
                fprintf('The %dth optimization calculation is performed.\n', obj.prediction_count);
            end

            % 一回の最適化分のシミュレーションを実行
            obj.runSingleHorizon();
        end

        % 結果の保存
        if obj.save_flag
            obj.VissimMeasurements.save();
        end
    
        % 結果表示のクラスを初期化
        ResultVisualizer = tool.ResultVisualizer(obj, obj.Config);

        % 結果表示
        ResultVisualizer.run();
    end
end