function makeRoadLinkPrmsMap(obj)
    % RoadPrmsMapの初期化
    obj.RoadLinkPrmsMap = tool.HierarchicalMap('KeyType1', 'int32', 'KeyType2', 'int32', 'ValueType', 'any');
    
    % RoadNumLinksMapを初期化（後々使う）
    obj.RoadNumLinksMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

    % Vissimクラスからデータを取得
    IntersectionStructMap = obj.Vissim.get('IntersectionStructMap');
    RoadLinkStructMap = obj.Vissim.get('RoadLinkStructMap'); 
    RoadBranchMap = obj.Vissim.get('RoadBranchMap');
    RoadMainLinkMap = obj.Vissim.get('RoadMainLinkMap');

    % intersection構造体の取得
    intersection = IntersectionStructMap(obj.id);

    % RoadNumLinksMapの作成
    for road_id = intersection.input_road_ids
        % 道路の順番を取得
        order_id = intersection.InputRoadOrderMap(road_id);

        % メインリンクのIDを取得
        main_link_id = RoadMainLinkMap(road_id);

        % メインリンクのCOMオブジェクトを取得
        MainLink = obj.Com.Net.Links.ItemByKey(main_link_id);

        % メインリンクのレーン数を取得
        num_links = MainLink.Lanes.Count;

        % RoadNumLinksMapに追加
        obj.RoadNumLinksMap(order_id) = num_links;
    end

    % RoadLinkPrmsMapの作成
    for road_id = intersection.input_road_ids
        % 道路の順番を取得
        order_id = intersection.InputRoadOrderMap(road_id);

        % branch構造体を取得
        branch = RoadBranchMap(road_id);

        % リンクの数を取得
        num_links = obj.RoadNumLinksMap(order_id);

        % RoadLinkStructMapを取得
        LinkStructMap = RoadLinkStructMap.getInnerMap(road_id);

        % メインリンクのlink構造体を取得
        main_link_id = RoadMainLinkMap(road_id);
        main_link = LinkStructMap(main_link_id);

        if num_links == 1
            % prms構造体を初期化
            prms = [];

            % 速度について
            prms.v = main_link.v;

            % D_b: 分岐点から信号機までの距離
            D_b = 0;

            % 左の分岐車線がある場合
            if branch.left ~= 0
                % 分岐車線のlink構造体を取得
                sub_link = LinkStructMap(branch.left);
                connector = LinkStructMap(sub_link.from_link_id);

                % D_b: 分岐点から信号機までの距離
                if main_link.length - connector.from_pos > D_b
                    D_b = main_link.length - connector.from_pos;
                end
            end

            % 右の分岐車線がある場合
            if branch.right ~= 0
                % 分岐車線のlink構造体を取得
                sub_link = LinkStructMap(branch.right);
                connector = LinkStructMap(sub_link.from_link_id);

                % D_b: 分岐点から信号機までの距離
                if main_link.length - connector.from_pos > D_b
                    D_b = main_link.length - connector.from_pos;
                end
            end

            prms.D_b = D_b;

            % D_f: 先行車の影響圏に入る距離
            prms.D_f = main_link.v - 15;

            % D_s: 信号の影響圏内に入る距離
            prms.D_s = main_link.v;

            % d_s: 信号の停止線から信号までの距離
            prms.d_s = 0;

            % d_f: 先行車に最接近する距離
            prms.d_f = 5;

            % p_s: 信号機の位置
            prms.p_s = main_link.length;

            % RoadLinkPrmsMapに追加
            obj.RoadLinkPrmsMap.add(order_id, 1, prms);
        else 
            for link_id = 1: num_links
                % prms構造体を初期化
                prms = [];

                % 速度について
                prms.v = main_link.v;

                if link_id == 1
                    % D_b: 分岐点から信号機までの距離
                    if branch.left ~= 0
                        % 分岐車線のlink構造体を取得
                        sub_link = LinkStructMap(branch.left);
                        connector = LinkStructMap(sub_link.from_link_id);

                        % D_b: 分岐点から信号機までの距離
                        prms.D_b = main_link.length - connector.from_pos;
                    else
                        prms.D_b = 0;
                    end
                elseif link_id == num_links
                    % D_b: 分岐点から信号機までの距離
                    if branch.right ~= 0
                        % 分岐車線のlink構造体を取得
                        sub_link = LinkStructMap(branch.right);
                        connector = LinkStructMap(sub_link.from_link_id);

                        % D_b: 分岐点から信号機までの距離
                        prms.D_b = main_link.length - connector.from_pos;
                    else
                        prms.D_b = 0;
                    end
                    
                else
                    % D_b: 分岐点から信号機までの距離
                    prms.D_b = 0;
                end

                % D_f: 先行車の影響圏に入る距離
                prms.D_f = main_link.v - 15;

                % D_s: 信号の影響圏内に入る距離
                prms.D_s = main_link.v;

                % d_s: 信号の停止線から信号までの距離
                prms.d_s = 0;

                % d_f: 先行車に最接近する距離
                prms.d_f = 3;

                % p_s: 信号機の位置
                prms.p_s = main_link.length;

                % RoadLinkPrmsMapに追加
                obj.RoadLinkPrmsMap.add(order_id, link_id, prms);
            end
        end
    end
end

% if isfield(road, 'signal_controller_id')
%     road_struct.D_b = road_struct.main_link_length - road_struct.from_pos;
%     road_struct.D_f = road.speed - 15;
%     road_struct.D_s = road.speed;
%     road_struct.d_s = 0;
%     road_struct.d_f = 5;
%     road_struct.p_s = obj.Com.Net.SignalHeads.ItemByKey(road.signal_head_ids(1)).get('AttValue', 'Pos') + road_struct.main_link_length;
%     road_struct.v = road.speed;
% end