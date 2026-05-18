# Building Additions in Fairfax County
## Data Summary
Data was sourced from ["Building Additions"](https://catalog.data.gov/dataset/building-additions), hosted by data.gov. This data consisted of information regarding each housing addition collected over multiple surveys of Fairfax County. The relevant data was of the source, area, length, and type of building addition.

Source listed both the year a building addition was found in, as well as the model used to detect it. Building additions were used to refer to the five types of construction used in the dataset, these being Decks, Patios, Aprons, Pools, and Other.

Decks are classified as elevated spaces, and are considered ideal for uneven areas. Patios are ground-level spaces considered ideal for flat areas. According to [Fairfax County](https://catalog.data.gov/dataset/building-additions), aprons are classified as patios for commercial buildings within this dataset. Pools are used to refer to swimming pools, which require a permit in Fairfax County.

## Data Exploration
Data was shown in barcharts, finding the number of each type of building addition for each source.

![image](/BuildingAdditions/images/dataExploration.png)

Most building additions are decks or patios. Note that the amount of data is very large and unbalanced, making certain surveys insignificant. For example, ORTHO 2009 only had a single additional entry, and EAGLEVIEW 2022 had relatively few entries compared to the highs of other data collection efforts.

## Methodology
Data was collected in a CSV format. This data was cleaned in R to remove building additions classified as "other" for clarity in the model, as well as removing IDs from each row. The data was then split into training and test sets with a 70-30 ratio. The training set was used to train a random forest model with the ranger package in R, finding the best out-of-bag error to be 36.44%. 

## Findings
When using the test set, the following prediction matrix was generated in R. Note that rows represent the actual identity of the row, with columns representing what the random forest predicted was the correct classification.

![image](/BuildingAdditions/images/RFMatrix.png)

It was found that about 36.11% of predictions were incorrect for this model. The accuracy of each area was found below.

![image](/BuildingAdditions/images/sensitivity.png)

![image](/BuildingAdditions/images/specificAccuracy.png)

It appears that the most accurate areas were pools, with the least accurate being aprons. This misclassification of aprons likely occured due to the aprons being patios specifically for commercial areas.

[See the Code](https://github.com/MathiasGetaneh/MathiasGetaneh.github.io/tree/main/BuildingAdditions)

[Back to Home](https://mathiasgetaneh.github.io/)