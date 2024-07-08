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
    end

    properties
        % 普通の変数
        file_name;
        file_dir;
    end

    methods
        function obj = Config(file_name, file_dir)
            % ファイル名とディレクトリの設定
            obj.file_name = file_name;
            obj.file_dir = file_dir;

            % 設定ファイルの読み込み
            data = yaml.loadFile(append(file_dir, file_name));

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
        end
    end

    methods
        displayControlMethod(obj);
    end

    methods
        group = parseGroup(obj, group_data);
    end
end

