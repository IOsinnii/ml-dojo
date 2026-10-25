# Day 0 — Setup: uv + Positron

This course uses **[uv](https://docs.astral.sh/uv/)** to manage Python and packages and **[Positron](https://positron.posit.co/)** to run the notebooks.

---

## 1. Why uv?

If you come from R, think of uv as **`renv` + `install.packages()` for Python, but much faster**.

| You want to… | R habit | pip habit | uv |
|---|---|---|---|
| Install Python itself | — | python.org installer | `uv python install 3.12` |
| Isolate a project's packages | `renv::init()` | `python -m venv .venv` | `uv sync` creates `.venv` automatically |
| Declare dependencies | `DESCRIPTION` | `requirements.txt` | `pyproject.toml` |
| Pin exact versions | `renv.lock` | `pip freeze` | `uv.lock` (written automatically) |
| Add a package | `install.packages("x")` | `pip install x` | `uv add x` |
| Restore a project on a new machine | `renv::restore()` | `pip install -r …` | `uv sync` |
| Run something in the environment | — | activate, then run | `uv run <command>` |

uv is a single binary written in Rust, and it is typically 10–100× faster than pip. The lockfile means that you, a colleague and an HPC job all get **identical** package versions. That matters for reproducible analyses and for methods sections.

---

## 2. Install uv (once per machine)

Windows (PowerShell):

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

macOS / Linux:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Check that it worked (open a new terminal first):

```bash
uv --version
```

---

## 3. Set up this course

From the `ml-primer` folder:

```bash
uv sync
```

That one command:
1. reads `pyproject.toml` (what we need) and `uv.lock` (exact versions),
2. downloads a suitable Python if you don't have one,
3. creates `.venv/` in the project folder and installs everything into it.

Your system Python is never touched. Delete `.venv/` at any time and run `uv sync` to rebuild it.

---

## 4. Everyday uv commands

```bash
uv add umap-learn
```
Adds a package to `pyproject.toml`, updates `uv.lock` and installs it.

```bash
uv add --dev ruff
```
Adds a development-only tool, such as a linter or Jupyter itself.

```bash
uv remove umap-learn
```
Removes the package again.

```bash
uv run python my_script.py
```
Runs a script inside the project environment, with no activation needed.

```bash
uv tree
```
Shows the dependency tree, which is useful for asking "why is this package here?".

```bash
uv lock --upgrade
```
Upgrades all pinned versions within the limits set in `pyproject.toml`.

```bash
uvx ruff check .
```
`uvx` runs a tool once in a throwaway environment without adding it to the project. Think of it as `npx` for Python.

### Anatomy of `pyproject.toml`

```toml
[project]
name = "ml-primer"
requires-python = ">=3.12"
dependencies = [          # needed to run the course
    "numpy", "pandas", "scikit-learn", "statsmodels", "seaborn", "ipykernel",
]

[dependency-groups]
dev = ["jupyterlab", "nbconvert"]   # tooling, not analysis code

[tool.uv]
package = false           # this is a project, not an installable library
```

**Commit** `pyproject.toml` and `uv.lock`. **Don't commit** `.venv/`.

### Exercise 0
1. Run `uv add scipy`, then open `pyproject.toml` to see what changed.
2. Run `uv run python -c "import scipy; print(scipy.__version__)"`.
3. Run `uv remove scipy`.

---

## 5. Run the notebooks in Positron

Positron notebooks work out of the box. `ipykernel` is already in the project, so Positron needs nothing extra.

1. **Open the folder:** use *File → Open Folder…* and choose `ml-primer`. Open the whole folder, not just a single notebook, so Positron finds `.venv`.
2. **Select the interpreter:** use the interpreter picker at the top right of the window and choose the Python under **`ml-primer\.venv`** (labelled *uv* or *Venv*). If it isn't listed, run `uv sync` first, then reload the window.
3. **Open the notebook:** open `notebooks/day1_fundamentals_linear_regression.ipynb`. It opens in the Positron Notebook Editor by default. If the kernel shown for the notebook isn't the `.venv` Python, switch it with the kernel selector.
4. **Run it:** run cells one at a time with `Shift+Enter`, or use *Run All*.
5. **Use the IDE panes:**
   - **Variables pane:** after the loading cell, `df` and `d` appear here.
   - **Data Explorer:** click a DataFrame in Variables to sort and filter the cohort and see column summaries.
   - **Help pane:** put the cursor on a function such as `train_test_split` to read its documentation.

> **Tip:** the notebooks load data with paths relative to the `notebooks/` folder (`../data/...`). Keep the folder layout as is.

### If something goes wrong

| Symptom | Fix |
|---|---|
| `ModuleNotFoundError: sklearn` | The wrong interpreter is selected. Pick the `.venv` Python. |
| `.venv` doesn't appear in the picker | Run `uv sync` in the project folder, then use *Developer: Reload Window*. |
| You added a package but the notebook doesn't see it | Restart the kernel after `uv add`. |
| `FileNotFoundError` for the CSV | Make sure the notebook is still inside `notebooks/`. |

### Run without Positron (optional)

```bash
uv run jupyter lab
```
