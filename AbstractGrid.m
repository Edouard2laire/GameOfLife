classdef (Abstract) AbstractGrid 
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

        dimension
    end
    methods (Abstract)
        obj = addPattern(obj, pattern, offset_x, offset_y)
        neighbour = getNeighbour(obj, x,y)
    end
    methods
        function obj = AbstractGrid(initialConfiguration)
            if nargin < 1 
                initialConfiguration = [];
            end

            obj.aliveCells  = configureDictionary("Points2D","logical");
            obj.borned      = repmat(Points2D(),0,0);
            obj.dead        = repmat(Points2D(),0,0);

            if ~isempty(initialConfiguration)
                obj = obj.addPattern(initialConfiguration,0, 0);
            end
        end

        function t = isAlive(obj, x, y)
            %ISALIVE Return 1 if the cell (x,y) is currently alive
            % Usage: obj.isAlive(x,y) 
            %        obj.isAlive(Points2D(x,y)) 

            if isempty(obj.aliveCells)
                t = false;
                return
            end

            if nargin == 3 
                t =  isKey(obj.aliveCells, Points2D(x,y));
            elseif nargin == 2 && isa(x,'Points2D')
                t = isKey(obj.aliveCells, x);
            end

        end

        function obj = update(obj)
            %update Update the board based on the rule of the game of life
            % Any live cell with fewer than two live neighbours dies, as if by underpopulation.
            % Any live cell with two or three live neighbours lives on to the next generation.
            % Any live cell with more than three live neighbours dies, as if by overpopulation.
            % Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
            
            stayingAlive        = false(1,size(obj.aliveCells,1));
            potientialyAlive    = [];
            
            AliveCells = obj.aliveCells.keys;

            for iCell = 1:length(AliveCells)
                neighbour = obj.getNeighbour(AliveCells(iCell));
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

            obj.borned          = Points2D(potientialyAlive(born, 1 ),potientialyAlive(born, 2 ));
            obj.dead            = AliveCells(~stayingAlive);
            
            obj.aliveCells.remove(obj.dead);
            obj.aliveCells(obj.borned) = true;

        end
    end
end