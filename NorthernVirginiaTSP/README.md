# Northern Virginia Traveling Salesperson Problem
## Data Summary
Data was sourced from NBER's [“City Distance Database - Place Distance Database"](https://www.nber.org/research/data/city-distance-database-place-distance-database), using the 100-mile file and places designated in the 2010 census.

## Cities Chosen
There were 10 cities chosen, all of which were from Northern Virginia and had significance as places to see on a road trip. These cities were Fairfax, Arlington, Lorton, Mount Vernon, Alexandria, Chantilly, Manassas, Leesburg, Fredericksburg, and Front Royal.

The cities placed on a map of Northern Virginia are shown below.

![image](/NorthernVirginiaTSP/images/cities.png)

The distances between each city is shown in the following distance matrix.

![image](/NorthernVirginiaTSP/images/TSPDistanceMatrix.png)

## Methodology
Data was collected in a CSV format. Data was turned into a distance matrix for specific cities using R. Using MATLAB, the traveling salesperson was solved using the distance matrix to find the optimal route. Note that for this problem, the starting city was chosen to be Fairfax.

Visualizations of the best path were created using Folium in Python.

## Findings
The optimal route, when starting and ending in Fairfax, was found to be in the following order.
- Arlington, VA
- Alexandria, VA
- Mount Vernon, VA
- Lorton, VA
- Fredericksburg, VA
- Manassas, VA
- Front Royal, VA
- Leesburg, VA
- Chantilly, VA
- Fairfax, VA

This leads to a distance of 190.921 miles to traverse all cities. A visualization of the path is below.

![image](/NorthernVirginiaTSP/images/TSP.png)

[See the Code](https://github.com/MathiasGetaneh/MathiasGetaneh.github.io/tree/main/NorthernVirginiaTSP)

[Back to Home](https://mathiasgetaneh.github.io/)