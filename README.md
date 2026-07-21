# Mathematical Framework for World Models in Quantitative Finance

**Author:** HongJin HE  
**Affiliations:** The Hong Kong University of Science and Technology · Stanford University (IHP)  
**Contact:** hhjhk@stanford.edu  
**Date:** July 2026 — *Preprint, submitted to arXiv:q-fin.MF*

---

## Overview

This repository contains the complete mathematical theory for applying **world models** to quantitative finance — the first systematic treatment of this connection in the literature.

The framework adapts the V-M-C world model architecture (Ha & Schmidhuber, 2018) to financial markets, replacing the memory module with a **Mean-Field Game equilibrium operator** (E-Game-C architecture), and provides rigorous mathematical foundations for each component.

## Files

| File | Description |
|------|-------------|
| [`paper_draft_v1.pdf`](paper_draft_v1.pdf) | Full paper (25 pages, ready for submission) |
| [`paper_draft_v1.tex`](paper_draft_v1.tex) | LaTeX source |
| [`mathematical_framework_overview.md`](mathematical_framework_overview.md) | Extended theoretical overview with full derivations |

## Core Contributions

Seven original theoretical ideas, fully formalized:

| # | Contribution | Section |
|---|-------------|---------|
| 1 | World model = optimal estimation problem | §I |
| 2 | Itô integral equations (not differential equations) | §II |
| 3 | Dual noise decomposition (physical + behavioral) + Cramér-Rao bound | §III |
| 4 | Financial events = operators on state space (Groupoid algebra) | §IV |
| 5 | E-Game-C architecture (replacing V-M-C for finance) | §V |
| 6 | Multi-scale MFC/MFG coexistence (hierarchical mean-field theory) | §VI |
| 7 | Cybernetics → market stationarity via stochastic Lyapunov stability | §VII |

## Main Theorems

- **Theorem 1** — Itô integral representation: market dynamics are integral equations, not differential equations
- **Theorem 2** — Uniqueness of dual noise decomposition via Lévy-Itô factorization
- **Theorem 3** — Prediction lower bound: irreducible variance ≥ σ²_τ·h + λ_η·m²_η·h (Cramér-Rao type)
- **Theorem 4** — Financial event algebra forms a topological groupoid
- **Theorem 5** — MFG equilibrium existence in E-Game-C (Schauder fixed point)
- **Theorem 6** — Hierarchical Nash equilibrium existence under Lasry-Lions monotonicity
- **Theorem 7** — Stochastic Lyapunov stability → unique stationary distribution

## Architecture: E-Game-C

```
Raw observations x_t
        ↓  Encoder E_φ (VAE)
  Latent state z_t
        ↓  Game module (MFG equilibrium)
  Predicted state z_{t+1} + memory h_{t+1}
        ↓  Controller π*
  Decision / signal a_t
```

The **Game** module replaces the RNN in the original world model with a mean-field game equilibrium operator — capturing multi-agent market dynamics with interpretability and out-of-distribution generalization.

## Citation

```bibtex
@article{he2026worldmodels,
  title   = {Mathematical Framework for World Models in Quantitative Finance},
  author  = {HongJin HE},
  year    = {2026},
  note    = {Preprint. arXiv:q-fin.MF (submitted)}
}
```
