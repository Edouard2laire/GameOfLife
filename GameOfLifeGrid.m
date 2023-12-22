classdef GameOfLifeGrid
    % GameOfLife Represent the grid of the game of life

    properties
        %aliveCells [nx2] (x,y) coordinate of the alives cells
        aliveCells

        %borned [nx2] (x,y) coordinate of the newly born cells after a call
        %to update
        borned

        %dead [nx2] (x,y) coordinate of the newly dead cells after a call
        %to update
        dead
    end

    methods
        function obj = GameOfLifeGrid(initialConfiguration)
            if nargin < 1 
                initialConfiguration = [];
            end

            obj.aliveCells = initialConfiguration;
            obj.borned     = initialConfiguration;
            obj.dead       = [];

        end

        function t = isAlive(obj, x, y)
            %ISALIVE Return 1 if the cell (x,y) is currently alive
            t = any(all(obj.aliveCells == [ x, y],2));
        end

        function neighbour = getNeighbour(obj, x,y)
            %getNeighbour Return the list of neighbour of the cell (x,y)
            % and their life status as a Nx3 array (x,y status)
            % The number of alive neighbour is sum(neighbour(:,3))

            neighbour = [ x - 1, y - 1,   obj.isAlive( x - 1 , y - 1) ; ...
                          x ,    y - 1,   obj.isAlive( x     , y - 1) ; ...
                          x + 1, y - 1,   obj.isAlive( x + 1 , y - 1) ; ...
                          x - 1, y    ,   obj.isAlive( x - 1 , y    ) ; ...
                          x + 1, y    ,   obj.isAlive( x + 1 , y    ) ; ...
                          x - 1, y + 1,   obj.isAlive( x - 1 , y + 1) ; ...
                          x    , y + 1,   obj.isAlive( x     , y + 1) ; ...
                          x + 1, y + 1,   obj.isAlive( x + 1 , y + 1) ; ...                          
                        ];
        end

        function obj = update(obj)
            %update Update the board based on the rule of the game of life
            % Any live cell with fewer than two live neighbours dies, as if by underpopulation.
            % Any live cell with two or three live neighbours lives on to the next generation.
            % Any live cell with more than three live neighbours dies, as if by overpopulation.
            % Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
            
            stayingAlive        = false(1,size(obj.aliveCells,1));
            potientialyAlive    = [];
        
            for iCell = 1:size(obj.aliveCells,1)
                neighbour = obj.getNeighbour(obj.aliveCells(iCell,1) , obj.aliveCells(iCell,2));
                nAlive    = sum(neighbour(:,3));
                
                % Keep track of the cell that should remains alive
                if nAlive == 2 || nAlive == 3
                    stayingAlive(iCell) = true;
                end
                
                % Create a list of dead cell, that has alived neighbour to
                % consider for aliveness 
                potientialyAlive = [ potientialyAlive ; ...
                                     neighbour( neighbour(:,3) == 0, [1,2] )];                    
            end
            
            % Find cells that should become alive. Number of occurance of
            % each cell in potientialyAlive correspond to the number of
            % neighbour of the dead cell. If this number is 3, then the
            % cell become alive. This doesn't require to call getNeighbour
            % for each cell. 
            [potientialyAlive,~,ic] = unique(potientialyAlive,'rows');
            nAlive  = accumarray(ic,1);
            born    = (nAlive == 3);

            obj.borned          = potientialyAlive(born, : );
            obj.dead            = obj.aliveCells(~stayingAlive, :);
            obj.aliveCells      = [ obj.aliveCells(stayingAlive, :)  ; ...
                                    potientialyAlive(born, : )];
        end
    end
end