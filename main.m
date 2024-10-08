clear;
close all;

% Configクラスの変数の作成
file_name = 'config.yaml';
file_dir = strcat(pwd, '\layout\');
Config = config.Config(file_name, file_dir);

% 制御方法の表示
Config.displayControlMethod();

% Vissimクラスの作成
Vissim = simulator.Vissim(Config);

% シミュレーションを行う
Vissim.run();