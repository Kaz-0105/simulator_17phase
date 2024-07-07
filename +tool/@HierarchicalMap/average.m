function values = average(obj, scale)
    if strcmp(scale, 'all')
        % 平均値の計算
        is_first = true;
        count = 0;

        for key1 = cell2mat(obj.OuterMap.keys)
            for key2 = cell2mat(obj.OuterMap(key1).keys)
                % 値の取得
                tmp_value = obj.get(key1, key2);

                % 型が整数や浮動小数点数でない場合
                if ~isnumeric(tmp_value)
                    error('The value is not numeric. We cannot calculate the average.');
                end

                % for分の一番最初は別処理
                if is_first
                    sum = tmp_value;
                    is_first = false;
                else  
                    sum = sum + tmp_value;
                end

                % 要素の個数をインクリメント
                count = count + 1;
            end
        end

        % 平均値を計算してvaluesにプッシュ
        values = double(sum) / count;
    elseif strcmp(scale, 'outer')
        values = containers.Map('KeyType', obj.key_type1, 'ValueType', 'any');

        for key1 = cell2mat(obj.OuterMap.keys)
            % 平均値の計算
            is_first = true;
            count = 0;
            for key2 = cell2mat(obj.OuterMap(key1).keys)
                % 値の取得
                tmp_value = obj.get(key1, key2);

                % 型が整数や浮動小数点数でない場合
                if ~isnumeric(tmp_value)
                    error('The value is not numeric. We cannot calculate the average.');
                end

                % for分の一番最初は別処理
                if is_first
                    sum = tmp_value;
                    is_first = false;
                else
                    sum = sum + tmp_value;
                end

                % 要素の個数をインクリメント
                count = count + 1;
            end

            % 平均に変換してvaluesにプッシュ
            values(key1) = double(sum) / count;
        end
    else
        error('The value of scale is invalid.');
    end
end