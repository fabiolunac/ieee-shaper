# MATLAB Files

Scripts for the design and digitalization of a nuclear pulse shaping filter.

## Files

### `PSC_coeff.m` — Pulse Shaper Circuit (PSC)

Derives the transfer function of a 5th-order RC ladder network (5 resistors + 5 capacitors, R = 5 kΩ, C = 1 nF) using symbolic ABCD matrix analysis.

- Builds the cascade ABCD matrix for the RC ladder
- Extracts H_psc(s) = V2/V1 = 1/A from the matrix
- Performs partial fraction decomposition (`residue`) into 5 first-order transfer functions
- Plots the impulse response of each component H_i(s) and the final H_psc(s)
- Saves the 5 partial-fraction TFs to `Hpsc.mat`

### `CSP_coeff.m` — Charge Sensitive Preamplifier (CSP)

Models the output of a CSP stage driven by a detector current pulse.

- Detector current: double-exponential model with τ_D = 5 ns, τ_R = 1 ns
- CSP stage: H(s) = −(Rf·Cd·s) / (Rf·Cf·s + 1), with Rf = 10 kΩ, Cf = 51 pF, Cd = 1 pF
- Performs partial fraction decomposition into 3 first-order transfer functions
- Plots the impulse response of H_csp(s)

### `paper.m` — Final Shaper and Digitalization

Assembles the full shaping filter from hardcoded partial-fraction coefficients and produces the figures for the paper.

- Reconstructs H_csp(s) (3 terms) and H_psc(s) (5 terms) from residue coefficients
- Computes the combined shaper H(s) = H_psc(s) · H_csp(s)
- Digitizes H(s) using impulse invariance (`impinvar`) at fs = 40 MHz
- Applies a 2nd-order Padé approximation to align the pulse peak at 75 ns
- Performs partial fraction decomposition of the discrete TF (`residuez`), grouping complex-conjugate poles into a 2nd-order section
- Produces publication-quality plots (Times New Roman, 16 pt) comparing continuous and discrete impulse responses

## Data

| File | Contents |
|------|----------|
| `Hpsc.mat` | Cell array `Hs` with the 5 first-order TFs from `PSC_coeff.m` |
