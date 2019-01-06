%stats2 = ToCount(kap,fieldSize);
%DiaryName = strcat (datestr(date),

stats3= ToCount(kap, fieldSize);

function toView()
date= datetime('now');
vector=[];
pivot = 0;
S = size(kap,1);
for i = 1: size(kap,3)
    if(pivot ~= kap(S,S,i)) 
        diary off
        pivot = kap(S,S,i);
        DiaryName = strcat (datestr(date),',Pivot-', num2str(pivot),'.txt');
        diary(DiaryName);
    end
    vector = null(kap(:,:,i),'r');
    vector = vector(:,2);
    mat = cat(2,kap(:,:,i),vector);
    display(mat);
end
diary off

end

function toCt= ToCount(GivenList, fieldSize)
toCt = zeros(1,fieldSize);
S = size(GivenList,1);
for i = 1: length(GivenList)
   mat = GivenList(:,:,i);
   toCt(mat(S,S)) = toCt(mat(S,S))+1;
end

end