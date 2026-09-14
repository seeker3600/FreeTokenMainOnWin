# FreeTokenOreore

Windows 上で FreeToken main を動かすための環境。

## Setup

```powershell
uv sync

git clone https://github.com/FlashML-org/FreeToken.git .\src\FreeToken

.\tools\prepare.ps1
```

FreeToken main の Python ソースを使う:

```powershell
$env:PYTHONPATH = (Resolve-Path .\src\FreeToken\python).Path
```

## Update

```powershell
git -C .\src\FreeToken pull
.\tools\prepare.ps1
```
