function initMaps(obj)
    % Mapの初期化
    obj.RoadInputMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    obj.RoadOutputMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    obj.IntersectionRoadQueueMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'any');
    obj.IntersectionCalcTimeMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');
    obj.IntersectionRoadNumVehsMap = tool.HierarchicalMap('KeyType1', 'int32','KeyType2', 'int32', 'ValueType', 'any');
    obj.IntersectionRoadDelayMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'any');
    obj.VehicleSpeedsMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

    % シミュレーション時間0秒のときのデータを設定

    % LinkInputOutputMapとLinkRoadMapを取得
    LinkInputOutputMap = obj.Vissim.get('LinkInputOutputMap');
    LinkRoadMap = obj.Vissim.get('LinkRoadMap');

    % RoadInputMapとRoadOutputMapについて
    for link_id = cell2mat(keys(LinkInputOutputMap))
        if strcmp(LinkInputOutputMap(link_id), 'input')
            road_id = LinkRoadMap(link_id);
            obj.RoadInputMap(road_id) = 0;
        elseif strcmp(LinkInputOutputMap(link_id), 'output')
            road_id = LinkRoadMap(link_id);
            obj.RoadOutputMap(road_id) = 0;
        end
    end

    % IntersectionStructMap, RoadLinkMap, LinkQueueCounterMapを取得
    IntersectionStructMap = obj.Vissim.get('IntersectionStructMap');

    % IntersectionRoadQueueMapについて
    for intersection_id = cell2mat(keys(IntersectionStructMap))
        % intersection構造体の取得
        intersection_struct = IntersectionStructMap(intersection_id);

        for road_id = intersection_struct.input_road_ids
            % 道路の順番を取得（時計回りで設定するのがルール）
            order = intersection_struct.InputRoadOrderMap(road_id);

            % 0をマップに格納
            obj.IntersectionRoadQueueMap.add(intersection_id, order, 0);
        end
    end

    % IntersectionCalcTimeMapについて
    for intersection_id = cell2mat(keys(IntersectionStructMap))
        obj.IntersectionCalcTimeMap(intersection_id) = 0;
    end

    % IntersectionNumVehsMapについて
    for intersection_id = cell2mat(keys(IntersectionStructMap))
        % intersection構造体の取得
        intersection_struct = IntersectionStructMap(intersection_id);

        for road_id = intersection_struct.input_road_ids
            % 道路の順番を取得（時計回りで設定するのがルール）
            order = intersection_struct.InputRoadOrderMap(road_id);

            % 空のリストをマップに格納
            obj.IntersectionRoadNumVehsMap.add(intersection_id, order, 0);
        end
    end

    % IntersectionRoadDelayMapについて
    for intersection_id = cell2mat(keys(IntersectionStructMap))
        % intersection構造体の取得
        intersection_struct = IntersectionStructMap(intersection_id);

        for road_id = intersection_struct.input_road_ids
            % 道路の順番を取得（時計回りで設定するのがルール）
            order = intersection_struct.InputRoadOrderMap(road_id);

            % 0をマップに格納
            obj.IntersectionRoadDelayMap.add(intersection_id, order, 0);
        end
    end
end