# Asynchronous FIFO RTL-to-GDS Flow using Synopsys Tools

## Overview

This project implements and verifies an Asynchronous FIFO for safe data transfer between independent clock domains.

The complete ASIC implementation flow was performed using Synopsys EDA tools from RTL design through physical implementation.

## Key Features

- Dual Clock Asynchronous FIFO
- Gray Code Read/Write Pointers
- Full and Empty Flag Detection
- Two-Flop CDC Synchronizers
- RTL Verification
- Synthesis
- Floorplanning
- Placement
- CTS
- Routing
- Static Timing Analysis

## Tools Used

- Verilog HDL
- Synopsys VCS
- Synopsys Design Compiler
- Synopsys IC Compiler II
- Synopsys PrimeTime

## Design Flow

RTL → Simulation → Synthesis → Floorplan → Placement → CTS → Routing → STA → GDSII

## Project Structure

```text
rtl/
tb/
scripts/
images/
docs/
```

## Results

### Block Diagram

![Block Diagram](images/block_diagram.png)

### Simulation

![Simulation](images/simulation_waveform.png)

### Floorplan

![Floorplan](images/floorplan.png)

### Placement

![Placement](images/placement.png)

### Routing

![Routing](images/routing.png)

## Skills Demonstrated

- RTL Design
- Clock Domain Crossing (CDC)
- ASIC Design Flow
- Static Timing Analysis
- Design Verification
## Verification Strategy

- Functional verification of read/write operations
- Full and empty flag validation
- Simultaneous read/write testing
- Asynchronous clock testing
- CDC synchronization verification
- Corner-case analysis
