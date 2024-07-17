function makeDelta4List(obj)
    % RoadLinkDelta4ListMapを初期化（δ4はD2行列で他の自動車の変数も必要になるため詳しく整理する）
    obj.RoadLinkDelta4ListMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'any');

    % uとzの変数の最後のインデックスを取得
    last_index = obj.u_length + obj.z_length;

    % delta_1の変数のリストを作成
    delta4_list = [];

    for road_id = 1: obj.road_num
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % LaneFirstVehsMapを取得
            LaneFirstVehsMap = obj.RoadLinkLaneFirstVehsMap.get(road_id, link_id);

            % リンクごとのδ4のリストを初期化
            link_delta4_list = [];

            % リンクごとの最後のインデックスを初期化
            link_last_index = 0;

            for veh_id = 1: obj.RoadLinkNumVehsMap.get(road_id, link_id)
                if veh_id == 1
                    % last_indexを更新
                    last_index = last_index + 4;

                    % link_last_indexを更新
                    link_last_index = link_last_index + 4;

                elseif veh_id == LaneFirstVehsMap(1)
                    % last_indexを更新
                    last_index = last_index + 7;

                    % link_last_indexを更新
                    link_last_index = link_last_index + 7;
                    
                elseif veh_id == LaneFirstVehsMap(2)
                    % last_indexを更新
                    last_index = last_index + 7;

                    % link_last_indexを更新 
                    link_last_index = link_last_index + 7;
                    
                elseif veh_id == LaneFirstVehsMap(3)
                    % last_indexを更新
                    last_index = last_index + 7;

                    % link_last_indexを更新
                    link_last_index = link_last_index + 7;
                    
                else
                    % delta4_listに追加
                    delta4_list = [delta4_list, last_index + 9];

                    % last_indexを更新
                    last_index = last_index + 10;

                    % link_delta4_listに追加
                    link_delta4_list = [link_delta4_list, link_last_index + 9];

                    % link_last_indexを更新
                    link_last_index = link_last_index + 10;
                end
            end

            % RoadLinkDelta4ListMapにリンクごとのδ4のリストを追加
            obj.RoadLinkDelta4ListMap.add(road_id, link_id, link_delta4_list);

        end
    end

    % VariableListMapにdelta_1の変数のリストを追加
    obj.VariableListMap('delta_4') = delta4_list;
end