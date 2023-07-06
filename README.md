# What is Trojan.BAT.PC-Optimizer-Pro?
As its name suggests, it is a batchfile trojan, pretending to be something while doing something else. It was my 2020 attempt at being funny after reading a lot about the funny "delete System32" joke and learning some batchfile.

The program will pretend to be a windows PC cleaning utility, scanning for unneeded files, and then prompting the user to delete them. This will result in the user unwittingly deleting their System32 folder, as an internet meme xD.

<sub>Also tbh this stupid project took way too much testing on VMs to finalize lol. And I also forgot my Win10 VM password so that is very nice 🙃</sub>
  
# Usage
To use the program, simply download the release, or repo. If you downloaded the repo, you have to "compile" the project yourself (you technically don't need to, but for pure aesthetic purposes, please do lol). This is detailed below. If you downloaded the repease, simply unzip and run the executable, allowing it administrator permissions when it requests it.

The program will load up a terminal and run several "tree" commands to make it look like it is scanning for unneeded files. In the meantime, there are supressed `takeown` and `icacls` commands that give the current user full control of the the System32 directory. Then, it will prompt the user to "remove" unneeded files, and as a result, silently remove the System32 directory. **This will FULLY BRICK the PC, and require a fresh reinstall of Windows to remedy. Use this program with caution.**

Funnily enough, Windows Defender actually registers this as a *severe* virus, named *Trojan:Win32/Wacatac.B!ml*, and the standard blue window of "are you sure you want to run this executable" also pops up (which you can continue to run the file by selecting *More Info → Run Anyways*). Kinda honored that a shitty batchfile program could be registered as a virus by Defender 😁.

## How to "Compile"
I've put all needed tools to properly set up/compile this project in the `/Tools/` folder. If you are going to compile it, please ideally make a new directory called `/Compiled/` in the root directory to match the `.gitignore` file lmao.

Make a copy of everything in the `/Source/` and `/Tools/` folders, and place them in the `/Compiled/` folder. Navigate into that folder (this will be our root folder now). Then, unzip all the zip archives  and delete the zips for less clutter. Now, there are 3 steps.

1. Decide if you want to include the warning notification in your compiled program. 
   - If not, completely remove the entire `WarningMessage` goto section within `PC Optimizer Pro.bat` that's located in the root directory, save the file, and delete the `Warning.vbs` file in the `/Assets/` folder.
   - If you do, decide if you want to encrypt the warning notification or not (I recommend you do for the sake of aesthetics). To encrypt it, simply move the `Encode.vbs` in the `/vba-to-vbe tool/` folder to the `/Assets/` folder. Drag the `Warning.vbs` file onto the `Encode.vbs` file. This will create a `Warning.vbe` file. Delete the `Warning.vbs` file, and the `Encode.vbs` file. Now, you can delete the `/vba-to-vbe tool/` folder. This leaves you with the `Warning.vbe` file in the `/Assets/` folder.<br><br>

2. Now, it's time to compile `PC Optimizer Pro.bat` in the root. Open this file up. If you chose to remove the warning notification, you should have already deleted the entire `WarningMessage` goto section. If you chose to encrypt the warning notification, edit the line `start "Warning.vbs" "./Assets/Warning.vbs"` to `start "Warning.vbe" "./Assets/Warning.vbe"` (I've written comments within the batchfile to explain stuff as well) and save the file. If you chose the not encrypt the warning notification, then do nothing to the batchfile. Now, navigate into `/bat-to-exe.zip/` and run the executable in there. Then, open `PC Optimizer Pro.bat` within it and click *Convert*. Save the resulting executable as `PC Optimizer Pro.exe` into the root, and delete the `/bat-to-exe.zip/` folder as well as `PC Optimizer Pro.bat`. This leaves you with the `PC Optimizer Pro.exe` file in the root.<br>

3. Lastly, to make the executable seem like a proper one, we need to add an icon, and have it run as administrator when clicked on. Navigate to `/ResourceHacker/` and run the executable inside. Load up `PC Optimizer Pro.exe`. Choose the "*Add Binary or Image Resource*" option, select `/Assets/computer.ico`, add it, and save the executable. This creates an executable with an icon, and a `PC Optimizer Pro_original.exe`. Delete the latter file (without closing Resource Hacker). Now, go back to Resource Hacker and open the "*Manifest*" resource, and click on the "*1 : 0*" file. This is the executable manifest. We need to add a code snippet to this so that the executable will always request administrator permissions when run. Right before the final closing `</assembly>` tag in the xml, add the following code snippet: <br><br>
`<!-- Added requestedExecutionLevel for administrative privileges -->` \
`<trustInfo xmlns="urn:schemas-microsoft-com:asm.v3">` \
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`<security>` \
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`<requestedPrivileges>` \
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`<requestedExecutionLevel level="requireAdministrator" />` \
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`</requestedPrivileges>` \
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;`</security>` \
`</trustInfo>` <br><br>
After you add it, click on "*Compile Script*" (green play button) this time, and then save the executable. Now, you can close Resource Hacker, as well as delete both the `/ResourceHacker/` dir and the `PC Optimizer Pro_original.exe` file (that's generated for the second time). This leaves you with the final `PC Optimizer Pro.exe` file in the root.

Congratulations! You have just """compiled""" Trojan.BAT.PC-Optimizer-Pro ("compiled" put in a very, very, loose way lmao, for obvious reasons)! :) Depending on your choices, you should either have a standalone executable, or an executable with an `/Assets/` folder that contains a vbs or vbe file. Running the executable will run the trojan.

## Dependencies
This program uses the command prompt and VBScript, so on the computer running it, both the visual basic script hosts and the command prompt must be present...

<sub>which is literally every default windows installation xD shush<sub>

# Disclaimers
I **DID NOT** write the tools used to compile within the `/Tools/` folder in this repo. The authors, credits, and copyrights to these tools are all included within the zip archives.  

**This program is purely made for EDUCATIONAL PURPOSES, with the assumption that the execution of the program will only be ran in a CONTROLLED TESTING ENVIRONMENT only!**. I do ***NOT*** enourage people to use this program on their own computers, much less computers that other people own. Using malware or any form of harmful software, including joke programs, on your own or others' computers, whether with or without consent, is **strictly prohibited** due to the potential for *severe and unintended consequences*.
