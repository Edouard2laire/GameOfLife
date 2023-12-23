classdef GameOfLifeFlatTorus < AbstractGrid
    % GameOfLife Represent the grid of the game of life but on a flat
    % torus. The game is done on a finit grid, where left and right border
    % are connected. Top and bottom border are also connected 

    properties
    end

    methods
        function obj = GameOfLifeFlatTorus(dim_x, dim_y, initialConfiguration)
            obj = obj@AbstractGrid(initialConfiguration);
            obj.dimension = [dim_x, dim_y];
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

            pattern = pattern + [offset_x, offset_y];

            for iCell = 1:size(pattern,1)
                
                if pattern(iCell,1) > obj.dimension(1) || pattern(iCell,2) > obj.dimension(2)
                    warning('Cell (%d,%d) is outside of the grid', pattern(iCell,1), pattern(iCell,2))
                elseif obj.isAlive(pattern(iCell,1), pattern(iCell,2))
                    warning('Cell (%d,%d) was already alive', pattern(iCell,1), pattern(iCell,2))
                else
                    obj.aliveCells(end+1,:) = pattern(iCell,:);
                    obj.borned(end+1,:) = pattern(iCell,:);
                end
            end
    
        end

        function neighbour = getNeighbour(obj, x,y)
            %getNeighbour Return the list of neighbour of the cell (x,y)
            % and their life status as a Nx3 array (x,y status)
            % The number of alive neighbour is sum(neighbour(:,3))

            x_m1 = mod(x-1, obj.dimension(1));
            y_m1 = mod(y-1, obj.dimension(2));

            x_p1 = mod(x+1, obj.dimension(1));
            y_p1 = mod(y+1, obj.dimension(2));

            neighbour = [ x_m1  , y_m1  ,   obj.isAlive( x_m1 , y_m1 ); ...
                          x     , y_m1  ,   obj.isAlive( x    , y_m1 ); ...
                          x_p1  , y_m1  ,   obj.isAlive( x_p1 , y_m1 ); ...
                          x_m1  , y     ,   obj.isAlive( x_m1 , y    ); ...
                          x_p1  , y     ,   obj.isAlive( x_p1 , y    ); ...
                          x_m1  , y_p1  ,   obj.isAlive( x_m1 , y_p1 ); ...
                          x     , y_p1  ,   obj.isAlive( x    , y_p1 ); ...
                          x_p1  , y_p1  ,   obj.isAlive( x_p1 , y_p1 ); ...                          
                        ];
        end
    end
end