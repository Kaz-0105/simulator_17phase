function makeDelta1List(obj)
    % RoadLinkDelta1ListMapを初期化（δ4はD2行列で他の自動車の変数も必要になるため詳しく整理する）
    obj.RoadLinkDelta1ListMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'any');

    % uとzの変数の最後のインデックスを取得
    last_index = obj.u_length + obj.z_length;

    % delta_1の変数のリストを作成
    delta1_list = [];

    for road_id = 1: obj.road_num
        for link_id = 1: obj.RoadNumLinksMap(road_id)
            % LaneFirstVehsMapを取得
            LaneFirstVehsMap = obj.RoadLinkLaneFirstVehsMap.get(road_id, link_id);

            % リンクごとのδ1のリストを初期化
            link_delta1_list = [];

            % リンクごとの最後のインデックスを初期化
            link_last_index = 0;

            for veh_id = 1: obj.RoadLinkNumVehsMap.get(road_id, link_id)
                if veh_id == 1
                    % delta1_listに追加
                    delta1_list = [delta1_list, last_index + 3];

                    % last_indexを更新
                    last_index = last_index + 4;

                    % link_delta1_listに追加
                    link_delta1_list = [link_delta1_list, link_last_index + 3];

                    % link_last_indexを更新
                    link_last_index = link_last_index + 4;

                elseif veh_id == LaneFirstVehsMap(1)
                    % delta1_listに追加
                    delta1_list = [delta1_list, last_index + 5];

                    % last_indexを更新
                    last_index = last_index + 7;

                    % link_delta1_listに追加
                    link_delta1_list = [link_delta1_list, link_last_index + 5];

                    % link_last_indexを更新
                    link_last_index = link_last_index + 7;
                    
                elseif veh_id == LaneFirstVehsMap(2)
                    % delta1_listに追加
                    delta1_list = [delta1_list, last_index + 5];

                    % last_indexを更新
                    last_index = last_index + 7;

                    % link_delta1_listに追加
                    link_delta1_list = [link_delta1_list, link_last_index + 5];

                    % link_last_indexを更新
                    link_last_index = link_last_index + 7;
                    
                elseif veh_id == LaneFirstVehsMap(3)
                    % delta1_listに追加
                    delta1_list = [delta1_list, last_index + 5];

                    % last_indexを更新
                    last_index = last_index + 7;

                    % link_delta1_listに追加
                    link_delta1_list = [link_delta1_list, link_last_index + 5];

                    % link_last_indexを更新
                    link_last_index = link_last_index + 7;
                    
                else
                    % delta1_listに追加
                    delta1_list = [delta1_list, last_index + 6];

                    % last_indexを更新
                    last_index = last_index + 10;

                    % link_delta1_listに追加
                    link_delta1_list = [link_delta1_list, link_last_index + 6];

                    % link_last_indexを更新
                    link_last_index = link_last_index + 10;

                end
            end

            % RoadLinkDelta1ListMapにリンクごとのδ1のリストを追加
            obj.RoadLinkDelta1ListMap.add(road_id, link_id, link_delta1_list);
        end
    end

    % VariableListMapにdelta_1の変数のリストを追加
    obj.VariableListMap('delta_1') = delta1_list;
end