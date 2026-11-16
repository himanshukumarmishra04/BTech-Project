@echo off
echo =====================================================================
echo  Stopping MarketPulse Local Processes (Ports 8000 and 8501)
echo =====================================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ports = @(8000, 8501); $found = $false; foreach ($p in $ports) { $conns = Get-NetTCPConnection -LocalPort $p -ErrorAction SilentlyContinue; if ($conns) { $found = $true; $pids = $conns | Select-Object -ExpandProperty OwningProcess -Unique; foreach ($procId in $pids) { Write-Host ('Stopping process on Port ' + $p + ' (PID: ' + $procId + ')...'); Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue } } }; if (-not $found) { Write-Host 'No active MarketPulse processes detected on ports 8000 or 8501.' } else { Write-Host 'MarketPulse processes stopped successfully.' }"

echo.
echo =====================================================================
pause
