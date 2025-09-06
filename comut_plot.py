import numpy as np
import os
import pandas as pd

import palettable
%matplotlib inline
%config InlineBackend.figure_format = 'retina'

import matplotlib.pyplot as plt
plt.rcParams["font.family"] = "arial" 

from comut import comut
from comut import fileparsers

comut = comut.CoMut()

mycn_mapping = {'yes':'#8E44AD','no':'#E5E7E9'}
alk_mapping = {'yes':'#229954','no':'#E5E7E9'}
germline_mapping = {'yes':'#F1C40F','no':'#E5E7E9'}
tumor_mapping = {'yes':'#F9E79F','no':'#E5E7E9'}
bar_mapping = {'BL': '#1891C2', 'RL': '#E56E25'}
bar_kwargs = {'width': 0.8, 'edgecolor': 'black'}

mapping = {'BL-empty':'white','RL-empty':'white','BL-MM':'#1891C2','RL-MM':'#E56E25','RL-MM_multiple':'#B41F1F','BL-MM_multiple':'#015F95'}
value_order=['BL-empty','BL-MM','BL-MM_multiple']
comut.add_categorical_data(data,  mapping=mapping,value_order=value_order,name = 'Mutation type', tick_style = 'oblique')

comut.add_categorical_data(data_ALKgroup, name = 'ALK_inh',mapping = alk_mapping)
comut.add_categorical_data(data_MYCN, name = 'MYCN',mapping = mycn_mapping)
comut.add_categorical_data(data_germline, name = 'Germline',mapping = germline_mapping)
comut.add_categorical_data(data_tumor, name = 'Tumor',mapping = tumor_mapping)
comut.add_bar_data(data_Variants, name = 'Variants',mapping = bar_mapping, stacked = True, bar_kwargs = bar_kwargs)


comut.plot_comut(figsize = (8.5, 8), x_padding = 0.04, y_padding = 0.04, tri_padding = 0.03, wspace = 0.5, hspace = 0)

comut.add_unified_legend()


from matplotlib.ticker import AutoMinorLocator # this function sets the location of the minor tick mark
minor_locator = AutoMinorLocator(2) # will place minor ticks in between major ticks

# set the axis minor tick locations to these positions
comut.axes['Mutation type'].yaxis.set_minor_locator(minor_locator)
comut.axes['Mutation type'].xaxis.set_minor_locator(minor_locator)

# add the grid
comut.axes['Mutation type'].grid( which= 'minor' , color='gray', axis='both')

# the spines by default are off, so we need to add them back
comut.axes['Mutation type'].spines['left'].set_visible(True)
comut.axes['Mutation type'].spines['bottom'].set_visible(True)

#comut.plot_comut(figsize = (20,20))
comut.add_unified_legend()
