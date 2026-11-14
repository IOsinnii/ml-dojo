# ML Dojo

A self-study attempt to **predict the contents of an upcoming introductory machine learning course** and to work through them ahead of time. The material is written from scratch as Jupyter notebooks. The examples are tailored to **bioinformatics and clinical systems biology**: biomarker panels, patient cohorts, and omics-style data where features far outnumber samples.

The course itself may turn out differently. This repo is my own guess at the ground it will cover, and practice for it.

## Layout

```
ml-dojo/
├── pyproject.toml, uv.lock   one shared environment for everything
├── primer/                   my own notebooks (Day 1, 2, …)
├── workshop_2026/            additional workshop material and extensions
└── data/                     shared data (only the simulated ELISA set is tracked)
```

## Notebooks (`primer/`)

| # | Notebook | Topics |
|---|---|---|
| 1 | [Fundamentals + linear regression](primer/day1_fundamentals_linear_regression.ipynb) | ML vocabulary, least squares by hand, confounding, train/test split, overfitting, the p ≫ n problem |
| 2 | [Logistic regression + gradient descent](primer/day2_logistic_regression_gradient_descent.ipynb) | odds ratios, log-loss, gradient descent from scratch, sensitivity/specificity, ROC/PR, calibration, target leakage |

More notebooks will follow.

## Data

The notebooks use a **simulated** ELISA cytokine dataset: rheumatoid arthritis patients vs healthy controls, n = 100 (`data/biomarker-analyses/elisa_biomarker_analysis_qmd/data/`). No real patient data is included.

## Getting started

The environment is managed with [uv](https://docs.astral.sh/uv/):

```bash
uv sync
```

See [SETUP.md](SETUP.md) for a short uv tutorial and instructions for running the notebooks in [Positron](https://positron.posit.co/).
