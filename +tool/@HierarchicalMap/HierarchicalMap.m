classdef HierarchicalMap < handle
    properties
        OuterMap;
        CounterMap;
    end

    properties
        key_type1;
        key_type2;
        value_type;
    end

    methods
        function obj = HierarchicalMap(varargin)
            % キーとバリューの型指定
            if nargin == 6
                for i = 1:2:5
                    if strcmp(varargin{i},'KeyType1')
                        obj.key_type1 = varargin{i + 1};
                    elseif strcmp(varargin{i},'KeyType2')
                        obj.key_type2 = varargin{i + 1};
                    elseif strcmp(varargin{i},'ValueType')
                        obj.value_type = varargin{i + 1};
                    else
                        error('Invalid parameter name.');
                    end
                end
            else
                error('Invalid number of parameters.');
            end

            % 外側のマップの初期化
            obj.OuterMap = containers.Map('KeyType', obj.key_type1, 'ValueType', 'any');

            % カウンターマップの初期化
            obj.CounterMap = containers.Map('KeyType', obj.key_type1, 'ValueType', 'int32');
        end
    end

    methods
        add(obj, key1, key2, value);
        value = get(obj, key1, key2);
        Map = getInnerMap(obj, key1);
        set(obj, key1, key2, value);
        remove(obj, key1, key2);
        values = outerKeys(obj);
        values = innerKeys(obj, key1);
        displayCounter(obj);
        flag = isKey(obj, key1, key2);
        values = average(obj, scale);
    end
end