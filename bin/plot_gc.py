#!/usr/bin/env python3
from parse import parse
import pandas as pd
from dateutil import parser as date_parser
import matplotlib.pyplot as plt
import os

file_name = os.path.expanduser("~/gc-logs.txt")

data = {"time": [], "gc": []}
for l in open(file_name, "r").readlines():
    p = parse("[{}] GC-elapsed: {}", l)
    data["time"].append(date_parser.parse(p[0]))
    data["gc"].append(float(p[1]))

df = pd.DataFrame(data=data)
df["gc-diff"] = df["gc"].diff()
df["gc-diff"][df["gc-diff"] < 0] = 0
print(df["gc-diff"].describe())
n, bins, patches = plt.hist(
    df["gc-diff"], 50, density=False, facecolor="g", alpha=0.75, log=True
)
plt.grid(True)
plt.show()
