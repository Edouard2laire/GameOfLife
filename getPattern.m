function cells = getPattern(name)
%GETPATTERN Generate common pattern from the Game of life. 
% Implemented pattern: 'square', 'boat', 'loaf', 'glider', 'light_space_ship'
% Usage: cells = getPattern('loaf')
% GameOfLifeGrid.add(cells, offset_x, offset_y)

pattern = [];

switch lower(name)

    case 'square'
        pattern = [ 1 1 ; ...
                    1 1];
    case 'blinker'
        pattern = [ 1 1 1; ...
                    0 0 0];
    case 'boat'
        pattern = [ 1 1 0 ; ...
                    1 0 1 ; ...
                    0 1 0 ];
    case 'loaf' 
        pattern = [ 1 1 0 ; ...
                    1 0 1 ; ...
                    0 1 1 ];
    case 'glider'
        pattern = [ 1 1 1 ; ... 
                    1 0 0 ; ...
                    0 1 0 ];
    case 'light_space_ship'
        pattern = [ 0 1 0 0 1 ; ...
                    1 0 0 0 0 ; ...
                    1 0 0 0 1 ; ...
                    1 1 1 1 0 ];
    case 'f-pentomino'
        pattern = [ 0 1 1 ; ...
                    1 1 0 ; ...
                    0 1 0 ];



end

[x,y] = find(pattern);
cells = [x,y];

end

