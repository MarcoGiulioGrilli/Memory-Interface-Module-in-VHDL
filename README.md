# Memory Interface Module in VHDL  

This project implements a **VHDL-based hardware module** designed to interface with a memory system. It retrieves data from memory and routes it to an output channel based on a received serial input.

## 📌 Project Overview  
The module processes an input stream where:  
- The **first two bits** select one of the four available output channels.  
- The **remaining bits (0 to 16)** represent the memory address to be accessed.  
- Upon reading the memory data (7-bit value), it is routed to the selected channel.  

The entire operation is synchronized with a clock signal, ensuring correct timing for data processing and output.

## ⚙️ Implementation  
The module is implemented using a **Finite State Machine (FSM)** with sequential execution, ensuring efficient and structured data flow:  
1. **START** – Initializes values and waits for input.  
2. **SELECTION** – Reads the selection bits to determine the output channel.  
3. **READ MEMORY** – Accesses memory based on the received address.  
4. **DEMULTIPLEXING** – Routes the retrieved value to the correct output.  
5. **DONE** – Resets outputs and prepares for the next execution cycle.  

## 🛠 Testing & Validation  
The module has been thoroughly tested using **test benches and Python scripts** to generate random test cases. It has successfully passed all pre-synthesis and post-synthesis tests, ensuring robustness under different conditions, including reset scenarios and corner cases.

## 📄 Files Included  
📌 **VHDL Source Code** – The complete VHDL implementation of the memory interface module.  
📄 **Project Report** – A detailed document explaining the project requirements, implementation, FSM design, testing process, and synthesis results.  

## 📊 Synthesis Report  
- **LUTs used:** 89  
- **Flip-Flops used:** 103  
- **Timing Constraints:** Fully met  

## 📢 Conclusion  
This project was developed to meet specific functional requirements, leveraging **VHDL’s low-level hardware control**. Extensive testing and synthesis validation have ensured a reliable and optimized implementation.  
