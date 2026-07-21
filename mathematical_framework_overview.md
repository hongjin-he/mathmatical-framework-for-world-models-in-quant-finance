# Mathematical Theory of World Models in Quantitative Finance

*Draft — Alpha Flow Research, HongJin HE, July 2026*

---

## Overview

This document formalizes seven original theoretical ideas into a rigorous mathematical framework.

| # | Core Idea | Section |
|---|-----------|---------|
| 1 | World model = optimal estimation problem | §I |
| 2 | Itô integral equations (not differential equations) | §II |
| 3 | Dual noise decomposition (physical + behavioral) + Cramér-Rao bound | §III |
| 4 | All financial events = operators (Groupoid structure) | §IV |
| 5 | Financial adaptation of V-M-C architecture | §V |
| 6 | MFC/MFG multi-scale coexistence | §VI |
| 7 | Cybernetics → market stationarity (Lyapunov) | §VII |

---

## §I Overall Framework: World Model = Optimal Estimation of Market State

### I.1 Formal Problem Definition

Let the **true state** of a financial market be a stochastic process on probability space $(\Omega, \mathcal{F}, \mathbb{P})$:

$$\mathbf{S}_t \in \mathcal{H}, \quad t \in [0, T]$$

where $\mathcal{H}$ is a (separable) Hilbert space called the **market state space** (defined precisely in §II).

The **information filtration** available to an observer at time $t$ is:

$$\mathbb{F} = (\mathcal{F}_t)_{t \geq 0}, \quad \mathcal{F}_t = \sigma\left(\{S_u, X_u, \mathcal{E}_u\}_{u \leq t}\right)$$

where $X_u$ denotes exogenous shocks (policy, macro data) and $\mathcal{E}_u$ the sequence of financial events (IPO, M&A, etc.).

**Definition 1.1 (Market World Model)**: A market world model is a parameterized map:

$$\mathcal{M}_\theta : \mathcal{F}_t \times [0, h] \to \mathcal{P}(\mathcal{H})$$

mapping the current information set $\mathcal{F}_t$ and forecast horizon $h > 0$ to a probability distribution over $\mathcal{H}$, such that:

$$\mathcal{M}_\theta(\mathcal{F}_t, h) \approx \mathbb{P}(\mathbf{S}_{t+h} \in \cdot \mid \mathcal{F}_t)$$

### I.2 Optimal Estimation Decomposition

**Theorem 1.1 (Prediction Error Decomposition)**: For any $\mathcal{F}_t$-measurable estimator $\hat{\mathbf{S}}_{t+h}$, the mean squared error decomposes as:

$$\underbrace{\mathbb{E}\left[\|\hat{\mathbf{S}}_{t+h} - \mathbf{S}_{t+h}\|^2_\mathcal{H}\right]}_{\text{Total Prediction Error}} = \underbrace{\|\text{Bias}_\theta\|^2}_{\text{Model Bias}} + \underbrace{\text{Var}_\tau(h)}_{\text{Physical Variance}} + \underbrace{\text{Var}_\eta(h)}_{\text{Behavioral Variance}}$$

where:
- **Model Bias**: reducible by better modeling (tends to 0)
- **Var$_\tau(h)$**: irreducible physical/structural randomness (detailed in §III)
- **Var$_\eta(h)$**: irreducible behavioral/sentiment randomness (detailed in §III)

**Core Proposition**: The world model's goal is to drive Bias → 0, while quantifying the theoretical lower bound on Var$_\tau$ + Var$_\eta$ (a Cramér-Rao-type bound). This lower bound is not a model deficiency — it is an **intrinsic structural property** of the market.

### I.3 Construction of State Space $\mathcal{H}$

For a single asset, the state vector is:

$$s_t = (p_t,\, v_t,\, \ell_t,\, \kappa_t,\, \iota_t)^\top \in \mathbb{R}^5$$

| Dimension | Symbol | Meaning | Domain |
|-----------|--------|---------|--------|
| 1 | $p_t$ | log price | $\mathbb{R}$ |
| 2 | $v_t$ | log volume | $\mathbb{R}_+$ |
| 3 | $\ell_t$ | capital structure (leverage ratio) | $[0, \infty)$ |
| 4 | $\kappa_t$ | equity size (shares outstanding) | $\mathbb{R}_+$ |
| 5 | $\iota_t$ | information disclosure level | $[0,1]$ |

For $n$ assets:

$$\mathbf{S}_t = (s^1_t, \ldots, s^n_t)^\top \in \mathbb{R}^{5n}, \quad \text{equivalently} \quad \mathcal{S}_t \in \mathbb{R}^{n \times 5}$$

Taking the continuum limit $n \to \infty$ for theoretical analysis:

$$\mathcal{H} = L^2([0,1] \times [0,T], \mathbb{R}^5)$$

This is an infinite-dimensional separable Hilbert space with inner product $\langle f, g \rangle = \int_0^1\int_0^T f(u,t) \cdot g(u,t)\, dt\, du$. Numerical implementations reduce to $\mathbb{R}^{5n}$.

