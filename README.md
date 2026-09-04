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

| No. | Problems | Hosted | Freestanding |
|:---:|:---:|:---:|:---:|
| 1 | Just a hello world | X | X |
| 2 | Take two integers as input and compare their sum to a predefined third integer, print the comparison | X | _ |
| 3 | Take arbitrary number of command line arguments and print them in order | X | _ |
| 4 | Take four integers as command line arguments and compare sum of each pair with each other, print the comparison | X | _ |
| 6 | Take a string (length limit = 256) from stdin, reverse it, and print the result | _ | _ |
| 7 | Take one string (length limit = 256) from stdin, one from command line argument, concatenate them, store the result, and print the stored result | _ | _ |
