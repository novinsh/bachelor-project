function plot_particles(p, map, i)

figure(map.fig)
set(p.fig,'XData',p.x,'YData',p.y);
plot(mean(p.x), mean(p.y), 'og','markersize',10)
text(mean(p.x)-.1, mean(p.y), num2str(i),'fontsize',7,'color',[0,0,0])
% linkdata on

% for i = 1;p.n
%     if ~p.w(i)
%         c = [0 0 1];
%     else
%         c = [1 1 0] * p.w(i);
%     end
%     plot(p.x(i),p.y(i),'o','MarkerEdgeColor',c)
% end