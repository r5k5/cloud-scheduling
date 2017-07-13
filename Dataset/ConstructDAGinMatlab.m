function [ExecTime TransferTime ] = ConstructDAGinMatlab( dag)


tasks={};

t=1;
inputsize=[]; 
outputsize=[];
inputfile={};
outputfile={};
for i=1:size(dag,2)
    if (strcmp(dag(1,i).Name,'adag'))
       Adag=dag(i);
       for k=1:size(Adag.Children,2)
           if(strcmp(Adag.Children(1,k).Name,'job'))
               jobathand=Adag.Children(1,k);
               tasks(t,1)={jobathand.Attributes(1).Value}; %task id
               tasks(t,2)={jobathand.Attributes(2).Value}; %task name
               tasks(t,3)={jobathand.Attributes(4).Value}; % run time
               ic=1;
               oc=1;
               for ch=1:size(jobathand.Children,2)
                   childathand=jobathand.Children(1,ch);
                   if (strcmp(childathand.Attributes(2).Value,'input'))
                     inputfile(t,ic)={childathand.Attributes(1).Value};  % input file name
                     inputsize(t,ic)=str2num(childathand.Attributes(5).Value); % input file size
                     ic=ic+1;
                   elseif(strcmp(childathand.Attributes(2).Value,'output'))
                     outputfile(t,oc)={childathand.Attributes(1).Value};  %output file name
                     outputsize(t,oc)=str2num(childathand.Attributes(5).Value); %output file size
                     oc=oc+1;
                   end
               end
               t=t+1;
           end
       end
       
     Transfermatrixlogical=zeros(size(tasks,1),size(tasks,1)); % dependency matrix
    for k=1:size(Adag.Children,2)
           if(strcmp(Adag.Children(1,k).Name,'child'))
            child=Adag.Children(1,k);
            childy=find(strcmp(tasks(:,1),child.Attributes(1).Value));
            for par=1:size(child.Children,2)
                childx=find(strcmp(tasks(:,1),child.Children(par).Attributes.Value));
                Transfermatrixlogical(childx,childy)=1;
            end
           end   
       end
        break;
    end
   
end

workflowdata=tasks(:,3);
ExecTime=zeros(size(tasks,1),1);
for i=1:size(tasks,1)
    
    ExecTime(i,1)=str2num(workflowdata{i,1});
    
end

PrepareTransferTimeMatrix;
end

