_Table
data   # data[row][col] holds 1 cell of datum
name   # name of i-th colum
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
num    # numeric     non-goal
term   # non-numeric non-goal
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
n      # count of nums
sd     # standard deviation
