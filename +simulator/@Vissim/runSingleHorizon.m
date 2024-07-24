function runSingleHorizon(obj)

    if obj.prediction_count == 1
        % break_timeを設定
        obj.break_time = obj.break_time + obj.Config.mpc.control_interval;
        obj.Com.Simulation.set('AttValue','SimBreakAt',obj.break_time);
        obj.Com.Simulation.RunContinuous();

        for intersection_id = cell2mat(keys(obj.IntersectionSignalControllerMap))
            % SignalControllerのCOMオブジェクトを取得
            SignalController = obj.IntersectionSignalControllerMap(intersection_id);

            % Controllerクラスの変数を取得
            % Controller = obj.IntersectionControllerMap(intersection_id);

            % 信号現示の制御権限を移しておく
            for signal_group_id = 1: SignalController.SGs.Count
                SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',1);
            end
        end
    else
        % 状態の更新
        obj.updateStates();

        % 最適化を行う
        obj.optimize();

        % クリアリングのタイプによって処理を分ける
        if obj.clearing_time_flag == 1
            for step = 1 : 2 * obj.Config.mpc.control_horizon
                for intersection_id = cell2mat(keys(obj.IntersectionSignalControllerMap))
                    % SignalControllerのCOMオブジェクトを取得
                    SignalController = obj.IntersectionSignalControllerMap(intersection_id);

                    % 最適な信号現示を取得
                    tmp_u_opt = obj.IntersectionOptStateMap(intersection_id);

                    u_opt = [];
                    for u_vec = tmp_u_opt
                        % 列を２倍に増やす
                        u_opt = [u_opt, u_vec];
                        u_opt = [u_opt, u_vec];
                    end

                    % 信号現示を設定
                    for signal_group_id = 1: SignalController.SGs.Count
                        if u_opt(signal_group_id, step) == 0
                            % 現在赤信号のとき
                            % 赤信号を出す
                            SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',1);
                        
                        elseif u_opt(signal_group_id, step) == 1
                            % 現在青信号のとき
                            if u_opt(signal_group_id, step + 1) == 0
                                % 1つ先が赤信号のときは赤信号を出す
                                SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',1);

                            elseif u_opt(signal_group_id, step + 2) == 0
                                % 2つ先が赤信号のときは黄信号を出す
                                SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',2);

                            else
                                % それ以外は青信号を出す
                                SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',3);

                            end
                        end 
                    end
                end

                % 1ステップ先までbreak_timeを設定
                obj.break_time = obj.break_time + obj.Config.mpc.time_step/2;

                if obj.break_time >= obj.Config.simulation.time
                    obj.break_time = obj.Config.simulation.time;

                    obj.Com.Simulation.set('AttValue','SimBreakAt',obj.break_time);

                    % 1ステップ進める
                    obj.Com.Simulation.RunContinuous();

                    break;
                else
                    obj.Com.Simulation.set('AttValue','SimBreakAt',obj.break_time);

                    % 1ステップ進める
                    obj.Com.Simulation.RunContinuous();
                end
            end
        else
            for step = 1:obj.Config.mpc.control_horizon
                for intersection_id = cell2mat(keys(obj.IntersectionSignalControllerMap))
                    % SignalControllerのCOMオブジェクトを取得
                    SignalController = obj.IntersectionSignalControllerMap(intersection_id);
    
                    % 最適な信号現示を取得
                    u_opt = obj.IntersectionOptStateMap(intersection_id);
    
                    % 信号現示を設定
                    
                    for signal_group_id = 1: SignalController.SGs.Count
                        if u_opt(signal_group_id, step) == 0
                            % 現在赤信号のときは赤信号を出す
                            SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',1);
                        
                        elseif u_opt(signal_group_id, step) == 1
                            % 現在青信号のとき
                            if u_opt(signal_group_id, step + 1) == 0
                                if obj.clearing_time_flag == 2
                                    % 1つ先が赤信号のときは黄色信号を出す
                                    SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',2);
                                elseif obj.clearing_time_flag == 3
                                    % 1つ先が赤信号のときは赤信号を出す
                                    SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',1);
                                else
                                    % 1つ先が赤信号のときも青信号を出す
                                    SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',3);
                                end
                            else
                                % １つ先が青の時は青信号を出す
                                SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',3);
                            end
                        end 
                    end
                    
                end
    
                % 1ステップ先までbreak_timeを設定
                obj.break_time = obj.break_time + obj.Config.mpc.time_step;
    
                if obj.break_time >= obj.Config.simulation.time
                    obj.break_time = obj.Config.simulation.time;
    
                    obj.Com.Simulation.set('AttValue','SimBreakAt',obj.break_time);
    
                    % 1ステップ進める
                    obj.Com.Simulation.RunContinuous();
    
                    break;
                else
                    obj.Com.Simulation.set('AttValue','SimBreakAt',obj.break_time);
    
                    % 1ステップ進める
                    obj.Com.Simulation.RunContinuous();
                end
            end
        end
    end

    % current_timeを更新
    obj.current_time = obj.break_time;

    % 結果の測定を行う
    obj.VissimMeasurements.update();
end