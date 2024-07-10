function updateIntersectionRoadDelayMap(obj)
    % IntesectionStructMap, RoadDelayMeasurementMapを取得
    IntersectionStructMap = obj.Vissim.get('IntersectionStructMap');
    RoadDelayMeasurementMap = obj.Vissim.get('RoadDelayMeasurementMap');

    % 系内の平均を出力するための変数を初期化
    sum = 0;
    count = 0;
    
    for intersection_id = cell2mat(keys(IntersectionStructMap))
        % intersection構造体の取得
        intersection_struct = IntersectionStructMap(intersection_id);

        for road_id = intersection_struct.input_road_ids
            % 道路の順番を取得（時計回りで設定するのがルール）
            order = intersection_struct.InputRoadOrderMap(road_id);

            % 前回までの遅れ時間を取得
            delay_time_data = obj.IntersectionRoadDelayMap.get(intersection_struct.id, order);

            % 遅れ時間の合計値を初期化
            sum1 = 0;

            % DelayTimeMeasurementのカウンターの初期化
            count1 = 0;

            % 遅れ時間の計算
            for delay_measurement_id = RoadDelayMeasurementMap(road_id)
                % DelayMeasurementのCOMオブジェクトから情報を取得
                tmp_delay_time = obj.Com.Net.DelayMeasurements.ItemByKey(delay_measurement_id).get('AttValue', 'VehDelay(Current, Last, All)');

                % tmp_delay_timeがNaNの場合は前回のデータを使う
                if isnan(tmp_delay_time)
                    tmp_delay_time = delay_time_data(end);
                end
                
                % 遅れ時間を加算
                sum1 = sum1 + tmp_delay_time;

                % DelayTimeMeasurementのカウンターを更新
                count1 = count1 + 1;
            end

            % 平均をとる
            delay_time = sum1 / count1;

            % 遅れ時間をMapにプッシュ
            obj.IntersectionRoadDelayMap.set(intersection_struct.id, order, [delay_time_data, delay_time]);

            % 遅れ時間の合計値とカウンターを加算
            sum = sum + delay_time;
            count = count + 1;
        end
    end

    % 平均を計算
    average = sum / count;
    
    % 表示
    fprintf('Delay Time: %f\n', average);
end