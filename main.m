clear;
close all;

% Configクラスの変数の作成
file_name = 'Config.yaml';
file_dir = strcat(pwd, '\layout\');
Config = config.Config(file_name, file_dir);

% 制御方法の表示
Config.showControlMethod();

% Vissimクラスの作成
Vissim = simulator.Vissim(Config);

% VissimクラスのCOMオブジェクトを取得
Com = Vissim.get('Com');

% シミュレーションを行う

for sim_count = 1:Config.sim_count
    fprintf('%d回目のシミュレーションを開始します。\n', sim_count);
    Vissim.clear_states();

    for sim_step = 1:Config.num_loop
        fprintf('%d回目の最適化計算を行っています。\n', sim_step);
        
        Vissim.updateSimulation(sim_step);
      
    end

    data_analysis = tool.data_analysis(Vissim.get('VissimMeasurements'), Config);

    % 性能指標の表示
    fprintf("Queue Length: %f\n", data_analysis.get_performance_index());

    data_analysis.save_figure_structs();

    data_analysis.compare_results();
end


