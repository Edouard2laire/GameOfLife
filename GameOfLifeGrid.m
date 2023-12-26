classdef GameOfLifeGrid < AbstractGrid
    % GameOfLife Represent the grid of the game of life

    properties
    end

    methods
        function obj = GameOfLifeGrid(initialConfiguration)
            obj = obj@AbstractGrid(initialConfiguration);
            obj.dimension = [Inf Inf];
        end

        function obj = addPattern(obj, pattern, offset_x, offset_y)
            %ADDPATTERN Give life to the (nx2) position of pattern. Add an
            % offset to the position using offset_x, offset_y. Default 0

            if nargin < 2 
                offset_x = 0;
            end
            if nargin < 3
                offset_y = 0;
            end
            
            pattern =  Points2D(pattern(:,1), pattern(:,2)) + Points2D(offset_x, offset_y);


            for iCell = 1:size(pattern,1)
                cell = pattern(iCell);

                if obj.isAlive(cell)
                    warning('Cell (%d,%d) was already alive', cell.x, cell.y)
                else
                    obj.aliveCells(end+1,:) = cell;
                    obj.borned(end+1,:)     = cell;
                end
            end
    
        end

        function neighbour = getNeighbour(obj, x, y)
            %getNeighbour Return the list of neighbour of the cell (x,y)
            % and their life status as a Nx3 array (x,y status)
            % The number of alive neighbour is sum(neighbour(:,3))

            if nargin == 2 && isa(x,'Points2D')
                y = x.y;
                x = x.x;
            end

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
    end
end