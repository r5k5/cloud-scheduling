function [schedule2] = getDeSlackSchedule(execTime,commTime,price,schedule2,sortedIndex,N,V)

flag=1;

while(flag==1)

    [~,costOld,startTimeVM,~,startTimeTask,endTimeTask]=getMakespanAndCost(execTime,commTime,price,sortedIndex,schedule2,N,V);
    X=zeros(N-2,1); %denotes the execution time for each task according to schedule2

    for h=1:N
        i=sortedIndex(h);
        if(i==1||i==N)
            continue;
        end
        X(i-1)=endTimeTask(i)-startTimeTask(i);
    end

    [~,candidateTask]=sort(X(:),'descend'); %candidateTask contains the task in decreasing order of execution time 
    candidateTask=candidateTask+1; %denotes the tasks except the entry and exit task nodes
    count=0; %denotes the number of idle
    candidateIdl=0; % denotes the set of idle times in the given schedule

    for i=1:V
        x=startTimeVM(i); %finding the idle slots for each VM
        for j=1:N
            if(startTimeTask(j)==x)
                x=endTimeTask(j);
            elseif(schedule2(j)==i&&startTimeTask(j)>x)
                count=count+1;
                candidateIdl(count)=startTimeTask(j)-x; %denotes the idle times 
                candidateIdlVM(count)=i; %denotes the VM for idle times of candidateIdl   
                startTimeIdl(count)=x;   %denotes the start time for each idle
                endTimeIdl(count)=startTimeTask(j);     %denotes the end time for each idle
                x=endTimeTask(j);
            end
        end
    end

    if(candidateIdl==0)
        return
    end

    [~,index]=sort(candidateIdl); %index contains the idle times in increasing order
    candidateIdlVM=candidateIdlVM(index); %candidateIdlVM now contains VM in increasing order of idle times
    startTimeIdl=startTimeIdl(index);
    endTimeIdl=endTimeIdl(index);
    i=1;

    while(i<=N-2)   %step 5 of DeSlack
        n=candidateTask(i);
        bestVM=NaN; %denotes the VM which may be a fit for task n
        minDiff=intmax;
        j=1;
        while(j<=count)
            idl=candidateIdlVM(j); %idl denotes a VM
            temp=schedule2(n);
            schedule2(n)=idl;
            [~,costNew]=getMakespanAndCost(execTime,commTime,price,sortedIndex,schedule2,N,V);
            schedule2(n)=temp;
            weightN=execTime(n,idl);
            weightIdl=endTimeIdl(j)-startTimeIdl(j);
            if((temp~=idl)&&(startTimeTask(n)>=startTimeIdl(j))&&(weightIdl>=weightN)&&(costNew<=costOld)&&((weightIdl-weightN)<minDiff))
                bestVM=idl;
                minDiff=weightIdl-weightN;
            end
            j=j+1;
        end
        if(~isnan(bestVM))
            schedule2(n)=bestVM;
            flag=1;
            i=N;  % so that inner while loop breaks and control goes to line number 5
        else
            flag=0;
        end
        i=i+1;
    end

end

end
