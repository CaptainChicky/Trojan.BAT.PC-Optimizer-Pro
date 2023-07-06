# What is Trojan.BAT.PC-Optimizer-Pro?
As its name suggests, it is a batchfile trojan, pretending to be something while doing something else. It was my 2020 attempt at being funny after reading a lot about the funny "delete System32" joke and learning some batchfile.

The program will pretend to be a windows PC cleaning utility, scanning for unneeded files, and then prompting the user to delete them. This will result in the user will unwittingly deleting their System32 folder, as an internet meme xD.
  
# Usage
To use the program, simply download the release, or repo. If you downloaded the repo, you have to "compile" the project yourself (you technically don't need to, but for pure aesthetic purposes, please do lol). This is detailed below. If you downloaded the repease, simply unzip and run the executable. 

The program will load up a terminal and run several "tree" commands to make it look like it is scanning for unneeded files. In the meantime, there are supressed `takeown` and `icacls` commands that give the current user full control



  <!-- Added requestedExecutionLevel for administrative privileges -->
  <trustInfo xmlns="urn:schemas-microsoft-com:asm.v3">
    <security>
      <requestedPrivileges>
        <requestedExecutionLevel level="requireAdministrator" />
      </requestedPrivileges>
    </security>
  </trustInfo>

  Trojan:Win32/Wacatac.B!ml
## How to "Compile"

## Dependencies
This program uses MS-DOS batch programming, along with Visual Basic. On a said computer, the Windows Command Prompt(cmd.exe) must be present, along with wscript.exe or cscript.exe to run the Visual Basic.

<sub>which is literally every default windows installation xD shush<sub>
# What this repository contains...
The repository has two folders:
  1) The "'Source' code" folder which contains the source code of the project. This includes the two batch files which are the "cleaning" utilities, and the "Assets" folder, which contain the preliminary warning that will open before running the destructive version, and the two icons which will be injected in the "compiled" batch executables.
  2) The "Compiled Project" folder which contains the compiled project. The two batch files have been "converted"(more like wrapped tbh) into executables. In the "Assets" folder, the warning which will pop up before running the destructive version of PC Optimizer Pro has been encoded into a .vbe file. The icons are still provided in the "Assets" folder. 
  
*Notice*: The uncompiled "destructive" batch file references to "Warning.vb**s**" in the code. The compiled "destructive" executable must reference to the encrypted warning "Warning.vb**e**" for the warning to correctly work. To solve this, one must change the warning local file link to the correct name before compiling, and then placing the correct compiled .vbe file in the correct directory(Assets). Although I have done such in the compiled folder, please note this when compiling this yourself(for whatever reason lol).

# Tools to compile the project...
***Disclaimer***: I **DID NOT** write these tools. The correct authors, credits, and reference links are availible to be read in the further readings of each folder in the "Tools-used-in-PC-Optimizer-Pro" repository. When referencing them or tools used in this repository, make sure to attribute correct credits to the correct authors, **NOT ME**.

If the links supplied in the author credits of the tools in the "Tools-used-in-PC-Optimizer-Pro" repository don't work(deleted from the internet), one can always use the internet archive(archive.org) assuming it has taken snapshots of said deleted page/link.



# Disclaimer!!!
Everything here in this repository has been made for educational purposes, with the more destructive aspects of it assumed to only be viewed and/or ran in a controlled testing environment only. I do ***NOT*** enourage people to do something like this themselves/to themselves. ***NEVER*** use malware, or anything that is, but no limited to, malware, anything remotely capable of destroying computers, or even "joke programs" *on your own or other people's computers*, not even with their consent, as this can have bad, unforeseen consequences.
