# Northern Virginia Traveling Salesperson Problem
## Data Summary
Data was sourced from NBER's [“City Distance Database - Place Distance Database"](https://www.nber.org/research/data/city-distance-database-place-distance-database), using the 100-mile file and places designated in the 2010 census.

## Cities Chosen
There were 10 cities chosen, all of which were from Northern Virginia and had significance as places to see on a road trip. These cities were Fairfax, Arlington, Lorton, Mount Vernon, Alexandria, Chantilly, Manassas, Leesburg, Fredericksburg, and Front Royal.

## Methodology
Data was collected in a CSV format. Data was turned into a distance matrix for specific cities using R. Using MATLAB, the traveling salesperson was solved using the distance matrix to find the optimal route.

Visualizations of the best path were created using Folium in Python.
