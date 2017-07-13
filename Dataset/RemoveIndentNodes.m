function RemoveIndentNodes( childNodes )

numNodes = childNodes.getLength;
remList = [];
for i = numNodes:-1:1
   theChild = childNodes.item(i-1);
   if (theChild.hasChildNodes)
      RemoveIndentNodes(theChild.getChildNodes);
   else
      if ( theChild.getNodeType == theChild.TEXT_NODE && ...
           ~isempty(char(theChild.getData()))         && ...
           all(isspace(char(theChild.getData()))))
         remList(end+1) = i-1; % java indexing
      end
   end
end
for i = 1:length(remList)
   childNodes.removeChild(childNodes.item(remList(i)));
end

end
