#BEGIN { split("",Fields) }
/#_/ { 
  
  for(i=1;i<=NF;i++) 
    if ($i in Fields)
      $i = Fields[$i]
  Fields["_" $2] = rest(3)
}    
    
function rest(i,  str) {
  for(i=i; i<=NF; i++)
     str = str " " $i
  return str
} 
END { for(x in Fields)
        print x,Fields[x]
}
