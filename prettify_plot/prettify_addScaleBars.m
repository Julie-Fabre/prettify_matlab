function prettify_addScaleBars(xLength, yLength, labelX, labelY, position, unitX, unitY, scaleLineWidth, fontSize)
% prettify_addScaleBars Add scale bars to a MATLAB figure
%
%   prettify_addScaleBars(xLength, yLength, labelX, labelY, position) adds scale bars to
%   the current figure. xLength and yLength specify the lengths of the
%   x and y scale bars respectively, labelX and labelY are the
%   labels for the x and y scale bars, and position specifies the
%   location ('bottomLeft', 'bottomRight', 'topLeft', 'topRight').
%
%   If no arguments are provided, the function will default to 25% 
%   (finding the nearest integer or decimal) of
%   the respective axis range and 'bottomRight' position.
%
%   Example:
%   plot(rand(10, 1))
%   prettify_addScaleBars([], [], [], [], 'topLeft')

% Get axis limits
ax = gca;
xLim = ax.XLim;
yLim = ax.YLim;

% Default values

if (nargin < 1 || isempty(xLength)) && (nargin < 3 || isempty(labelX))
    xLength = NaN;
    labelX = 'NaN';
elseif nargin < 1 || isempty(xLength)
    xLength = roundToNearestTenPercent(diff(xLim));
elseif nargin < 3 || isempty(labelX)
     if nargin < 6 || isempty(unitX)
        %labelX = sprintf('%.2g units', xLength);
        labelX = sprintf('%s %s', regexprep(sprintf('%.2f', xLength), '\.?0+$', ''));
    else
        %labelX = sprintf('%.2g %s', xLength, unitX);
        labelX = sprintf('%s %s', regexprep(sprintf('%.2f', xLength), '\.?0+$', ''), unitX);
    end
end

if (nargin < 2 || isempty(yLength)) && (nargin < 4 || isempty(labelY))
    yLength = NaN;
    labelY = 'NaN';
elseif nargin < 2 || isempty(yLength)
    yLength = roundToNearestTenPercent(diff(yLim));
elseif nargin < 4 || isempty(labelY)
     if nargin < 7 || isempty(unitY)
        %labelY = sprintf('%.2g units', yLength);
        labelY = sprintf('%s %s', regexprep(sprintf('%.2f', yLength), '\.?0+$', ''));
    else
        %labelY = sprintf('%.2g %s', yLength, unitY);
        labelY = sprintf('%s %s', regexprep(sprintf('%.2f', yLength), '\.?0+$', ''), unitY);
    end
end



if nargin < 5 || isempty(position)
    position = 'topLeft';
end

if nargin < 8 || isempty(scaleLineWidth)
    scaleLineWidth = 2;
end

if nargin < 9 || isempty(fontSize)
    fontSize = 12;
end

switch position
    case 'bottomRight'
        xBarStart = xLim(2);
        yBarStart = yLim(1);
        xBarEnd = xBarStart - xLength;
        yBarEnd = yBarStart + yLength;
    case 'bottomLeft'
        xBarStart = xLim(1);
        yBarStart = yLim(1);
        xBarEnd = xBarStart + xLength;
        yBarEnd = yBarStart + yLength;
    case 'topRight'
        xBarStart = xLim(2);
        yBarStart = yLim(2);
        xBarEnd = xBarStart - xLength;
        yBarEnd = yBarStart - yLength;
    case 'topLeft'
        xBarStart = xLim(1);
        yBarStart = yLim(2);
        xBarEnd = xBarStart + xLength;
        yBarEnd = yBarStart - yLength;
    otherwise
        error('Invalid position. Choose from: bottomLeft, bottomRight, topLeft, topRight');
end

% Select color for plotting
if sum(ax.Color <= 0.3) == 3 % dark figure -> plot in white 
    thisColor = 'w';
else
    thisColor = 'k';
end

% Plot scale bars and prevent them from being added to legend
hold on;
if ~isnan(yLength) && ~isnan(xLength) && xLength ~= 0 && yLength ~= 0
h1 = plot([xBarStart, xBarEnd], [yBarStart, yBarStart], [thisColor '-'], ...
    'LineWidth', scaleLineWidth);
h2 = plot([xBarStart, xBarStart], [yBarStart, yBarEnd], [thisColor '-'], ...
    'LineWidth', scaleLineWidth);
