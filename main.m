clear;
close all;

% Configクラスの変数の作成
Config = config.Config();

% 制御方法の表示
Config.displayControlMethod();

% Vissimクラスの作成
Vissim = simulator.Vissim(Config);

% シミュレーションを行う
Vissim.run();