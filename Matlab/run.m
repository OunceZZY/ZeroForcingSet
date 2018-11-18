%cycleminor =  deleteEdges(cc2,addingEdge, 3);

%c = addEdges(ret,[1,1;3,4],3,modelSize,50);
%GraphType = 'Theta-2-1-2';
GraphType = 'UniToCyc';
modelSize = 5;
targetRank = 4;
fieldSize = 7;
date= datetime('now');
DiaryName = strcat (GraphType,'-',datestr(date),'-',num2str(modelSize),'mr',num2str(targetRank),'fs',num2str(fieldSize),'.txt');
delete(DiaryName);
diary(DiaryName);

ac = [  1,2,3,4;
        2,3,4,5];
Lapl = Laplacian(ac,modelSize);
kap = Extension(Lapl, [1,2,3,4,5,6],fieldSize,targetRank);
fprintf("Lngth: %d\n",size(kap,3));
diary off

function ret = deleteEdges(matrices, edges, targetRank )
    ret = [];
    for i = 1:length(matrices)
       add = matrices(:,:,i);
       for j = 1: length(edges)
           add(edges(1,j),edges(2,j))=0;
           add(edges(2,j),edges(1,j))=0;
       end
       if(rank(add) == targetRank)
           ret = cat(3,ret,add);
           
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

for p= -fieldSize: fieldSize
    if(p==0 && adjacency(1,current)~=adjacency(2,current))
       continue; 
    end
    matrix( edges(1,current), edges(2,current) ) = p;
    matrix( edges(2,current), edges(1,current) ) = p;
    if(current<length(edges))
        ret = addAllEdges(matrix, dim, edges, current+1,targetRank, fieldSize,ret);
    else 
        if(rank(matrix) == targetRank)
            ret = cat(3,ret,matrix);
        end
    end
end
end

function LapMat = Laplacian(adjacency,modelSize) 
LapMat = zeros(modelSize);
for j =1:length(adjacency)
   LapMat(adjacency(1,j), adjacency(2,j)) = -1;
   LapMat(adjacency(2,j), adjacency(1,j)) = -1;
   LapMat(adjacency(1,j), adjacency(1,j)) = LapMat(adjacency(1,j), adjacency(1,j))+1;
   LapMat(adjacency(2,j), adjacency(2,j)) = LapMat(adjacency(2,j), adjacency(2,j))+1;
end
end

function result = Extension(matrix, edges,fieldSize,targetRank)
extra=length(matrix);
ExtendedMat=cat(2, cat(1,matrix,zeros(1,extra)),zeros(extra+1,1) );
result = extendRec(ExtendedMat,edges,1, fieldSize,targetRank,[]);
end

function result = extendRec(matrix, edges,current ,fieldSize, targetRank,result)
extra = length(matrix);
for p= -fieldSize:fieldSize
    if(p == 0 && extra~= edges(current))
        continue;
    end
    matrix( extra, edges(current) ) = p;
    matrix( edges(current), extra ) = p;
    if(current < length(edges))
        result = extendRec(matrix, edges,current+1 ,fieldSize, targetRank,result);
    else
        r= rank(matrix);
        if(r == targetRank)
            fprintf("Rank: %d\n",r);
            disp(matrix);
            result = cat(3,result,matrix);
        end
    end
end
end