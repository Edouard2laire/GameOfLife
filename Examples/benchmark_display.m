% Benchmark multiple ways to handle the display 
% See https://www.reddit.com/r/matlab/comments/18opob5/comment/kemupin/?context=3

%% Method #1 - Create/Delete rectangles, delete rectangle using querry (findobj)
clear; close all;

cells   = getPattern('f-pentomino');
N_iter  = 2000;


f1 = figure('Name','Game of Life - #1','NumberTitle','off');
axis equal
axis([-50 50 -50 50]);
set(gca, 'YDir','reverse')
grid on

obj     = GameOfLifeGrid(cells);
iter    = 1; 
fps     = 0;

t0 = tic; 
while(ishghandle(f1)) && iter < N_iter

    t1 = tic;
    
    % Draw new cells 
    for iCell = 1:size(obj.borned,1)
        alive_cell = obj.borned(iCell,:);
        rectangle('Position',[alive_cell(1) alive_cell(2) 1 1], 'FaceColor','black',...
                  'Tag', sprintf('%d-%d',alive_cell(1),alive_cell(2) ))
    end
    
    % % Remove dead cells 
    if size(obj.dead,1) >= 1
        % Create querry to find all the cells that should be deleted 
        querry =  cell(1,3*size(obj.dead,1));
        querry(1:3:3*size(obj.dead,1))  = repmat({'Tag'},1,size(obj.dead,1));
        querry(2:3:3*size(obj.dead,1))  = cellstr([num2str(obj.dead(:,1)) repmat('-',size(obj.dead,1),1)  num2str(obj.dead(:,2))]);
        querry(3:3:3*size(obj.dead,1))  = repmat({'-or'},1,size(obj.dead,1));

        querry(2:3:3*size(obj.dead,1)) = cellfun(@(x)strrep(x,' ',''), querry(2:3:3*size(obj.dead,1)), 'UniformOutput', false);
        querry = querry(1:end-1);
        h = findobj(0,querry);

        if ~isempty(h)
            delete(h);
        end
    end
    obj = update(obj);
    iter = iter+1;
    
    newt = toc(t1);    
    fps = .9*fps + .1*(1/newt);

    title(sprintf('Iter %d - %d cell alive (fps %.2f)', iter, size(obj.aliveCells,1),fps))
    drawnow

end
toc(t0);

%% Method #2 - Create/Delete rectangles, delete rectangle using dictionnary to store handle
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

%% Method #3 - Create rectangle only onces and stores them, 
% when a rectangle is deleted, only hides it instead of destroying it
clear; close all;

cells   = getPattern('f-pentomino');
N_iter  = 2000;

f3 = figure('Name','Game of Life - #1','NumberTitle','off');
axis equal
axis([-50 50 -50 50]);
set(gca, 'YDir','reverse')
grid on

obj     = GameOfLifeGrid(cells);
iter    = 1; 
fps     = 0;

handles = configureDictionary("string",class(rectangle));

t0 = tic; 
while(ishghandle(f3)) && iter < N_iter

    tic;
    
    % Draw new cells 

    querry = cellstr([num2str(obj.borned(:,1)) repmat('-',size(obj.borned,1),1)  num2str(obj.borned(:,2))]);
    querry = cellfun(@(x)strrep(x,' ',''), querry, 'UniformOutput', false);
    
    isStored  = isKey(handles,querry);
    arrayfun(@(x)set(x,'Visible','on'), handles(querry(isStored)));
    
    idx_to_create = find(~isStored);
    for iCell = 1:length(idx_to_create)
        alive_cell = obj.borned(idx_to_create(iCell),:);
        h = rectangle('Position',[alive_cell(1) alive_cell(2) 1 1], 'FaceColor','black',...
                  'Tag', sprintf('%d-%d',alive_cell(1),alive_cell(2) ));
        handles(sprintf('%d-%d',alive_cell(1),alive_cell(2) )) = h;
    end
    
    % % Remove dead cells 
    if size(obj.dead,1) >= 1
        % Create querry to find all the cells that should be deleted 
        % Remove dead cells 
        querry = cellstr([num2str(obj.dead(:,1)) repmat('-',size(obj.dead,1),1)  num2str(obj.dead(:,2))]);
        querry = cellfun(@(x)strrep(x,' ',''), querry, 'UniformOutput', false);
        
        h = handles(querry);
        arrayfun(@(x)set(x,'Visible','off'),h);
    end
    
    obj = update(obj);
    iter = iter+1;
    
    newt = toc;    
    fps = .9*fps + .1*(1/newt);

    title(sprintf('Iter %d - %d cell alive (fps %.2f)', iter, size(obj.aliveCells,1),fps))
    drawnow

end
toc(t0);