---

## §II Itô Integral Equations (Not Differential Equations)

### II.1 Why Not Differential Equations

**This is the most fundamental mathematical foundation of the entire framework.**

The standard SDE notation $dS_t = \mu_t\, dt + \sigma_t\, dW_t$ superficially resembles a differential equation, but it is **not**. The reason:

**Proposition II.1**: The Wiener process $W_t$ is a.s. nowhere differentiable.

*Proof*: For any $t$, the difference quotient $\frac{W_{t+\epsilon} - W_t}{\epsilon}$ is distributed as $\mathcal{N}(0, 1/\epsilon)$. As $\epsilon \to 0$, the variance $\to \infty$, so the limit does not exist in probability. $\square$

**Corollary**: The expression $\sigma_t \cdot \frac{dW_t}{dt}$ is meaningless everywhere. Therefore SDEs must be understood **not** as differential equations, but as **integral equations** (in the Itô sense).

### II.2 Correct Mathematical Statement

**Definition II.1 (Itô Integral Equation)**: The evolution equation for market state is:

$$\mathbf{S}_t = \mathbf{S}_0 + \int_0^t \mu(\mathbf{S}_u, u)\, du + \int_0^t \sigma(\mathbf{S}_u, u)\, dW_u$$

where:
- $\int_0^t \mu\, du$: Lebesgue integral, pathwise well-defined
- $\int_0^t \sigma\, dW_u$: **Itô stochastic integral**, defined as an $L^2$-limit:

$$\int_0^t \sigma_u\, dW_u := \lim_{n \to \infty} \sum_{k=0}^{n-1} \sigma_{t_k}\left(W_{t_{k+1}} - W_{t_k}\right)$$

This limit exists in $L^2(\Omega)$ (not pathwise).

**Itô Isometry** (the essence of the adaptedness requirement):

$$\mathbb{E}\left[\left|\int_0^t \sigma_u\, dW_u\right|^2\right] = \mathbb{E}\left[\int_0^t |\sigma_u|^2\, du\right]$$

This requires $\sigma_u$ to be $\mathcal{F}_u$-adapted (no look-ahead), which is the mathematical essence of **no-arbitrage**.

### II.3 Complete Integral Equation with Event Jumps

Incorporating financial events (operator framework from §IV):

$$\mathbf{S}_t = \mathbf{S}_0 + \underbrace{\int_0^t \mu(\mathbf{S}_u)\, du}_{\text{deterministic drift}} + \underbrace{\int_0^t \sigma(\mathbf{S}_u)\, dW_u}_{\text{physical stochastic integral}} + \underbrace{\int_0^t \int_{\mathbb{R}^k} z\, \tilde{N}^\eta(du, dz)}_{\text{behavioral jump integral}} + \underbrace{\sum_{\tau_w \leq t} (T_w - I)\mathbf{S}_{\tau_w^-}}_{\text{event operator jumps}}$$

where $\tilde{N}^\eta(dt, dz) = N^\eta(dt, dz) - \nu(dz)\, dt$ is the **compensated Poisson random measure**.

**Proposition II.2 (Doob-Meyer Decomposition)**: Under this framework, $\mathbf{S}_t$ uniquely decomposes as:

$$\mathbf{S}_t = \underbrace{M_t}_{\text{Martingale}} + \underbrace{A_t}_{\text{Bounded variation}}$$

where:
- $M_t = \int_0^t \sigma\, dW + \int \int z\, \tilde{N}^\eta$: zero-mean stochastic part
- $A_t = \mathbf{S}_0 + \int_0^t \mu\, du + \sum_{\tau_w \leq t}$: predictable structural part

The world model's task is to learn $A_t$ (the predictable component); $M_t$ is **fundamentally unpredictable** by the martingale property.

### II.4 Why This Matters for Control Theory

Since the equations are integral-form, the classical ODE Pontryagin maximum principle must be replaced by the **Stochastic Maximum Principle**. The optimal control condition becomes:

$$0 = \mathcal{H}(s^*, a^*, Y_t) := \sup_{a \in \mathcal{A}} \left[r(s, a) + Y_t^\top f(s, a) + \frac{1}{2}\text{tr}(Z_t^\top \sigma \sigma^\top Z_t)\right]$$

where $(Y_t, Z_t)$ is the adjoint (backward SDE) process. This is the mathematical foundation for §VII.

---

## §III Dual Noise Decomposition and Cramér-Rao Bound

### III.1 Fundamental Defect of Single-Noise Models

Standard Black-Scholes-type models assume a single noise source:

$$dS_t = \mu S_t\, dt + \sigma S_t\, dW_t$$

**This is structurally incorrect** because it conflates two fundamentally different types of uncertainty:
1. **Physical/structural noise**: arising from fundamental information asymmetry, measurement error, parameter estimation error
2. **Behavioral/sentiment noise**: arising from panic, herding, overreaction by market participants

