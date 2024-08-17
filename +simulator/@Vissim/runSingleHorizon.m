function runSingleHorizon(obj)
    if obj.prediction_count == 1
        % break_timeを設定
        obj.break_time = obj.break_time + obj.Config.mpc.control_interval;
        obj.Com.Simulation.set('AttValue','SimBreakAt',obj.break_time);
        obj.Com.Simulation.RunContinuous();

    else
        % 状態の更新
        obj.updateStates();

        % 最適化を行う
        obj.optimize();

        % クリアリング時間が赤信号、黄信号ともに存在する場合
        if obj.clearing_time_flag == 1
            % 各ステップごとに繰り返し処理を行う
            for step = 1 : 2 * obj.Config.mpc.control_horizon
                % 繰り返し処理で各交差点の信号現示をVISSIMに設定
                for intersection_id = cell2mat(keys(obj.IntersectionSignalControllerMap))
                    % 制御方法を取得
                    intersection_struct = obj.IntersectionStructMap(intersection_id);
                    control_method = intersection_struct.control_method;

                    % 制御手法で処理を分ける（固定式の場合はスキップ）
                    if strcmp(control_method, 'Fixed')
                        continue;
                    end

                    % SignalControllerのCOMオブジェクトを取得
                    SignalController = obj.IntersectionSignalControllerMap(intersection_id);

                    % 最適な信号現示を取得
                    tmp_u_opt = obj.IntersectionOptStateMap(intersection_id);

                    u_opt = [];
                    for u_vec = tmp_u_opt
                        % 列を２倍に増やす
                        u_opt = [u_opt, u_vec, u_vec];
                    end

                    % 各SignalGroupに対して信号現示を設定
                    for signal_group_id = 1: SignalController.SGs.Count
                        % 最適な信号現示が赤のとき
                        if u_opt(signal_group_id, step) == 0
                            SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',1);

                        % 最適な信号現示が青のとき
                        elseif u_opt(signal_group_id, step) == 1
                            % 1つ先が赤信号のときは赤信号を出す
                            if u_opt(signal_group_id, step + 1) == 0
                                SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',1);
                            % 2つ先が赤信号のときは黄信号を出す
                            elseif u_opt(signal_group_id, step + 2) == 0
                                SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',2);
                            % それ以外は青信号を出す
                            else
                                SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',3);
                            end
                        end 
                    end
                end

                % 1ステップ先までbreak_timeを設定
                obj.break_time = obj.break_time + obj.Config.mpc.time_step/2;

                % シミュレーションの終了時刻を超えたらストップ
                if obj.break_time >= obj.Config.simulation.time
                    % 時間を最終時刻に設定
                    obj.break_time = obj.Config.simulation.time;

                    % break_timeを設定
                    obj.Com.Simulation.set('AttValue','SimBreakAt',obj.break_time);

                    % 1ステップ進める
                    obj.Com.Simulation.RunContinuous();

                    % ループを抜ける
                    break;
                end

                % break_timeを設定
                obj.Com.Simulation.set('AttValue','SimBreakAt',obj.break_time);

                % 1ステップ進める
                obj.Com.Simulation.RunContinuous();
            end

        % クリアリング時間が赤信号のみ、黄信号のみ、または存在しない場合
        else
            % 各ステップごとに繰り返し処理を行う
            for step = 1:obj.Config.mpc.control_horizon
                % 繰り返し処理で各交差点の信号現示をVISSIMに設定
                for intersection_id = cell2mat(keys(obj.IntersectionSignalControllerMap))
                    % 制御方法を取得
                    intersection_struct = obj.IntersectionStructMap(intersection_id);
                    control_method = intersection_struct.control_method;

                    % 制御手法で処理を分ける（固定式の場合はスキップ）
                    if strcmp(control_method, 'Fixed')
                        continue;
                    end

                    % SignalControllerのCOMオブジェクトを取得
                    SignalController = obj.IntersectionSignalControllerMap(intersection_id);
    
                    % 最適な信号現示を取得
                    u_opt = obj.IntersectionOptStateMap(intersection_id);
    
                    % SignalGroupごとに信号現示を設定
                    for signal_group_id = 1: SignalController.SGs.Count
                        % 最適な信号現示が赤のとき
                        if u_opt(signal_group_id, step) == 0
                            SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',1);
                        % 最適な信号現示が青のとき
                        elseif u_opt(signal_group_id, step) == 1
                            % 1つ先が赤信号のとき
                            if u_opt(signal_group_id, step + 1) == 0
                                % クリアリング時間が黄信号のみの場合
                                if obj.clearing_time_flag == 2
                                    SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',2);
                                % クリアリング時間が赤信号のみの場合
                                elseif obj.clearing_time_flag == 3
                                    SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',1);
                                % クリアリング時間がない場合
                                else
                                    SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',3);
                                end
                            % 1つ先も青信号のとき
                            else
                                SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',3);
                            end
                        end 
                    end 
                end
    
                % 1ステップ先までbreak_timeを設定
                obj.break_time = obj.break_time + obj.Config.mpc.time_step;
    
                % シミュレーションの終了時刻を超えたらストップ
                if obj.break_time >= obj.Config.simulation.time
                    % 時間を最終時刻に設定
                    obj.break_time = obj.Config.simulation.time;
    
                    % break_timeを設定
                    obj.Com.Simulation.set('AttValue','SimBreakAt',obj.break_time);
    
                    % 1ステップ進める
                    obj.Com.Simulation.RunContinuous();
    
                    break;
                end

                % break_timeを設定
                obj.Com.Simulation.set('AttValue','SimBreakAt',obj.break_time);

                % 1ステップ進める
                obj.Com.Simulation.RunContinuous();
            end
        end
    end

    % current_timeを更新
    obj.current_time = obj.break_time;

    % 結果の測定を行う
    obj.VissimMeasurements.update();
end