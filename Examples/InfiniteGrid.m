clear; close all;
profile on

cells   = getPattern('f-pentomino');
N_iter  = 200;

f2 = figure('Name','Game of Life - #1','NumberTitle','off');
axis equal
axis([-50 50 -50 50]);
set(gca, 'YDir','reverse')
grid on

obj     = GameOfLifeGrid(cells);
iter    = 1; 
fps     = 0;

handles = configureDictionary("Points2D",class(rectangle));

t0 = tic; 
while(ishghandle(f2)) && iter < N_iter

    tic;
    
    % Draw new cells 
    for iCell = 1:size(obj.borned,1)
        alive_cell = obj.borned(iCell);
        h = rectangle('Position',[alive_cell.x alive_cell.y 1 1], 'FaceColor','black',...
                  'Tag', sprintf('%d-%d',alive_cell.x,alive_cell.y ));
        handles(alive_cell) = h;
    end
    
    % % Remove dead cells 
    if ~isempty(obj.dead)
        h = handles(obj.dead);
        handles.remove(obj.dead);
        delete(h);
    end

    obj = update(obj);
    iter = iter+1;
    
    newt = toc;    
    fps = .9*fps + .1*(1/newt);

    title(sprintf('Iter %d - %d cell alive (fps %.2f)', iter, size(obj.aliveCells,1),fps))
    drawnow

end
toc(t0);
profile viewer
