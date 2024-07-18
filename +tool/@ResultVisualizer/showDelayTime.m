function showDelayTime(obj)
    % LineGraphの設定
    setting = obj.GraphSettingMap('line_graph');

    % 時間データを取得
    time = obj.VissimMeasurements.get('time');

    % IntersectionRoadDelayMapの取得
    IntersectionRoadDelayMap = obj.VissimMeasurements.get('IntersectionRoadDelayMap');

    % 他の結果と比較するか、系全体と交差点ごとのどちらで表示するか場合分け
    if strcmp(obj.Config.result.contents.delay_time.scale, 'system')
        % 全ての交差点でのキューの長さを平均
        delay_avg = IntersectionRoadDelayMap.average('all');

        % figureのウィンドウを開く
        obj.tmp_figure_id = obj.tmp_figure_id + 1;
        figure(obj.tmp_figure_id);

        % LineGraphの表示
        plot(time, delay_avg, 'LineWidth', setting.line_width);

        % グラフのタイトルとラベルの設定
        title('Delay Time (all intersection)', 'FontSize', obj.font_sizes.title);
        xlabel('Time [s]', 'FontSize', obj.font_sizes.label);
        ylabel('Delay Time [s]', 'FontSize', obj.font_sizes.label);

        % グラフのx軸の範囲を設定
        xlim([0, time(end)]);

        % 座標軸のFontSizeの設定
        ax = gca;
        ax.FontSize = obj.font_sizes.axis;

        % 凡例をまとめるセル配列を作成
        legend_list = {'Current data'};

        % 凡例の表示
        legend(legend_list);

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
        
                % matファイルの読み込み（timeとIntersectionRoadDelayMapの取得）
                load(path, 'time');
                load(path, 'IntersectionRoadDelayMap');

                % 全ての交差点でのキューの長さを取得
                delay_avg = IntersectionRoadDelayMap.average('all');

                % LineGraphの表示
                plot(time, delay_avg, 'LineWidth', setting.line_width);

                % 凡例の追加
                legend_list{end+1} = strcat('Compare ', num2str(path_id), ' data');

                % 凡例の表示
                legend(legend_list);
            end

            % 座標の固定を解除
            hold off;
        end
    elseif strcmp(obj.Config.result.contents.delay_time.scale, 'intersection')
        % IntersectionDelayMapを作成
        IntersectionDelayMap = IntersectionRoadDelayMap.average('outer');

        % IntersectionFigureMapの取得
        IntersectionFigureMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

        % IntersectionLegendListMapの初期化
        IntersectionLegendListMap = containers.Map('KeyType', 'int32', 'ValueType', 'any');

        % 交差点ごとにグラフを作成
        for intersection_id = cell2mat(IntersectionDelayMap.keys)
            % figureのウィンドウを開く
            obj.tmp_figure_id = obj.tmp_figure_id + 1;
            figure(obj.tmp_figure_id);

            % IntersectionFigureMapに追加
            IntersectionFigureMap(intersection_id) = obj.tmp_figure_id;

            % 各交差点でのキューの長さを取得
            delay_avg = IntersectionDelayMap(intersection_id);

            % LineGraphの表示
            plot(time, delay_avg, 'LineWidth', setting.line_width);

            % グラフのタイトルとラベルの設定
            title(strcat('Delay Time (intersection : ', num2str(intersection_id), ')'), 'FontSize', obj.font_sizes.title);
            xlabel('Time [s]', 'FontSize', obj.font_sizes.label);
            ylabel('Delay Time [m]', 'FontSize', obj.font_sizes.label);

            % グラフのx軸の範囲を設定
            xlim([0, time(end)]);

            % 座標軸のFontSizeの設定
            ax = gca;
            ax.FontSize = obj.font_sizes.axis;

            % 凡例をまとめるセル配列を作成
            legend_list = {'Current data'};

            % IntersectionLegendListMapにプッシュ
            IntersectionLegendListMap(intersection_id) = legend_list;

            % 凡例の表示
            legend(legend_list);
        end

        % 過去の結果と比較する場合
        if obj.flags.compare
            % path_idの最大値を取得
            max_path_id = max(cell2mat(obj.ComparePathMap.keys));

            for path_id = cell2mat(obj.ComparePathMap.keys)
                % 比較するデータの相対パスの取得
                relative_path = obj.ComparePathMap(path_id);

                % 絶対パスに変換
                if strcmp(relative_path(1), '\')
                    path = strcat(pwd, relative_path);
                else
                    path = strcat(pwd, '\', relative_path);
                end

                % matファイルの読み込み（timeとIntersectionRoadDelayMapの取得）
                load(path, 'time');
                load(path, 'IntersectionRoadDelayMap');

                % IntersectionDelayMapを作成
                IntersectionDelayMap = IntersectionRoadDelayMap.average('outer');

                for intersection_id = cell2mat(IntersectionDelayMap.keys)
                    % figureのウィンドウを開く
                    figure_id = IntersectionFigureMap(intersection_id);
                    figure(double(figure_id));

                    % 座標を固定
                    hold on;

                    % 各交差点でのキューの長さを取得
                    delay_avg = IntersectionDelayMap(intersection_id);

                    % LineGraphの表示
                    plot(time, delay_avg, 'LineWidth', setting.line_width);

                    % 凡例の追加
                    legend_list = IntersectionLegendListMap(intersection_id);
                    legend_list{end+1} = strcat('Compare ', num2str(path_id), ' data');

                    % IntersectionLegendListMapにプッシュ
                    IntersectionLegendListMap(intersection_id) = legend_list;

                    % 凡例の表示
                    if path_id == max_path_id
                        legend(legend_list);
                    end

                    % 座標の固定を解除
                    hold off;
                end
            end
        end
    end

    % 交差点ごとの場合はシステム全体での時系列データを作っていないので作成
    if strcmp(obj.Config.result.contents.delay_time.scale, 'intersection')
        % 全ての交差点でのキューの長さを平均
        delay_avg = IntersectionRoadDelayMap.average('all');
    end

    % 評価指標の出力
    fprintf('Average Delay Time: %f\n', mean(delay_avg));

end