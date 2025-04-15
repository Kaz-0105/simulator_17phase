clear;
close all;

% 実験のパラメータを作成
control_method_list = "Dan";

num_phases_list = [4];

seed_list = 1;

input1_list = 900;
input2_list = 500;
input3_list = 900;
input4_list = 500;

yellow_time_list = 1;
red_time_list = 1;

N_p_list = 5;
N_c_list = 2;
N_s_list = 5;

for control_method = control_method_list
    for num_phases = num_phases_list
        for seed = seed_list
            for input1 = input1_list
                for input2 = input2_list
                    for input3 = input3_list
                        for input4 = input4_list   
                            for yellow_time = yellow_time_list
                                for red_time = red_time_list
                                    for N_p = N_p_list
                                        for N_c = N_c_list
                                            for N_s = N_s_list
                                                % Configクラスの変数の作成
                                                Config = config.Config();

                                                %% control_methodの設定
                                                
                                                % IntersectionsMapを取得
                                                IntersectionsMap = Config.network.GroupsMap(1).IntersectionsMap;

                                                % Intersectionを走査
                                                for intersection_id = cell2mat(IntersectionsMap.keys)
                                                    % intersection_structを取得
                                                    intersection_struct = IntersectionsMap(intersection_id);

                                                    % control_methodを設定
                                                    intersection_struct.control_method = char(control_method);

                                                    % intersection_structをIntersectionsMapにプッシュ
                                                    IntersectionsMap(intersection_id) = intersection_struct;
                                                end

                                                %% num_phasesの設定

                                                % NumRoadsNumPhasesMapを取得
                                                NumRoadsNumPhasesMap = Config.model.dan.NumRoadsNumPhasesMap;

                                                % 十字路のところを変更
                                                NumRoadsNumPhasesMap(4) = num_phases;

                                                %% seedの設定
                                                Config.vissim.seed = seed;

                                                %% inputの設定

                                                % VehicleInputsMapを取得
                                                VehicleInputsMap = Config.network.GroupsMap(1).PrmsMap('vehicle_inputs');

                                                % input_structを取得
                                                input1_struct = VehicleInputsMap(1);
                                                input2_struct = VehicleInputsMap(2);
                                                input3_struct = VehicleInputsMap(3);
                                                input4_struct = VehicleInputsMap(4);

                                                % volumeを設定
                                                input1_struct.volume = input1;
                                                input2_struct.volume = input2;
                                                input3_struct.volume = input3;
                                                input4_struct.volume = input4;

                                                % VehicleInputsMapにプッシュ
                                                VehicleInputsMap(1) = input1_struct;
                                                VehicleInputsMap(2) = input2_struct;
                                                VehicleInputsMap(3) = input3_struct;
                                                VehicleInputsMap(4) = input4_struct;

                                                %% yellow_time, red_timeの設定
                                                Config.intersection.yellow_time = yellow_time;
                                                Config.intersection.red_time = red_time;

                                                %% N_p, N_c, N_sの設定
                                                Config.mpc.predictive_horizon = N_p;
                                                Config.mpc.control_horizon = N_c;
                                                Config.model.dan.N_s = N_s;

                                                if N_p - N_s > 0
                                                    Config.model.dan.m = 2;
                                                end

                                                % 制御方法の表示
                                                Config.displayControlMethod();

                                                % Vissimクラスの作成
                                                Vissim = simulator.Vissim(Config);

                                                % シミュレーションを行う
                                                Vissim.run();

                                                clear Config;
                                                clear Vissim;

                                                close all;
                                            end
                                        end
                                    end
                                end 
                            end
                        end
                    end
                end
            end
        end
    end
end