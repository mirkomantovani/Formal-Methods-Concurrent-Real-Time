
# coding: utf-8

# In[13]:


import sys


# In[14]:


hist = open('output.hist.txt', 'r')
lines = hist.readlines()


# In[15]:


filter_adj = [line for line in lines if 'ADJACENT' not in line]

# In[16]:


for line in filter_adj:
    sys.stdout.write(line)

