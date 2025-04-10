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
        VehicleSpeedsMap;                  
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
        % 車両の速度データを保存するメソッド
        function updateVehicleSpeedsMap(obj)
            vehiclesCom = obj.Com.Net.Vehicles;
            vehicleIds = vehiclesCom.GetMultiAttValues('No');
            vehicleSpeeds = vehiclesCom.GetMultiAttValues('Speed');

            vehicleIds(:, 1) = [];
            vehicleSpeeds(:, 1) = [];

            vehicleIds = cell2mat(vehicleIds);
            vehicleSpeeds = cell2mat(vehicleSpeeds);

            for index = 1: length(vehicleIds)
                vehicleId = vehicleIds(index);
                vehicleSpeed = vehicleSpeeds(index);

                if isKey(obj.VehicleSpeedsMap, vehicleId)
                    obj.VehicleSpeedsMap(vehicleId) = [obj.VehicleSpeedsMap(vehicleId), vehicleSpeed];
                else
                    obj.VehicleSpeedsMap(vehicleId) = vehicleSpeed;
                end
            end
        end
    end
        
        
end