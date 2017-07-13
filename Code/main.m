function [] = main()

cd 'D:\Projects\Cloud-Scheduling\Code\ScaleStar'

[~,cost1,makespan1] = main();

cd 'D:\Projects\Cloud-Scheduling\Code\BHEFT'

[~,cost2,makespan2] = main();

cd 'D:\Projects\Cloud-Scheduling\Code\HBCS'

[x,cost3,makespan3] = main();


%plot for cost
plot(x,cost1,x,cost2,x,cost3);
xlabel('Budget');
ylabel('Cost');
legend('ScaleStar','BHEFT','HBCS','Location','northwest');

%{
% plot for makespan
plot(x,makespan1,x,makespan2,x,makespan3);
xlabel('Budget');
ylabel('Makespan');
legend('ScaleStar','BHEFT','HBCS','Location','northeast');
%}

end