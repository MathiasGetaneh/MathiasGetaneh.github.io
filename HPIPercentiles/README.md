# Percentile Changes in the Housing Price Index
## Data Summary
Data was sourced from the FHFA [Housing Price Index](https://www.fhfa.gov/data/hpi/datasets?tab=master-hpi-data), received in September 2025. The dataset had 10 variables. These variables, along with what they described, were as follows:
- hpi_type
    - Type of development recorded
    - Traditional, Non-Metro, Manufactured, Distress-Free, Developmental
- hpi_flavor
    - How much data was recorded by HPI
    - Purchases only, All Transactions, Expanded Data
- frequency
    - How frequently data was recorded
    - Monthly, Quarterly, Annually
- level
    - Type of area recorded
    - Metropolitan area, State, Region, Continental US
- place_name
    - Name of place
- place_id
    - ID associated with area
- yr
    - Year data was recorded
- period
    - Chronological record for the year
    - 1-4 for Quarterly, 1-12 for Monthly
- index_nsa
    - Non-seasonally adjusted HPI
    - Available for each row
- index_sa
    - Seasonally adjusted HPI
    - This information is unavailable for certain areas


## Data Exploration
Each variable was investigated to find general information about the HPI. The data varies in start dates, but generally started collection around 1975 for most areas with HPIs starting at 100. General information about the HPI Type and Flavor is as follows:

![image](/HPIPercentiles/images/hpitype.png)

![image](/HPIPercentiles/images/hpiflavor.png)

As can be seen, most information is classified has a "Traditional" HPI Type, and most data in the dataset was collected using All Transactions. 


## Methodology
Data was collected in a CSV format. However, some data used commas in the format of "City, State" and necessitated alterations. These alterations were done using Cygwin, an editor that uses UNIX language for Windows. The CSV file was altered to use semicolons as the delimiter, to avoid conflict with city names.

Data was first processed in R to make a secondary CSV file. This secondary CSV file contained both absolute and proportional changes in both types of HPI, to calculate the changes in HPI compared to the previous period recorded. This was because HPIs are not directly comparable between 2 areas, as it is not associated with a fixed cost but instead with relative cost from when data was first collected. This introduced an additional 4 columns to the dataset. A 5th column representing state, as well as a 6th column representing time, were also introduced to make comparisons between different areas and types of data collection possible.

When making the modified dataset, R also made plots recording the differences between changes in the HPI between states and Metropolitan areas recorded from that state. Amazon Athena was used on the modified dataset to perform inquiries on the states with the biggest change in HPI, using the proportional non-seasonally adjusted HPI. This modified dataset was also used by Python, in order to find periods in which the HPI decreased. 


## Findings
Some of the more illuminating R plots were as follows:

![image](/HPIPercentiles/images/nsa_Delaware.png)

![image](/HPIPercentiles/images/nsa_Alaska.png)

![image](/HPIPercentiles/images/nsa_Maryland.png)

These images show that changes in the HPI happen for the state level and their metropolitan areas at about the same rate, with some exceptions which are likely to be noise in the data.

The Athena query on the data, with its results, were as follows:

![image](/HPIPercentiles/images/AthenaQuery.png)

![image](/HPIPercentiles/images/AthenaResponseGreatest.png)

![image](/HPIPercentiles/images/AthenaResponseLeast.png)

The biggest HPI changes happened in Idaho, Hawaii, and Vermont with 133%, 128%, and 75% increases in HPI in a single month. Note that these places also had major losses as well, implying massive levels of instability at certain points in time. The states with the least change in HPI were Kentucky, Pennsylvania, and Kansas, with changes of 6.3%, 7%, and 7.2%, respectively. This implies increased stability in those regions in regards to the housing market.

Python was used to investigate HPI losses over time. Plots regarding HPI losses are given below, graphing the time vs amount of HPI drops.

![image](/HPIPercentiles/images/hpilosses_time_all.png)

A modified drop only recording severe drops was also made. Note that severe drops are defined here as drops where the proportional change in the non-seasonally adjusted HPI goes below -0.02.

![image](/HPIPercentiles/images/hpilosses_time_severe.png)

It appears that most falls in the Housing Price Index occurred between 1980 and 1990. Another period where the Housing Price Index significantly decreases is the later end of the 2000s, when the 2007-10 Subprime Mortgage Crisis occurred. 

[See the Code](https://github.com/MathiasGetaneh/MathiasGetaneh.github.io/tree/main/HPIPercentiles)

[Back to Home](https://mathiasgetaneh.github.io/)