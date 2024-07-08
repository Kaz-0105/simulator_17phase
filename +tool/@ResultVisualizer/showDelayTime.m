function showDelayTime(obj)
    % LineGraphの設定
    setting = obj.GraphSettingMap('line_graph');

    % 時間データを取得
    time = obj.VissimMeasurements.get('time');

    % 他の結果と比較するか、系全体と交差点ごとのどちらで表示するか場合分け
    if strcmp(obj.Config.result.contents.delay_time.scale, 'system')
        % IntersectionRoadDelayMapの取得
        IntersectionRoadDelayMap = obj.VissimMeasurements.get('IntersectionRoadDelayMap');

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
        
                % matファイルの読み込み（timeとIntersectionRoadDelayMapの取得）
                time = load(path, 'time');
                IntersectionRoadDelayMap = load(path, 'IntersectionRoadDelayMap');

                % 全ての交差点でのキューの長さを取得
                delay_avg = IntersectionRoadDelayMap.average('all');

                % LineGraphの表示
                plot(time, delay_avg, 'LineWidth', setting.line_width);

                % 凡例の表示
                legend(strcat('Compare ', num2str(path_id), ' data'));
            end

            % 座標の固定を解除
            hold off;
        end
    elseif strcmp(obj.Config.result.contents.delay_time.scale, 'intersection');
        % IntersectionRoadDelayMapの取得
        IntersectionRoadDelayMap = obj.VissimMeasurements.get('IntersectionRoadDelayMap');

        % IntersectionDelayMapを作成
        IntersectionDelayMap = IntersectionRoadDelayMap.average('outer');

        % IntersectionFigureMapの取得
        IntersectionFigureMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

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


                % matファイルの読み込み（timeとIntersectionRoadDelayMapの取得）
                time = load(path, 'time');
                IntersectionRoadDelayMap = load(path, 'IntersectionRoadDelayMap');

                % IntersectionDelayMapを作成
                IntersectionDelayMap = IntersectionRoadDelayMap.average('outer');

                for intersection_id = cell2mat(IntersectionDelayMap.keys)
                    % figureのウィンドウを開く
                    figure_id = IntersectionFigureMap(intersection_id);
                    figure(figure_id);

                    % 座標を固定
                    hold on;

                    % 各交差点でのキューの長さを取得
                    delay_avg = IntersectionDelayMap(intersection_id);

                    % LineGraphの表示
                    plot(time, delay_avg, 'LineWidth', setting.line_width);

                    % 凡例の表示
                    legend(strcat('Compare ', num2str(path_id), ' data'));

                    % 座標の固定を解除
                    hold off;
                end
            end
        end
    end
end