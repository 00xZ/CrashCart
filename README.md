<div align="center">

# 🚑 CrashCart

**When Windows won't boot, CrashCart pulls the user's data out before you fix (or nuke) the OS — then puts it right back in.**

_Inspired by laziness built from spite_




</div>

---

## 📖 Table of Contents

- [What's Included](#-whats-included)
- [The Scenario](#-the-scenario)
- [Requirements](#-requirements)
- [What Gets Rescued](#-what-gets-rescued)
- [Usage — Extraction](#-usage--extraction-usersyncbat)
- [Usage — Restoration](#usage---restoration-userrestorebat)

---

## 📦 What's Included

| Script | Purpose |
|---|---|
| `UserSync.bat` | The extraction. Boots on a working machine with the corrupted drive attached, scans it for user profiles, and pulls the data off to safety. |
| `UserRestore.bat` | The reunion. Once Windows is fixed or reinstalled, puts the  user's files back where they belong. |

---

## 🩺 The Scenario

You all know the situation, windows wont boot. Grandpa read online that System23 had a virus in it. Its all good gramps we've all been there. Gramps cant lose his personal file's though. You know the run down. The fix is a reinstall but the Gramps entire digital life is still sitting on that drive.

CrashCart exists because i got tired of doing it by hand just for Gramps to come back asking for his 2011 Minecraft world. Here's how we can prevent that: pull the drive, connect it to a working PC, run `UserSync.bat`, grab everything that matters, then fix or reimage the broken install. Once it's healthy again, `UserRestore.bat` puts everything back like nothing happened.

No weird program's. No "Windows Easy Transfer" nonsense. Just the data, extracted and returned.

---

## ✅ Requirements

- 🖥️ A working Windows 10/11 machine to run CrashCart from
- 🔌 The corrupted drive connected as a secondary disk (USB enclosure, SATA-to-USB adapter, etc. you know this..)
- 🔑 **Must be run as Administrator** (needed to read other users' profile folders, and for Wi-Fi profile export)
- 💾 Enough free space at the destination to hold the extracted data

---

## 🧳 What Gets Rescued

For each user profile found on the users drive, CrashCart pulls (where present):

<details>
<summary><strong>Click to expand full list</strong></summary>

- 📁 Desktop, Documents, Downloads, Pictures, Videos, Music
- ⭐ Favorites, Saved Games, Contacts, Links, Searches
- ☁️ OneDrive folder
- ⚙️ AppData\Roaming (and relevant AppData\Local subfolders)
- 🌐 Browser profiles: Chrome, Edge, Firefox, Brave, Opera, Vivaldi
- 📧 Outlook data files and Outlook AppData
- 📶 Wi-Fi profiles (SSIDs + saved passwords, exported via `netsh`)
- 🔐 SSH keys (`.ssh` folder)
- 📝 Sticky Notes
- 🕘 Quick Access / Recent items
- 🔧 `.gitconfig`
- 🎮 `.minecraft` folder
- Feel free to give me more ideas
</details>

> System accounts (`Public`, `Default`, `Default User`, `All Users`, `defaultuser0`) are automatically skipped — no point resuscitating profiles that were never really "alive."

---

## 🔄 Usage — Extraction (`UserSync.bat`)

1. Connect the corrupted drive to a working PC.
2. Right-click `UserSync.bat` → **Run as administrator**.
3. Enter the **drive letter** of the corrupted disk (e.g. `D`).
   - 🔒 If the drive is BitLocker-encrypted, CrashCart will detect it and ask for the key (Good luck getting it thought bahahaha)
4. Choose where to save the extracted data:
   - **[1] Desktop** — creates a named folder on your current Desktop
   - **[2] Another Drive** — specify a destination drive letter AND folder name
5. CrashCart loops through every user profile on the patient drive, shows an estimated size, and pulls each category of data with progress shown as `[step/total]`.
6. When , itll give you the path to the rescued data. ✅

Once extraction is done, you're clear to reimage, repair, or reinstall Windows on the original drive.

---

## Usage - Restoration (UserRestore.bat)

1. On the now-healthy Windows install, right-click `UserRestore.bat` → **Run as administrator**.
2. Choose where the extracted backup is located:
   - **[1] Desktop** — lists backup folders found on your Desktop
   - **[2] Another Drive** — enter the drive letter and pick from the list
3. Confirm the backup you selected.
4. CrashCart restores each rescued profile to `C:\Users\<username>\`, creating the user folder if it doesn't already exist.
5. 🔁 **Restart Windows** once the restore completes so account/profile changes take effect properly.
6. Friendly remind Gramps not to touch System32.... dont worry youll see him next week :)

7. ---

## 🔄 Special Thanks To!

1. Me drinking too much coffee on my lunch break
2. **AI**... yeah AI; I couldve spent all week on StackOverFlow trying to make this but luckily that's a time of the past.
3. All the customers who are too picky for just a User file to be moved over..

---

 **I will be adding onto this as I learn more but feel free to pull request this.** 

**And remember, no matter how rude they are; its fraud upon to put a 3 week time-delayed zip bomb in the startup folder.!**
<p align="center">
  <b><i><span style="color:limegreen;">Eyezik ❤️</span></i></b><br><br><br>
</p>
---
