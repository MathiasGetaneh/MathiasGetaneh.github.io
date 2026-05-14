# -*- coding: utf-8 -*-
"""
Created on Fri Dec  5 18:29:25 2025

@author: mathi
"""

import pandas as pd  # for data frame creation
# import graphing library
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np # for numeric library

#Getting modified housing dataset
housing = pd.read_csv("hpiWithIndexChange.csv", sep=";", low_memory=False)
#housing = housing[housing['frequency'] == 'monthly']
#Changing time to datetype format seen in Python
#Counts of hpi_type
plt.figure(figsize=(15,15))
sns.countplot(data=housing, x='hpi_type')
plt.ylabel("Count")
plt.title("Number of each type of development")
plt.savefig('hpitype.png',facecolor='white', transparent=False)
plt.show()

#Counts of hpi_flavor
plt.figure(figsize=(15,15))
sns.countplot(data=housing, x='hpi_flavor')
plt.ylabel("Count")
plt.title("Amount of each record type recorded")
plt.savefig('hpiflavor.png',facecolor='white', transparent=False)
plt.show()

housing['Time'] = pd.to_datetime(housing['Time'])
#Sorting to find states
housing_state = housing[housing['level'] == 'State']
housing_state = housing_state[housing_state['hpi_type'] == 'traditional']
housing_state = housing_state[housing_state['hpi_flavor'] == 'all-transactions']
#maxIndex = housing_state.sort_values(by=['index_nsa'], ascending=False)

#Finding the states where hpi decreased
loweredHPI = housing_state[(housing_state['prop_change_nsa'] < 0) | (housing_state['prop_change_sa'] < 0)]
#Finding times where HPI lowered more than 2%
prop_loss = -0.02
severeLoweredHPI = loweredHPI[(loweredHPI['prop_change_nsa'] <prop_loss) | (loweredHPI['prop_change_sa'] <prop_loss)]
#Finding amount of times HPI lowered across time
states = pd.unique(loweredHPI['State'])
timesLowered = pd.DataFrame(data={'State': pd.unique(loweredHPI['State']), 'Occurences': loweredHPI['State'].value_counts()})
#Finding average HPI losses
timesLowered['Mean Change (Not Seasonally Adjusted)'] = loweredHPI.groupby('State')['change_nsa'].mean()
timesLowered['Mean Percentage Change (Not Seasonally Adjusted)'] = loweredHPI.groupby('State')['prop_change_nsa'].mean()
timesLowered['Mean Change (Seasonally Adjusted)'] = loweredHPI.groupby('State')['change_sa'].mean()
timesLowered['Mean Percentage Change (Seasonally Adjusted)'] = loweredHPI.groupby('State')['prop_change_sa'].mean()
#Finding amount of times HPI severely lowered across time
states = pd.unique(severeLoweredHPI['State'])
timesSeverelyLowered = pd.DataFrame(data={'State': pd.unique(severeLoweredHPI['State']), 'Occurences': severeLoweredHPI['State'].value_counts()})
#Finding average HPI losses
timesSeverelyLowered['Mean Change (Not Seasonally Adjusted)'] = severeLoweredHPI.groupby('State')['change_nsa'].mean()
timesSeverelyLowered['Mean Percentage Change (Not Seasonally Adjusted)'] = severeLoweredHPI.groupby('State')['prop_change_nsa'].mean()
timesSeverelyLowered['Mean Change (Seasonally Adjusted)'] = severeLoweredHPI.groupby('State')['change_sa'].mean()
timesSeverelyLowered['Mean Percentage Change (Seasonally Adjusted)'] = severeLoweredHPI.groupby('State')['prop_change_sa'].mean()
#Finding amount of times HPI lowered by timespan
timesLoweredByMonth = pd.DataFrame(data={'Time': pd.unique(loweredHPI['Time']), 'Occurences': loweredHPI['Time'].value_counts()})
timesLoweredByMonth['Mean Change (Not Seasonally Adjusted)'] = loweredHPI.groupby('Time')['change_nsa'].mean()
timesLoweredByMonth['Mean Change (Seasonally Adjusted)'] = loweredHPI.groupby('Time')['change_sa'].mean()
#Finding amount of times HPI severely lowered by timespan
timesSeverelyLoweredByMonth = pd.DataFrame(data={'Time': pd.unique(severeLoweredHPI['Time']), 'Occurences': severeLoweredHPI['Time'].value_counts()})
timesSeverelyLoweredByMonth['Mean Change (Not Seasonally Adjusted)'] = severeLoweredHPI.groupby('Time')['change_nsa'].mean()
timesSeverelyLoweredByMonth['Mean Change (Seasonally Adjusted)'] = severeLoweredHPI.groupby('Time')['change_sa'].mean()

#Finding counts of States with lowering HPI graphically
plt.figure(figsize=(25,13))
sns.countplot(data=loweredHPI, x='State')
plt.ylabel("Count")
plt.title("Number of HPI Decreases by State")
plt.savefig('hpilosses_all.png',facecolor='white', transparent=False)
plt.show()

#Finding counts of States with severely lowered HPI graphically
plt.figure(figsize=(25,13))
sns.countplot(data=severeLoweredHPI, x='State')
plt.ylabel("Count")
plt.title("Number of Severe HPI Decreases by State")
plt.savefig('hpilosses_severe.png',facecolor='white', transparent=False)
plt.show()

#Finding decreases in HPI by time
plt.figure(figsize=(25,13))
sns.scatterplot(data=timesLoweredByMonth, x='Time', y="Occurences")
plt.ylabel("Count")
plt.title("HPI Decreases over Time")
plt.savefig('hpilosses_time_all.png',facecolor='white', transparent=False)
plt.show()

#Finding severe changes in HPI by time
plt.figure(figsize=(25,13))
sns.scatterplot(data=timesSeverelyLoweredByMonth, x='Time', y="Occurences")
plt.ylabel("Count")
plt.title("Severe HPI Decreases over Time")
plt.savefig('hpilosses_time_severe.png',facecolor='white', transparent=False)
plt.show()

#Finding average HPI and HPI change by state
states = pd.unique(housing_state['State'])
generalStateInformation = pd.DataFrame(data={'State': pd.unique(housing_state['State']), 'Mean HPI (Not Seasonally Adjusted)': housing_state.groupby('State')['index_nsa'].mean(), 'Mean HPI (Seasonally Adjusted)': housing_state.groupby('State')['index_sa'].mean()})
generalStateInformation['Mean Change (Not Seasonally Adjusted)'] = housing_state.groupby('State')['change_nsa'].mean()
generalStateInformation['Mean Change (Seasonally Adjusted)'] = housing_state.groupby('State')['change_sa'].mean()
