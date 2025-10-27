# MF-ECC-HDC
Memory-Free Error Correction for Hyperdimensional Computing (HDC) Edge Accelerators

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](#license)
[![HDC](https://img.shields.io/badge/Topic-HDC-blue.svg)](#)

**MF-ECC** is a lightweight, memory-free error correction technique for HDC classifiers.  
Instead of storing ECC check-bits in memory, we generate them **on the fly** with a tiny logic block and a compact list of **trigger indices** that mark when the check-bit value changes across dimensions. This removes check-bit memory, avoids faults in that region, and scales logarithmically with the hypervector dimension. See the block diagram in the paper’s Fig. 4 (page 5). :contentReference[oaicite:2]{index=2}

<p align="center"><img src="images/overview.png" width="780" alt="System overview"></p>

## TL;DR
- **No ECC memory:** check-bits are generated per dimension by a counter/popcount-style **Check-Bit Generator (CBG)**; only the indices of changes are stored. (Sec. III-A/B, pp. 3–4) :contentReference[oaicite:3]{index=3}  
- **Reorder once, reuse always:** sort dimensions by ECC codeword; reorder CHVs + rewire QHV to match; accuracy is preserved since dimension order doesn’t affect similarity. (Fig. 3, p. 3; Sec. III-B/C) :contentReference[oaicite:4]{index=4}  
- **Tiny hardware:** ~26 LUTs and 5 regs; **0 BRAM/DSP**, **0 added latency** on PYNQ-Z2. (Table IV, p. 6) :contentReference[oaicite:5]{index=5}  
- **Robust:** maintains accuracy under **~0.12–0.15 fault probability** before >5% drop; ≥12× better than prior art in that metric. (Table II, p. 6) :contentReference[oaicite:6]{index=6}  
- **Scales:** memory growth **O(log₂D)** vs. baseline ECC **O(D)**. (Fig. 7, p. 6) :contentReference[oaicite:7]{index=7}


---

## Repository layout
- `python/` —  Offline processing (generate indices, reorder CHVs, auto-emit HDL).
- `hardware/hdl/` — VHDL codes including: trigger index ROM, ECC decoder, CHV memory wrapper, and QHV rewiring.
- `images/` — figures reproduced from experiments.
