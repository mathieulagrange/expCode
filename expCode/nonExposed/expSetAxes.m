function expSetAxes(config, p)

if  length(p.legendNames)>1
    if any(p.legendLocation ~= 0)
        if ischar(p.legendLocation)
            legend(p.legendNames, 'Location', p.legendLocation);
        else
            legend(p.legendNames);
        end
    end
else
%     xlabel(p.legendNames);
end

if strcmpi(p.orientation(1), 'h')
    set(gca,'ytick', 1:length(p.labels));
    set(gca, 'yticklabel', p.labels);
    xlabel(p.axisLabels{1}, 'fontsize', config.displayFontSize);
else
    ylabel(p.axisLabels{1}, 'fontsize', config.displayFontSize);
    set(gca,'xtick', 1:length(p.labels));
    set(gca, 'xticklabel', p.labels);
    b=get(gca,'XTick');
    %     c=get(gca,'YTick');
    if p.rotateAxis
    c=axis; c=c(3:4);
    th=text(b,repmat(c(1)-.05*(c(2)-c(1)),length(b),1),p.labels,'HorizontalAlignment','right','rotation', p.rotateAxis);
    set(th, 'fontsize', config.displayFontSize);
    set(gca,'XTickLabel',{''});
    end
   

end
set(gca, 'fontsize', config.displayFontSize);
% title(p.title);
% axis tight