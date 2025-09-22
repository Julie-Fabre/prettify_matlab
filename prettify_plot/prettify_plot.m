function prettify_plot(varargin)
% make current figure pretty
% ------
% Inputs: Name - Pair arguments
% ------
% - XLimits: string or number.
%       If a string, either:
%           - 'keep': don't change any of the xlimits
%           - 'same': set all xlimits to the same values
%           - 'rows': set all xlimits to the same values for each subplot row
%           - 'cols': set all xlimits to the same values for each subplot col
%       If a number, 1 * 2 double setting the minimum and maximum values
% - YLimits: string or number.
%       If a string, either:
%           - 'keep': don't change any of the ylimits
%           - 'same': set all ylimits to the same values
%           - 'rows': set all ylimits to the same values for each subplot row
%           - 'cols': set all ylimits to the same values for each subplot col
%       If a number, 1 * 2 double setting the minimum and maximum values
% - CLimits, string or number.
%       If a string, either:
%           - 'keep': don't change any of the xlimits
%           - 'same': set all xlimits to the same values
%           - 'rows': set all xlimits to the same values for each subplot row
%           - 'cols': set all xlimits to the same values for each subplot col
%       If a number, 1 * 2 double setting the minimum and maximum values
% - LimitsRound % Number of decimals to keep when rounding. set to NaN if you don't want any changes
% - SymmetricalCLimits: boolean. Whether to make CLimits symmetrical around 0
% - FigureColor: string (e.g. 'w', 'k', 'Black', ..) or RGB value defining the plots
%       background color.
% - TextColor: string (e.g. 'w', 'k', 'Black', ..) or RGB value defining the plots
%       text color.
% - NeutralColor: string (e.g. 'w', 'k', 'Black', ..) or RGB value defining the plots
%       text color.
% - LegendLocation: string determining where the legend is. Either:
%       'north'	Inside top of axes
%       'south'	Inside bottom of axes
%       'east'	Inside right of axes
%       'west'	Inside left of axes
%       'northeast'	Inside top-right of axes (default for 2-D axes)
%       'northwest'	Inside top-left of axes
%       'southeast'	Inside bottom-right of axes
%       'southwest'	Inside bottom-left of axes
%       'northoutside'	Above the axes
%       'southoutside'	Below the axes
%       'eastoutside'	To the right of the axes
%       'westoutside'	To the left of the axes
%       'northeastoutside'	Outside top-right corner of the axes (default for 3-D axes)
%       'northwestoutside'	Outside top-left corner of the axes
%       'southeastoutside'	Outside bottom-right corner of the axes
%       'southwestoutside'	Outside bottom-left corner of the axes
%       'best'	Inside axes where least conflict occurs with the plot data at the time that you create the legend. If the plot data changes, you might need to reset the location to 'best'.
%       'bestoutside'	Outside top-right corner of the axes (when the legend has a vertical orientation) or below the axes (when the legend has a horizontal orientation)
% - LegendReplace: ! buggy sometimes ! boolean, if you want the legend box to be replace by text
%       directly plotted on the figure, next to the each subplot's
%       line/point
% - LegendReorder: boolean, whether to reorder or not the legend elements
%       according to their location on the graph
% - TitleFontSize: double, font size for titles
% - LabelFontSize: double, font size for x, y, z axis labels
% - GeneralFontSize: double, font size for other figure elements (legends,
%       colorbars, x/y/z ticks, text elements, ...)
% - Font: string. See listfonts() for a list of all available fonts
% - PointSize: double, size for point elements
% - LineThickness: double, thickness value for lines 
% - AxisTicks: string. Either 'out' (the tick marks come out of the axis)
%       or 'in' (the tick marks go in of the axis)
% - TickLength: number, determines size of ticks
% - TickWidth: number, determines size of ticks
% - AxisBox: String. Either 'off' (no box) or 'on' (a box)
% - AxisAspectRatio: String. Either 'equal', 'square', or 'image'. Set as
%   'keep' if you don't want any changes.
% - AxisTightness: String. Either 'tickaligned', 'tight' or 'padded'.Set as
%   'keep' if you don't want any changes.
% - AxisUnits - not in use yet
% - ChangeColormaps: boolean, whether to adjust the colormaps or not
% - DivergingColormap: String corresponding to the brewermap colormap for
%       sequential data. Options: 'BrBG', 'PRGn', 'PuOr', 'RdBu', 'RdGy',
%       'RdYlBu', 'RdYlGn', 'Spectral'. Add a * before to reverse (eg: '*RdBu')
% - SequentialColormap: String corresponding to the brewermap colormap for
%       sequential data. Options: 'Blues', 'BuGn', 'BuPu', 'GnBu', 'Greens',
%       'Greys', 'OrRd', 'Oranges', 'PuBu', 'PuBuGn', 'PuRd', 'Purples', 'RdPu',
%       'Reds', 'YlGn', 'YlGnBu', 'YlOrBr', 'YlOrRd'. Add a * before to
%       reverse (eg: '*Blues')
% - PairedColormap - not in use yet
% - QualitativeColormap - not in use yet
% ------
% to do:
% - option to adjust vertical and horiz. lines
% - padding
% - fit data to plot (adjust lims)
% - padding / suptitles
% ------
% Julie M. J. Fabre

