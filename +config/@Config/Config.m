classdef Config<handle
    properties
        inpx_file;          % inpxファイルのパス 
        layx_file;          % layxファイルのパス
        graphic_mode;       % グラフィックモード
        seed;               % シード値
        predictive_horizon; % 予測ホライゾン
        control_horizon;    % 制御ホライゾン
        time_step;          % タイムステップ
        max_time;           % 最適化時間の上限
        control_interval;   % 制御のインターバル時間
        num_loop;           % MPCのサイクルのループ回数
        sim_count;          % シミュレーションする時間
        sim_resolution;     % シミュレーション時間で1sあたりに何回自動車の位置を更新するか(解像度)
        plot_list = {};     % 出力するデータ
        model_prms = [];    % 予測モデルのパラメータ
        groups = {};        % group構造体
    end

    methods
        function obj = Config(file_name, file_dir)
            data = yaml.loadFile(append(file_dir, file_name));

            % inpxファイルの設定 
            [inpx_dir, inpx_name, inpx_ext] = fileparts(data.inpx_file);

            if strlength(inpx_dir) == 0
                obj.inpx_file = char(append(file_dir, inpx_name, inpx_ext));
            else
                obj.inpx_file = char(append(pwd,'\', data.inpx_file));
            end

            % layxファイルの設定
            [layx_dir, layx_name, layx_ext] = fileparts(data.layx_file);                    % data.layx_fileをディレクトリ,名前,拡張子に分ける
            
            if strlength(layx_dir) == 0
                obj.layx_file = char(append(file_dir,layx_name,layx_ext));                        % ファイル名のみしかyamlファイルに記載されていない場合は,yamlファイルと同じディレクトリに存在するとする
            else
                obj.layx_file = char(append(pwd, '\', data.layx_file));                        % ディレクトリまで記載があった場合は,そのまま
            end

            % グラフィックモードの設定
            try
                obj.graphic_mode = data.graphic_mode;
            catch
                obj.graphic_mode = 0;
            end

            % シード値の設定
            try
                obj.seed = data.seed;
            catch
                obj.seed = randi(100);
            end

            % シミュレーションの解像度の設定（シミュレーション内の時間で1秒間に何回自動車の位置を更新するか）
            try
                obj.sim_resolution = data.sim_resolution;
            catch
                obj.sim_resolution = 10;
            end

            % 予測ホライゾンの設定
            obj.predictive_horizon = data.predictive_horizon;

            % 制御ホライズンの設定
            obj.control_horizon = data.control_horizon;

            % タイムステップの設定
            obj.time_step = data.time_step;

            % 最適化時間の上限を設定
            obj.max_time = data.max_time;

            % 制御のインターバル時間の設定
            obj.control_interval = obj.control_horizon*obj.time_step;

            % MPCのサイクルのループの回数
            obj.num_loop = data.num_loop;

            % シミュレーションの回数
            obj.sim_count = data.sim_count;

            % 出力するデータに関して
            for plot = data.plot_list
                plot = plot{1};

                plot_struct = [];
                plot_struct.data = plot.data;
                plot_struct.type = plot.type;

                obj.plot_list{end+1} = plot_struct;
            end


            % group構造体の作成（道路の配置や進路割合などをまとめた構造体）
            group_files = data.groups;
            for group_file = group_files
                group_file = group_file{1};
                roads_file = group_file{1};
                intersections_file = group_file{2};

                [roads_file_dir, roads_file_name, roads_file_ext] = fileparts(roads_file);
                [intersections_file_dir, intersections_file_name, intersections_file_ext] = fileparts(intersections_file);

                if strlength(roads_file_dir) == 0
                    roads_file = char(append(file_dir, roads_file_name, roads_file_ext));
                end

                if strlength(intersections_file_dir) == 0
                    intersections_file = char(append(file_dir, intersections_file_name, intersections_file_ext));
                end

                obj.groups{end+1} = config.Config.parseGroup(roads_file, intersections_file);  % 1つのエリアの情報をまとめたgroup構造体をgroupsとしてセル配列にまとめる
            end

            % 予測モデルのパラメータの設定（修正必要）
            obj.model_prms = yaml.loadFile(append(file_dir, 'config_dan.yaml'));
        end

        function showControlMethod(obj)
            for group = obj.groups
                group = group{1};
                for intersection_struct = group.intersections
                    intersection_struct = intersection_struct{1};
                    if strcmp(intersection_struct.control_method, 'Dan4')
                        fprintf('交差点%dの制御方法: MPC(十字路)\n', intersection_struct.id);
                    elseif strcmp(intersection_struct.control_method, 'Fix4')
                        fprintf('交差点%dの制御方法: 固定式(十字路)\n', intersection_struct.id);
                    elseif strcmp(intersection_struct.control_method, 'Dan3')
                        fprintf('交差点%dの制御方法: MPC(三叉路)\n', intersection_struct.id);
                    elseif strcmp(intersection_struct.control_method, 'Fix3')
                        fprintf('交差点%dの制御方法: 固定式(三叉路)\n', intersection_struct.id);
                    end
                end
            end
        end
    end

    methods(Access = private)
    end

    methods(Static)
        group = parseGroup(roads_file, intersections_file);
    end
    
end

