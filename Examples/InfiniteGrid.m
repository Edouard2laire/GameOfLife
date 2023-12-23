profile on

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

while(ishghandle(f)) && iter < 1000

    tic;
    
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
    
    newt = toc;    
    fps = .9*fps + .1*(1/newt);

    title(sprintf('Iter %d - %d cell alive (fps %.2f)', iter, size(obj.aliveCells,1),fps))
    drawnow

end

profile viewer