elseif ~isnan(xLength) && xLength ~= 0
    h1 = plot([xBarStart, xBarEnd], [yBarStart, yBarStart], [thisColor '-'], ...
        'LineWidth', scaleLineWidth);
else 
  h2 = plot([xBarStart, xBarStart], [yBarStart, yBarEnd], [thisColor '-'], ...
    'LineWidth', scaleLineWidth);

end
hold off;

% Exclude scale bars from legend
if ~isnan(xLength) && xLength ~= 0
set(get(get(h1, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
end
if ~isnan(yLength) && yLength ~= 0
set(get(get(h2, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
end

% Hide x and y axis
ax.XAxis.Visible = 'off';
ax.YAxis.Visible = 'off'; % Add labels for scale bars based on position
switch position
    case 'bottomRight'
        textPos = {'center', 'top'; 'left', 'middle'};
    case 'bottomLeft'
        textPos = {'center', 'top'; 'right', 'middle'};
    case 'topRight'
        textPos = {'center', 'bottom'; 'left', 'middle'};
    case 'topLeft'
        textPos = {'center', 'bottom'; 'right', 'middle'};
end


switch position
    case 'bottomRight'
        if ~isnan(xLength) && xLength ~= 0
        text((xBarStart + xBarEnd)/2, yBarStart-0.02*range(yLim)*sign(yLength), labelX, ...
            'HorizontalAlignment', textPos{1, 1}, 'VerticalAlignment', textPos{1, 2}, ...
            'Color', thisColor, 'FontSize', fontSize);
        end
        if ~isnan(yLength) && yLength ~= 0
        text(xBarStart+0.06*range(xLim)*sign(xLength), (yBarStart + yBarEnd)/2, labelY, ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90, ...
            'Color', thisColor, 'FontSize', fontSize);
        end
    case 'bottomLeft'
        if ~isnan(xLength)&& xLength ~= 0
        text((xBarStart + xBarEnd)/2, yBarStart-0.02*range(yLim)*sign(yLength), labelX, ...
            'HorizontalAlignment', textPos{1, 1}, 'VerticalAlignment', textPos{1, 2}, ...
            'Color', thisColor, 'FontSize', fontSize);
        end
        if ~isnan(yLength) && yLength ~= 0
        text(xBarStart-0.05*range(xLim), (yBarStart + yBarEnd)/2, labelY, ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90, ...
            'Color', thisColor, 'FontSize', fontSize);
        end

    case 'topRight'
        if ~isnan(xLength)&& xLength ~= 0
        text((xBarStart + xBarEnd)/2, yBarStart+0.03*range(yLim)*sign(yLength), labelX, ...
            'HorizontalAlignment', textPos{1, 1}, 'VerticalAlignment', textPos{1, 2}, ...
            'Color', thisColor, 'FontSize', fontSize);
        end
        if ~isnan(yLength) && yLength ~= 0
        text(xBarStart+0.06*range(xLim)*sign(xLength), (yBarStart + yBarEnd)/2, labelY, ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90, ...
            'Color', thisColor, 'FontSize', fontSize);
        end

    case 'topLeft'
        if ~isnan(xLength)&& xLength ~= 0
        text((xBarStart + xBarEnd)/2, yBarStart+0.03*range(yLim)*sign(yLength), labelX, ...
            'HorizontalAlignment', textPos{1, 1}, 'VerticalAlignment', textPos{1, 2}, ...
            'Color', thisColor, 'FontSize', fontSize);
        end
        if ~isnan(yLength) && yLength ~= 0
        text(xBarStart-0.05*range(xLim), (yBarStart + yBarEnd)/2, labelY, ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90, ...
            'Color', thisColor, 'FontSize', fontSize);
        end
end


end
function val = roundToNearestTenPercent(rangeVal)
   % QQ hacky 

    if rangeVal >= 5
        scale = 10^floor(log10(rangeVal));
        val = round(0.25 * rangeVal / scale) * scale;
        if val == 0
            scale = 10^ceil(log10(rangeVal));
            val = round(0.25 * rangeVal * scale) / scale;
        end
    else
        scale = 10^ceil(log10(rangeVal));
        val = round(0.25 * rangeVal * scale) / scale;
    end
end
