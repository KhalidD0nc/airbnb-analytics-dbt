---
description: How to activate the Python virtual environment (.venv)
---

To activate the virtual environment in your terminal:

1. **Mac/Linux**:
   ```bash
   source .venv/bin/activate
   ```

2. **Windows (Command Prompt)**:
   ```cmd
   .venv\Scripts\activate
   ```

3. **Windows (PowerShell)**:
   ```powershell
   .\.venv\Scripts\Activate.ps1
   ```

### Quick Check
// turbo
Run this to verify you are in the virtual environment:
```bash
which python
```
It should point to your project folder's `.venv/bin/python`.

### Automatic Activation (Recommended)
If you use VS Code, I have already updated your `.vscode/settings.json` to automatically use this environment for the Python extension and dbt.

If you want it to activate automatically in your shell whenever you enter this directory, you can install [direnv](https://direnv.net/) and create a `.envrc` file:
```bash
echo "layout python" > .envrc
direnv allow
```
