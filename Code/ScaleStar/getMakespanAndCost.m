function [makespan,cost,startTimeVM,endTimeVM,startTimeTask,endTimeTask] = getMakespanAndCost(execTime,commTime,price,sortedIndex,schedule,N,V)

startTimeVM=NaN(V,1);   %denotes the start time of each VM
endTimeVM=zeros(V,1);   %denotes the end time of each VM
startTimeTask=NaN(N,1); %denotes the start time of each task
endTimeTask=NaN(N,1);   %denotes the end time of each task

for h=1:N
    i=sortedIndex(h); %ensures that tasks are selected in non-increasing order of BLevel
    x=endTimeVM(schedule(i));
    for j=1:N
        if(commTime(j,i)~=0&&x<endTimeTask(j)+commTime(j,i))  %commTime(j,i)~=0 selects the direct predecessors of task i
            if(schedule(i)==schedule(j))    %if predecessor and task are assigned to same VM then commTime=0
                x=max(x,endTimeTask(j));
            else
                x=endTimeTask(j)+commTime(j,i);
            end
        end
    end
    startTimeTask(i)=x;
    endTimeTask(i)=x+execTime(i,schedule(i));
    if(isnan(startTimeVM(schedule(i))))
        startTimeVM(schedule(i))=startTimeTask(i);               
    end 
     endTimeVM(schedule(i))=endTimeTask(i);
end

makespan=endTimeTask(sortedIndex(N));  %sortedIndex(N) denotes the exit task node
cost=0;  %denotes the monetary cost of running the tasks as per the schedule

for i=1:V
    if(isnan(startTimeVM(i)))
        startTimeVM(i)=0;
    end
    cost=cost+price(i)*(endTimeVM(i)-startTimeVM(i));
end