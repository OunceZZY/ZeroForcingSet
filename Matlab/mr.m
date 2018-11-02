
%fprintf("%s\n","Here");


fieldSize = 2;
targetRank = 4;
modelSize = 5;
%adjacency = [1,2,3,4,5,1,2,3,4,5;
       %      2,3,4,5,1,1,2,3,4,5];
adjacency = [1,2,3,4,1,2,3,4,5;
             2,3,4,5,1,2,3,4,5];
GraphType = 'Path-Lap';
DiaryName = strcat (GraphType,'-',num2str(modelSize),'mr',num2str(targetRank),'fs',num2str(fieldSize),'.txt');
delete(DiaryName);
diary(DiaryName);

fprintf("Adjacency list:\n");
disp(adjacency);
fprintf("Field size: %d\n\n", fieldSize)
allmatmeets(fieldSize, targetRank, modelSize, adjacency);


diary off
type(DiaryName);

function allmatmeets(fs, targetRank, modelSize,adjacency)
% with n as "field siz3", targetRank as minimum rank

mat = zeros(modelSize);

ret = [];

subcur(mat,1, fs, targetRank, modelSize, adjacency, ret);

%for a=1:length(allValids)
%    print(allValids(:,:,a));
%end

end

function subcur(mat, current, fs, targetRank, modelSize,adjacency, ret)
   for p = 1:fs
       v=p;
       if(adjacency(1,current) ~= adjacency(2,current))
           v = -p;
       end
       mat( adjacency(1,current),adjacency(2,current) ) = v;
       mat( adjacency(2,current),adjacency(1,current) ) = v;
       
       
       if(current<length(adjacency))
           subcur(mat, current+1, fs, targetRank, modelSize,adjacency,ret);
       else   
           if(rank(mat) == targetRank)
               %fprintf("Rank: %d\n", targetRank);
               %disp(mat);
               ret = cat(3,ret,mat);
           end
       end
   end
end