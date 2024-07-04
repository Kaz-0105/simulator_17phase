function showCalcTime(obj, varargin)
    % IntersectionCalcTimeMapを取得
    IntersectionCalcTimeMap = obj.VissimMeasurements.get('IntersectionCalcTimeMap');

    if mod(nargin, 2) ~= 0
        error('Invalid number of parameters in method showCalcTime.');
    end

    % scaleがsystemかintersectionかを判定
    % compareがtrueかfalseかを判定
    for i = 1:2:nargin
        if strcmp(varargin{i}, 'scale')
            scale = varargin{i + 1};
        elseif strcmp(varargin{i}, 'compare')
            compare = varargin{i + 1};
        else
            error('Invalid parameter name in method showCalcTime.');
        end
    end

    if strcmp(scale, 'system')
        if compare
        else
        end
    elseif strcmp(scale, 'intersection')
        if compare
        else 
        end
    else
        error('Invalid scale in method showCalcTime.');
    end

end