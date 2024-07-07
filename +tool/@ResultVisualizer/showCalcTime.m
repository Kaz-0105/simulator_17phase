function showCalcTime(obj)
    % 他の結果と比較するか、系全体と交差点ごとのどちらで表示するか場合分け
    if strcmp(obj.Config.result.contents.calc_time.scale, 'system')
        % IntersectionCalcTimeMapの取得
        IntersectionCalcTimeMap = obj.VissimMeasurements.get('IntersectionCalcTimeMap');

        % 平均値の計算
        average = tool.map.average(IntersectionCalcTimeMap);

        % figureのウィンドウを開く
        figure;

        % histogramの表示
        histogram(average, 'BinWidth', 1, 'FaceAlpha', 0.5, 'data1');

        % グラフのタイトル、ラベルの設定
        title('Calculation Time (average of all intersections)', 'FontSize', obj.font_size.title);
        xlabel('Calculation Time [s]', 'FontSize', obj.font_size.label);
        ylabel('Frequency', 'FontSize', obj.font_size.label);

        % 座標軸のFontSizeの設定
        ax = gca;
        ax.FontSize = obj.font_size.axis;

        % 過去の結果と比較する場合
        if obj.compare_flag
            % 座標を固定
            hold on;

            for path_id = cell2mat(obj.CompareDataPathMap.keys)
                % 比較するデータの相対パスの取得
                relative_path = obj.CompareDataPathMap(path_id);

                % 絶対パスに変換
                if strcmp(path(1), '\')
                    path = strcat(pwd, relative_path);
                else 
                    path = strcat(pwd, '\', relative_path);
                end

                % matファイルの読み込み（IntersectionCalcTimeMapの取得）
                IntersectionCalcTimeMap = load(path, 'IntersectionCalcTimeMap');

                % 平均値の計算
                average = tool.map.average(IntersectionCalcTimeMap);

                % legendのラベルの設定
                legend_label = strcat('data', num2str(path_id + 1));

                % histogramの表示
                histogram(average, 'BinWidth', 1, 'FaceAlpha', 0.5, legend_label);
            end

            % 凡例の表示
            legend();

            % 座標の固定を解除
            hold off;
        end
    elseif strcmp(obj.Config.result.contents.calc_time.scale, 'intersection')
        % IntersectionCalcTimeMapの取得
        IntersectionCalcTimeMap = obj.VissimMeasurements.get('IntersectionCalcTimeMap');

        % 交差点ごとにグラフを作成
        for intersection_id = cell2mat()

    end
end