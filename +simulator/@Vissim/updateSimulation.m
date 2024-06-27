function updateSimulation(obj, sim_step)

    if sim_step == 1
        % break_timeを設定
        obj.break_time = obj.break_time + obj.Config.control_interval;
        obj.Com.Simulation.set('AttValue','SimBreakAt',obj.break_time);
        obj.Com.Simulation.RunContinuous();

        for intersection_id = keys(obj.IntersectionSignalControllerMap)'
            intersection_id = intersection_id{1};

            % SignalControllerのCOMオブジェクトを取得
            SignalController = obj.IntersectionSignalControllerMap(intersection_id);

            % Controllerクラスの変数を取得
            Controller = obj.IntersectionControllerMap(intersection_id);

            % 信号現示の制御権限を移しておく
            for signal_group_id = 1: SignalController.SGs.Count
                SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',1);
            end
        end
    else
        obj.updateStates();
        obj.optimize();

        for step = 1:obj.Config.control_horizon
            % 1ステップ先までbreak_timeを設定
            obj.break_time = obj.break_time + obj.Config.time_step;
            obj.Com.Simulation.set('AttValue','SimBreakAt',obj.break_time);

            for intersection_id = keys(obj.IntersectionSignalControllerMap)'
                intersection_id = intersection_id{1};

                % SignalControllerのCOMオブジェクトを取得
                SignalController = obj.IntersectionSignalControllerMap(intersection_id);

                % 最適な信号現示を取得
                u_opt = obj.IntersectionOptStateMap(intersection_id);

                % 信号現示を設定
                for signal_group_id = 1: SignalController.SGs.Count
                    if u_opt(signal_group_id, step) == 0
                        SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',1);
                    else
                        SignalController.SGs.ItemByKey(signal_group_id).set('AttValue','State',3);
                    end 
                end
            end

            % 1ステップ進める
            obj.Com.Simulation.RunContinuous();
        end
    end

    % 結果の測定を行う
    obj.VissimMeasurements.updateData(obj.Maps, obj.IntersectionControllerMap);
end