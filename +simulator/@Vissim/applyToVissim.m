function applyToVissim(obj)
    obj.Com.Simulation.set('AttValue', 'NumRuns', obj.Config.simulation.count);                       % シミュレーション回数の設定をVissimに渡す
    obj.Com.Simulation.set('AttValue','RandSeed',obj.Config.vissim.seed);                             % 乱数シードの設定をVissimに渡す
    obj.Com.Simulation.set('AttValue','UseMaxSimSpeed',obj.Config.vissim.max_sim_speed);                                        % シミュレーションを最高速度で行うようにVissimを設定する
    obj.Com.Simulation.set('AttValue','UseAllCores',true);                                            % シミュレーションに全てのコアを使うようにVissimを設定する
    obj.Com.Simulation.set('AttValue','SimPeriod',obj.Config.simulation.time);                        % シミュレーション時間を設定する
    obj.Com.Simulation.set('AttValue','SimRes',obj.Config.vissim.resolution);                         % 解像度を設定                    
    obj.Com.Graphics.CurrentNetworkWindow.set('AttValue','QuickMode',obj.Config.vissim.graphic_mode); % 描画設定をVissimに渡す


    % VehicleInputsの設定
    obj.setVehicleInputs();

    % VehicleRoutesの設定
    obj.setVehicleRoutes();
end