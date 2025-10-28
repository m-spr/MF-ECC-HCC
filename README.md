# MF-ECC-HDC
Memory-Free Error Correction for Hyperdimensional Computing (HDC) Edge Accelerators

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](#license)
[![HDC](https://img.shields.io/badge/Topic-HDC-blue.svg)](#)

Brain-inspired **Hyperdimensional Computing (HDC)** has gained traction as an efficient and lightweight machine learning paradigm. With advantages like **one-shot learning** and **resource efficiency**, HDC is well-suited for **edge devices** with limited computational resources.  

While HDC inherently exhibits **fault tolerance**, **soft errors in associative memory** can degrade system performance, especially in **safety-critical applications** where reliability is paramount. Traditional **Error-Correcting Codes (ECC)** are commonly employed to mitigate such faults, but their **high storage overhead** poses challenges for edge deployments.  

### **Aboutr MF-ECC-HDC** 
**MF-ECC** is a lightweight, memory-free error correction technique for HDC classifiers.  
Instead of storing ECC check-bits in memory, we generate them **on the fly** with a tiny logic block and a compact list of **trigger indices** that mark when the check-bit value changes across dimensions. This removes check-bit memory, avoids faults in that region, and scales logarithmically with the hypervector dimension.

<p align="center"><img src="images/overall.png" alt="System overview"></p>
---

## **Hardware Overview**  

The following figure presents Memory-Free Error Correction for Hyperdimensional Computing Edge Accelerators within the HDC accelerator.  
<p align="center"><img src="images/hardware.png" alt="System overview"></p>

---
## **Getting Started**  

To set up the framework, follow these steps:  

- Clone this repository  
- Make a new project based on [RCEHDC]((https://github.com/m-spr/RCEHDC)) 
- I need to add them later. please contact me meanwhile if I still didn't update the repositori [email](https://github.com/m-spr/RCEHDC)


Citation
------------
If you find this work useful, please cite the following paper:
(Currently accepted and waiting for publication)
```
@inproceedings{roodsari2025Non,
  title={MF-ECC: Memory-Free Error Correction for Hyperdimensional Computing Edge Accelerators},
  author={Roodsari, Mahboobe Sadeghipour and Mayahinia, Mahta and Tahoori, Mehdi},
  booktitle={2026 31st Asia and South Pacific Design Automation Conferenc(ASP-DAC 2026)},
  year={2026},
  organization={IEEE}
}
```
----

## Repository layout
- `python/` —  Offline processing (generate indices, reorder CHVs, auto-emit HDL).
- `hardware/` — VHDL codes including: trigger index ROM, ECC decoder, CHV memory wrapper, and QHV rewiring.
- `images/` — figures reproduced from experiments.
