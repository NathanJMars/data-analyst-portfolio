# LCMS Retention Modeling with Python

## Project Overview
This project evaluates whether LCMS retention time can be predicted from RDKit-derived molecular descriptors and whether the resulting models recover descriptor relationships consistent with expected chromatographic behavior.

## Dataset Summary
The notebook expects the dataset archive to remain at data/descriptors.zip within the project folder. 
The dataset contains one row per molecule. Key fields include:

- `rt` (retention time target)
- RDKit-derived 2D molecular descriptors
- descriptor families related to:
  - molecular size and weight
  - surface area
  - lipophilicity
  - charge distribution
  - topology and connectivity

The source data had already been pre-filtered before analysis:
- molecules with retention times below 2 minutes were removed
- molecules for which RDKit descriptors could not be generated were removed

## Data Grain
The dataset is structured at the following grain:

**one row per molecule**

This project therefore focused on descriptor-based modeling rather than relational joins or transaction-level aggregation.

## Tools Used
- Python
- Jupyter Notebook
- pandas
- numpy
- matplotlib
- scikit-learn
- GitHub

## Workflow

### Data Inspection

Inspection steps included:
- confirming row and column counts
- checking data types
- checking for missing values
- checking for duplicate rows
- reviewing summary statistics for the target variable

### Target Exploration

This included:
- summary statistics for `rt`
- histogram of the target distribution
- review of transformed target behavior for comparison

### Descriptor Screening

Screening steps included:
- removing zero-variance descriptor columns
- computing descriptor correlations with `rt`
- ranking the strongest positive and negative associations
- plotting the strongest correlation signals

### Model Development

Models tested:
- Mean baseline
- Linear Regression
- Ridge Regression
- Random Forest Regressor
- Tuned Random Forest Regressor

The workflow included:
- train/test split
- feature scaling for linear models
- model evaluation using MAE, RMSE, and R²
- cross-validation for model stability
- hyperparameter tuning for Ridge and Random Forest
- error analysis across the retention-time range

### Model Interpretation
Interpretation was performed using two approaches:
- linear coefficients to review broad descriptor-family effects
- Random Forest feature importances to identify the strongest predictive variables

This allowed the project to balance interpretability with predictive performance.

## Technical Outputs
This project produced:
- a Jupyter Notebook containing the full modeling workflow
- model comparison tables across baseline, linear, and non-linear regressors
- target distribution and descriptor screening visuals
- actual vs predicted and residual plots for the best-performing model
- retention-time bin error analysis
- feature importance outputs for model interpretation

## Results
A mean-value baseline produced essentially no explanatory value (R² ~0.00), confirming that the prediction task required structure beyond trivial averaging. Linear Regression and tuned Ridge Regression performed similarly, with R² values around 0.59 and RMSE values around 112, indicating that linear descriptor relationships explained a substantial portion of retention-time variation but left meaningful error unresolved.

The untuned Random Forest achieved the strongest performance on the held-out test set:

- MAE: 58.66
- RMSE: 85.44
- R²: 0.7623

This outperformed both linear approaches and the tuned Random Forest, indicating that non-linear descriptor relationships improved predictive accuracy and that the constrained tuning search space reduced performance rather than improving it.

Cross-validation and tuning were still useful for evaluating model stability and parameter sensitivity:
- Best Ridge alpha: 0.01
- Best Ridge CV RMSE: 112.57
- Best Random Forest parameters from the reduced search:
  - n_estimators: 100
  - max_depth: 10
  - min_samples_split: 2
  - min_samples_leaf: 1
- Best tuned Random Forest CV RMSE: 102.08

## Key Findings
- Retention time showed strong predictability from the available 2D molecular descriptors.
- Linear and Ridge regression provided similar baseline performance, indicating a meaningful but limited linear signal.
- The untuned Random Forest materially improved predictive performance over both linear models and the naive baseline.
- The tuned Random Forest did not outperform the untuned Random Forest on the held-out test set.
- Error analysis showed that model performance was strongest in the mid retention range and weaker at both extremes.
- The model systematically overpredicted low-retention compounds and underpredicted high-retention compounds.
- The most important predictor families were related to lipophilicity, surface area, charge distribution, and molecular size.
- `MolLogP`, a descriptor of lipophilicity, remained the strongest Random Forest feature, which is consistent with expected reversed-phase LC behavior.

## Interpretation
Linear models were retained as interpretable baselines, even though Random Forest performed better overall. This allowed the project to show both predictive benchmarking and descriptor-level interpretation.

At a high level, the results support expected reversed-phase LC behavior: compounds with stronger nonpolar or lipophilic character and relevant surface-area patterns tend to show longer retention. Because the scientific objective was to determine whether the descriptor set and modeling workflow would recover a known chromatographic relationship, the untuned Random Forest was treated as the final analytical endpoint once it both improved predictive performance and confirmed the expected importance of lipophilicity-related descriptors.

## Limitations
- The dataset contains only 2D molecular descriptors and does not include full structural or experimental complexity.
- Many descriptors are highly correlated, limiting one-to-one interpretation of model coefficients.
- The models are predictive and associative; they do not prove chromatographic mechanism.
- No experimental condition metadata was included beyond the descriptor matrix.
- Error increased at the extremes of the retention-time distribution, especially for the highest-retention compounds.

## Technical Notes
### Modeling Techniques Used
- feature/target split for supervised regression
- zero-variance feature removal
- correlation-based descriptor screening
- train/test validation workflow
- standardized linear regression baselines
- cross-validation for model stability
- hyperparameter tuning
- non-linear ensemble regression with Random Forest
- coefficient and feature-importance interpretation
- residual and bin-based error analysis

## Repository Structure
- `LCMS Retention Modelling.ipynb` — main modeling notebook
- `LCMS Summary Presentation.pdf` — project summary document
- `README.txt` — project overview, workflow, findings, and limitations
- 'data/descriptors.zip` — source dataset archive used for the notebook
