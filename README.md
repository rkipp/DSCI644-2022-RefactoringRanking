# Project Topic - Prediction of who should refactor the code


## Research Questions

The focus of this project was to answer or at least provide insights towards answering the following research questions:

1. Which of the three classification model in our evaluation set tends to give the best performance?
2. What is the trade-off in overall model performance if improved performance of the low committer group is a priority?
3. Which features are most important in predicting which developer is best suited for a given refactoring request?

## Data Pre-Processing

The raw data used in this project is contained in the file `data/project3-authors.csv`.  This file contains undated refactoring commit data from three open source projects.  These projects and the number of records for each project are were as follows:

1. adangle/PMD, 8495
2. hibernate, 5399
3. eclipse, 3423

Data from the *adangle/PMD* and *hibernate* projects were extracted from `data/project3-authors.csv` and used to build the design matrices which were used to train models for each project.  The processed design matrix files can be found at:

+ `data/df_design_matrix_adangle.csv`
+ `data/df_design_matrix_hibernate.csv`

The files can be recreated from the original `data/project3-authors.csv` file by running the running the code in the following jupyter notebooks:

+ `DataPrep_adangle.ipynb` - processes the data to create the adangle design matrix
+ `DataPrep_hibernate.ipynb` - processes the data to create the hibernate design matrix



## Exploratory Data Analysis

+ Distibution of the project committers is highly skewed with a small number of developers doing a large majority of the historical commits.
+ 

## Model Building Process - Reproducing Our Results

To reproduce our results from scratch, follow these steps:

1. TODO
2. TODO

## Trained Models - Using Our Trained Models


## Assumptions

1. Best developer to do a refactor is the one who had the most historical commits of the file and refactoring type being requested.



## Results

+ Goal of our models was to predict the `AuthorGroup` (response) based on two categorical predictors: `RefactoringType` and `FilePath`
  - `AuthorGroup` has 4 levels listed and defined on slide 11 of the file `documentation/RefactoringRanking_pre_phase4_FINAL v2.pptx`
  - `RefactoringType` has 27 levels listed on slide 5 of the file `documentation/RefactoringRanking_pre_phase4_FINAL v2.pptx`
  - `FilePath` has 3139 levels in the *adangle/PMD* project and 1609 levels in the *hibernate* project
+ We evaluated the performance of the following 3 types of models: J48 Decision Tree, Naïve-Bayes and Random Forest.
+ Of these 3 models types, **Random Forest** out performed the other two based on the shapes of the ROC and PR curves for each of the 4 response levels as shown in Figure 3. of file `documentation/Group4_Phase4_FINAL.pdf`.
+ Good model performance

Details of our results are described in the file `documentation/Group4_Phase4_FINAL.pdf`