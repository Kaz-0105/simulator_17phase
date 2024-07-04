function save(obj, base_name, directory)
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

    data = { RoadInputMap, RoadOutputMap, IntersectionRoadQueueMap, ...
             IntersectionCalcTimeMap, IntersectionRoadNumVehsMap, IntersectionRoadDelayMap};

    % データを保存
    save(file_path, 'data');
    fprintf('Data saved to %s\n', file_path);
    


end