These have a qualitative difference: the first is locally continuous in time (Brownian paths), while the second often exhibits **discontinuous jumps** (panic, fear, euphoria).

### III.2 Dual Noise Decomposition

**Definition III.1 (Dual Noise Decomposition)**: The market state process decomposes as:

$$d\mathbf{S}_t = \mu(\mathbf{S}_t, t)\, dt + \underbrace{\sigma_\tau(\mathbf{S}_t)\, dW_t^{(\tau)}}_{\text{physical noise } \tau_t} + \underbrace{dJ_t^{(\eta)}}_{\text{behavioral noise } \eta_t}$$

**Physical noise** $\tau_t \equiv \sigma_\tau(\mathbf{S}_t)\, dW_t^{(\tau)}$:
- Source: information asymmetry, market microstructure friction, fundamental valuation uncertainty
- Math structure: continuous Itô integral; $W_t^{(\tau)}$ is standard Brownian motion
- Statistics: locally Gaussian, continuous paths, quadratic variation $[S^{(\tau)}]_t = \int_0^t \sigma_\tau^2\, du$

**Behavioral noise** $\eta_t$:
- Source: sentiment shocks, herding behavior, liquidity crises (flash crashes), sudden policy shifts
- Math structure: pure-jump Lévy process

$$dJ_t^{(\eta)} = \int_{\mathbb{R}} z\, \tilde{N}^\eta(dt, dz)$$

with Lévy measure $\nu^\eta(dz)$ describing jump intensity (typically **heavy-tailed**: $\nu(|z| > x) \sim x^{-\alpha}$, $\alpha \in (1,2)$)

- Statistics: non-Gaussian, discontinuous paths, possibly infinitely many small jumps (Lévy type) or finitely many large jumps (compound Poisson type)

**Definition III.2 (Separation Condition)**: The two noise types are mutually independent:

$$[W^{(\tau)}, J^{(\eta)}]_t = 0 \quad \text{a.s.}$$

Behavioral shocks are not driven by Brownian motion.

### III.3 Characteristic Function and Lévy-Itô Decomposition

**Proposition III.1 (Complete Lévy-Itô Decomposition)**: The characteristic function of the noise process factorizes as:

$$\mathbb{E}\left[e^{i\xi^\top (\tau_t + \eta_t)}\right] = \exp\left(-t\Psi(\xi)\right)$$

where the Lévy exponent $\Psi(\xi)$ is given by the **Lévy-Khintchine formula**:

$$\Psi(\xi) = \underbrace{\frac{1}{2}\xi^\top \Sigma_\tau \xi}_{\text{physical noise (Gaussian)}} + \underbrace{\int_{\mathbb{R}^d}\left(1 - e^{i\xi^\top z} + i\xi^\top z \mathbf{1}_{|z|\leq 1}\right)\nu^\eta(dz)}_{\text{behavioral noise (jump part)}}$$

This decomposition is **unique**: the characteristic triplet $(\Sigma_\tau, 0, \nu^\eta)$ uniquely determines the noise distribution.

### III.4 Cramér-Rao-Type Prediction Lower Bound

**Theorem III.1 (Prediction Impossibility under Dual Noise)**: Let $\hat{S}_{t+h}$ be any $\mathcal{F}_t$-measurable unbiased estimator. Then:

$$\text{Var}\left(\hat{S}_{t+h} - S_{t+h}\right) \geq \underbrace{\sigma_\tau^2 \cdot h}_{\text{physical uncertainty bound}} + \underbrace{\lambda_\eta \cdot m_2^\eta \cdot h}_{\text{behavioral uncertainty bound}}$$

where:
- $\sigma_\tau^2$: physical noise intensity (squared volatility)
- $\lambda_\eta$: behavioral jump intensity (expected jumps per unit time)
- $m_2^\eta = \int_{\mathbb{R}} z^2\, \nu^\eta(dz)$: second moment of jump size distribution

*Proof sketch*: Apply Cramér-Rao inequality to the Gaussian component $W^{(\tau)}$; apply Poisson MSE lower bound to $J^{(\eta)}$; add by independence. $\square$

**Corollary III.1 (Quantum Analogy)**: Analogous to Heisenberg's uncertainty principle:

$$\Delta S_t \cdot \Delta(\partial_t S_t) \geq \sigma_\tau + \sqrt{\lambda_\eta m_2^\eta}$$

Market "position" (price) and "momentum" (return) cannot both be predicted to arbitrary precision simultaneously — this is an intrinsic bound determined by the dual noise structure, **independent of model quality**.

### III.5 Mathematical Nature of the Temperature Parameter $\tau$

The financial version of the temperature parameter $\tau$ from Ha & Schmidhuber (2018):

$$\mathbf{S}_{t+1}^{(\tau)} = f_\theta(\mathbf{S}_t) + \tau \cdot \varepsilon_t, \quad \varepsilon_t \sim \mathcal{N}(0, I)$$

Under the dual noise framework, $\tau$ is correctly understood as:

