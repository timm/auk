NR==1 { 
	Pat1=this"([a-zA-Z0-9_]*)"
    gsub(/,/,"\\1,",that) 
	Pat2=that"\\1" 
}
{ print gensub(Pat1,Pat2,"g",$0) }
