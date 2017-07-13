function [sortedIndex] = getBLevel(avgExecTime,commTime,N)

bLevel=zeros(N,1); %index of bLevel denotes the task 

for k=1:N
    i=N-k+1; %starting from exit node
    for j=1:N
        if(commTime(i,j)~=0&&bLevel(i)<bLevel(j)+avgExecTime(i)+commTime(i,j)) %commTime(i,j)~=0 selects the successors of task i
            bLevel(i)=bLevel(j)+avgExecTime(i)+commTime(i,j);
        end
    end
    if(bLevel(i)==0) %for exit node
        bLevel(i)=avgExecTime(i);
    end
end

[~,sortedIndex] = sort(bLevel(:),'descend'); %sortedIndex denotes the order of task in non-increasing order of BLevel
            
end