function [x] = getCA1(i,j,k,est,eft,execTime,price)

x=((execTime(i,k)*price(k)-execTime(i,j)*price(j))/execTime(i,j)*price(j))+((eft(i,k)-eft(i,j))/(eft(i,j)-est(i,j)));

end 