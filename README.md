# pin

A CLI tool to pin, recall, run, edit, and manage shell commands — your own personal favorites list for the terminal.

Tired of losing good commands in the scrollback void? `pin` lets you save and reuse useful one-liners, history entries, and scripts with ease.

---

## 🛠 Installation

1. Copy `pin.sh` to somewhere in your `$PATH`, like `/usr/local/bin/` or `~/bin/`
2. Make it executable:

```bash
chmod +x /path/to/pin.sh
```

3. Optionally rename it:

```bash
mv pin.sh pin
```

---

## 📌 Usage

```bash
pin [options] [command]
```

### 🔧 Examples

| Command              | Description                               |
| -------------------- | ----------------------------------------- |
| `pin "echo hello"`   | Pin a raw command                         |
| `pin -- ls -l`       | Alternate syntax for raw command          |
| `pin -n 3`           | Pin line 3 of `.bash_history`             |
| `pin -n 3 -m "desc"` | Pin line 3 with a comment                 |
| `pin -n 10-12`       | Pin lines 10–12 from history              |
| `pin -s foo`         | Search pins for `foo`                     |
| `pin -l`             | List all pinned commands                  |
| `pin -u 15`          | Delete line 15 from pins                  |
| `pin -u 15-17`       | Delete lines 15–17                        |
| `pin -c 15`          | Copy line 15 to clipboard (needs `xclip`) |
| `pin -e 15`          | Open new shell with line 15 preloaded     |
| `pin --run 15`       | Execute pin #15 immediately               |

---

## 📂 Files Used

- `~/.bash_pins` – Stores your pinned commands
- `~/.bash_history` – Used when grabbing lines with `-n`

---

## 🧱 Dependencies

Most features work out-of-the-box, except:

- `-c` (clipboard) requires [`xclip`](https://github.com/astrand/xclip) on X11
- `-e` (edit) launches a new interactive Bash shell to preload the command

Wayland users: swap `xclip` for `wl-copy`.

---

## ⚠️ Notes

- `-e` opens a new Bash session and preloads the pin into the input prompt. You can edit and hit Enter to run.
- This tool is *not* a full shell history manager. It’s a **favorites list**, by design.

---

## 📜 License

See [LICENSE](./LICENSE)

---

## 🥘 Why?

Because sometimes `history | grep ssh` isn’t enough.

