function [schedule1,schedule2] = getScaleStarSchedule(execTime,commTime,price,sortedIndex,est,eft,N,V,Budget)

schedule1=zeros(N,1); %schedule as created by CA1 values

for i=1:N
    bestVM=1;
    schedule1(i)=bestVM;
    for j=2:V
        if(getCA1(i,j,bestVM,est,eft,execTime,price)>getCA1(i,bestVM,j,est,eft,execTime,price)) %step 3 of ScaleStar
            bestVM=j;
            schedule1(i)=j;
        end
    end
end

[makespanOld,costOld]=getMakespanAndCost(execTime,commTime,price,sortedIndex,schedule1,N,V); %step 4 of ScaleStar
A=zeros(N,V);         
count=0;             %denotes the number of pairs of task and VM for which A(i,j) is non zero 

for i=1:N
    for j=1:V
        if(schedule1(i)~=j) %step 5 of ScaleStar
            temp=schedule1(i);
            schedule1(i)=j;
            [makespanNew,costNew]=getMakespanAndCost(execTime,commTime,price,sortedIndex,schedule1,N,V);  
            schedule1(i)=temp;
            A(i,j)=getCA2(makespanOld,costOld,makespanNew,costNew);
            if(A(i,j)~=0)
                count=count+1;
            end
        end
    end
end

B=zeros(count); %denotes the set A in step 6
Brow=zeros(count);
Bcol=zeros(count);
count=0;

for i=1:N
    for j=1:V
        if(A(i,j)~=0) %step 6 of ScaleStar
            count=count+1;
            B(count)=A(i,j);
            Brow(count)=i;
            Bcol(count)=j;
        end
    end
end

[~,index]=sort(B); %step 7 of ScaleStar
Brow=Brow(index);
Bcol=Bcol(index);
costCurr=costOld; %costOld is the monetary cost execution of schedule 1(step 8 of ScaleStar)
schedule2=schedule1; %schedule2 is the schedule produced by applying CA2
i=1;
j=count;

while(i<=j) %step 9 of ScaleStar
    if(costCurr>Budget)
        VM=schedule2(Brow(i));
        task=Brow(i);
        schedule2(task)=Bcol(i);
        i=i+1;
    else
        VM=schedule2(Brow(j));
        task=Brow(j);
        schedule2(task)=Bcol(j);        
        j=j-1;
    end
    costOld=costCurr;
    [~,costCurr]=getMakespanAndCost(execTime,commTime,price,sortedIndex,schedule2,N,V);
    if(costCurr>Budget) %invalidating previous assignment
        schedule2(task)=VM;
        costCurr=costOld;
    end
end

if(costCurr>Budget) %step 10 of ScaleStar
    [~,VM]=min(price);
    schedule2(:)=VM;
end
  