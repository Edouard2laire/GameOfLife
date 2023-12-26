% profile on
clear; close all;


f = figure('Name','Game of Life - #1','NumberTitle','off');
axis equal
axis([-50 50 -50 50]);
set(gca, 'YDir','reverse')
grid on

game     = GameOfLifeGrid(getPattern('f-pentomino'));
iter    = 1; 
fps     = 0;
tfps    = 10; % target fps

handles = configureDictionary("string",class(rectangle));

t0 = tic; 
while(ishghandle(f)) && iter < 2000

    t1 = tic;
    
    % Draw new cells 
    for iCell = 1:size(game.borned,1)
        alive_cell = game.borned(iCell,:);
        h = rectangle('Position',[alive_cell(1) alive_cell(2) 1 1], ...
                      'FaceColor','black',...
                      'Tag', sprintf('%d-%d',alive_cell(1),alive_cell(2) ));
        handles(keyHash([alive_cell(1),alive_cell(2)])) = h;
    end
    
    % Remove dead cells 
    if size(game.dead,1) >= 1
        querry = arrayfun(@(x,y)keyHash([x,y]), game.dead(:,1), game.dead(:,2));        
        delete(handles(querry));
    end
    
    % Update Grid
    game = update(game);
    iter = iter+1;
    
    % Display some information and force redraw
    newt = toc(t1);    
    pause(max(0, (1 - tfps*newt)/tfps))

    fps = .9*fps + .1*(1/toc(t1));
    title(sprintf('Iter %d - %d cell alive (fps %.2f)', iter, size(game.aliveCells,1),fps))
end
toc(t0);

%profile viewer