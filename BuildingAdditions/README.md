# Building Additions in Fairfax County
## Data Summary
Data was sourced from ["Building Additions"](https://catalog.data.gov/dataset/building-additions), hosted by data.gov. This data consisted of information regarding each housing addition collected over multiple surveys of Fairfax County. The relevant data was of the source, area, length, and type of building addition.

## Methodology
Data was collected in a CSV format. This data was cleaned in R to remove building additions classified as "other" for clarity in the model, as well as removing IDs from each row. The data was then split into training and test sets with a 70-30 ratio. The training set was used to train a random forest model with the ranger package in R, finding the best out-of-bag error to be 36.44%. 

[Back to Home](https://mathiasgetaneh.github.io/)