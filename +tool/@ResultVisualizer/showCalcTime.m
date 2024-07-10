function showCalcTime(obj)
    % histogramの設定を取得
    setting = obj.GraphSettingMap('histogram');

    % max_timeの取得
    max_time = obj.Config.mpc.max_time;

    % 他の結果と比較するか、系全体と交差点ごとのどちらで表示するか場合分け
    if strcmp(obj.Config.result.contents.calc_time.scale, 'system')
        % IntersectionCalcTimeMapの取得
        IntersectionCalcTimeMap = obj.VissimMeasurements.get('IntersectionCalcTimeMap');

        % 全ての交差点での計算時間の時系列を結合
        connect = tool.map.connect(IntersectionCalcTimeMap);

        % figureのウィンドウを開く
        obj.tmp_figure_id = obj.tmp_figure_id + 1;
        figure(obj.tmp_figure_id);

        % histogramの表示
        histogram(connect, 'BinWidth', setting.bin_width, 'FaceAlpha', setting.face_alpha, 'BinLimits', [-1, 2*max_time]);

        % グラフのタイトル、ラベルの設定
        title('Calculation Time (all intersection)', 'FontSize', obj.font_sizes.title);
        xlabel('Calculation Time [s]', 'FontSize', obj.font_sizes.label);
        ylabel('Frequency', 'FontSize', obj.font_sizes.label);

        % 座標軸のFontSizeの設定
        ax = gca;
        ax.FontSize = obj.font_sizes.axis;

        % 凡例をまとめるセル配列を作成
        legend_list = {'Current data'};

        % 凡例を表示
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

                % matファイルの読み込み（IntersectionCalcTimeMapの取得）
                load(path, 'IntersectionCalcTimeMap');

                % 全ての交差点での計算時間の時系列を結合
                connect = tool.map.connect(IntersectionCalcTimeMap);

                % histogramの表示
                histogram(connect, 'BinWidth', setting.bin_width, 'FaceAlpha', setting.face_alpha, 'BinLimits', [-1, 2*max_time]);

                % 凡例の追加
                legend_list{end+1} = strcat('Compare ', num2str(path_id), ' data');
            end

            % 凡例の表示
            legend(legend_list);

            % 座標の固定を解除
            hold off;
        end
    elseif strcmp(obj.Config.result.contents.calc_time.scale, 'intersection')
        % IntersectionCalcTimeMapの取得
        IntersectionCalcTimeMap = obj.VissimMeasurements.get('IntersectionCalcTimeMap');

        % IntersectionFigureMapの初期化
        IntersectionFigureMap = containers.Map('KeyType', 'int32', 'ValueType', 'int32');

        % IntersectionLegendListMapの初期化
        IntersectionLegendListMap = containers.Map('KeyType', 'int32', 'ValueType', 'any'); 

        % 交差点ごとにグラフを作成
        for intersection_id = cell2mat(IntersectionCalcTimeMap.keys)
            % figureのウィンドウを開く
            obj.tmp_figure_id = obj.tmp_figure_id + 1;
            figure(obj.tmp_figure_id);

            % IntersectionFigureMapに追加
            IntersectionFigureMap(intersection_id) = obj.tmp_figure_id;

            % histogramの表示
            histogram(IntersectionCalcTimeMap(intersection_id), 'BinWidth', setting.bin_width, 'FaceAlpha', setting.face_alpha, 'BinLimits', [-1, 2*max_time]);

            % グラフのタイトル、ラベルの設定
            title(strcat('Calculation Time (intersection : ', num2str(intersection_id), ')'), 'FontSize', obj.font_sizes.title);
            xlabel('Calculation Time [s]', 'FontSize', obj.font_sizes.label);
            ylabel('Frequency', 'FontSize', obj.font_sizes.label);

            % 座標軸のFontSizeの設定
            ax = gca;
            ax.FontSize = obj.font_sizes.axis;

            % 凡例の追加
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

                % matファイルの読み込み（IntersectionCalcTimeMapの取得)
                load(path, 'IntersectionCalcTimeMap');

                % 交差点ごとにグラフを作成
                for intersection_id = cell2mat(IntersectionCalcTimeMap.keys)
                    % figureのウィンドウを開く
                    figure_id = IntersectionFigureMap(intersection_id);
                    figure(double(figure_id));

                    % 座標を固定
                    hold on;

                    % histogramの表示
                    histogram(IntersectionCalcTimeMap(intersection_id), 'BinWidth', setting.bin_width, 'FaceAlpha', setting.face_alpha, 'BinLimits', [-1, 2*max_time]);

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
end