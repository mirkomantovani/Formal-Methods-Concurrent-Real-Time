
# coding: utf-8

# In[80]:


import sys


# In[81]:


hist = open('output.hist.txt', 'r')
lines = hist.readlines()


# In[82]:


def filter_lines(line):
    is_adjacent = 'ADJACENT' in line
    is_danger = "DANGER" in line
    return not (is_adjacent or is_danger)


# In[83]:


def split_time_instants(lines):
    result = []
    instant = []
    for line in lines:
        if "-----" in line:
            result.append(instant)
            instant = []
        instant.append(line)
    return result


# In[84]:


def order_time_instant(instant):
    result = []
    result.append(instant[0])
    result += sorted(instant[1:])
    return result


# In[85]:


filter_adj = list(filter(filter_lines, lines))
instants = split_time_instants(filter_adj)
result = []
for instant in instants[1:]:
    result += order_time_instant(instant)
for line in result:
    sys.stdout.write(line)

