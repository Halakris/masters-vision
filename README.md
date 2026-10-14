# Masters-Vision: Indoor Navigation System

## Project Overview
This project aims to develop an autonomous indoor navigation system using computer vision as a proof of concept for a "welcoming robot". The system achieves spatial awareness in GPS-challenged indoor environments.

## Problem Statement
GNSS positioning (GPS) degrades significantly indoors due to building materials like concrete and steel attenuating satellite signals by 20-30 dB or more. Indoor environments require higher relative accuracy for navigation through confined spaces and multi-level buildings. This project explores computer vision-based methods for indoor localization and mapping without relying on external satellite signals.

## Goals
- Develop computer vision-based indoor navigation system
- Achieve localization and mapping in GPS-challenged environments
- Enable autonomous navigation through large buildings (universities, airports, hospitals)
- Proof of concept for "welcoming robot" capabilities

## Project Structure
- `src/` - Source code directory
- `data/` - Dataset and sensor data
- `notebooks/` - Jupyter notebooks for exploration
- `tests/` - Unit and integration tests

## Setup

### Prerequisites
- Python 3.8+
- pip package manager

### Installation
1. Clone the repository
2. Create a virtual environment:
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

### Configuration
- See `.env` file for configuration settings (not tracked in git)

## Git Ignore
Standard Python virtual environment and distribution files are excluded.

---
*This is a proof of concept for indoor vision-based wayfinding capabilities.*