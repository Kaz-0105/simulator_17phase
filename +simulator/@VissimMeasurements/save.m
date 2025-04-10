function save(obj)
    % base_nameの取得
    base_name = obj.Config.result.save.name;

    % 保存先の相対パスの取得
    relative_path = obj.Config.result.save.path;

    % 絶対パスに変換
    if strcmp(relative_path(1), '\')
        directory = strcat(pwd, relative_path);
    else
        directory = strcat(pwd, '\', relative_path);
    end


    % ディレクトリが存在しない場合は作成
    if ~exist(directory, 'dir')
        mkdir(directory);
    end

    % ベース名でファイルパスを作成
    file_path = fullfile(directory, [base_name '.mat']);

    % ファイルが既に存在するか確認する
    count = 1;
    while exist(file_path, 'file')
        % ファイル名が存在する場合、カウンタを使って新しいファイル名を作成する
        file_path = fullfile(directory, sprintf('%s(%d).mat', base_name, count));
        count = count + 1;
    end

    % 保存したい変数を指定
    RoadInputMap = obj.RoadInputMap;                       
    RoadOutputMap = obj.RoadOutputMap;                          
    IntersectionRoadQueueMap = obj.IntersectionRoadQueueMap;
    IntersectionCalcTimeMap = obj.IntersectionCalcTimeMap;           
    IntersectionRoadNumVehsMap = obj.IntersectionRoadNumVehsMap;        
    IntersectionRoadDelayMap = obj.IntersectionRoadDelayMap;
    VehicleSpeedsMap = obj.VehicleSpeedsMap;
    time = obj.time;

    % データを保存
    save(file_path, 'RoadInputMap', 'RoadOutputMap', 'IntersectionRoadQueueMap', 'IntersectionCalcTimeMap', 'IntersectionRoadNumVehsMap', 'IntersectionRoadDelayMap', 'VehicleSpeedsMap', 'time');
    fprintf('Data saved to %s\n', file_path);
    


end