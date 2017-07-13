TransferTime=zeros(size(tasks,1),size(tasks,1));
for k=1:size(tasks,1)
    ind=find(Transfermatrixlogical(k,:)==1); % child tasks of k
    for j=1:size(ind,2)
        inputfiles2task=inputfile(ind(j),:); % Input files to child task ind(j)
        for f=1:size(inputfiles2task,2)
            ind1=find(strcmp(outputfile(k,:),inputfiles2task(f))); % find input file of ind(j) in output files of parent task k
            if ~isempty(ind1)
            TransferTime(k,ind(j))=TransferTime(k,ind(j))+outputsize(k,ind1); % add file size to the transfer matrix
            end
        end
    end

end
TransferTime=TransferTime/(20*(10^6)); % Bandwidth assumed to be 20 MBPS
