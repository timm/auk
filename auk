#  -*- sh -*-

# Programs must be written for people to read, and only incidentally for machines to execute.
# - H. Abelson and G. Sussman (in "The Structure and Interpretation of Computer Programs)

# If you understand what you're doing, you're not learning anything.
# - Anonymous

# Programming languages should be designed not by piling feature on top of feature, 
# but by removing the weaknesses and restrictions that make additional features appear necessary.
# - Anonymous, Revised Report on the Algorithmic Language Scheme

# Question authority; but, raise your hand first.
# - A. Dershowitz

# There is a division in the student population between those who go to
# college to learn and those who go to college to earn a diploma.
# - J. Blau (letter to the editor, Chronicle of Higher Education, May 24, 2002)

# It is important that students bring a certain ragamuffin, barefoot
# irreverence to their studies; they are not here to worship what is known,
# but to question it.
# - J. Bronowski

# If you can't explain it simply, you don't understand it well enough.
# - A. Einstein

# We flew down weekly to meet with IBM, but they thought the way to measure
# software was the amount of code we wrote, when really the better the
# software, the fewer lines of code.
# - W. Gates

# The purpose of computing is insight, not numbers.
# - R. Hamming

# The fastest algorithm can frequently be replaced by one that is almost
# as fast and much easier to understand.
# - D. Jones

export Here=$(pwd)
export Etc=$Here/etc
export Src=$Here/src
export Lib=$HOME/opt/auk/lib
export Tmp=$HOME/opt/auk/tmp  
export Bin=$Here/bin
export PATH="$Bin:$PATH"

if    [ -z "$*" ] 
then  echo "This is Auk (copyleft 2013 tim@menzies.us)"
	  echo "(and a little auk goes a long, long way)"
	  echo ""
	  bash --init-file $Etc/boot.sh -i
else  bash  -c ". $Etc/boot.sh; $*"
fi

# to do:
# markdown
# web server
# line, appends next line
