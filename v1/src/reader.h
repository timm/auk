_Table
data   # data[row][col] holds 1 cell of datum
name   # name of i-th colum
colnum # reverse index on name
#
# meta knowledge
#
order  # order of the columns
nump   # is i-th column numeric
wordp  # is i-th column non-numeric?
indep  # list of indep columns 
dep    # list of dep columns
less   # numeric goal to be minimized
more   # numeric goal to be maximized
klass  # non-numeric goal
term   # non-numeric non-goal
num    # numeric non-goal
# 
# for all cols
n      # count of things in this col
#
# for wordp columns:
#
count  # count of each word
mode   # most common word
most   # count of most common word 
#
# for nump columns:
#
hi     # upper bound
lo     # lower bound
mu     # mean
m2     # sum of all nums
sd     # standard deviation
