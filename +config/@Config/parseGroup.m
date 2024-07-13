function group = parseGroup(obj, group_data)
    % 道路と交差点の情報が格納されたパスを取得
    roads_file = group_data.roads;
    intersections_file = group_data.intersections;

    [roads_file_dir, roads_file_name, roads_file_ext] = fileparts(roads_file);
    [intersections_file_dir, intersections_file_name, intersections_file_ext] = fileparts(intersections_file);

    if strlength(roads_file_dir) == 0
        roads_file = char(append(obj.file_dir, roads_file_name, roads_file_ext));
    end

    if strlength(intersections_file_dir) == 0
        intersections_file = char(append(obj.file_dir, intersections_file_name, intersections_file_ext));
    end

    % グループ構造体の初期化
    group = [];

    % グループのIDを取得
    group.id = group_data.id;

    % 道路のデータを取得
    roads_data = yaml.loadFile(roads_file);

    % RoadsMapの初期化
    group.RoadsMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    for road_data = roads_data.roads
        road_data = road_data{1};
        tmp_road = [];

        % 道路のIDを取得
        tmp_road.id = road_data.id;

        % 道路を構成するリンクのIDを取得
        if isfield(road_data, 'link_ids')
            tmp_road.link_ids = cell2mat(road_data.link_ids);
        else
            error('There is no link_ids information in the configuration file.');
        end

        % Signal Controller（1つの交差点の信号機をまとめたグループのこと）のIDを取得
        if isfield(road_data, 'signal_controller_id')
            tmp_road.signal_controller_id = road_data.signal_controller_id;
        end

        % sig_head_idを取得
        if isfield(road_data, 'sig_head_ids')
            tmp_road.sig_head_ids = cell2mat(road_data.sig_head_ids);
        end

        % 自動車の速度を取得
        if isfield(road_data, 'speed')
            tmp_road.speed = road_data.speed;
        else
            tmp_road.speed = 60;
        end

        % 分岐情報を取得
        if isfield(road_data, 'branch')
            tmp_road.branch = road_data.branch;
        end

        group.RoadsMap(tmp_road.id) = tmp_road;
    end

    % 交差点のデータを取得
    intersections_data = yaml.loadFile(intersections_file);

    % IntersectionsMapの初期化
    group.IntersectionsMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    for intersection_data = intersections_data.intersections
        intersection_data = intersection_data{1};
        tmp_intersection = [];

        % 交差点のIDを取得
        tmp_intersection.id = intersection_data.id;

        % 流入側の道路のリストとその方角を取得
        tmp_intersection.input_road_ids = [];
        tmp_intersection.InputRoadOrderMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

        for input_road = [intersection_data.input_roads{:}]
            tmp_intersection.input_road_ids(end + 1) = input_road.id;
            tmp_intersection.InputRoadOrderMap(input_road.id) = input_road.order;
        end

        % 流出側の道路のリストを取得
        tmp_intersection.output_road_ids = [];
        tmp_intersection.OutputRoadOrderMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

        for output_road = [intersection_data.output_roads{:}]
          
            tmp_intersection.output_road_ids(end + 1) = output_road.id;
            tmp_intersection.OutputRoadOrderMap(output_road.id) = output_road.order;
        end

        % 交差点の制御方法を取得
        tmp_intersection.control_method = char(intersection_data.control_method);

        group.IntersectionsMap(tmp_intersection.id) = tmp_intersection; 
    end
end

