# asman

The purpose of this repository is to solve various fundamental programming problems in assembly to have a better understanding of low-level internals. The problems would be extremely easy to solve in a high-level language. But to solve them in assembly, understanding of stack, CPU fundamentals, SysV ABI, linux syscall ABI etc would be unavoidable. The programs follow NASM intel syntax and divided into two categories:

- Hosted: Links to libc
- Freestanding: Syscall-based

# Targets

- x86_64 (linux)

# Dependencies

## Must to have:

- `nasm`: for assembling
- `gcc`: for linking hosted programs
- `gnu ld`: for linking freestanding programs

## Optional:

- `clang`: optional compiler
- `ld.lld`: optional linker
- `objdump`: for using `scripts/odmp` to dump binary

# Problems list

- [x] 1. Just a hello world.
- [ ] 2. Take two integers as input and compare their sum to a predefined third integer, print the comparison.
- [ ] 3. Take two integers as command line argument and compare their sum to a predefined third integer, print the comparison.