$$\tau_t = \sqrt{\sigma_\tau^2(\mathbf{S}_t) + \lambda_\eta(t) \cdot m_2^\eta(t)}$$

That is, $\tau_t$ is **time-varying** — a composite measure of physical and behavioral noise intensity. Learning the time-series dynamics of $\tau_t$ allows the world model to dynamically calibrate its uncertainty estimates.

**Key insight**: Increasing $\tau_t$ is not "adding noise" — it is the world model **honestly acknowledging** its predictive limitations during high-sentiment periods (large $\lambda_\eta$).

---

## §IV Financial Event Operator Framework (Summary and Integration)

*Full derivations are provided in the companion document "Event Operator Framework."*

### IV.1 Unified Definition of Event Operators

**Definition IV.1 (Affine Event Operator)**: Each financial event $w \in \mathcal{W}$ defines an operator on the state space:

$$T_w(s) = A_w \cdot s + b_w + \Sigma_w\, \varepsilon_w, \quad \varepsilon_w \sim \mathcal{N}(0, I)$$

Operator classification (three algebraic modes):

| Mode | Name | Scope | Matrix shape | Examples |
|------|------|-------|--------------|---------|
| I | Local (endomorphism) | Single asset, dimension-preserving | Square $d \times d$ | Stock split, secondary offering |
| II | Global (tensor product) | All assets simultaneously | Kronecker $dn \times dn$ | Rate hike, systemic crisis |
| III | Pairwise (morphism) | Two assets → one (or reverse) | **Non-square** | M&A (merger), spin-off |

### IV.2 Groupoid Structure

Because Mode III events change the dimension of the state space ($n$ changes), the event algebra $(\mathcal{G}_{\text{fin}}, \circ)$ must be a **Groupoid**, not a Semigroup:

**Theorem IV.1**: $(\mathcal{G}_{\text{fin}}, \circ)$ is a topological groupoid, where:
- Objects: $\text{Ob}(\mathcal{G}) = \{\mathcal{H}_S : S \text{ is a valid configuration}\}$
- Morphisms: $T_w \in \text{Hom}(\mathcal{H}_S, \mathcal{H}_{S'})$
- Composition: $T_{w_2} \circ T_{w_1}$ is defined only when $\text{src}(T_{w_2}) = \text{tgt}(T_{w_1})$

### IV.3 Integration with the Integral Equation

The complete market state integral equation (restating §II.3):

$$\mathbf{S}_t = \mathbf{S}_0 + \int_0^t \mu\, du + \int_0^t \sigma_\tau\, dW^{(\tau)} + \int_0^t\int z\, \tilde{N}^\eta(du,dz) + \sum_{\tau_w \leq t} (T_w - I)\mathbf{S}_{\tau_w^-}$$

Relationship between the last two terms:
- $\int\int z\, \tilde{N}^\eta$: **continuous** behavioral noise accumulation (infinitely many micro-jumps, Lévy type)
- $\sum (T_w - I)\mathbf{S}_{\tau_w^-}$: **discrete** financial event jumps (finitely many, driven by groupoid operators)

Both can be unified under jump measure notation, but financial event jumps take values in the operator space $\mathcal{G}_{\text{fin}}$ rather than $\mathbb{R}^k$.

---

## §V VMC Financial Architecture: E-Game-C Three-Module System

### V.1 Limitations of the Original VMC

Ha & Schmidhuber (2018) V-M-C architecture:
- **V** (Vision / VAE): compresses pixels to low-dimensional latent space
- **M** (Memory / MDN-RNN): learns dynamics in latent space
- **C** (Controller / CMA-ES): makes decisions based on $(z_t, h_t)$

Problems with direct transfer to finance:
1. No "pixels" — inputs are heterogeneous, unstructured mixed data
2. The "environment" is not fixed — markets are themselves the **feedback result** of all participants' actions
3. A single "M" cannot capture multi-agent games (Nash equilibrium, not optimal control)

### V.2 Financial Adaptation: E-Game-C Architecture

**Module E (Information Encoder)**

**Definition V.1**: The information encoder is a measurable map:

$$\mathcal{E}_\phi : \mathcal{F}_t \to \mathcal{Z}$$

where $\mathcal{Z} \subset \mathbb{R}^{d_z}$ is a low-dimensional latent space ($d_z \ll \dim(\mathcal{F}_t)$).

Implementation: Variational Autoencoder (VAE), optimizing the ELBO:

$$\mathcal{L}_{\text{ELBO}}(\phi, \psi) = \mathbb{E}_{z \sim q_\phi}[\log p_\psi(\mathbf{x} | z)] - D_{KL}(q_\phi(z | \mathbf{x}) \| p(z))$$

where $\mathbf{x}_t$ denotes raw observations (daily OHLCV, order book, sentiment indicators, event sequences) and $z_t = \mathcal{E}_\phi(\mathbf{x}_t)$ is the compressed "core market state vector."

**Module Game (Mean-Field Game Equilibrium)**

This is a fundamental replacement of the original M module. Rather than a single RNN predictor, it is a **game equilibrium map** over all decision-making agents.

**Definition V.2**: Let the market consist of a continuum of agents $u \in [0,1]$, each with state $z^u_t \in \mathcal{Z}$ following:

$$dz^u_t = f(z^u_t, a^u_t, \mu_t)\, dt + \sigma\, dW^u_t$$

where $\mu_t = \text{Law}(z^u_t)$ is the empirical distribution of all agents' states (the "mean field").

Each agent solves an optimal control problem (MFG form):

$$V^u(z, \mu) = \sup_{a \in \mathcal{A}} \mathbb{E}\left[\int_t^T r^u(z^u_s, a^u_s, \mu_s)\, ds + g^u(z^u_T, \mu_T)\right]$$

**Definition V.3**: A mean-field game equilibrium $(\hat{a}^u, \hat{\mu})$ satisfies:
1. **Optimality**: $\hat{a}^u = \arg\max_a \mathbb{E}[r^u(z^u, a, \hat{\mu})]$ (each agent plays best response)
2. **Consistency**: $\hat{\mu}_t = \text{Law}(z^u_t)$ under $\hat{a}^u$ (mean field is self-consistent)

**Proposition V.1 (MFG Equilibrium Existence)**: If the reward function $r^u$ is continuous in $(\mu, a)$ and $f$ is Lipschitz in $(z, \mu)$, then a mean-field game equilibrium exists (by Schauder's fixed point theorem).

*Proof sketch*: Define the map $\Phi: \mu \mapsto \text{Law}(\hat{z}^u_{\cdot}[\mu])$, where $\hat{z}^u[\mu]$ solves the optimal dynamics under fixed $\mu$. Show $\Phi$ is a continuous map on a compact convex set and apply Schauder's theorem. $\square$

**Module C (Controller)**

**Definition V.4**: The controller is an optimal policy based on $(z_t, h_t)$:

$$\pi^* : \mathcal{Z} \times \mathcal{H}_{\text{RNN}} \to \mathcal{A}$$

where $h_t$ is the Game module's hidden state (compressed memory of historical equilibrium paths).

Controller optimization objective (MFC form — the "central planner's" view):

$$\pi^* = \arg\max_\pi \mathbb{E}_\pi\left[\sum_{t=0}^T \gamma^t R_t(z_t, a_t, \mu_t)\right]$$

where $\gamma \in (0,1)$ is the discount factor and $R_t$ is the composite reward (individual returns and global efficiency).

### V.3 E-Game-C Information Flow

$$\underbrace{\mathbf{x}_t \in \mathcal{F}_t}_{\text{raw observations}} \xrightarrow{\mathcal{E}_\phi} \underbrace{z_t \in \mathcal{Z}}_{\text{core market state}} \xrightarrow{\text{Game}(\cdot; \hat{\mu})} \underbrace{(z_{t+1}, h_{t+1})}_{\text{predicted state + memory}} \xrightarrow{\pi^*} \underbrace{a_t \in \mathcal{A}}_{\text{decision/signal}}$$

**Key improvement**: In the original World Models, the $M$ module is a single neural network learning environment dynamics. In E-Game-C, the **Game** module is a **game equilibrium operator** whose dynamics arise from the interactions of all market participants — not a black-box $f_\theta$ fit to data. This yields **interpretability** (equilibrium structure) and **generalization** (equilibrium can be solved in novel market states).

---

## §VI MFC/MFG Multi-Scale Coexistence: Hierarchical Mean-Field Theory

### VI.1 Core Insight

Traditional mean-field theory places all agents at the **same level**: either all MFG (decentralized games) or all MFC (centralized control).

**HongJin's insight**: Real financial markets **simultaneously exhibit both structures**, depending on the observation scale:
- Macro scale (nations): countries as wholes interact via **MFG** (decentralized, no central planner)
- Meso scale (sectors/firms): within a country, central bank/regulators act as central planners → **MFC**
- Micro scale (investors): within a firm, individual investors interact via **MFG**

**This is not a contradiction — it is a description of the same system at different scales, analogous to micro/macro duality in physics.**

### VI.2 Two-Level Hierarchical Mean-Field Model

Let $K=2$ (generalizes to arbitrary $K$ levels):

**Layer 1 (Macro / Nations)**: $N$ countries, with country $j$ having macro-state:

$$d\xi^j_t = b^{(1)}(\xi^j_t, \nu^{(1)}_t, \alpha^j_t)\, dt + \sigma^{(1)}\, dB^j_t, \quad j = 1, \ldots, N$$

where $\nu^{(1)}_t = \frac{1}{N}\sum_{j=1}^N \delta_{\xi^j_t}$ is the macro mean field and $\alpha^j_t$ is the national policy.

**Layer 2 (Micro / Firms)**: Within country $j$, $M_j$ firms:

$$dx^i_t = b^{(2)}(x^i_t, \mu^{(2)}_{j,t}, \xi^j_t, a^i_t)\, dt + \sigma^{(2)}\, dW^i_t, \quad i \in \text{Cluster}(j)$$

where $\mu^{(2)}_{j,t} = \frac{1}{M_j}\sum_{i \in \text{Cluster}(j)} \delta_{x^i_t}$ is the micro mean field and $\xi^j_t$ is the exogenous macro state.

**Hierarchical Coupling Condition**:

$$\nu^{(1)}_t = \mathcal{A}\left(\{\mu^{(2)}_{j,t}\}_{j=1}^N\right)$$

The macro mean field is an **aggregation** $\mathcal{A}$ of the micro mean fields (e.g., weighted average).

### VI.3 Duality of Game and Control

**Layer 1 (MFG equilibrium)**: Countries as rational agents maximizing individual objectives:

$$\alpha^{j,*}_t = \arg\max_{\alpha^j} \mathbb{E}\left[\int_0^T r^{(1)}(\xi^j_t, \alpha^j_t, \nu^{(1)}_t)\, dt\right]$$

Equilibrium: $\alpha^{j,*}$ is a best response to $\nu^{(1)}_t$, and $\nu^{(1)}_t = \text{Law}(\xi^j_t | \alpha^{j,*})$ is consistent.

**Layer 2 (MFC + MFG hybrid)**: Within country $j$:
- Central bank / regulator (MFC planner): $\alpha^j_t$ influences firms via $\xi^j_t$
- Individual firms (MFG agents): each optimizes given $(\xi^j_t, \mu^{(2)}_{j,t})$

### VI.4 Hierarchical Nash Equilibrium Existence Theorem

**Theorem VI.1 (Existence of Hierarchical Mean-Field Equilibrium)**: Under the following conditions, a hierarchical Nash equilibrium $(\alpha^{*}, \hat{a}^{*})$ exists:

1. **Boundedness**: $b^{(k)}, r^{(k)}$ are bounded in all variables
2. **Lipschitz continuity**: $b^{(k)}$ is Lipschitz in $(x, \mu, \xi, a)$ with constant $L < \infty$
3. **Monotonicity (Lasry-Lions condition)**:
$$\int (r^{(2)}(x, \mu, a) - r^{(2)}(x, \mu', a))\, d(\mu - \mu')(x) \leq 0$$
for all probability measures $\mu, \mu'$ (prevents multiple equilibria)

*Proof framework*:
1. For fixed $\xi^j_t$, Layer 2 MFG equilibrium $\hat{a}^*[\xi^j]$ exists by Schauder's theorem (Proposition V.1)
2. Equilibrium firm distribution $\mu^{(2)}_{j,t}[\xi^j]$ is determined by step 1
3. Aggregation $\nu^{(1)}_t = \mathcal{A}(\{\mu^{(2)}_{j,t}\})$ yields the macro mean field
4. Layer 1 MFG equilibrium $\alpha^*$ exists by Schauder's theorem given $\nu^{(1)}_t$
5. The fixed-point map $\Xi: \xi \mapsto b^{(1)}(\xi, \nu^{(1)}[\xi], \alpha^*[\xi])$ is a contraction by the Lipschitz assumption, yielding a unique solution. $\square$

### VI.5 Main Corollaries

**Corollary VI.1 (Multi-Scale Information Decomposition)**: Under hierarchical equilibrium, firm $i$'s optimal strategy decomposes as:

$$a^{i,*}_t = \underbrace{\phi^{(1)}(\xi^j_t, \nu^{(1)}_t)}_{\text{macro equilibrium contribution}} + \underbrace{\phi^{(2)}(x^i_t, \mu^{(2)}_{j,t}, \xi^j_t)}_{\text{micro equilibrium contribution}} + O(\varepsilon)$$

where $\varepsilon$ is the inter-layer coupling strength. This enables hierarchical training of the world model (learn macro first, then micro), reducing computational complexity.

**Corollary VI.2 (MFC/MFG Switching Condition)**: As regulatory control intensity $\lambda_{\text{reg}} \to 0$, Layer 2 degenerates to pure MFG; as $\lambda_{\text{reg}} \to \infty$, it degenerates to pure MFC. Real markets are a mixture with $\lambda_{\text{reg}} \in (0, \infty)$.

### VI.6 Graphon Extension

When $N \to \infty$ (continuum approximation), the country index becomes $u \in [0,1]$, where each $u$ represents a type of agent (extreme retail $u \approx 0$, institutional $u \approx 1$).

**Definition VI.2 (Graphon Agent Representation)**: State vector for agent type $u \in [0,1]$:

$$ds^u_t = b(s^u_t, \mu_t, u)\, dt + \sigma(s^u_t, u)\, dW^u_t$$

where $\mu_t = \int_0^1 \delta_{s^u_t}\, du$ is the Graphon mean field.

**Extension**: $u$ should be a **vector** $u \in [0,1]^m$ ($m$ type dimensions, e.g., "risk preference × information access × geography"), not a scalar. This has not been systematically modeled in existing literature.

---

## §VII Cybernetics Framework: Lyapunov Stability and Market Stationarity

### VII.1 Mathematical Essence of the Cybernetics Connection

Market evolution viewed as a **dynamic control system**:

$$\frac{d\mathbf{S}_t}{dt} = F(\mathbf{S}_t, \mathbf{u}_t, \mathbf{W}_t), \quad \mathbf{u}_t \in \mathcal{U}$$

where:
- $\mathbf{S}_t$: system state (market state)
- $\mathbf{u}_t$: control input (regulatory policy, monetary policy, collective investor behavior)
- $\mathbf{W}_t$: external disturbance (dual noise $\tau_t + \eta_t$)

The central control-theoretic question: **under what conditions does the market (system) remain stable (stationary)?**

### VII.2 Stochastic Lyapunov Stability

**Definition VII.1 (Equilibrium Point)**: $\mathbf{S}^* \in \mathcal{H}$ is an equilibrium state if, in the absence of external shocks, $F(\mathbf{S}^*, 0, 0) = 0$ (center of mean reversion).

**Definition VII.2 (Lyapunov Function)**: $V: \mathcal{H} \to \mathbb{R}_+$ is a Lyapunov function for the system if:
1. $V(\mathbf{S}^*) = 0$ and $V(\mathbf{S}) > 0$ for $\mathbf{S} \neq \mathbf{S}^*$
2. $V$ is twice continuously differentiable
3. (Decay condition) $\mathcal{L}V(\mathbf{S}) \leq -c \cdot V(\mathbf{S})$ for some $c > 0$

where the Itô generator is:

$$\mathcal{L}V(\mathbf{S}) = \nabla V(\mathbf{S})^\top \mu(\mathbf{S}) + \frac{1}{2}\text{tr}\left(\sigma_\tau(\mathbf{S})^\top \nabla^2 V(\mathbf{S})\, \sigma_\tau(\mathbf{S})\right) + \int_{\mathbb{R}^k}\left[V(\mathbf{S}+z) - V(\mathbf{S}) - z^\top \nabla V(\mathbf{S})\right]\nu^\eta(dz)$$

Three terms correspond to contributions from: deterministic drift, physical noise, and behavioral jumps.

**Theorem VII.1 (Stochastic Stability)**: If a Lyapunov function $V$ exists with $\mathcal{L}V(\mathbf{S}) \leq -c \cdot V(\mathbf{S})$, then:
1. **Exponential mean-square stability**: $\mathbb{E}[V(\mathbf{S}_t)] \leq V(\mathbf{S}_0) \cdot e^{-ct}$
2. **Unique stationary distribution**: $\mathbf{S}_t$ admits a unique stationary distribution $\pi^*$, with exponential convergence from any initial distribution
3. **Market stationarity**: the time series $\{S_t\}$ is a (geometrically ergodic) stationary process

*Proof*: By Itô's formula:

$$dV(\mathbf{S}_t) = \mathcal{L}V(\mathbf{S}_t)\, dt + \nabla V^\top \sigma_\tau\, dW + \int[V(\mathbf{S}+z)-V(\mathbf{S})]\tilde{N}^\eta(dt,dz)$$

Taking expectations and applying $\mathcal{L}V \leq -cV$:

$$\frac{d}{dt}\mathbb{E}[V(\mathbf{S}_t)] \leq -c\cdot \mathbb{E}[V(\mathbf{S}_t)]$$

Gronwall's inequality gives $\mathbb{E}[V(\mathbf{S}_t)] \leq V(\mathbf{S}_0) e^{-ct}$. Existence of stationary distribution follows from Khasminskii (1980) compactness conditions. $\square$

### VII.3 Natural Lyapunov Candidate Functions for Financial Markets

**Choice 1 (Distance from equilibrium)**:

$$V(\mathbf{S}) = \|\mathbf{S} - \mathbf{S}^*\|^2_\mathcal{H}$$

Describes mean reversion mathematically. $\mathcal{L}V \leq -cV$ is equivalent to: the drift $\mu(\mathbf{S})$ toward equilibrium is fast enough to dominate noise diffusion.

**Choice 2 (Fundamental valuation gap)**:

$$V(\mathbf{S}) = \sum_{i=1}^n w_i (p^i_t - p^{i,*}_t)^2$$

where $p^{i,*}_t$ is the fundamental value of asset $i$. $\mathcal{L}V \leq -cV$ corresponds to mean reversion around fundamentals (dynamic version of the efficient market hypothesis).

**Choice 3 (Information entropy)**:

$$V(\mathbf{S}) = D_{KL}(\mu_t \| \pi^*)$$

where $\mu_t$ is the current distribution. $\mathcal{L}V \leq -cV$ means the distribution converges to stationarity exponentially.

### VII.4 Conditions for Market Instability (Bubbles / Crises)

**Definition VII.3 (Lyapunov Instability Region)**: Let $\mathcal{R}_{\text{unstable}} = \{\mathbf{S} : \mathcal{L}V(\mathbf{S}) > 0\}$.

In this region, $V$ is increasing and the system moves away from equilibrium — **this corresponds to market bubbles or crises**.

**Proposition VII.1 (Bubble Formation Condition)**: If $\mathbf{S}_0 \in \mathcal{R}_{\text{unstable}}$ and the behavioral jump intensity $\lambda_\eta$ is sufficiently large (emotionally driven market), the system may enter an "escape trajectory" where mean reversion fails — corresponding to a financial crisis or asset bubble.

**Corollary VII.1 (World Model as Monitor)**: Define the real-time risk indicator:

$$\text{RiskIndex}(t) = \mathcal{L}V(\mathbf{S}_t)$$

When $\text{RiskIndex}(t) > 0$, the market is in a potentially unstable state. This is a core application of the world model: **real-time monitoring of market stability**, beyond predicting returns.

### VII.5 Laplace Transform and Frequency Domain Analysis

For the linearized system (linearized around equilibrium):

$$\frac{d\tilde{\mathbf{S}}}{dt} = A\tilde{\mathbf{S}} + B\mathbf{u}$$

(where $\tilde{\mathbf{S}} = \mathbf{S} - \mathbf{S}^*$, $A = \nabla F|_{\mathbf{S}^*}$)

After Laplace transform, the transfer function is:

$$G(s) = (sI - A)^{-1}B$$

Necessary and sufficient condition for stability: all eigenvalues of $A$ have negative real parts ($\text{Re}(\lambda_k(A)) < 0$ for all $k$).

**Financial interpretation**: Eigenvalues of $A$ describe the market's "natural frequencies" — negative real parts correspond to mean reversion; positive real parts correspond to explosive growth (bubbles).

---

## §VIII Summary of Main Theorems

| Theorem | Section | Statement |
|---------|---------|-----------|
| **Theorem 1** (Itô Integral Representation) | §II | Market state dynamics are correctly expressed as Itô integral equations, not differential equations; a.s. non-differentiability of $W_t$ is the fundamental reason |
| **Theorem 2** (Dual Noise Uniqueness) | §III | Market noise admits a unique Lévy-Itô decomposition $(\Sigma_\tau, 0, \nu^\eta)$; physical noise (Gaussian) and behavioral noise (pure jump) are orthogonal in characteristic function space |
| **Theorem 3** (Prediction Lower Bound) | §III | Prediction variance of any unbiased estimator is at least $\sigma_\tau^2 h + \lambda_\eta m_2^\eta h$; this bound is model-independent — an intrinsic information-theoretic lower bound of the market |
| **Theorem 4** (Event Algebra = Groupoid) | §IV | The complete financial event algebra is a topological groupoid; dimension-preserving events form a monoid sub-structure; dimension-changing events require the groupoid morphism framework |
| **Theorem 5** (MFG Equilibrium Existence) | §V | Under Lipschitz conditions, the E-Game-C mean-field game equilibrium exists (Schauder fixed point) |
| **Theorem 6** (Hierarchical MFG Equilibrium) | §VI | Under boundedness, Lipschitz, and Lasry-Lions monotonicity conditions, the two-layer hierarchical mean-field system admits a unique hierarchical Nash equilibrium |
| **Theorem 7** (Stochastic Lyapunov Stability) | §VII | If a Lyapunov function satisfying $\mathcal{L}V \leq -cV$ exists, the market process is exponentially mean-square stable with a unique stationary distribution |

---

## §IX Connection Map: Unified Structure of the Seven Ideas

```
Overall Framework (§I): World model = optimal estimation problem
            ↓
    ┌───────────────────────────────────────────┐
    │           Mathematical Foundations         │
    │   §II  Itô integral (not differential)    │
    │   §III Dual noise τ + η (Cramér-Rao)     │
    └───────────────────────────────────────────┘
            ↓                       ↓
   §IV  Event operator         §V  VMC → E-Game-C
   (Groupoid structure)        (Game equilibrium replaces RNN)
            ↓                       ↓
    ┌───────────────────────────────────────────┐
    │         §VI  Multi-scale MFC/MFG          │
    │  Nations (MFG) → Sectors (MFC+MFG) →     │
    │  Investors (MFG): Hierarchical Nash       │
    └───────────────────────────────────────────┘
            ↓
   §VII  Cybernetics (Lyapunov stability)
   World model = dynamic control system
   Stationarity = existence of Lyapunov function
   Bubbles/crises = local failure of Lyapunov condition
```

### Paper Structure Map

| Paper Section | Corresponds to | Core Theorem |
|--------------|----------------|-------------|
| §1 Introduction | §I.1–I.2 | Prediction error decomposition |
| §2 Preliminaries | §II | Itô integral theorem |
| §3 Dual Noise Model | §III | Theorems 2 + 3 |
| §4 Event Operators | §IV | Theorem 4 |
| §5 World Model Architecture | §V | Theorem 5 |
| §6 Hierarchical MFG | §VI | Theorem 6 |
| §7 Stability Analysis | §VII | Theorem 7 |
| §8 Discussion | §IX | Unified structure |

---

*End of Document*
