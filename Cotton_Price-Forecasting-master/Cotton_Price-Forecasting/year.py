import pandas as pd
import numpy as np
import datetime
import csv


df= pd.read_csv(r"E:\Projects\price_prediction\datafile (3).csv")
df['month'] = pd.DatetimeIndex(df['arrival_date']).month
print(df['month'].to_csv(r"E:\Projects\price_prediction\output_month.csv", index=False))
