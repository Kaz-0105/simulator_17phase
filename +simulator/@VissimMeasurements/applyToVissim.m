function applyToVissim(obj)
    % Vehicle Network Performanceの設定
    obj.Com.Evaluation.set('AttValue','VehNetPerfCollectData',true);
    obj.Com.Evaluation.set('AttValue','VehNetPerfFromTime',0);
    obj.Com.Evaluation.set('AttValue','VehNetPerfToTime',obj.Config.simulation.time);
    obj.Com.Evaluation.set('AttValue','VehNetPerfInterval',obj.Config.mpc.control_interval);
    
    % Delay Timeの設定
    obj.Com.Evaluation.set('AttValue','DelaysCollectData',true);                         % Delayの計測をONにする
    obj.Com.Evaluation.set('AttValue','DelaysFromTime',0);                               % Delayの計測の開始時間の設定
    obj.Com.Evaluation.set('AttValue','DelaysToTime',obj.Config.simulation.time);        % Delayの計測の終了時間の設定
    obj.Com.Evaluation.set('AttValue','DelaysInterval',obj.Config.mpc.control_interval); % データの収集間隔の設定

    % Queue Lengthの設定
    obj.Com.Evaluation.set('AttValue','QueuesCollectData',true);                         % Queueの計測をONにする
    obj.Com.Evaluation.set('AttValue','QueuesFromTime',0);                               % Queueの計測の開始時間の設定
    obj.Com.Evaluation.set('AttValue','QueuesToTime',obj.Config.simulation.time);        % Queueの計測の終了時間の設定
    obj.Com.Evaluation.set('AttValue','QueuesInterval',obj.Config.mpc.control_interval); % データの収集間隔の設定

    % Data Collectionの設定
    obj.Com.Evaluation.set('AttValue', 'DataCollCollectData', true);                         % Data Collectionの計測をONにする
    obj.Com.Evaluation.set('AttValue', 'DataCollFromTime', 0);                               % Data Collectionの計測の開始時間の設定
    obj.Com.Evaluation.set('AttValue', 'DataCollToTime', obj.Config.simulation.time);        % Data Collectionの計測の終了時間の設定
    obj.Com.Evaluation.set('AttValue', 'DataCollInterval', obj.Config.mpc.control_interval); % データの収集間隔の設定
end