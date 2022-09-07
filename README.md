# ppc_hw
helloworld powerpc-app on qemu-e500


This is a minimal program that prints to the serial port.
A real program will have to do a lot more configuration.
Documentation and source code from a more complete processor 
setup can be found at Freescale, search for AN2551.

##CREDITS
* The program is based on a stripped version of the u-boot code,
  and the three header files in the inc folder have been copied from
  u-boot. A little hack was be done in processor.h (see AAA_HACK_DISABLE)
  to avoid having to include even more files .

* The file startup.S is essentially the same file as the file
  EclipseDemos/Juno/POWERPC/Freescale_MPC5554Demo/crt0.S
  From and archive at [macraigor](http://www.macraigor.com/gnu/hw_support_12.0.0_64-bit.exe)

* The file test.ld is adapted from an 
  [article](http://opensourceforu.efytimes.com/2011/07/qemu-for-embedded-systems-development-part-2/) 
  on bare metal arm on qemu.

##SYNOPSIS
  At startup, tlb1, entry0 is mapped and code is executed from it.
  However, it is only 4kB so in real use this code will have to 
  map more code into memory. Since entry0 is in use, entry1 is used
  for the ccsrbar mapping. 

###FILES:
* startup.S  -- sets the stackpointer and calls c_entry
* test.c     -- implements c_entry which maps the ccsrbar to
                be able to access the serial port.
                Then it prints a message to the serial port.


##INSTRUCTIONS

  Edit the makefile to set correct paths to the toolchain and qemu. 

  (You need to have a toolchain to cross-compile to ppc
  and an appropriate qemu-version. Instructions for these
  are forthcoming).
  
###Update for 22.04.1 LTS (Jammy Jellyfish)
makefile is optimized for gcc-11

###Usage:
*    `make`       -- compiles and links it.
*    `make run`   -- let qemu run the compiled binary  (exit with `C-a x`)
*    `make debug` -- start qemu, waiting for a gdb-connection.
*    `make dis_test`   -- dumps the assembler to stdout

*    attaching with gdb (inside emacs) --
 	  `/home/ara/gnutools-bin/powerpc-eabi/bin/powerpc-eabi-gdb -i=mi test.elf`
 	  in gdb: `target remote localhost:1234`



# How to connect with vscode to qemu (host) using gdb
```json
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
           "type": "gdb",
            "request": "attach",
            "name": "Attach to gdbserver",
            "target": "localhost:1234",
            "remote": true,
            "printCalls": true,
            "stopAtEntry": true,
            "stopAtConnect": true,
            "executable": "${workspaceFolder}/ppc/ppc_hw/test.elf",
            "cwd": "${workspaceRoot}/ppc/ppc_hw/",
            "gdbpath": "/usr/bin/gdb-multiarch",
            "autorun": [
                "set architecture powerpc:e500",
                "file /home/chuckufarley/Projctes/ppc/ppc_hw/test.elf"
            ]
        }
    ]
}
```
