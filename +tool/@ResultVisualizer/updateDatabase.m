function updateDatabase(obj)
    % VissimMeasurementsクラスからデータを取得
    IntersectionRoadQueueMap = obj.VissimMeasurements.get('IntersectionRoadQueueMap');
    IntersectionRoadDelayMap = obj.VissimMeasurements.get('IntersectionRoadDelayMap');
    IntersectionCalcTimeMap = obj.VissimMeasurements.get('IntersectionCalcTimeMap');
    IntersectionControllerMap = obj.Vissim.get('IntersectionControllerMap');
    VehicleSpeedsMap = obj.VissimMeasurements.get('VehicleSpeedsMap');

    % Vissimクラスからデータを取得
    IntersectionStructMap = obj.Vissim.get('IntersectionStructMap');

    % データベースのパスを取得
    path = obj.Config.result.database.path;

    % パスが存在しない場合新しくcsvファイルを作成
    if ~exist(obj.Config.result.database.path, 'file')
        % ヘッダーを取得
        headers = {};
        headers{1} = 'simulation_id';
        headers{2} = 'intersection_id';
        headers{3} = 'control_method';
        headers{4} = 'num_phases';
        headers{5} = 'seed';

        % 道路の数を取得
        num_roads = length(IntersectionRoadQueueMap.innerKeys(1));

        % ヘッダーを追加
        for road_id = 1: num_roads
            headers{end + 1} = ['input', num2str(road_id)];
        end

        % ヘッダーを追加
        for road_id = 1: num_roads
            headers{end + 1} = ['relflow', num2str(road_id)];
        end

        headers{end + 1} = 'yellow_time';
        headers{end + 1} = 'red_time';

        headers{end + 1} = 'N_p';
        headers{end + 1} = 'N_c';
        headers{end + 1} = 'N_s';

        headers{end + 1} = 'queue';
        headers{end + 1} = 'delay';
        headers{end + 1} = 'speed';
        headers{end + 1} = 'calc_time';
        headers{end + 1} = 'success_rate';

        data_table = cell2table(cell(0, numel(headers)), 'VariableNames', headers);

        % csvファイルを作成
        writetable(data_table, path);
    end

    % データを取得
    data_table = readtable(path);

    % シミュレーション回数の設定
    
    % データベースに存在するシミュレーションIDを取得
    simulation_ids = data_table.simulation_id;

    % シミュレーションのIDを設定
    found_flag = false;
    simulation_id = 1;

    while found_flag == false
        % シミュレーションIDが存在する場合、IDをインクリメント
        if ismember(simulation_id, simulation_ids)
            simulation_id = simulation_id + 1;
        else
            found_flag = true;
        end
    end

    % QueueとDelayの交差点ごとの道路平均を取得
    IntersectionQueueMap = average(IntersectionRoadQueueMap, 'outer');
    IntersectionDelayMap = average(IntersectionRoadDelayMap, 'outer');

    for intersection_id = cell2mat(IntersectionRoadQueueMap.outerKeys())
        % intersection構造体を取得
        intersection_struct = IntersectionStructMap(intersection_id);

        % 制御方法を取得
        control_method = intersection_struct.control_method;

        % 道路の数を取得
        num_roads = intersection_struct.num_roads;

        % フェーズ数を取得
        % 固定式の場合
        if strcmp(control_method, 'Fixed')
            % 道路数によって場合分け
            if num_roads == 4
                num_phases = 4;
            elseif num_roads == 3
                num_phases = 3;
            elseif num_roads == 5
                num_phases = 5;
            end
        % 壇モデルの場合
        elseif strcmp(control_method, 'Dan')
            % NumRoadsNumPhasesMapを取得
            NumRoadsNumPhasesMap = obj.Config.model.dan.NumRoadsNumPhasesMap;

            % 道路数によって場合分け
            if num_roads == 4
                num_phases = NumRoadsNumPhasesMap(num_roads);
            elseif num_roads == 3
                num_phases = NumRoadsNumPhasesMap(num_roads);
            elseif num_roads == 5
                num_phases = NumRoadsNumPhasesMap(num_roads);
            end
        end

        % seed値を取得
        seed = obj.Config.vissim.seed;

        % VehicleInputsMapを取得
        VehicleInputsMap = obj.Config.network.GroupsMap(1).PrmsMap('vehicle_inputs');

        % 流入量を取得
        inputs = zeros(1, num_roads);
        for input_id = 1: num_roads
            inputs(input_id) = VehicleInputsMap(input_id).volume;
        end

        % VehicleRoutesMapを取得
        VehicleRoutesMap = obj.Config.network.GroupsMap(1).PrmsMap('vehicle_routes');

        % RoadTemplatesMapを取得
        RoadRelFlowTemplateMap = VehicleRoutesMap(intersection_id).RoadRelFlowTemplateMap;

        % RoadOrderMapを取得
        InputRoadOrderMap = intersection_struct.InputRoadOrderMap;

        % 旋回率を取得
        relflows = zeros(1, num_roads);
        for road_id = cell2mat(RoadRelFlowTemplateMap.keys)
            % 道路の順番を取得
            order_id = InputRoadOrderMap(road_id);

            % 旋回率のテンプレートIDを取得
            relflows(order_id) = RoadRelFlowTemplateMap(road_id);
        end

        % yellow_timeとred_timeの有無を取得
        yellow_time = obj.Config.intersection.yellow_time;
        red_time = obj.Config.intersection.red_time;

        % N_pの値を取得
        N_p = obj.Config.mpc.predictive_horizon;

        % N_cの値を取得
        N_c = obj.Config.mpc.control_horizon;

        % N_sの値を取得
        N_s = obj.Config.model.dan.N_s;

        % QueueとDelayの時間平均を取得
        queue = round(mean(IntersectionQueueMap(intersection_id)), 1);
        delay = round(mean(IntersectionDelayMap(intersection_id)), 1);
        calc_time = round(mean(IntersectionCalcTimeMap(intersection_id)), 2);

        % speedの時間平均を取得（TODO: 全体でまとめちゃってるので直したかったら直す）
        vehicle_average_speeds = [];
        for vehicle_id = cell2mat(VehicleSpeedsMap.keys())
            vehicle_average_speeds = [vehicle_average_speeds; mean(VehicleSpeedsMap(vehicle_id))];
        end
        speed = round(mean(vehicle_average_speeds), 1);

        % 計算の成功率を計算
        Controller = IntersectionControllerMap(intersection_id);
        success_rate = Controller.get('success_rate');

        % データベースを更新
        % 同じシミュレーション条件のデータが存在する場合、データを更新

        % 条件が一致するかどうかのフラグ
        row_flags = data_table.intersection_id == intersection_id;
        row_flags = row_flags & strcmp(data_table.control_method, control_method);
        row_flags = row_flags & data_table.num_phases == num_phases;
        row_flags = row_flags & data_table.seed == seed;

        for road_id = 1: num_roads
            row_flags = row_flags & data_table.(['input', num2str(road_id)]) == inputs(road_id);
        end

        for road_id = 1: num_roads
            row_flags = row_flags & data_table.(['relflow', num2str(road_id)]) == relflows(road_id);
        end
        
        row_flags = row_flags & data_table.yellow_time == yellow_time;
        row_flags = row_flags & data_table.red_time == red_time;

        row_flags = row_flags & data_table.N_p == N_p;
        row_flags = row_flags & data_table.N_c == N_c;
        row_flags = row_flags & data_table.N_s == N_s;

        row_index = find(row_flags);

        % データが存在する場合、データを更新
        if ~isempty(row_index)
            data_table.queue(row_index) = queue;
            data_table.delay(row_index) = delay;
            data_table.speed(row_index) = speed;
            data_table.calc_time(row_index) = calc_time;
            data_table.success_rate(row_index) = success_rate;
        else
            % データが存在しない場合、データを追加
            new_data = cell(1, numel(data_table.Properties.VariableNames));

            new_data{1} = simulation_id;
            new_data{2} = intersection_id;
            new_data{3} = control_method;
            new_data{4} = num_phases;
            new_data{5} = seed;

            for road_id = 1: num_roads
                new_data{5 + road_id} = inputs(road_id);
            end

            for road_id = 1: num_roads
                new_data{5 + num_roads + road_id} = relflows(road_id);
            end

            new_data{5 + 2 * num_roads + 1} = yellow_time;
            new_data{5 + 2 * num_roads + 2} = red_time;

            new_data{5 + 2 * num_roads + 3} = N_p;
            new_data{5 + 2 * num_roads + 4} = N_c;
            new_data{5 + 2 * num_roads + 5} = N_s;

            new_data{5 + 2 * num_roads + 6} = queue;
            new_data{5 + 2 * num_roads + 7} = delay;
            new_data{5 + 2 * num_roads + 8} = speed;
            new_data{5 + 2 * num_roads + 9} = calc_time;
            new_data{5 + 2 * num_roads + 10} = success_rate;

            new_data = cell2table(new_data, 'VariableNames', data_table.Properties.VariableNames);

            data_table = [data_table; new_data];
        end

        % データベースを更新
        writetable(data_table, path);
    end
end