
# native modules
$src = ".\.venv\Lib\site-packages\freetoken\kernel"
$dst = ".\src\FreeToken\python\freetoken\kernel"

Copy-Item "$src\_cpu_moe*.pyd"       $dst -Force
Copy-Item "$src\_pinned_tensor*.pyd" $dst -Force
Copy-Item "$src\_ple_store*.pyd"     $dst -Force

# dependency patches
$site = ".\.venv\Lib\site-packages"

Get-ChildItem ".\patches\*.patch" | Sort-Object Name | ForEach-Object {
    git -C $site apply --check $_.FullName 2>$null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "apply: $($_.Name)"
        git -C $site apply $_.FullName
    } else {
        git -C $site apply --reverse --check $_.FullName 2>$null

        if ($LASTEXITCODE -eq 0) {
            Write-Host "skip:  $($_.Name)"
        } else {
            throw "patch failed: $($_.Name)"
        }
    }
}
