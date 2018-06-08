
# coding: utf-8

# In[8]:


import sys
import re


# In[9]:


hist = open('output.hist.txt', 'r')
lines = hist.readlines()


# In[10]:


def filter_lines(line):
    is_adjacent = 'ADJACENT' in line
    is_danger = "DANGER" in line
    return not (is_adjacent or is_danger)


# In[11]:


def split_time_instants(lines):
    result = []
    instant = []
    for line in lines:
        if "-----" in line:
            result.append(instant)
            instant = []
        instant.append(line)
    return result


# In[12]:


def order_time_instant(instant):
    result = []
    result.append(instant[0])
    result += sorted(instant[1:])
    return result


# In[13]:


def sub_position(line, pre):
    is_pre = pre in line
    if is_pre:
        x = "{} = {}.0"
        s = "{} = {}"
        line = re.sub(x.format(pre, 13), s.format(pre, "BIN-AREA"), line)
        line = re.sub(x.format(pre, 14), s.format(pre, "TOMBSTONE"), line)
        line = re.sub(x.format(pre, 15), s.format(pre, "CONVEYOR-BELT"), line)
    return line
        
def pretty_positions(lines):
    result = []
    for line in lines:
        line = sub_position(line, "ARM")
        line = sub_position(line, "CART")
        line = sub_position(line, "OPERATOR")
        result.append(line)
    return result


# In[17]:


def sub_actions(line):
    is_action = "CURRENT-ACTION" in line
    if is_action:
        x = "CURRENT-ACTION = {}.0"
        s = "CURRENT-ACTION = {}"
        line = re.sub(x.format(0), s.format("GO TO BIN-AREA"), line)
        line = re.sub(x.format(1), s.format("PICK FROM BIN-AREA"), line)
        line = re.sub(x.format(2), s.format("DROP TO LOCAL BIN"), line)
        line = re.sub(x.format(3), s.format("GO TO TOMBSTONE"), line)
        line = re.sub(x.format(4), s.format("PICK FROM LOCAL BIN"), line)
        line = re.sub(x.format(5), s.format("DROP TO TOMBSTONE"), line)
    return line
        
def pretty_actions(lines):
    result = []
    for line in lines:
        result.append(sub_actions(line))
    return result


# In[18]:


filter_adj = list(filter(filter_lines, lines))
instants = split_time_instants(filter_adj)
result = []
for instant in instants[1:]:
    result += order_time_instant(instant)
result = pretty_positions(result)
result = pretty_actions(result)
for line in result:
    sys.stdout.write(line)

