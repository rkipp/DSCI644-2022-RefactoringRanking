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

The video in `data\02_Weka_build_RF_win10.mp4` walks through the steps described below.

The models were generated using Weka (https://www.cs.waikato.ac.nz/ml/weka/) v3.8.6.  Once downloaded and installed (see `documentation/01_Weka_install_win10.mp4` for details), the data files can be opened within Weka using either the csv version or the Weka-formatted arff version.  To read in a data file into Weka, follow these steps:

1. Download 1 or more of the files in the `data/` folder that start with **df_**.  Two of these files will be `csv` and the other two will be `arff` which is the native Weka format.
2. Launch the Weka GUI - After installing Weka for Windows, you will have two launch options: "Weka 3.8.6" and "Weka 3.8.6 (with console)".  Click on the "Weka 3.8.6" option to launch the GUI version.
3. From the main Weka GUI, you'll see a column on the right side of the interface labled "Applications".  In this column will be an option labled "Workbench".  Click this button to bring up the "Weka Workbench" screen.
4. Click on the "Open File..." button near the top of the "Weka Workbench" screen.  This will bring up the "Open" file dialog screen.
5. Select the type of file you want to open from drop down menu at bottom of the "Open" dialog screen (either CSV or Arff)
6. Select one of the data files you downloaded in step 1 and click "Open".
7. In the "Attributes" section on the left, if anything other than: **RefactorType**,  **L1**, **L2**, **L3**, **L4**, **L5**, **L6**, or **AuthorGroup** is listed, select those items and then click the **Remove** button at the bottom of this section.  This step removes the columns that aren't used in the modeling process.

After completing the above steps, the data is ready for the model building step.  To reconstruct a Random Forest classifier model in Weka, follow these steps:

1. After opening a data file, from the second row of button at the top of Weka Workbench, click on the **Classify** button. This will open the *Classify* tab.
2. From the *Classify* tab, click the **Choose** button near the top, scroll down to the list and expand the *trees* option.
3. Under the *trees* folder, select *RandomForest*.  The parameters for the *RandomForest* can be set left-clicking in the white box next to **Choose**.  The descriptions of each of these parameters is available by clicking on **More**.  
4. Click the dropdown box just above the **Start** and **Stop** buttons and select **(Nom) AuthorGroup**. This selects the response variable.
5. Under **Test options** section, select **Cross-validation** and enter 10 for the value of **Folds**.
6. Click the **Start** button to start the model build process.

The model build process may take awhile depending on your hardware.  Upon successful completion, the classifier accuracies and confusion matrix will be shown in the **Classifier output** pane on the right.  The model can be saved by right-clicking on the model (in the **Result list** pane).  The precision-recall and other outputs can be viewed and saved by right-clicking on the model and selecting "Visualize Threshold Curve".  Once the preferred model has been built and found satisfactory, it needs to be finalized and saved before using for predictions.  Finalizing consists of re-evaluating the same classifier model, but changing the Test Options settings to "Use training set".  Note that this will generate a new confusion matrix and error table which should be ignored.  Once regenerated, the model is saved by right-clicking on the model under "Results list" and selecting "Save Model".  This saved model will be retrieved when making predictions.

The above steps need to be followed separately for each of the data sets.

## Making a prediction from a trained model

The video in `data\03_weka_RF_finalize_and_predict_win10.mp4` walks through the process described below.

In order to make a prediction we need two things: the trained model saved in the previous steps, and the dataset that is to be used for prediction.  A sample of the later can be found in `data/sample_predict_on_adangel.arff`.  This file will make six predictions.  Four of these predicitions will be correct, on for each class (extremely high, high, medium, and low).  Two of the predictions will incorrectly classify the low group as shown in the last two rows of Table 8. in our final report located at `documentation/Group4_Phase4_FINAL.pdf`.

The most straightforward way to setup the prediction dataset is to use the Weka native .arff format.  The appropriate .arff file used to build the model can be used as a template: open it using a text editor (e.g. Notepad++) and save it with another name to represent the prediction dataset.  All rows above and including the "@data" line should be retained, and all to-be-predicted rows should be added below the "@data" line using the same format i.e. single-quote enclosed (since they're categorical - not needed if numerical) and comma separated.  Since this is the data to be predicted, the last field will be unknown and should be "?" (without quotes).  This dataset is to be saved for recall within Weka.

Within Weka, reload the original model training dataset (although it won't be used - it's needed to be able to move to the next step), click on "Classify" and load the saved model from the previous paragraph by right-clicking in the "Results list" panel.  Once loaded, select "Supplied test set" under "Test Options" and click the "Set..." button.  In the "Test Instances" window, click "Open file...", then find and select the prediction dataset generated earlier.  At this point the model is ready to be executed to generate predictions.  Before executing the model, click on "More Options".  From the "Classifier Evaluation options" screen, click the "Choose" button next to "Output predictions" and select the format for the output then click "OK" to close this dialog.

To execute the model on the prediction dataset, right-click on the model and select "Re-evaluate model on current test set".  The predictions will be output in the Classifier Output panel and also saved to the file specified under "Output predictions" for subsequent analysis.

Once a model is built and trained on a project, run the model with a properly formatted input to generate a prediction.  To create a properly formatted request, start with an unformatted refactoring request that takes the following form:

type-of-refactor,six-file-path-level-of-file-to-be-refactored

Acknowledging: https://machinelearningmastery.com/save-machine-learning-model-make-predictions-weka/ for the very clear description of how to do the above.

### type-of-refactor

This is one of the following 27 refactoring types:

Move Class, Rename Attribute, Rename Method, Extract Method,
Inline Method, Rename Parameter, Extract Variable, Rename Variable,
Extract Superclass, Move Method, Extract And Move Method, Parameterize Variable,
Extract Subclass, Push Down Attribute, Push Down Method, Extract Class,
Move Attribute, Move And Rename Class, Inline Variable, Rename Class,
Pull Up Method, Replace Variable With Attribute, Move Source Folder, Pull Up Attribute,
Extract Interface, Move And Rename Attribute, Change Package

Remember, these values need to enclosed in single quotes as discussed above when creating rows to make predictions on.

### six-file-path-level-of-file-to-be-refactored

An example of a adangle/PMD project-relative path will look like this:

pmd-core/src/main/java/net/sourceforge/pmd/util/document/DocumentOperationsApplierForNonOverlappingRegions.java

This file path would be converted at follows:

pmd-core,src,main,java,net,sourceforge/pmd/util/document/DocumentOperationsApplierForNonOverlappingRegions.java

### Example of a formatted input row

Using the example developed above, the full input to model would be a csv string with the following 8 values including the ? at the end on a single line:

'Move Class',pmd-core,src,main,java,net,sourceforge/pmd/util/document/DocumentOperationsApplierForNonOverlappingRegions.java,?


## Assumptions

1. Best developer to do a refactor is the one who had the most historical commits of the file and refactoring type being requested.


## Results

+ Models were built to predict the `AuthorGroup` (response) based on two categorical predictors: `RefactoringType` and `FilePath` separated out into 6 levels designated **L1** through **L6**
  - `AuthorGroup` has 4 levels listed and defined on slide 11 of the file `documentation/RefactoringRanking_pre_phase4_FINAL v2.pdf`
  - `RefactoringType` has 27 levels listed on slide 5 of the file `documentation/RefactoringRanking_pre_phase4_FINAL v2.pdf`
  - `FilePath` had 3139 unique instances in the *adangle/PMD* project and 1609 in the *hibernate* project.
+ We evaluated the performance of the following 3 types of models: J48 Decision Tree, Naïve-Bayes and Random Forest.
+ Of these 3 models types, **Random Forest** out performed the other two based on the shapes of the ROC and PR curves for each of the 4 response levels as shown in Figure 3. of file `documentation/Group4_Phase4_FINAL.pdf`.
+ Performance of the adangle/PMD project model was good across all four response levels with only a small amount of decline moving from extremely high to high to medium to low committer groups.
+ Performance of the hibernate project models degraded more severely moving from extremely high to high to medium to low committer groups than the adangle/PMD project.
+ Degradation in performance in the low and medium class predicitions show a strong correlation in the amount of overlap in the files worked on between these groups and the extremely high committer groups.
  - The calculations done for this test are shown in the file `prop_test.R`

Details of our results are described in the file `documentation/Group4_Phase4_FINAL.pdf`
