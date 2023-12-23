f = figure('Name','Game of Life');
ax =  axis();
axis equal
xlim([-50 50]);
ylim([-50 50]);
grid on
set(gca, 'YDir','reverse')

cells   = getPattern('f-pentomino');
obj     = GameOfLifeGrid(cells);
iter    = 1; 
fps     = 0;

while(ishghandle(f))

    tic;
    
    % Draw new cells 
    for iCell = 1:size(obj.borned,1)
        cell = obj.borned(iCell,:);
        rectangle('Position',[cell(1) cell(2) 1 1], 'FaceColor','black',...
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

end