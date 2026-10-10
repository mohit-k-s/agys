# agys — Antigravity Session Explorer ⚡

An interactive terminal browser, search tool, and session launcher for Google Antigravity CLI (`agy`).

---

## Why `agys`?

When working in the Antigravity CLI, jumping back into previous contexts can be tricky:
- `agy --continue` only resumes the *most recent* session.
- `agy --conversation <id>` requires knowing or manually copying the exact UUID.

**`agys`** solves this by providing a fast, interactive TUI and CLI toolkit to browse, search, inspect, and resume any past session.

---

## Features

- 🖥️ **Split-Screen Terminal UI**:
  - **Left pane**: Browse past sessions with auto-generated titles, message counts, and human-friendly timestamps (`2m ago`, `yesterday`).
  - **Right pane**: View conversation details, active workspace folders, artifacts generated, and the complete prompt history.
- 📜 **Full Transcript Viewer**:
  - Press `t` on any session to inspect the complete step-by-step turn history, including model reasoning, tool executions, and responses.
- 🔍 **Real-Time Fuzzy Filter**:
  - Press `/` to immediately filter sessions by title or ID as you type.
- 🚀 **1-Key Instant Resume**:
  - Press `Enter` on any selected conversation to launch straight into `agy --conversation <id>`.
- 📋 **Clipboard Integration**:
  - Press `c` to copy the conversation UUID or resume command to your clipboard.
- ⚡ **Scriptable CLI Mode**:
  - Quickly query session history from scripts or terminal one-liners (`list`, `show`, `search`, `resume`).
- 🪶 **Zero External Dependencies**:
  - Written entirely using the Python 3 standard library (`curses`, `sqlite3`, `json`, `subprocess`). No `pip install` or virtual environment needed.

---

## Requirements

- Python 3.8+
- macOS or Linux
- Google Antigravity CLI (`agy`) installed

---

## Installation

### Option 1: One-Shot Install Script (Quickest)

Run the automated installer directly:

```bash
curl -fsSL https://github.com/mohit-k-s/agys/raw/main/install.sh | bash
```

Or if you've already cloned the repository:

```bash
git clone https://github.com/mohit-k-s/agys.git
cd agys
./install.sh
```

The script will:
- Check for Python 3.8+ and verify `agy` presence
- Install `agys` to `~/.local/bin/agys`
- Validate your `$PATH` and provide instructions if not yet configured

---

### Option 2: Manual Symlink

```bash
git clone https://github.com/mohit-k-s/agys.git
cd agys
chmod +x agys
mkdir -p ~/.local/bin
ln -sf "$(pwd)/agys" ~/.local/bin/agys
```

### Option 3: System-Wide Install

```bash
sudo cp agys /usr/local/bin/agys
sudo chmod +x /usr/local/bin/agys
```

Verify the installation:
```bash
agys --help
```

---

## Usage

### 1. Interactive TUI Mode

Launch the interactive session browser:

```bash
agys
```

#### Keyboard Shortcuts

| Key | Action |
| :--- | :--- |
| `↑` / `k` | Move selection up |
| `↓` / `j` | Move selection down |
| `Enter` | **Resume session** in `agy` |
| `t` | **View full transcript** |
| `/` | Filter sessions by title/ID |
| `c` | Copy session ID to clipboard |
| `r` | Refresh session list |
| `q` / `Esc` | Quit |

#### Transcript Viewer Controls

| Key | Action |
| :--- | :--- |
| `↑` / `k` | Scroll up one line |
| `↓` / `j` | Scroll down one line |
| `Page Up` / `Page Down` | Scroll half-page |
| `g` / `G` | Jump to top / bottom |
| `q` / `Esc` | Return to session browser |

---

### 2. CLI Mode

If you prefer command-line queries without launching the TUI:

#### List all sessions
```bash
agys list
# or shorthand
agys ls
```

#### Inspect a session and its user prompts
```bash
agys show <conversation-id-or-prefix>
```

#### Search sessions by prompt or title keywords
```bash
agys search <keyword>
```

#### Resume a session by keyword or ID
```bash
agys resume <keyword>
```
*If a single session matches, it resumes immediately. If multiple sessions match, it opens the interactive picker with the filtered results.*

---

## How It Works

Antigravity stores CLI session history in the user application directory (`~/.gemini/antigravity-cli/`):
- `conversation_summaries.db`: SQLite database indexing conversation IDs, titles, timestamps, and step metrics.
- `brain/<id>/.system_generated/logs/transcript.jsonl`: Event streams recording every user prompt, assistant response, and tool execution.

`agys` reads directly from these local records, parses the prompt sequences and transcripts, and provides a streamlined interface on top of the native `agy` command.

---

## License

MIT
