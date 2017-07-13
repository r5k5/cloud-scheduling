function [schedule0,est,eft] = getHeftSchedule(execTime,commTime,sortedIndex,N,V)

est=zeros(N,V);       %denotes the earliest start time of each task on every VM
eft=zeros(N,V);       %denotes the earliest finish time of each task on every VM
schedule0=zeros(N,1); %denotes the schedule obtained by assigning each task to a VM where it finishes earliest
availTime=zeros(V,1); %denotes the instant of time when a particular VM is free

for h=1:N
    i=sortedIndex(h); %ensures that tasks are selected in non-increasing order of BLevel
    temp=0;           %denotes the time when all the direct predecessors of task i have finished execution and transferred the required data to task i
    task=0;           %denotes the predecessor of task i which takes maximum time to finish and send required data to task i 
    for k=1:N         %this loop is for selecting the direct predecessors of task i
        if(commTime(k,i)~=0&&schedule0(k)~=0&&temp<eft(k,schedule0(k))+commTime(k,i)) %commTime(k,i)~=0 selects direct predecessors of task i
            temp=eft(k,schedule0(k))+commTime(k,i);
            task=k;
        end
    end
    for j=1:V         %this loop fills the est and eft table
        if(task~=0&&j==schedule0(task))
            y=max(availTime(j),temp-commTime(task,i)); %if predecessor and current task are on the same VM then commTime=0
        else
            y=max(availTime(j),temp);
        end
        est(i,j)=y;
        eft(i,j)=est(i,j)+execTime(i,j);
    end
    [value,index]=min(eft(i,:)); %index denotes the VM on which task i finishes earliest, value denotes the finishing time
    schedule0(i)=index;          %task i is assigned to VM index
    availTime(index)=value;      %availTime of VM index changes after assignment
end          