% Set default parameter values
options = struct('XLimits', 'keep', ... % set to 'keep' if you don't want any changes
    'YLimits', 'keep', ... % set to 'keep' if you don't want any changes
    'CLimits', 'keep', ... % set to 'keep' if you don't want any changes
    'LimitsRound', 2, ... % set to NaN if you don't want any changes
    'SymmetricalCLimits', false, ...
    'FigureColor', [1, 1, 1], ...
    'TextColor', [0, 0, 0], ...
    'NeutralColor', [0.6, 0.6, 0.6], ... % used if figure background color is set to 'none'
    'LegendLocation', 'best', ...
    'LegendReplace', false, ... % BUGGY sometimes
    'LegendBox', 'off', ...
    'TitleFontSize', 15, ...
    'LabelFontSize', 15, ...
    'GeneralFontSize', 15, ...
    'Font', 'Arial', ...
    'BoldTitle', 'off', ...
    'PointSize', 8, ...
    'LineThickness', 2, ...
    'AxisTicks', 'out', ...
    'TickLength', [0.0125, 0.031], ...
    'TickWidth', 1.3, ...
    'AxisBox', 'off', ...
    'AxisGrid', 'off', ...
    'AxisAspectRatio', 'keep', ... % set to 'keep' if you don't want any changes
    'AxisTightness', 'tight', ... % set to 'keep' if you don't want any changes 
    'AxisUnits', 'points', ...
    'ChangeColormaps', false, ... % set to false if you don't want any changes
    'DivergingColormap', '*RdBu', ...
    'SequentialColormap', 'YlOrRd', ...
    'PairedColormap', 'Paired', ...
    'QualitativeColormap', 'Set1'); %

% read the acceptable names
optionNames = fieldnames(options);

% count arguments
nArgs = length(varargin);
if round(nArgs/2) ~= nArgs / 2
    error('prettify_plot() needs propertyName/propertyValue pairs')
end

for iPair = reshape(varargin, 2, []) % pair is {propName;propValue}
    %inputName = lower(iPair{1}); % make case insensitive
    inputName = iPair{1};

    if any(strcmp(inputName, optionNames))
        options.(inputName) = iPair{2};
    else
        error('%s is not a recognized parameter name', inputName)
    end
end

% Check Name/Value pairs make sense
if (ischar(options.FigureColor) || isstring(options.FigureColor)) %convert to rgb
    options.FigureColor = prettify_rgb(options.FigureColor);

    if strcmp(options.FigureColor, 'none') % use a neutral text color that will show up on most backgrounds
        options.TextColor = options.NeutralColor;
    end
