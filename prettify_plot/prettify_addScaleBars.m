function prettify_addScaleBars(xLength, yLength, labelX, labelY, position, unitX, unitY)
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
% Default values
if nargin < 1 || isempty(xLength)
    xLength = roundToNearestTenPercent(diff(xLim));
end
if nargin < 2 || isempty(yLength)
    yLength = roundToNearestTenPercent(diff(yLim));
end
if nargin < 3 || isempty(labelX)
    if nargin < 6 || isempty(unitX)
        labelX = sprintf('%.2f units', xLength);
    else
        labelX = sprintf('%.2f %s', xLength, unitX);
    end
end
if nargin < 4 || isempty(labelY)
     if nargin < 7 || isempty(unitY)
        labelY = sprintf('%.2f units', yLength);
    else
        labelY = sprintf('%.2f %s', yLength, unitY);
    end
end
if nargin < 5 || isempty(position)
    position = 'bottomLeft';
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
if sum(ax.Color >= 0.7) == 3 % dark figure -> plot in white 
    thisColor = 'w';
else
    thisColor = 'k';
end

% Plot scale bars and prevent them from being added to legend
hold on;
h1 = plot([xBarStart, xBarEnd], [yBarStart, yBarStart], [thisColor '-'], 'LineWidth', 2);
h2 = plot([xBarStart, xBarStart], [yBarStart, yBarEnd], [thisColor '-'], 'LineWidth', 2);
hold off;

% Exclude scale bars from legend
set(get(get(h1, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');
set(get(get(h2, 'Annotation'), 'LegendInformation'), 'IconDisplayStyle', 'off');


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
        text((xBarStart + xBarEnd)/2, yBarStart-0.02*range(yLim)*sign(yLength), labelX, ...
            'HorizontalAlignment', textPos{1, 1}, 'VerticalAlignment', textPos{1, 2}, 'Color', thisColor);
        text(xBarStart+0.06*range(xLim)*sign(xLength), (yBarStart + yBarEnd)/2, labelY, ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90, 'Color', thisColor);

    case 'bottomLeft'
        text((xBarStart + xBarEnd)/2, yBarStart-0.02*range(yLim)*sign(yLength), labelX, ...
            'HorizontalAlignment', textPos{1, 1}, 'VerticalAlignment', textPos{1, 2}, 'Color', thisColor);
        text(xBarStart-0.05*range(xLim), (yBarStart + yBarEnd)/2, labelY, ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90, 'Color', thisColor);

    case 'topRight'
        text((xBarStart + xBarEnd)/2, yBarStart+0.03*range(yLim)*sign(yLength), labelX, ...
            'HorizontalAlignment', textPos{1, 1}, 'VerticalAlignment', textPos{1, 2}, 'Color', thisColor);
        text(xBarStart+0.06*range(xLim)*sign(xLength), (yBarStart + yBarEnd)/2, labelY, ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90, 'Color', thisColor);

    case 'topLeft'
        text((xBarStart + xBarEnd)/2, yBarStart+0.03*range(yLim)*sign(yLength), labelX, ...
            'HorizontalAlignment', textPos{1, 1}, 'VerticalAlignment', textPos{1, 2}, 'Color', thisColor);
        text(xBarStart-0.05*range(xLim), (yBarStart + yBarEnd)/2, labelY, ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Rotation', 90, 'Color', thisColor);
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
