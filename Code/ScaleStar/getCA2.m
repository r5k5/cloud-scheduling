function [CA2] = getCA2(makespanOld,costOld,makespanNew,costNew)

if(makespanNew>makespanOld)%costOld<=costNew||
    CA2=0;
else
    CA2=(makespanNew-makespanOld)/(costOld-costNew);
end

end