end
if ischar(options.TextColor) || isstring(options.TextColor) %convert to rgb
    options.TextColor = prettify_rgb(options.TextColor);
end
if ~strcmp(options.FigureColor, 'none')
    if sum(options.FigureColor-options.TextColor) <= 1.5 %check background and text and sufficiently different
        if sum(options.FigureColor) >= 1.5 % light
            options.TextColor = [0, 0, 0];
        else
            options.TextColor = [1, 1, 1];
        end
    end
end

% Get handles for current figure and axis
currFig = gcf; 

% Set color properties for figure and axis
set(currFig, 'color', options.FigureColor);

% update font
try
fontname(currFig, options.Font)
catch
     % matlab version < 2022 , this function doesn't exist
end

% get axes children
currFig_children = currFig.Children;
all_axes = find(arrayfun(@(x) contains(currFig_children(x).Type, 'axes'), 1:size(currFig_children, 1)));

% pre-allocate memory
xlims_subplot = nan(size(all_axes, 2), 2);
ylims_subplot = nan(size(all_axes, 2), 2);
clims_subplot = nan(size(all_axes, 2), 2);

% set colors to replace and default text/axis colors
if strcmp(options.FigureColor, 'none')
    colorsToReplace = [0, 0, 0; 1, 1, 1];
    mainColor = options.NeutralColor;
else
    colorsToReplace = options.FigureColor;
    mainColor = options.TextColor;
end

% update axis limits
if ~isempty(all_axes)
    

for iAx =  1:size(all_axes, 2)
    thisAx = all_axes(iAx);
    currAx = currFig_children(thisAx);
    ax_pos(iAx,:) = get(currAx, 'Position');
    % Get x and y limits
        xlims_subplot(iAx, :) = currAx.XLim;
        ylims_subplot(iAx, :) = currAx.YLim;
        clims_subplot(iAx, :) = currAx.CLim;
end
prettify_axis_limits(all_axes, currFig_children, ...
    ax_pos, xlims_subplot, ylims_subplot, clims_subplot, ...
    options.XLimits, options.YLimits, options.CLimits, ...
    options.LimitsRound, options.SymmetricalCLimits);

% update colorbars
colorbars = findobj(currFig_children, 'Type', 'colorbar');
prettify_colorbar(colorbars, colorsToReplace, mainColor, options.ChangeColormaps, options.DivergingColormap, ...
    options.SequentialColormap);

