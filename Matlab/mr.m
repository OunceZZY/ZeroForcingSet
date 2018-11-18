
GraphType = 'WheelExtension';
modelSize = 6;
targetRank = 3;
fieldSize = 2;
date= datetime('now');

adjacency = [1,2,3,4,5,6,6,6,6,6,1,2,3,4,5,6;
             2,3,4,5,1,1,2,3,4,5,1,2,3,4,5,6];
%adjacency = [1,2,3,4,1,2,3,4,5; 2,3,4,5,1,2,3,4,5];

DiaryName = strcat (datestr(date),GraphType,'-',num2str(modelSize),'mr',num2str(targetRank),'fs',num2str(fieldSize),'.txt');
delete(DiaryName);
diary(DiaryName);

fprintf("Adjacency list:\n");
disp(adjacency);
fprintf("Field size: %d\n\n", fieldSize)
ret = allmatmeets(fieldSize, targetRank, modelSize, adjacency);
%addingEdge = [1,1;
%              3,4  ];
%m2 = addEdges(ret,addingEdge,targetRank,modelSize,fieldSize);

diary off
type(DiaryName);

function ret2 = allmatmeets(fs, targetRank, modelSize,adjacency)
% with n as "field siz3", targetRank as minimum rank
mat = zeros(modelSize);

ret = [];
ret2 = subcur(mat,1, fs, targetRank, modelSize, adjacency, ret);
end

function ret = subcur(mat, current, fs, targetRank, modelSize,adjacency, ret)

    for p = -fs:fs
       if(p == 0 && adjacency(1,current)~=adjacency(2,current))
           continue;
       end
       mat( adjacency(1,current),adjacency(2,current) ) = p;
       mat( adjacency(2,current),adjacency(1,current) ) = p;
       
       if(current<length(adjacency))
           ret = subcur(mat, current+1, fs, targetRank, modelSize,adjacency,ret);
       else   
           if(rank(mat) == targetRank)
               ret = cat(3,ret,mat);
           end
       end
   end
end



function ret = addEdges(matrices, edges, targetRank, dim,fieldSize) 
ret = [];
for i=1: length(matrices)
    thisMat = matrices(:,:,i);
    ret = addAllEdges(thisMat,dim, edges, 1,targetRank,fieldSize,ret);
end

end

function ret = addAllEdges(matrix, dim, edges, current, targetRank,fieldSize,ret)
for p= 1: fieldSize
    matrix( edges(1,current), edges(2,current) ) = -p;
    matrix( edges(2,current), edges(1,current) ) = -p;
    if(current<length(edges))
        ret = addAllEdges(matrix, dim, edges, current+1,targetRank, fieldSize,ret);
    else 
        %disp(matrix); 
        if(rank(matrix) == targetRank)   
            ret = cat(3,ret,matrix);
        end
    end
end

end

