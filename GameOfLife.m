f = figure('Name','Game of Life');
ax =  axis();
axis equal
xlim([0 10]);
ylim([0 10]);
grid on

cells = [3 , 2 ; 3 , 3 ; 3 , 4];
obj = GameOfLifeGrid(cells);

while(ishghandle(f))

    for iCell = 1:size(obj.borned,1)
        cell = obj.borned(iCell,:);
        rectangle('Position',[cell(1) cell(2) 1 1], 'FaceColor','pink',...
                  'Tag', sprintf('%d-%d',cell(1),cell(2) ))
    end

    for iCell = 1:size(obj.dead,1)
        cell = obj.dead(iCell,:);
        h = findobj('Tag',sprintf('%d-%d',cell(1),cell(2) ));

        if ~isempty(h)
            delete(h)
        end
    end

    obj = update(obj);
    pause(0.5);

end