% update (sub)plot properties
for iAx = 1:size(all_axes, 2)
    thisAx = all_axes(iAx);
    currAx = currFig_children(thisAx);
    set(currAx, 'color', options.FigureColor);
    if ~isempty(currAx)

        % Set grid/box/tick options
        set(currAx, 'TickDir', options.AxisTicks)
        set(currAx, 'Box', options.AxisBox)
        set(currAx, 'TickLength', options.TickLength); % Make tick marks longer.
        set(currAx, 'LineWidth', options.TickWidth); % Make tick marks and axis lines thicker.

        %set(currAx, 'Grid', options.AxisGrid)
        if strcmp(options.AxisAspectRatio, 'keep') == 0 && ...
                ((sum(strcmp(options.XLimits, {'rows', 'cols' 'all'})) == 0 && sum(strcmp(options.YLimits, {'rows', 'cols' 'all'})) == 0) && ~isnumeric(options.XLimits))
            axis(currAx, options.AxisAspectRatio)
        end
        if strcmp(options.AxisTightness, 'keep') == 0 &&...
                ((sum(strcmp(options.XLimits, {'rows', 'cols' 'all'})) == 0 && sum(strcmp(options.YLimits, {'rows', 'cols' 'all'})) == 0) && ~isnumeric(options.XLimits))
            axis(currAx, options.AxisTightness)
        end

        % Set text properties
        set(currAx.XLabel, 'FontSize', options.LabelFontSize, 'Color', mainColor);
        if strcmp(currAx.YAxisLocation, 'left') % if there is both a left and right yaxis, keep the colors
            set(currAx.YLabel, 'FontSize', options.LabelFontSize);
        else
            set(currAx.YLabel, 'FontSize', options.LabelFontSize, 'Color', mainColor);
        end
        if strcmp(options.BoldTitle, 'on')
            set(currAx.Title, 'FontSize', options.TitleFontSize, 'Color', mainColor, ...
                'FontWeight', 'Bold')
        else
            set(currAx.Title, 'FontSize', options.TitleFontSize, 'Color', mainColor, ...
                'FontWeight', 'Normal');
        end
        %disp(currAx)
        set(currAx, 'FontSize', options.GeneralFontSize, 'GridColor', mainColor, ...
            'YColor', mainColor, 'XColor', mainColor, ...
            'MinorGridColor',mainColor);
        if ~isempty(currAx.Legend)
            set(currAx.Legend, 'Color', options.FigureColor, 'TextColor', mainColor)
        end

        % Adjust properties of line children within the plot
        childLines = findall(currAx, 'Type', 'line');
        for thisLine = childLines'
            % if any lines/points become the same as background, change
            % these.

            if ~strcmp(thisLine.Color, 'none')
                if ismember(thisLine.Color, colorsToReplace, 'rows') 
                    thisLine.Color = mainColor;
                end
            end
            % adjust markersize
            if sum(get(thisLine, 'Marker') == 'none') < 4
                set(thisLine, 'MarkerSize', options.PointSize);
                set(thisLine, 'MarkerFaceColor', thisLine.Color);
            end
            % adjust line thickness
            %if strcmp('-', get(thisLine, 'LineStyle'))
                set(thisLine, 'LineWidth', options.LineThickness);
            %end
        end

        % Adjust properties of dots children within the plot

        childPoints = findall(currAx, 'Type', 'scatter');
        for thisPoint = childPoints'
            % if any lines/points become the same as background, change
            % these.
            if size(thisPoint.CData, 1) == 1 % one uniform color
                if ismember(thisPoint.CData, colorsToReplace, 'rows')
                    thisPoint.CData = mainColor;
                end
            else
            if size(thisPoint.CData,2) == 3
                if ismember(thisPoint.CData, colorsToReplace, 'rows')
                    points_sub = ismember(thisPoint.CData == [0, 0, 0; 1, 1, 1], 'rows');
                    if any(points_sub)
                        set(thisPoint, 'MarkerEdgeColor', mainColor)
                    end
                end
            end
                
            end
            % adjust markersize
            if strcmp(get(thisPoint, 'Marker'), 'none')
                if thisPoint.SizeData < options.PointSize
                    set(thisPoint, 'SizeData', options.PointSize);
                end
                %set(thisPoint, 'MarkerFaceColor', thisPoint.CData);
            end
        end


        % Adjust properties of errorbars children within the plot
        childErrBars = findall(currAx, 'Type', 'ErrorBar');
        for thisErrBar = childErrBars'
            if strcmp('.', get(thisErrBar, 'Marker'))
                set(thisErrBar, 'MarkerSize', options.PointSize);
            end
            if strcmp('-', get(thisErrBar, 'LineStyle'))
                set(thisErrBar, 'LineWidth', options.LineThickness);
            end
        end

        % Adjust properties of any plotted text
        childTexts = findall(currAx, 'Type', 'Text');
        for thisText = childTexts'
            set(thisText, 'FontSize', options.GeneralFontSize, 'Color', mainColor);
        end

        

        % adjust legend
        if ~isempty(currAx.Legend)
            try
                prettify_legend(currAx, options.LegendReplace, options.LegendLocation, options.LegendBox)
            catch
            end
        end

    end
end
end

