classdef Points2D 
    %2DPOINTS Class representing a 2D point
    
    properties
        x int32 = 0
        y int32 = 0
    end
    
    methods
        function obj = Points2D(x,y)
            if nargin == 0 
                x = 0; y = 0;
            end

            if length(x) > 1 && length(y) == length(x)
                obj = repmat(Points2D(),size(x,1),1);
                for iPoint = 1:size(x,1)
                    obj(iPoint) = Points2D(x(iPoint),y(iPoint));
                end
                return;
            end
            
            obj.x = x;
            obj.y = y;
        end
        
        function h = keyHash(obj)
            h = keyHash([obj.x obj.y]);
        end

        function mat = toMat(obj)
            mat = cell2mat(arrayfun(@(a)[a.x , a.y],obj,'UniformOutput',false));
        end


        % Equality operator 
        function TF = keyMatch(objA,objB)
            TF = objA.x == objB.x && objA.y == objB.y;
        end
        function TF = eq(objA,objB)
            if size(objA,1) > 1
                 mat = toMat(objA);
                 TF = all( mat(:,1) == objB.x &  mat(:,2) == objB.y,2);

                return;
            end
            TF = objA.x == objB.x && objA.y == objB.y;
        end
        function TF = ne(objA,objB)
            TF =  ~(objA ==  objB);
        end

        % Arithmetic operator
        function r = plus(obj1,obj2)
            if size(obj1,1) > 1
                r =  repmat(Points2D(),size(obj1,1),1);
                for iPoint = 1:size(obj1,1)
                    r(iPoint) = obj1(iPoint) + obj2;
                end
                return;
            end

            r = Points2D( obj1.x + obj2.x, ...
                          obj1.y + obj2.y);
        end
        
    end
end

