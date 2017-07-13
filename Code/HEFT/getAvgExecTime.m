function [avgExecTime]=getAvgExecTime(execTime,N,V)

avgExecTime=zeros(N,1); %gives the average execution time of each task

for i=1:N
    for j=1:V
        avgExecTime(i)=avgExecTime(i)+execTime(i,j);
    end
    avgExecTime(i)=avgExecTime(i)/V;
end