'''
Adam Hendel
Sentry Data Systems: Data Challenge
31-Mar-2018
Animated Plot of Time Series (Principal Component)
Saves a sequence of images that can be stitched together in video editing software
'''

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib import animation


# Set up formatting for the movie files
writer = animation.FFMpegFileWriter()
#writer = Writer(fps=15, metadata=dict(artist='Me'), bitrate=1800)

d = pd.read_csv('T:/Dropbox/Projects/Sentry/Data/pca_df.csv')
months=[]
dt = list(d['MM'])
dv = list(d['PC1'])
for i, x in enumerate(dt):
    if (i+1)<len(dt):
        if dt[i+1]==x:
            months.append('')
        else:
            months.append(x)
    else:
        months.append('')

plt.style.use('dark_background')
fig = plt.figure()
ax = plt.axes(xlim=(0,len(dv)), ylim=(min(dv),max(dv)))
ax.xaxis.set_major_locator(plt.MaxNLocator(len(months)))

line, = ax.plot(dt, dv, '-')

x = [x for x in range(len(dv))]

def animate(i):
    #line.set_ydata(dv[-i:] + dv[:-i])
    line.set_ydata(dv[i:] + dv[:i])
    line.set_xdata(x)
    #labs = months[-i:] + months[:-i]
    labs = months[i:] + months[:i]
    ax.set_xticklabels(labs)
    plt.savefig('T:/Dropbox/Projects/Sentry/video/Still/pca_{}.png'.format(i))
    return line,

anim = animation.FuncAnimation(fig, animate, interval=20, blit=False)

plt.show()
