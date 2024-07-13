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
        RoadLinkMap;                         % キー：道路のID、バリュー：その道路に属するリンクのIDの配列が入ったセル配列
        
        LinkInputOutputMap;                  % キー：リンクのID、バリュー：そのリンクが末端流入リンクまたは末端流出リンクであるかどうか
        
        LinkTypeMap;                         % キー：リンクのID、バリュー：リンクの種類
        RoadMainLinkMap;                     % キー：道路のID、バリュー：その道路に属するメインリンクのID

        RoadBranchMap;                       % キー：道路のID、バリュー：その道路の分岐情報
        
        ConnectorSubLinkMap;                 % キー：コネクタのID、バリュー：そのコネクタに接続するサブリンクのID
        ConnectorMainLinkMap;                % キー：コネクタのID、バリュー：そのコネクタに接続するメインリンクのID
        SubLinkConnectorMap;                 % キー：サブリンクのID、バリュー：そのサブリンクに接続するコネクタのID
        MainLinkConnectorMap;                % キー：メインリンクのID、バリュー：そのメインリンクに接続するコネクタのID

        RoadStructMap;                       % キー：道路のID、バリュー：道路の長さに関する構造体
        IntersectionStructMap;               % キー：交差点のID、バリュー：交差点の流入出道路に関する構造体

        LinkQueueCounterMap;                 % キー：リンクのID、バリュー：そのリンクのキューカウンターのID
        LinkDataCollectionMeasurementMap;    % キー：リンクのID、バリュー：DataCollectionMeasurementのID
        RoadDelayMeasurementMap;             % キー：道路のID、バリュー：DelayMeasurementのID

        IntersectionControllerMap;           % キー：交差点のID、バリュー：制御器のクラスのオブジェクト
        IntersectionSignalControllerMap;     % キー：交差点のID、バリュー：SignalControllerのCOMオブジェクト

        IntersectionOptStateMap;             % キー：交差点のID、バリュー：その交差点の信号現示の最適解
        
        
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

            % roadLinkMapの作成
            obj.makeRoadLinkMap();

            % LinkInputOutputMapの作成
            obj.makeLinkInputOutputMap();

            % linkTypeMapの作成                                                   
            obj.makeLinkTypeMap();

            % ConnectorSubLinkMapとSubLinkConnectorMapの作成
            obj.makeConnectorSubLinkMap();
            % ConnectorMainLinkMapとMainLinkConnectorMapの作成
            obj.makeConnectorMainLinkMap();

            % RoadStructMapの作成
            obj.makeRoadStructMap();

            % IntersectionStructMapの作成
            obj.makeIntersectionStructMap();

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

            % RoadBranchMapの作成
            obj.makeRoadBranchMap();

            % Vissim上の設定を行う
            obj.applyToVissim();

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
        % 道路とリンクの関係について
        makeRoadLinkMap(obj);

        % リンクの種類について
        makeLinkTypeMap(obj);
        makeConnectorSubLinkMap(obj);
        makeConnectorMainLinkMap(obj);
        
        makeRoadStructMap(obj);
        makeLinkInputOutputMap(obj);
        makeLinkQueueCounterMap(obj);
        makeIntersectionStructMap(obj);
        makeIntersectionControllerMap(obj);
        makeRoadDelayMeasurementMap(obj);
        makeLinkDataCollectionMeasurementMap(obj);
        makeRoadBranchMap(obj);
        makeInputRoadLaneStructMap(obj);
        makeSubLinkLaneMap(obj);

        applyToVissim(obj);
        
        updateStates(obj);
        optimize(obj);
        runSingleHorizon(obj, sim_step);
        main_link_id = getMainLink(obj, link_ids);
    end

    methods(Static)
    end
end