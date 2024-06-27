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
        LinkRoadMap;                        % キー：リンクのID、バリュー：そのリンクが属する道路のID
        LinkTypeMap;                        % キー：リンクのID、バリュー：リンクの種類
        RoadLinkMap;                        % キー：道路のID、バリュー：その道路に属するリンクのIDの配列が入ったセル配列
        RoadStructMap;                      % キー：道路のID、バリュー：道路の長さに関する構造体
        LinkInputOutputMap;                 % キー：リンクのID、バリュー：そのリンクが末端流入リンクまたは末端流出リンクであるかどうか
        IntersectionStructMap;              % キー：交差点のID、バリュー：交差点の流入出道路に関する構造体
        LinkQueueMap;                       % キー：リンクのID、バリュー：そのリンクのキューカウンターのID
        Maps;                               % キー：Mapの名前、バリュー：そのMapの変数
        IntersectionControllerMap;          % キー：交差点のID、バリュー：制御器のクラスのオブジェクト
        IntersectionSignalControllerMap;    % キー：交差点のID、バリュー：SignalControllerのCOMオブジェクト
        IntersectionOptStateMap;            % キー：交差点のID、バリュー：その交差点の信号現示の最適解
    end

    properties
        % その他の変数
        break_time = 0;                     % シミュレーションのブレイクポイントの時間
    end

    methods(Access = public)
        % コンストラクタ
        function obj = Vissim(Config)

            % yamlクラスの変数の設定
            obj.Config = Config;

            % COMのオブジェクトの設定
            obj.Com = actxserver('VISSIM.vissim');
            obj.Com.LoadNet(Config.inpx_file);
            obj.Com.LoadLayout(Config.layx_file);

            % Vehicle Network Performanceの設定
            obj.Com.Evaluation.set('AttValue','VehNetPerfCollectData',true);
            obj.Com.Evaluation.set('AttValue','VehNetPerfFromTime',0);
            obj.Com.Evaluation.set('AttValue','VehNetPerfToTime',Config.control_interval*Config.num_loop);
            obj.Com.Evaluation.set('AttValue','VehNetPerfInterval',Config.control_interval);

            % Delay Timeの設定
            obj.Com.Evaluation.set('AttValue','DelaysCollectData',true);                                                        % Delayの計測をONにする
            obj.Com.Evaluation.set('AttValue','DelaysFromTime',0);                                                              % Delayの計測の開始時間の設定
            obj.Com.Evaluation.set('AttValue','DelaysToTime',Config.control_interval*Config.num_loop);                          % Delayの計測の終了時間の設定
            obj.Com.Evaluation.set('AttValue','DelaysInterval',Config.control_interval);                                        % データの収集間隔の設定

            % Queue Lengthの設定
            obj.Com.Evaluation.set('AttValue','QueuesCollectData',true);                                            % Queueの計測をONにする
            obj.Com.Evaluation.set('AttValue','QueuesFromTime',0);                                                  % Queueの計測の開始時間の設定
            obj.Com.Evaluation.set('AttValue','QueuesToTime',Config.control_interval*Config.num_loop);              % Queueの計測の終了時間の設定
            obj.Com.Evaluation.set('AttValue','QueuesInterval',Config.control_interval);                            % データの収集間隔の設定

            % シミュレーション用の設定
            obj.Com.Simulation.set('AttValue', 'NumRuns', Config.sim_count);                                             % シミュレーション回数の設定をVissimに渡す
            obj.Com.Simulation.set('AttValue','RandSeed',Config.seed);                                                  % 乱数シードの設定をVissimに渡す
            obj.Com.Graphics.CurrentNetworkWindow.set('AttValue','QuickMode',Config.graphic_mode);                      % 描画設定をVissimに渡す
            obj.Com.Simulation.set('AttValue','UseMaxSimSpeed',false);                                                   % シミュレーションを最高速度で行うようにVissimを設定する
            obj.Com.Simulation.set('AttValue','UseAllCores',true);                                                      % シミュレーションに全てのコアを使うようにVissimを設定する
            obj.Com.Simulation.set('AttValue','SimPeriod',Config.control_interval*Config.num_loop);                     % シミュレーション時間を設定する

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

            % LinkQueueMapの作成
            obj.makeLinkQueueMap();

            % mapをまとめたmapの作成
            obj.Maps = containers.Map('KeyType', 'char', 'ValueType', 'any');
            obj.Maps('LinkRoadMap') = obj.LinkRoadMap;
            obj.Maps('LinkTypeMap') = obj.LinkTypeMap;
            obj.Maps('RoadLinkMap') = obj.RoadLinkMap;
            obj.Maps('RoadStructMap') = obj.RoadStructMap;
            obj.Maps('LinkInputOutputMap') = obj.LinkInputOutputMap;
            obj.Maps('IntersectionStructMap') = obj.IntersectionStructMap;
            obj.Maps('LinkQueueMap') = obj.LinkQueueMap;

            % 制御器の設定
            obj.IntersectionControllerMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

            for intersection_struct = values(obj.IntersectionStructMap)
                intersection_struct = intersection_struct{1};
                switch intersection_struct.control_method
                    case 'Dan4'
                        obj.IntersectionControllerMap(intersection_struct.id) = controller.Dan4(intersection_struct.id, Config, obj.Maps);
                    case 'Dan3'
                        obj.IntersectionControllerMap(intersection_struct.id) = controller.Dan3(intersection_struct.id, Config, obj.Maps);
                end    
            end

            % VissimMeasurementsクラスの変数の設定
            obj.VissimMeasurements = simulator.VissimMeasurements(obj.Com);

            % 制御器のCOMオブジェクトの設定
            obj.IntersectionSignalControllerMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

            for group = obj.Config.groups
                group = group{1};
                for intersection = group.intersections
                    intersection = intersection{1};
                    obj.IntersectionSignalControllerMap(intersection.id) = obj.Com.Net.SignalControllers.ItemByKey(intersection.id);
                end
            end
        end
        
        function clear_states(obj)
        end

        
    end

    methods(Access = public)
        value = get(obj, property_name);
        updateSimulation(obj, sim_step);
    end

    methods(Access = private)
        makeLinkRoadMap(obj);
        makeLinkTypeMap(obj);
        makeRoadLinkMap(obj);
        makeRoadStructMap(obj);
        makeLinkInputOutputMap(obj);
        makeLinkQueueMap(obj);
        makeIntersectionStructMap(obj);
        updateStates(obj);
        optimize(obj);
    end

    methods(Static)
    end
end