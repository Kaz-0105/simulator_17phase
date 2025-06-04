classdef VissimMeasurements < handle

    properties
        % クラス
        Config; % Configクラスの変数
        Com;    % VissimのCOMオブジェクト
        Vissim; % Vissimクラスの変数
    end

    properties
        % Map
        RoadInputMap;                      % ネットワークに流入する車両数のマップ    
        RoadOutputMap;                     % ネットワークから流出する車両数のマップ                           
        IntersectionRoadQueueMap;          % 信号待ちの長さのマップ
        IntersectionCalcTimeMap;           % 計算時間のマップ
        IntersectionRoadNumVehsMap;        % 車両数のマップ
        IntersectionRoadDelayMap;          % 遅れ時間のマップ
        VehicleSpeedsMap;                  % 車両ごとの速度データをまとめるマップ   
        AverageSpeedsMap;                   % 平均速度の時系列データをまとめるマップ
        IntersectionRoadsMap;               % 交差点IDから道路IDへのマップ
        RoadLinksMap;                       % 道路IDからリンクIDへのマップ
        IntersectionRoadNumQueuesMap;       % 信号待ち車列台数のマップ
    end

    properties
        % リスト
        time; % 時間のリスト
    end

    methods(Access = public)

        function obj = VissimMeasurements(Vissim)
            % VissimのCOMオブジェクトを設定
            obj.Com = Vissim.get('Com');

            % Configクラスの変数を設定
            obj.Config = Vissim.get('Config');

            % Vissimクラスの変数を設定
            obj.Vissim = Vissim;

            % Mapの初期化
            obj.initMaps();
            
            % timeの初期化
            obj.time = 0;

            % Vissim側の計測データに関する設定
            obj.applyToVissim();

            % IntersectionRoadMapを初期化
            obj.initIntersectionRoadsMap();

            % RoadLinksMapを初期化
            obj.initRoadLinksMap();
        end
    end

    methods
        value = get(obj, property_name);
        update(obj);
    end

    methods(Access = private)
        % マップを初期化する関数
        initMaps(obj)

        % Vissim上の設定を行う関数
        applyToVissim(obj)
        
        % 計測データの更新を行う関数
        updateRoadInputMap(obj)
        updateRoadOutputMap(obj)
        updateIntersectionRoadQueueMap(obj)
        updateIntersectionCalcTimeMap(obj)
        updateIntersectionRoadNumVehsMap(obj)
        updateIntersectionRoadDelayMap(obj)
    end

    methods(Access = private)
        % IntersectionRoadMapを初期化するメソッド
        function initIntersectionRoadsMap(obj)
            IntersectionStructMap = obj.Vissim.get('IntersectionStructMap');
            obj.IntersectionRoadsMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

            for intersection_id = cell2mat(keys(IntersectionStructMap))
                tmp_data = struct();
                tmp_data.input_road_ids = IntersectionStructMap(intersection_id).input_road_ids;
                tmp_data.output_road_ids = IntersectionStructMap(intersection_id).output_road_ids;

                obj.IntersectionRoadsMap(intersection_id) = tmp_data;
            end
        end

        % RoadLinkMapを初期化するメソッド
        function initRoadLinksMap(obj)
            % RoadLinkMapを初期化
            obj.RoadLinksMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

            RoadLinkMap = obj.Vissim.get('RoadLinkMap');
            for road_id = cell2mat(keys(RoadLinkMap))
                tmp_links_map = containers.Map('KeyType', 'int32', 'ValueType', 'any');
                for link_id = RoadLinkMap(road_id)
                    tmp_links_map(link_id) = obj.Com.Net.Links.ItemByKey(link_id);
                end
                obj.RoadLinksMap(road_id) = tmp_links_map;
            end
        end

        % 車両の速度データを保存するメソッド
        function updateVehicleSpeedsMap(obj)
            % VehicleSpeedsMapの更新
            for intersection_id = cell2mat(keys(obj.VehicleSpeedsMap))
                if (intersection_id == 0)
                    % 全体用
                    vehicles_com = obj.Com.Net.Vehicles;
                    vehicle_ids = vehicles_com.GetMultiAttValues('No');
                    vehicle_speeds = vehicles_com.GetMultiAttValues('Speed');

                    vehicle_ids(:, 1) = [];
                    vehicle_speeds(:, 1) = [];

                    vehicle_ids = cell2mat(vehicle_ids);
                    vehicle_speeds = cell2mat(vehicle_speeds);

                    tmp_vehicle_speeds_map = obj.VehicleSpeedsMap(0);

                    for index = 1: length(vehicle_ids)
                        vehicle_id = vehicle_ids(index);
                        vehicle_speed = round(vehicle_speeds(index), 1);

                        if isKey(tmp_vehicle_speeds_map, vehicle_id)
                            tmp_vehicle_speeds_map(vehicle_id) = [tmp_vehicle_speeds_map(vehicle_id), vehicle_speed];
                        else
                            tmp_vehicle_speeds_map(vehicle_id) = vehicle_speed;
                        end
                    end

                else
                    % 各交差点用
                    tmp_vehicle_speeds_map = obj.VehicleSpeedsMap(intersection_id);

                    for road_id = obj.IntersectionRoadsMap(intersection_id).input_road_ids
                        tmp_links_map = obj.RoadLinksMap(road_id);
                        for link_id = cell2mat(tmp_links_map.keys)
                            link_com = tmp_links_map(link_id);
                            vehicles_com = link_com.Vehs;

                            vehicle_ids = vehicles_com.GetMultiAttValues('No');
                            vehicle_speeds = vehicles_com.GetMultiAttValues('Speed');

                            vehicle_ids(:, 1) = [];
                            vehicle_speeds(:, 1) = [];

                            vehicle_ids = cell2mat(vehicle_ids);
                            vehicle_speeds = cell2mat(vehicle_speeds);

                            for index = 1: length(vehicle_ids)
                                vehicle_id = vehicle_ids(index);
                                vehicle_speed = round(vehicle_speeds(index), 1);

                                if isKey(tmp_vehicle_speeds_map, vehicle_id)
                                    tmp_vehicle_speeds_map(vehicle_id) = [tmp_vehicle_speeds_map(vehicle_id), vehicle_speed];
                                else
                                    tmp_vehicle_speeds_map(vehicle_id) = vehicle_speed;
                                end
                            end
                        end
                    end
                    
                end
            end 

            % AverageSpeedsMapの更新
            for intersection_id = cell2mat(keys(obj.AverageSpeedsMap))
                if (intersection_id == 0)
                    % 全体用
                    vehicles_com = obj.Com.Net.Vehicles;
                    vehicle_speeds = vehicles_com.GetMultiAttValues('Speed');
                    vehicle_speeds(:, 1) = [];
                    vehicle_speeds = cell2mat(vehicle_speeds);

                    if (isempty(vehicle_speeds))
                        obj.AverageSpeedsMap(0) = [obj.AverageSpeedsMap(0), 60];
                    else
                        obj.AverageSpeedsMap(0) = [obj.AverageSpeedsMap(0), round(mean(vehicle_speeds), 1)];
                    end
                else
                    % 各交差点用
                    vehicle_speeds = [];
                    for road_id = obj.IntersectionRoadsMap(intersection_id).input_road_ids
                        tmp_links_map = obj.RoadLinksMap(road_id);
                        for link_id = cell2mat(tmp_links_map.keys)
                            link_com = tmp_links_map(link_id);
                            vehicles_com = link_com.Vehs;

                            tmp_vehicle_speeds = vehicles_com.GetMultiAttValues('Speed');
                            tmp_vehicle_speeds(:, 1) = [];
                            vehicle_speeds = [vehicle_speeds, cell2mat(tmp_vehicle_speeds)'];
                        end
                    end
                    obj.AverageSpeedsMap(intersection_id) = [obj.AverageSpeedsMap(intersection_id), round(mean(vehicle_speeds), 1)];
                end
            end
        end

        function updateIntersectionRoadNumQueuesMap(obj)
            % モデル化誤差を見ない場合はスキップ
            if ~obj.Config.vissim.model_error_flg
                return;
            end

            for intersection_id = cell2mat(keys(obj.IntersectionRoadNumQueuesMap))
                RoadNumQueueMap = obj.IntersectionRoadNumQueuesMap(intersection_id);

                for road_id = cell2mat(keys(RoadNumQueueMap))
                    LinksMap = obj.RoadLinksMap(road_id);
                    tmp_sum = 0;

                    for link_id = cell2mat(keys(LinksMap))
                        LinkCom = LinksMap(link_id);
                        VehsCom = LinkCom.Vehs;

                        in_queues = VehsCom.GetMultiAttValues('InQueue');
                        in_queues(:, 1) = [];
                        in_queues = cell2mat(in_queues);
                        tmp_sum = tmp_sum + sum(in_queues);
                    end

                    RoadNumQueueMap(road_id) = [RoadNumQueueMap(road_id), tmp_sum];
                end

                obj.IntersectionRoadNumQueuesMap(intersection_id) = RoadNumQueueMap;
            end
        end
    end
        
        
end