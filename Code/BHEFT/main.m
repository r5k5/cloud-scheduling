function [x,y1,y2] = main()

% OBJECTIVE: minimize the execution time given that cost lies within budget

load('montage_25/execTime.mat');   %execution time matrix
load('montage_25/commTime.mat');   %communication time matrix
load('montage_25/price.txt');      %price of using each processor for unit time

N=size(execTime,1);   %number of tasks
V=size(execTime,2);   %number of processors
%Budget=500;

[avgExecTime] = getAvgExecTime(execTime,N,V);
[sortedIndex] = getBLevel(avgExecTime,commTime,N);

%{
[HeftSchedule] = getHeftSchedule(execTime,commTime,sortedIndex,N,V);
[HeftMakespan,HeftCost] = getMakespanAndCost(execTime,commTime,price,sortedIndex,HeftSchedule,N,V);

[CheapestSchedule] = getCheapestSchedule(price,N,V);
[CheapestMakespan,CheapestCost] = getMakespanAndCost(execTime,commTime,price,sortedIndex,CheapestSchedule,N,V);

[BheftSchedule] = getBheftSchedule(execTime,commTime,price,sortedIndex,N,V,Budget);
[BheftMakespan,BheftCost] = getMakespanAndCost(execTime,commTime,price,sortedIndex,BheftSchedule,N,V);
%}

[HeftSchedule] = getHeftSchedule(execTime,commTime,sortedIndex,N,V);
[~,HeftCost] = getMakespanAndCost(execTime,commTime,price,sortedIndex,HeftSchedule,N,V);

[CheapestSchedule] = getCheapestSchedule(price,N,V);
[~,CheapestCost] = getMakespanAndCost(execTime,commTime,price,sortedIndex,CheapestSchedule,N,V);

HeftCost=ceil(HeftCost);
CheapestCost=ceil(CheapestCost);

x=zeros(HeftCost+10-CheapestCost+10+1,1);
y1=zeros(HeftCost+10-CheapestCost+10+1,1);
y2=zeros(HeftCost+10-CheapestCost+10+1,1);

for i=CheapestCost-10:HeftCost+10
    Budget=i;
    [BheftSchedule] = getBheftSchedule(execTime,commTime,price,sortedIndex,N,V,Budget);
    [Makespan,Cost] = getMakespanAndCost(execTime,commTime,price,sortedIndex,BheftSchedule,N,V);
    x(i-CheapestCost+10+1)=i;
    y1(i-CheapestCost+10+1)=Cost;
    y2(i-CheapestCost+10+1)=Makespan;
end

plot(x,y1,x,y2);
xlabel('Budget');
legend('Cost','Makespan','Location','northeast');

end
