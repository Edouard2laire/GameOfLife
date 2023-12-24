f = figure('Name','Game of Life');
grid_dim = [20 20];

ax =  axis();
axis equal off 

xlim([0 grid_dim(1)]); ylim([0 grid_dim(2)]);
set(gca, 'YDir','reverse')

% add box
xline([0, grid_dim(1)], 'blue','LineWidth',2)
yline([0, grid_dim(2)], 'red', 'LineWidth',2)

%add grid
xline(1:(grid_dim(1)-1), 'Color', '#808080','LineWidth',0.5)
yline(1:(grid_dim(2)-1), 'Color', '#808080','LineWidth',0.5)



obj     = GameOfLifeFlatTorus(20, 20,[]);
obj     = obj.addPattern(getPattern('light_space_ship'), 12, 5);
obj     = obj.addPattern(getPattern('loaf'), 2, 2);
obj     = obj.addPattern(getPattern('blinker'), 2, 12);

iter    = 1; 
fps     = 0;

while(ishghandle(f)) && iter <= 78

    tic;
    
    % Draw new cells 
    for iCell = 1:size(obj.borned,1)
        cell = obj.borned(iCell,:);
        rectangle('Position',[cell(1) cell(2) 1 1], 'FaceColor','blue',...
                  'Tag', sprintf('%d-%d',cell(1),cell(2) ))
    end
    
    % Remove dead cells 
    for iCell = 1:size(obj.dead,1)
        cell = obj.dead(iCell,:);
        h = findobj('Tag',sprintf('%d-%d',cell(1),cell(2) ));

        if ~isempty(h)
            delete(h)
        end
    end
    obj = update(obj);
    iter = iter+1;
    
    newt = toc;    
    fps = .9*fps + .1*(1/newt);

    title(sprintf('Iter %d - %d cell alive (fps %.2f)', iter, size(obj.aliveCells,1),fps))
    drawnow

    exportgraphics(gca,"Fig/FlatTorus.gif","Append",true)


    pause(0.15)

end