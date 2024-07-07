classdef Vissim < handle

    properties
        % クラスのオブジェクト変数
        Config;                           % Configクラスの変数
        Com;                              % VissimのCOMオブジェクト
        VissimMeasurements;               % VissimMeasurementsクラスの変数
        VissimData;                       % VissimDataクラスの変数 
    end

    properties
        % Mapの変数
        LinkRoadMap;                         % キー：リンクのID、バリュー：そのリンクが属する道路のID
        LinkTypeMap;                         % キー：リンクのID、バリュー：リンクの種類
        RoadLinkMap;                         % キー：道路のID、バリュー：その道路に属するリンクのIDの配列が入ったセル配列
        RoadStructMap;                       % キー：道路のID、バリュー：道路の長さに関する構造体
        LinkInputOutputMap;                  % キー：リンクのID、バリュー：そのリンクが末端流入リンクまたは末端流出リンクであるかどうか
        IntersectionStructMap;               % キー：交差点のID、バリュー：交差点の流入出道路に関する構造体
        LinkQueueCounterMap;                 % キー：リンクのID、バリュー：そのリンクのキューカウンターのID
        IntersectionControllerMap;           % キー：交差点のID、バリュー：制御器のクラスのオブジェクト
        IntersectionSignalControllerMap;     % キー：交差点のID、バリュー：SignalControllerのCOMオブジェクト
        IntersectionOptStateMap;             % キー：交差点のID、バリュー：その交差点の信号現示の最適解
        RoadDelayMeasurementMap;             % キー：道路のID、バリュー：DelayMeasurementのID
        LinkDataCollectionMeasurementMap;    % キー：リンクのID、バリュー：DataCollectionMeasurementのID
    end

    properties
        % その他の変数
        break_time = 0;         % シミュレーションのブレイクポイントの時間
        current_time = 0;       % 現在のシミュレーションの時間
        prediction_count = 0;   % 予測回数

        is_save;                % シミュレーション結果を保存するかどうかのフラグ
        save_path;              % シミュレーション結果を保存する
    end

    methods(Access = public)
        % コンストラクタ
        function obj = Vissim(Config)

            % yamlクラスの変数の設定
            obj.Config = Config;

            % 結果の保存に関する設定
            obj.is_save = Config.result.save.active;
            obj.save_path = Config.result.save.path;

            % COMのオブジェクトの設定
            obj.Com = actxserver('VISSIM.vissim');
            obj.Com.LoadNet(Config.network.inpx_file);
            obj.Com.LoadLayout(Config.network.layx_file);

            % Vehicle Network Performanceの設定
            obj.Com.Evaluation.set('AttValue','VehNetPerfCollectData',true);
            obj.Com.Evaluation.set('AttValue','VehNetPerfFromTime',0);
            obj.Com.Evaluation.set('AttValue','VehNetPerfToTime',Config.simulation.time);
            obj.Com.Evaluation.set('AttValue','VehNetPerfInterval',Config.mpc.control_interval);

            % Delay Timeの設定
            obj.Com.Evaluation.set('AttValue','DelaysCollectData',true);                     % Delayの計測をONにする
            obj.Com.Evaluation.set('AttValue','DelaysFromTime',0);                           % Delayの計測の開始時間の設定
            obj.Com.Evaluation.set('AttValue','DelaysToTime',Config.simulation.time);        % Delayの計測の終了時間の設定
            obj.Com.Evaluation.set('AttValue','DelaysInterval',Config.mpc.control_interval); % データの収集間隔の設定

            % Queue Lengthの設定
            obj.Com.Evaluation.set('AttValue','QueuesCollectData',true);                     % Queueの計測をONにする
            obj.Com.Evaluation.set('AttValue','QueuesFromTime',0);                           % Queueの計測の開始時間の設定
            obj.Com.Evaluation.set('AttValue','QueuesToTime',Config.simulation.time);        % Queueの計測の終了時間の設定
            obj.Com.Evaluation.set('AttValue','QueuesInterval',Config.mpc.control_interval); % データの収集間隔の設定

            % シミュレーション用の設定
            obj.Com.Simulation.set('AttValue', 'NumRuns', Config.simulation.count);                       % シミュレーション回数の設定をVissimに渡す
            obj.Com.Simulation.set('AttValue','RandSeed',Config.vissim.seed);                             % 乱数シードの設定をVissimに渡す
            obj.Com.Graphics.CurrentNetworkWindow.set('AttValue','QuickMode',Config.vissim.graphic_mode); % 描画設定をVissimに渡す
            obj.Com.Simulation.set('AttValue','UseMaxSimSpeed',false);                                    % シミュレーションを最高速度で行うようにVissimを設定する
            obj.Com.Simulation.set('AttValue','UseAllCores',true);                                        % シミュレーションに全てのコアを使うようにVissimを設定する
            obj.Com.Simulation.set('AttValue','SimPeriod',Config.simulation.time);                        % シミュレーション時間を設定する
            obj.Com.Simulation.set('AttValue','SimRes',Config.vissim.resolution);                         % 解像度を設定                            % シミュレーションの解像度を設定する

            % linkRoadMapの作成                                                        
            obj.makeLinkRoadMap();

            % linkTypeMapの作成                                                   
            obj.makeLinkTypeMap();

            % roadLinkMapの作成
            obj.makeRoadLinkMap();

            % RoadStructMapの作成
            obj.makeRoadStructMap();

            % IntersectionStructMapの作成
            obj.makeIntersectionStructMap();

            % LinkInputOutputMapの作成
            obj.makeLinkInputOutputMap();

            % LinkQueueCounterMapの作成
            obj.makeLinkQueueCounterMap();

            % IntersectionControllerMapの作成
            obj.makeIntersectionControllerMap();

            % IntersectionSignalControllerMapの作成
            obj.makeIntersectionSignalControllerMap();

            % IntersectionRoadDelayMeasurementMapの作成
            obj.makeRoadDelayMeasurementMap();

            % LinkDataCollectionMeasurementMapの作成
            obj.makeLinkDataCollectionMeasurementMap();

            % VissimMeasurementsクラスの変数の設定
            obj.VissimMeasurements = simulator.VissimMeasurements(obj);
        end
        
        function clear_states(obj)
        end

        
    end

    methods(Access = public)
        value = get(obj, property_name);
        run(obj);
    end

    methods(Access = private)
        makeLinkRoadMap(obj);
        makeLinkTypeMap(obj);
        makeRoadLinkMap(obj);
        makeRoadStructMap(obj);
        makeLinkInputOutputMap(obj);
        makeLinkQueueCounterMap(obj);
        makeIntersectionStructMap(obj);
        makeIntersectionControllerMap(obj);
        makeRoadDelayMeasurementMap(obj);
        makeLinkDataCollectionMeasurementMap(obj)
        
        updateStates(obj);
        optimize(obj);
        runSingleHorizon(obj, sim_step);
        main_link_id = getMainLink(obj, link_ids);
    end

    methods(Static)
    end
end