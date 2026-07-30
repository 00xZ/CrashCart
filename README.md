<div align="center">

# 🚑 CrashCart

**When Windows won't boot, CrashCart pulls the patient's data out before you fix (or nuke) the OS — then puts it right back in.**

Built because "just back up the user profile real quick" should not require a 45-minute fight with Windows.

![Platform](https://img.shields.io/badge/platform-Windows%2010%20%7C%2011-0078D6?logo=windows&logoColor=white)
![Shell](https://img.shields.io/badge/shell-Batch%20Script-4EAA25?logo=gnu-bash&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)
![Status](https://img.shields.io/badge/status-active-brightgreen)

</div>

---

## 📖 Table of Contents

- [What's Included](#-whats-included)
- [The Scenario](#-the-scenario)
- [Requirements](#-requirements)
- [What Gets Rescued](#-what-gets-rescued)
- [Usage — Extraction](#-usage--extraction-usersyncbat)
- [Usage — Restoration](#-usage--restoration-userrestorebat)
- [⚠️ Important Notes & Warnings](#️-important-notes--warnings)
- [License](#-license)

---

## 📦 What's Included

| Script | Purpose |
|---|---|
| `UserSync.bat` | The extraction. Boots on a working machine with the corrupted drive attached, scans it for user profiles, and pulls the data off to safety. |
| `UserRestore.bat` | The reunion. Once Windows is fixed or reinstalled, puts the patient's files back where they belong. |

---

## 🩺 The Scenario

Windows is corrupted. Won't boot. Repair options are shrugging at you. The fix is a reinstall — but the customer's entire digital life is still sitting on that drive.

CrashCart exists for exactly that moment: pull the drive, connect it to a working PC, run `UserSync.bat`, grab everything that matters, then fix or reimage the broken install. Once it's healthy again, `UserRestore.bat` puts everything back like nothing happened.

No wizards. No "Windows Easy Transfer" nonsense. Just the data, extracted and returned.

---

## ✅ Requirements

- 🖥️ A working Windows 10/11 machine to run CrashCart from
- 🔌 The corrupted drive connected as a secondary disk (USB enclosure, SATA-to-USB adapter, etc.)
- 🔑 **Must be run as Administrator** (needed to read other users' profile folders, and for Wi-Fi profile export)
- 💾 Enough free space at the destination to hold the extracted data

---

## 🧳 What Gets Rescued

For each user profile found on the patient drive, CrashCart pulls (where present):

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

</details>

> System accounts (`Public`, `Default`, `Default User`, `All Users`, `defaultuser0`) are automatically skipped — no point resuscitating profiles that were never really "alive."

---

## 🔄 Usage — Extraction (`UserSync.bat`)

1. Connect the corrupted drive to a working PC.
2. Right-click `UserSync.bat` → **Run as administrator**.
3. Enter the **drive letter** of the corrupted disk (e.g. `D`).
   - 🔒 If the drive is BitLocker-encrypted, CrashCart will detect it and prompt for the 48-digit recovery key to unlock it.
4. Choose where to save the extracted data:
   - **[1] Desktop** — creates a named folder on your current Desktop
   - **[2] Another Drive** — specify a destination drive letter and folder name
5. CrashCart loops through every user profile on the patient drive, shows an estimated size, and pulls each category of data with progress shown as `[step/total]`.
6. When finished, you'll get a completion screen with the path to the rescued data. ✅

Once extraction is done, you're clear to reimage, repair, or reinstall Windows on the original drive.

---

## ♻️ Usage — Restoration (`UserRestore.bat`)

1. On the now-healthy Windows install, right-click `UserRestore.bat` → **Run as administrator**.
2. Choose where the extracted backup is located:
   - **[1] Desktop** — lists backup folders found on your Desktop
   - **[2] Another Drive** — enter the drive letter and pick from the list
3. Confirm the backup you selected.
4. CrashCart restores each rescued profile to `C:\Users\<username>\`, creating the user folder if it doesn't already exist.
5. 🔁 **Restart Windows** once the restore completes so account/profile changes take effect properly.

Patient's data, fully resuscitated.

---

## ⚠️ Important Notes & Warnings

> [!WARNING]
> **This is a file copy, not a full profile restore.** It does *not* migrate registry hives, so program settings tied to the registry, user SIDs, or Windows account credentials are **not** restored — only file-based data. You'll still need to create matching local/Microsoft accounts with the same usernames on the destination machine for folder ownership/permissions to line up cleanly.

> [!CAUTION]
> **BitLocker recovery keys and Wi-Fi passwords are handled in plain text.** The recovery key is typed directly into the console, and exported Wi-Fi profiles include saved passwords in cleartext XML files. Treat extracted backups as sensitive and store them securely (encrypted drive, private location).

- 🔗 **Junction points are excluded** (`/XJ` flag on robocopy) to avoid infinite loops from folders like `AppData\Local\Application Data`.
- 🌐 Browser data is copied as-is — for a clean extraction, avoid running browsers on the patient drive beforehand if possible.
- 📊 Large profiles (especially with big `AppData`, OneDrive caches, or Minecraft worlds) can make extraction slow and large — check the estimated size shown before letting it run unattended.
- 🛡️ Run an antivirus scan on the patient drive before extraction if you're not sure of its history — no sense saving the malware along with the vacation photos.

---

## 📄 License

Add your preferred license here (e.g. MIT).

<div align="center">

No wizard required. Just a cart, a crash, and a plan. 🚑

</div>
