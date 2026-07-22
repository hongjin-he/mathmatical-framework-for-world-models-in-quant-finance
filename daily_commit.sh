#!/bin/bash
# Daily commit script for Alpha Flow research notebooks
# Commits one new notebook per day to GitHub

REPO_DIR="/Users/hehongjin/Documents/Alpha Flow/核心總結"
NOTEBOOKS_DIR="$REPO_DIR/notebooks"
LOG_FILE="$REPO_DIR/commit_log.txt"

cd "$REPO_DIR" || exit 1

# Find notebooks in order
NOTEBOOKS=(
    "notebooks/day01_why_factor_models_fail.ipynb"
    "notebooks/day02_roughness_of_noise.ipynb"
    "notebooks/day03_dual_noise.ipynb"
    "notebooks/day04_information_world_state_space.ipynb"
    "notebooks/day05_markets_as_mean_field_games.ipynb"
    "notebooks/day06_mfc_mfg_hierarchy.ipynb"
    "notebooks/day07_events_as_operators.ipynb"
    "notebooks/day08_lyapunov_stability.ipynb"
    "notebooks/day09_why_finance_is_harder.ipynb"
    "notebooks/day10_avatar_analogy_data_granularity.ipynb"
    "notebooks/day11_optimal_control_markov.ipynb"
    "notebooks/day12_seven_theorems_unified.ipynb"
    "notebooks/day13_finance_to_agi.ipynb"
    "notebooks/day14_reflection_and_next_steps.ipynb"
)

# Determine which notebook to commit today
# Count how many notebooks are already tracked in git
COMMITTED=$(git ls-files notebooks/ | grep '\.ipynb$' | wc -l | tr -d ' ')
IDX=$COMMITTED

if [ "$IDX" -ge "${#NOTEBOOKS[@]}" ]; then
    echo "$(date): All notebooks already committed." >> "$LOG_FILE"
    exit 0
fi

NOTEBOOK="${NOTEBOOKS[$IDX]}"
DAY=$((IDX + 1))

# Stage and commit
git add "$NOTEBOOK"

# Also add the notebooks directory README if this is the first one
if [ "$IDX" -eq 0 ]; then
    git add notebooks/
fi

git commit -m "Add Day $DAY notebook: $(basename $NOTEBOOK .ipynb)

First-principles research notes on mathematical framework for
world models in quantitative finance. Part $DAY of 14.

Co-Authored-By: HongJin HE <hhjhk@stanford.edu>"

# Push to GitHub
git push origin main

echo "$(date): Committed Day $DAY — $NOTEBOOK" >> "$LOG_FILE"
