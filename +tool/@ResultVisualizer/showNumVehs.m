function showNumVehs(obj)
    % LineGraphの設定の取得
    setting = obj.GraphSettingMap('line_graph');

    % 時間データを取得
    time = obj.VissimMeasurements.get('time');

    % 他の結果と比較するか、系全体と交差点ごとのどちらで表示するか場合分け
    if strcmp(obj.Config.result.contents.num_vehs.scale, 'system')
        % RoadInputMapの取得
        RoadInputMap = obj.VissimMeasurements.get('RoadInputMap');

        % RoadOutputMapの取得
        RoadOutputMap = obj.VissimMeasurements.get('RoadOutputMap');

        % 流入口と流出口の通過車両数の合計を時系列で取得
        input_sum = tool.map.sum(RoadInputMap);
        output_sum = tool.map.sum(RoadOutputMap);

        % 系内の車両数の時系列を計算
        num_vehs = [];
        for time_id = 1:length(time)
            if time_id == 1
                num_vehs = [num_vehs, input_sum(time_id) - output_sum(time_id)];
            else
                num_vehs = [num_vehs, num_vehs(end) + input_sum(time_id) - output_sum(time_id)];
            end
        end

        % figureのウィンドウを開く
        obj.tmp_figure_id = obj.tmp_figure_id + 1;
        figure(obj.tmp_figure_id);

        % LineGraphの表示
        plot(time, num_vehs, 'LineWidth', setting.line_width);

        % グラフのタイトルとラベルの設定
        title('Number of Vehicles (all intersection)', 'FontSize', obj.font_sizes.title);
        xlabel('Time [s]', 'FontSize', obj.font_sizes.label);
        ylabel('Number of Vehicles', 'FontSize', obj.font_sizes.label);

        % 座標軸のFontSizeの設定
        ax = gca;
        ax.FontSize = obj.font_sizes.axis;

        % 凡例の表示
        legend('Current data');

        % 過去の結果と比較する場合
        if obj.flags.compare
            % 座標を固定
            hold on;

            for path_id = cell2mat(obj.ComparePathMap.keys)
                % 比較するデータの相対パスの取得
                relative_path = obj.ComparePathMap(path_id);

                % 絶対パスに変換
                if strcmp(relative_path(1), '\')
                    path = strcat(pwd, relative_path);
                else
                    path = strcat(pwd, '\', relative_path);
                end

                % matファイルの読み込み（timeとRoadInputMap、RoadOutputMapの取得）
                time = load(path, 'time');
                RoadInputMap = load(path, 'RoadInputMap');
                RoadOutputMap = load(path, 'RoadOutputMap');

                % 流入口と流出口の通過車両数の合計を時系列で取得
                input_sum = tool.map.sum(RoadInputMap);
                output_sum = tool.map.sum(RoadOutputMap);

                % 系内の車両数の時系列を計算
                num_vehs = [];
                for time_id = 1:length(time)
                    if time_id == 1
                        num_vehs = [num_vehs, input_sum(time_id) - output_sum(time_id)];
                    else
                        num_vehs = [num_vehs, num_vehs(end) + input_sum(time_id) - output_sum(time_id)];
                    end
                end

                % LineGraphの表示
                plot(time, num_vehs, 'LineWidth', setting.line_width);

                % 凡例の表示
                legend('Compare ', num2str(path_id), ' data');
            end
        end
    elseif strcmp(obj.Config.result.contents.num_vehs.scale, 'intersection')
        % IntersectionRoadNumVehsMapの取得
        IntersectionRoadNumVehsMap = obj.VissimMeasurements.get('IntersectionRoadNumVehsMap');

        % IntersectionFigureMapの初期化
        IntersectionFigureMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

        for intersection_id = cell2mat(IntersectionRoadNumVehsMap.outerKeys())
            % RoadNumVehsMapの取得
            RoadNumVehsMap = IntersectionRoadNumVehsMap.getInnerMap(intersection_id);

            % 交差点全体での車両数を取得
            num_vehs = tool.map.sum(RoadNumVehsMap);

            % figureのウィンドウを開く
            obj.tmp_figure_id = obj.tmp_figure_id + 1;
            figure(obj.tmp_figure_id);

            % LineGraphの表示
            plot(time, num_vehs, 'LineWidth', setting.line_width);

            % グラフのタイトルとラベルの設定
            title(strcat('Number of Vehicles (intersection ID : ', num2str(intersection_id), ')'), 'FontSize', obj.font_sizes.title);
            xlabel('Time [s]', 'FontSize', obj.font_sizes.label);
            ylabel('Number of Vehicles', 'FontSize', obj.font_sizes.label);

            % 座標軸のFontSizeの設定
            ax = gca;
            ax.FontSize = obj.font_sizes.axis;

            % 凡例の表示
            legend('Current data');
        end

        % 過去の結果と比較する場合
        if obj.flags.compare
            for path_id = cell2mat(obj.ComparePathMap.keys)
                % 比較するデータの相対パスの取得
                relative_path = obj.ComparePathMap(path_id);

                % 絶対パスに変換
                if strcmp(relative_path(1), '\')
                    path = strcat(pwd, relative_path);
                else
                    path = strcat(pwd, '\', relative_path);
                end

                % matファイルの読み込み（timeとIntersectionRoadNumVehsMapの取得）
                time = load(path, 'time');
                IntersectionRoadNumVehsMap = load(path, 'IntersectionRoadNumVehsMap');

                % 交差点ごとの車両数を取得
                for intersection_id = cell2mat(IntersectionRoadNumVehsMap.outerKeys())
                    % figureのウィンドウを開く
                    figure_id = IntersectionFigureMap(intersection_id);
                    figure(figure_id);

                    % 座標を固定
                    hold on;

                    % RoadNumVehsMapの取得
                    RoadNumVehsMap = IntersectionRoadNumVehsMap.getInnerMap(intersection_id);

                    % 交差点全体での車両数を取得
                    num_vehs = tool.map.sum(RoadNumVehsMap);

                    % LineGraphの表示
                    plot(time, num_vehs, 'LineWidth', setting.line_width);

                    % 凡例の表示
                    legend(strcat('Compare ', num2str(path_id), ' data'));

                    % 座標の固定を解除
                    hold off;
                end
            end
        end
    end
end