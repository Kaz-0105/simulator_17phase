classdef StandardMap < containers.Map
    methods
        function value = average(obj)
            is_first = true;
            count = 0;
            for key = cell2mat(obj.keys)
                % 数値であることを確認
                if ~isnumeric(obj(key)) || ~isinteger(obj(key))
                    error('The value is not numeric. We cannot calculate the average.');
                end

                % 一番最初のキーだけ別処理
                if is_first
                    sum = obj(key);
                    is_first = false;
                else
                    sum = sum + obj(key);
                end

                % 要素の個数をインクリメント
                count = count + 1;
            end

            % 平均値を計算してvalueにプッシュ
            value = sum / count;
        end
    end
end