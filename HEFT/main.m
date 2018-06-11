function [HeftSchedule,HeftMakespan,HeftCost] = main()

% OBJECTIVE: minimize the execution time 

load('montage_25/execTime.mat');   %execution time matrix
load('montage_25/commTime.mat');   %communication time matrix
load('montage_25/price.txt');      %price of using each processor for unit time

N=size(execTime,1);   %number of tasks
V=size(execTime,2);   %number of VM

[avgExecTime] = getAvgExecTime(execTime,N,V);
[sortedIndex] = getBLevel(avgExecTime,commTime,N);
[HeftSchedule] = getHeftSchedule(execTime,commTime,sortedIndex,N,V);
[HeftMakespan,HeftCost] = getMakespanAndCost(execTime,commTime,price,sortedIndex,HeftSchedule,N,V);

end
