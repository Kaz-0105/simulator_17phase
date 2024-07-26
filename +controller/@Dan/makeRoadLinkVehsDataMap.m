function makeRoadLinkVehsDataMap(obj)
    % RoadLinkPosVehsMapとRoadLinkRouteVehsMapとRoadLinkLaneVehsMapを初期化
    obj.RoadLinkPosVehsMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'any');
    obj.RoadLinkRouteVehsMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'any');
    obj.RoadLinkLaneVehsMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'any');
    
    % RoadNumLinksMapを初期化（後々使う）
    obj.RoadNumLinksMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

    % Vissimクラスからデータを取得
    IntersectionStructMap = obj.Vissim.get('IntersectionStructMap');
    RoadNumLanesMap = obj.Vissim.get('RoadNumLanesMap');
    RoadBranchMap = obj.Vissim.get('RoadBranchMap');

    % VissimDataクラスからデータを取得
    VissimData = obj.Vissim.get('VissimData');
    RoadLaneVehsDataMap = VissimData.get('RoadLaneVehsDataMap');

    % intersection構造体を取得
    intersection = IntersectionStructMap(obj.id);

    for road_id = intersection.input_road_ids
        % 道路の順番を取得
        order_id = intersection.InputRoadOrderMap(road_id);

        % リンクの数を取得
        num_links = obj.RoadNumLinksMap(order_id);

        if num_links == 1
            % 自動車情報の数値行列を初期化
            tmp_vehs_data = [];

            for lane_id = 1: RoadNumLanesMap(road_id)
                % 自動車情報を取得
                vehs_data = RoadLaneVehsDataMap.get(road_id, lane_id);

                % 車線情報を追加
                [num_vehs, ~] = size(vehs_data);
                vehs_data = [vehs_data, double(lane_id) * ones(num_vehs, 1)];

                % tmp_vehs_dataにプッシュ
                tmp_vehs_data = [tmp_vehs_data; vehs_data];
            end

            % 自動車の位置で降順にソート
            tmp_vehs_data = sortrows(tmp_vehs_data, 1, 'descend');

            % RoadLinkPosVehsMapに追加
            if ~isempty(tmp_vehs_data)
                obj.RoadLinkPosVehsMap.add(order_id, 1, tmp_vehs_data(:, 1));
            else
                obj.RoadLinkPosVehsMap.add(order_id, 1, []);
            end

            % RoadLinkRouteVehsMapに追加
            if ~isempty(tmp_vehs_data)
                obj.RoadLinkRouteVehsMap.add(order_id, 1, tmp_vehs_data(:, 2));
            else
                obj.RoadLinkRouteVehsMap.add(order_id, 1, []);
            end

            % RoadLinkLaneVehsMapに追加
            if ~isempty(tmp_vehs_data)
                obj.RoadLinkLaneVehsMap.add(order_id, 1, tmp_vehs_data(:, 3));
            else
                obj.RoadLinkLaneVehsMap.add(order_id, 1, []);
            end
        else
            % branch構造体を取得
            branch = RoadBranchMap(road_id);

            % 車線のカウンターを初期化
            count = 0;
            end_count = 0;

            for link_id = 1: num_links
                % 自動車情報の数値行列を初期化
                tmp_vehs_data = [];

                if link_id == 1
                    if branch.left ~= 0
                        % 車線のカウンターの更新
                        count = count + 1;

                        % 自動車情報の取得
                        vehs_data = RoadLaneVehsDataMap.get(road_id, count);

                        % 車線情報を追加
                        [num_vehs, ~] = size(vehs_data);
                        vehs_data = [vehs_data, (count - end_count) * ones(num_vehs, 1)];

                        % tmp_vehs_dataにプッシュ
                        tmp_vehs_data = [tmp_vehs_data; vehs_data];

                        % 車線のカウンターの更新
                        count = count + 1;

                        % 自動車情報の取得
                        vehs_data = RoadLaneVehsDataMap.get(road_id, count);

                        % 車線情報を追加
                        [num_vehs, ~] = size(vehs_data);
                        vehs_data = [vehs_data, (count - end_count) * ones(num_vehs, 1)];

                        % tmp_vehs_dataにプッシュ
                        tmp_vehs_data = [tmp_vehs_data; vehs_data];

                        % 車線のカウンターの更新
                        end_count = count;

                    else
                        % 車線のカウンターの更新
                        count = count + 1;

                        % 自動車情報の取得
                        vehs_data = RoadLaneVehsDataMap.get(road_id, count);
                        
                        % 車線情報を追加
                        [num_vehs, ~] = size(vehs_data);
                        vehs_data = [vehs_data, (count - end_count) * ones(num_vehs, 1)];

                        % tmp_vehs_dataにプッシュ
                        tmp_vehs_data = [tmp_vehs_data; vehs_data];

                        % 車線のカウンターの更新
                        end_count = count;  

                    end
                elseif link_id == num_links
                    if branch.right ~= 0
                        % 車線のカウンターの更新
                        count = count + 1;

                        % 自動車情報の取得
                        vehs_data = RoadLaneVehsDataMap.get(road_id, count);
                        
                        % 車線情報を追加
                        [num_vehs, ~] = size(vehs_data);
                        vehs_data = [vehs_data, (count - end_count) * ones(num_vehs, 1)];
                        
                        % tmp_vehs_dataにプッシュ
                        tmp_vehs_data = [tmp_vehs_data; vehs_data];

                        % 車線のカウンターの更新
                        count = count + 1;

                        % 自動車情報の取得
                        vehs_data = RoadLaneVehsDataMap.get(road_id, count);

                        % 車線情報を追加
                        [num_vehs, ~] = size(vehs_data);
                        vehs_data = [vehs_data, (count - end_count) * ones(num_vehs, 1)];

                        % tmp_vehs_dataにプッシュ
                        tmp_vehs_data = [tmp_vehs_data; vehs_data];

                        % 車線のカウンターの更新
                        end_count = count;
                    else
                        % 車線のカウンターの更新
                        count = count + 1;

                        % 自動車情報の取得
                        vehs_data = RoadLaneVehsDataMap.get(road_id, count);

                        % 車線情報を追加
                        [num_vehs, ~] = size(vehs_data);
                        vehs_data = [vehs_data, (count - end_count) * ones(num_vehs, 1)];

                        % tmp_vehs_dataにプッシュ
                        tmp_vehs_data = [tmp_vehs_data; vehs_data];

                        % 車線のカウンターの更新
                        end_count = count;
                    end
                else
                    % 車線のカウンターの更新
                    count = count + 1;

                    % 自動車情報の取得
                    vehs_data = RoadLaneVehsDataMap.get(road_id, count);
                    
                    % 車線情報を追加
                    [num_vehs, ~] = size(vehs_data);
                    vehs_data = [vehs_data, (count - end_count) * ones(num_vehs, 1)];

                    % tmp_vehs_dataにプッシュ
                    tmp_vehs_data = [tmp_vehs_data; vehs_data];

                    % 車線のカウンターの更新
                    end_count = count;
                end

                % 自動車の位置で降順にソート
                tmp_vehs_data = sortrows(tmp_vehs_data, 1, 'descend');

                % RoadLinkPosVehsMapにプッシュ
                if ~isempty(tmp_vehs_data)
                    obj.RoadLinkPosVehsMap.add(order_id, link_id, tmp_vehs_data(:, 1));
                else
                    obj.RoadLinkPosVehsMap.add(order_id, link_id, []);
                end

                % RoadLinkRouteVehsMapにプッシュ
                if ~isempty(tmp_vehs_data)
                    obj.RoadLinkRouteVehsMap.add(order_id, link_id, tmp_vehs_data(:, 2));
                else
                    obj.RoadLinkRouteVehsMap.add(order_id, link_id, []);
                end

                % RoadLinkLaneVehsMapにプッシュ
                if ~isempty(tmp_vehs_data)
                    obj.RoadLinkLaneVehsMap.add(order_id, link_id, tmp_vehs_data(:, 3));
                else
                    obj.RoadLinkLaneVehsMap.add(order_id, link_id, []);
                end
            end
        end      
    end
end
