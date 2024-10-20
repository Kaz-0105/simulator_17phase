classdef Config<handle
    properties
        % 構造体
        network;
        vissim;
        mpc;
        simulation;
        model;
        result;
        graph;
        intersection;
    end

    properties
        % 普通の変数
        file_name;
        file_dir;
    end

    methods
        function obj = Config()
            % ファイル名とディレクトリの設定
            obj.file_name = 'config.yaml';
            obj.file_dir = strcat(pwd, '\layout\');
            
            % 設定ファイルの読み込み
            data = yaml.loadFile(append(obj.file_dir, obj.file_name));

            % network構造体の設定
            obj.makeNetworkStruct(data);

            % vissim構造体の設定
            obj.makeVissimStruct(data);

            % mpc構造体の設定
            obj.makeMpcStruct(data);

            % simulation構造体の設定
            obj.makeSimulationStruct(data);

            % model構造体の設定
            obj.makeModelStruct(data);

            % result構造体の設定
            obj.makeResultStruct(data);

            % graph構造体の設定
            obj.makeGraphStruct(data);

            % intersection構造体の設定
            obj.makeIntersectionStruct(data);
        end
    end

    methods
        displayControlMethod(obj);
        
    end

    methods
        group = parseGroup(obj, group_data);
    end
end

