gsub(/^"["]+/,"") { In = 1 - In } 
               { print In ? "# " $0 : $0 }
