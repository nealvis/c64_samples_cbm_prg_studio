# c64_samples_cbm_prg_studio
This is a repository of Commodore 64 sample code.  Each directory usually contains a small example program demonstrating just one or a few concepts. CBM Prg Studio is used within Windows to build a .prg or .d64 file from the source code.  The CBM Prg Studio project file will be included in each directory as appropriate.  These programs built with CBM Prg Studio can be executed/tested on the VICE C64 emulator running on Windows.

# Setup
To setup a development environment to build and run these sampes follow the following steps

- Install CBM Prg Studio.  This is an IDE specifically for building C64 code (as well as other 8 bit 6502 based platforms)
  - Download the released version here: https://www.ajordison.co.uk/
  - I used version: 3.14.1 BETA 1 which seems to do a better job calling the c64 emulator.  
    Download link: http://www.mediafire.com/file/rjn8mxb0m34zs84/file
- Install the VICE C64 emulator 
  - Download the latest version here: https://vice-emu.sourceforge.io/
  - I used version 3.5

- The first time you run CBM Program Studio you will want to set two settings via Tools->Options on the menu
  - Under "Project" you'll want to set the Default Location setting to the directory in which you'll want your projects created
  - Under "Emulator Control" you'll want to set the Emulator and Path setting the x64sc.exe file in your VICE installation.  It will be in the bin directory.

- Now you should be ready to try the samples in this repository.

- Clone the repository, Open CBM Prg Studio, open one of the project files like hello/hello.cbmprj, then hit the Generate and Launch button in the IDE to run the program in VICE.  
**Note:** if the asssembly dump file opens when you hit Generate and Launch, just close it and then the program should run in the emulator.
