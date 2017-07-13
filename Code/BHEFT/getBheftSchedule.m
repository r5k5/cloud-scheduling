function [schedule] = getBheftSchedule(execTime,commTime,price,sortedIndex,N,V,Budget)

c_bar=zeros(N,1);     %denotes the value of c_bar
sigma_c=0;            %denotes the value of sigma of c
sigma_c_bar=0;        %denotes the value of sigma of c_bar
est=zeros(N,V);       %denotes the earliest start time of each task on every VM
eft=zeros(N,V);       %denotes the earliest finish time of each task on every VM
schedule=zeros(N,1);  %denotes the schedule obtained by assigning each task to a VM where it finishes earliest
availTime=zeros(V,1); %denotes the instant of time when a particular VM is free

for i=1:N   %this loop fills all the values for c_bar
    for j=1:V
        c_bar(i)=c_bar(i)+execTime(i,j)*price(j);
    end
    c_bar(i)=c_bar(i)/V;
    sigma_c_bar=sigma_c_bar+c_bar(i);
end

for h=1:N   %this loop implements the BHEFT algorithm
    i=sortedIndex(h);  %selects the tasks in order of the priorities
    SAB=Budget-sigma_c-sigma_c_bar;
    if(SAB>=0)
        AF=c_bar(i)/sigma_c_bar;
    else
        AF=0;
    end
    CTB=c_bar(i)+SAB*AF;    
    
    temp=0;           %denotes the time when all the direct predecessors of task i have finished execution and transferred the required data to task i
    task=0;           %denotes the predecessor of task i which takes maximum time to finish and send required data to task i 
    flag=0;           %flag=0 represents S* is a null set
    for k=1:N         %this loop is for selecting the direct predecessors of task i
        if(commTime(k,i)~=0&&temp<eft(k,schedule(k))+commTime(k,i)) %commTime(k,i)~=0 selects direct predecessors of task i
            temp=eft(k,schedule(k))+commTime(k,i);
            task=k;
        end
    end
    for j=1:V         %this loop fills the est and eft table
        y=0;          %y will denote the est of the selected VM
        if(task~=0&&j==schedule(task))
            y=max(availTime(j),temp-commTime(task,i)); %if predecessor and current task are on the same VM then commTime=0
        else
            y=max(availTime(j),temp);
        end
        est(i,j)=y;
        eft(i,j)=est(i,j)+execTime(i,j);
        if(execTime(i,j)*price(j)<=CTB)
            flag=1;   %flag=1 represents S* set is not null
        end
    end
    if(flag==1)  %case 1 of selection rules
        [value,index]=sort(eft(i,:));
        for j=1:V
            m=index(j);
            if(execTime(i,m)*price(m)<=CTB)
                schedule(i)=m;
                availTime(m)=value(j);               
                break;
            end
        end
    elseif(flag==0&&SAB>=0)   %case 2 of selection rules
        [value,index]=min(eft(i,:));
        schedule(i)=index;          
        availTime(index)=value;     
    elseif(flag==0&&SAB<0)   %case 3 of selection rules
        [~,index]=sort(price);
        schedule(i)=index;
        availTime(index)=eft(i,index);
    end   
    
    sigma_c=sigma_c+execTime(i,schedule(i))*price(schedule(i));   %value is used in next iteration   
    sigma_c_bar=sigma_c_bar-c_bar(i);   %value is used in next iteration
end
