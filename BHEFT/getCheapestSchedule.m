function [CheapestSchedule] = getCheapestSchedule(price,N,V)

p=1;  % represents the cheapest processor
CheapestSchedule = zeros(N,1);

for i=2:V  % finding the cheapest processor
    if(price(p)>price(i))
        p=i;
    end
end

for i=1:N  % cheapest schedule -> assigning every task to cheapest processor
    CheapestSchedule(i)=p;
end

end
    