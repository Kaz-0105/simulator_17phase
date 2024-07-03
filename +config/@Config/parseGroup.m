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
        tmp_road.link_ids = [];  
        for link_id = road_data.v_ids
            tmp_road.link_ids(end + 1) = link_id{1};
        end

        % 道路を構成するリンクのうち直進車線のメインのリンクのIDを取得
        tmp_road.main_link_id = road_data.v_mid;

        % Signal Controller（1つの交差点の信号機をまとめたグループのこと）のIDを取得
        if isfield(road_data, 'v_sc')
            tmp_road.signal_controller_id = road_data.v_sc;
        end

        % % Signal Group（1つの交差点で挙動ごとに信号機を分けたグループのこと）のIDを取得
        % if isfield(road_data, 'v_sg')
        %     tmp_road.signal_group = {};

        %     for signal_group = road_data.v_sg
        %         tmp_signal_group = [];
        %         signal_group = signal_group{1};
        %         tmp_signal_group.id = signal_group.id;
        %         tmp_signal_group.dirct = char(signal_group.dirct);
        %         tmp_road.signal_group{end + 1} = tmp_signal_group;
        %     end
        % end


        % % 進路の割合を取得
        % if isfield(road_data, 'v_rfs')
        %     tmp_road.rel_flows = {};

        %     for rel_flow = road_data.v_rfs
        %         tmp_rel_flow = [];
        %         rel_flow = rel_flow{1};
        %         tmp_rel_flow.id = rel_flow.id;
        %         tmp_rel_flow.rf = rel_flow.rf;
        %         tmp_rel_flow.dirct = char(rel_flow.dirct);
        %         tmp_road.rel_flows{end + 1} = tmp_rel_flow;
        %     end
        % end

        % 自動車の流入量を取得
        if isfield(road_data, 'input')
            tmp_road.input = road_data.input;
        end

        % sig_head_idを取得
        if isfield(road_data, 'sig_head_ids')
            tmp_sig_head_ids = [];
            for sig_head_id = [road_data.sig_head_ids{:}]
                tmp_sig_head_ids(end + 1) = sig_head_id;
            end
            tmp_road.sig_head_ids = tmp_sig_head_ids;
        end

        % 自動車の速度を取得
        if isfield(road_data, 'speed')
            tmp_road.speed = road_data.speed;
        else
            tmp_road.speed = 60;
        end

        % queue_counterのIDを取得
        tmp_road.queue_counter_ids = [];
        for queue_counter_id = [road_data.queue_counter_ids{:}]
            tmp_road.queue_counter_ids(end + 1) = queue_counter_id;
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

