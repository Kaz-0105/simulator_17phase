function run(obj)
    for sim_count = 1:obj.Config.simulation.count
        % シミュレーションの開始を表示
        fprintf('%d回目のシミュレーションを開始しました。\n', sim_count);

        % Vissimクラスの再初期化
        obj.clear_states();
        
        
        while obj.get('current_time') < obj.Config.simulation.time
            % 最適化の予測の回数をインクリメント
            obj.prediction_count = obj.prediction_count + 1;

            % 何回目の最適化計算かを表示
            fprintf('%d回目の最適化計算を行います。\n', obj.prediction_count);

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