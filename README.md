# Assembly programming

## Contributors

- [Álvaro Marco](https://github.com/alvaro-marco)
- [Ramón Hernández](https://github.com/uRHL)

## Introduction

Assembly languages are the low-level programming languages that let us control the execution at register and byte-memory level. Although is not very intuitive for humans like high-level programming languages (Java, C++, Python...) for microprocessors is straight-forward to execute this code since they do not need to interpret it.


Assembly languages make direct use of the registers and operation codes, it depends completely on the microprocessor and its architecture. This project is focused on learning the basics of assembly thus we will use microprocessors with simple architecture (at most 32-bit). Those have a smaller instruction set and register bank than modern microprocessors, but to develop the mind-set for assembly programming they are good enough.


## Proyect 01

The goal is to develop a program to do matrix multiplications. The program will be executed in a [MIPS architecture microprocessor](https://en.wikipedia.org/wiki/MIPS_architecture), so we have to adapt the code to the registers and instruction set available in this architecture. A manual of this architecture can be found in the folder [docs](./docs). For more information check the corresponding [proyect folder](./pr01)



## Proyect 02

The goal is to develop our own instruction set for the [microprocessor Z80](https://en.wikipedia.org/wiki/Zilog_Z80), which has an 8-bit architecture. Those instructions can be interpreted by the simulator [WepSim](https://wepsim.github.io/). We will need to write a simple progrmam to test all those instructions. For more information check the corresponding [proyect folder](./pr02)
