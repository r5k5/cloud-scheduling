function [HbcsSchedule] = getHbcsSchedule(execTime,commTime,price,HeftSchedule,CheapestSchedule,sortedIndex,N,V,Budget)

[~,HeftCost] = getMakespanAndCost(execTime,commTime,price,sortedIndex,HeftSchedule,N,V); %calculating cost of HeftSchedule

if(HeftCost<Budget)  % if the fastest schedule is within budget then return the fastest schedule
    HbcsSchedule = HeftSchedule;
    return;
end

[~,CheapestCost] = getMakespanAndCost(execTime,commTime,price,sortedIndex,CheapestSchedule,N,V); %calculating cost of CheapestSchedule

RB = Budget;  %Remaining budget
RCB = CheapestCost;  %remaining cheapest budget

FT=zeros(N,V);       %denotes the earliest finish time of each task on every VM
HbcsSchedule=zeros(N,1);  %denotes the HbcsSchedule
availTime=zeros(V,1); %denotes the instant of time when a particular VM is free

for h=1:N
    i=sortedIndex(h);  %selects the tasks according to the upward rank
    
    p = 1;  %denotes the cheapest processor for task i
    for j=2:V  %calculating the cheapest processor for task i
        if(execTime(i,j)*price(j)<execTime(i,p)*price(p))
            p = j;
        end
    end
    
    RCB = RCB - execTime(i,p)*price(p);  %step 9 of HBCS
    
    temp=0;           %denotes the time when all the direct predecessors of task i have finished execution and transferred the required data to task i
    task=0;
    for k=1:N         %this loop is for selecting the direct predecessors of task i
        if(commTime(k,i)~=0&&temp<FT(k,HbcsSchedule(k))+commTime(k,i)) %commTime(k,i)~=0 selects direct predecessors of task i
            temp=FT(k,HbcsSchedule(k))+commTime(k,i);
            task=k;
        end
    end
    for j=1:V
        if(task~=0&&j==HbcsSchedule(task))
            y=max(availTime(j),temp-commTime(task,i)); %if predecessor and current task are on the same VM then commTime=0
        else
            y=max(availTime(j),temp);
        end
        FT(i,j)=y+execTime(i,j);
    end
    [~,pBest] = min(FT(i,:)); % pBest denotes the VM on which task i finishes earliest
    [~,pWorst] = max(FT(i,:)); % pWorst denotes the VM on which task i finishes latest
    
    Cost=zeros(V,1);  % denotes the cost for executing task i on each processor
    for j=1:V  % calculating the cost of executing task i on each processor
        Cost(j)=execTime(i,j)*price(j);
        if(j==pBest)
            CostBest = Cost(j);
        end
    end
    
    CostCoeff = RCB/RB;  % step 13 of HBCS
    
    Worthiness = zeros(V,1);  % denotes the worthiness of each processor for task i
    
    for j=1:V  % calculating the worthiness of each processor for task i
        if(Cost(j)>CostBest)
            Worthiness(j) = intmin;
        elseif(Cost(j)>RB-RCB)
            Worthiness(j) = intmin;
        else
            TimeR = (FT(i,pWorst)-FT(i,j))/(FT(i,pWorst)-FT(i,pBest));
            CostR = (Cost(pBest)-Cost(j))/(max(Cost)-min(Cost));
            Worthiness(j) = CostR*CostCoeff+TimeR;
        end
    end
    
    [~,pSel] =  max(Worthiness);  % pSel denotes the suitable processor for task i according to HBCS
    
    HbcsSchedule(i) = pSel;  % assigning the suitable processor to task i
    
    RB = RB - Cost(pSel);  % updating the remaining budget according to step 19 of HBCS
end

end
           