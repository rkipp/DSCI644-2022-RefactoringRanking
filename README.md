# Prediction of who should refactor the code


## Project Objectives

The goal of this project was to build a model which takes a refactoring request as input and outputs a prediction of who is best suited to do the refactoring.  More specifically, the focus was to answer or at least provide insights towards answering the following research questions:

1. Which of the three classification model in our evaluation set tends to give the best performance?
2. What is the trade-off in overall model performance if improved performance of the low committer group is a priority?
3. Which features are most important in predicting which developer is best suited for a given refactoring request?

## Data Pre-Processing

The raw data used in this project is contained in the file `data/project3-authors.csv`.  This file contains undated refactoring commit data from three open source projects.  These projects and the number of records for each project were as follows:

1. adangle/PMD, 8495
2. hibernate, 5399
3. eclipse, 3423

Data from the *adangle/PMD* and *hibernate* projects were extracted from `data/project3-authors.csv` and used to build the design matrices which were used to train models for each project.  The processed design matrix files can be found at:

+ `data/df_design_matrix_adangle.csv`
+ `data/df_design_matrix_hibernate.csv`

The files can be recreated from the original `data/project3-authors.csv` file by running the code in the following jupyter notebooks:

+ `notebooks/DataPrep_adangle.ipynb` - processes the data to create the adangle design matrix
+ `notebooks/DataPrep_hibernate.ipynb` - processes the data to create the hibernate design matrix

These notebooks were built using the libraries in the `requirements.txt` file running on Python 3.10.1 which can be downloaded from [here](https://www.python.org/downloads/release/python-3101/)

## Exploratory Data Analysis

+ Distibution of the project committers is highly skewed with a small number of developers doing a large majority of the historical commits.
  - See `notebooks/Phase2Explore.ipynb` for details

## Model Building Process - Reproducing Our Results

To reproduce our results from scratch, follow these steps:

1. TODO
2. TODO

## Making a prediction from a trained model

Once a model is built and trained on a project, run the model with a properly formatted input to generate a prediction.  To create a properly formatted request, start with an unformatted refactoring request that takes the following form:

type-of-refactor,six-file-path-level-of-file-to-be-refactored

### type-of-refactor

This is one of the following 27 refactoring types:

Move Class, Rename Attribute, Rename Method, Extract Method,
Inline Method, Rename Parameter, Extract Variable, Rename Variable,
Extract Superclass, Move Method, Extract And Move Method, Parameterize Variable,
Extract Subclass, Push Down Attribute, Push Down Method, Extract Class,
Move Attribute, Move And Rename Class, Inline Variable, Rename Class,
Pull Up Method, Replace Variable With Attribute, Move Source Folder, Pull Up Attribute,
Extract Interface, Move And Rename Attribute, Change Package

### six-file-path-level-of-file-to-be-refactored

An example of a adangle/PMD project-relative path will look like this:

pmd-core/src/main/java/net/sourceforge/pmd/util/document/DocumentOperationsApplierForNonOverlappingRegions.java

This file path would be converted at follows:

pmd-core,src,main,java,net,sourceforge/pmd/util/document/DocumentOperationsApplierForNonOverlappingRegions.java

### Example of input formatted

Using the example developed above, the full input to model would be a csv string with the following 7 values on a single line:

Move Class,pmd-core,src,main,java,net,sourceforge/pmd/util/document/DocumentOperationsApplierForNonOverlappingRegions.java

### Running the model to make a prediction

With a properly formatted input string, follow these steps to make a prediction:

1. TODO
2. TODO


## Assumptions

1. Best developer to do a refactor is the one who had the most historical commits of the file and refactoring type being requested.


## Results

+ Models were built to predict the `AuthorGroup` (response) based on two categorical predictors: `RefactoringType` and `FilePath` separated out into 6 levels designated **L1** through **L6**
  - `AuthorGroup` has 4 levels listed and defined on slide 11 of the file `documentation/RefactoringRanking_pre_phase4_FINAL v2.pdf`
  - `RefactoringType` has 27 levels listed on slide 5 of the file `documentation/RefactoringRanking_pre_phase4_FINAL v2.pdf`
  - `FilePath` had 3139 unique instances in the *adangle/PMD* project and 1609 in the *hibernate* project.
+ We evaluated the performance of the following 3 types of models: J48 Decision Tree, Naïve-Bayes and Random Forest.
+ Of these 3 models types, **Random Forest** out performed the other two based on the shapes of the ROC and PR curves for each of the 4 response levels as shown in Figure 3. of file `documentation/Group4_Phase4_FINAL.pdf`.
+ Performance of the adangle/PMD project model was good across all four response levels with only a small amount of degradation moving from extremely high to high to medium to low committer groups.
+ Performance of the hibernate project models degraded more severely moving from extremely high to high to medium to low committer groups than the adangle/PMD project.

Details of our results are described in the file `documentation/Group4_Phase4_FINAL.pdf`