# Función para esperar la conexión a internet
function Esperar-Conectividad {
    $timeout = 300  # 5 minutos en segundos
    $reintento = 0
    while ($reintento -lt $timeout) {
        try {
            # Hacer ping a 1.1.1.1 (Cloudflare) o usar Test-NetConnection
            $ping = Test-Connection -ComputerName 1.1.1.1 -Count 1 -Quiet -ErrorAction SilentlyContinue
            if ($ping) {
                Write-Host "Conexión establecida."
                return
            }
        } catch {}
        Start-Sleep -Seconds 5
        $reintento += 5
    }

    # Si no hay conexión luego de 5 minutos, seguir igual
    Write-Host "No se detectó conexión, continúa de todos modos."
}

# Esperar conectividad al inicio
Esperar-Conectividad

# Bucle infinito: ejecutar speedtest cada 1 hora
while ($true) {
    try {
        powershell.exe -ExecutionPolicy Bypass -File "C:\ookla\test_speedtest.ps1"
    } catch {
        Add-Content -Path "C:\ookla\log.txt" -Value "$(Get-Date): Error ejecutando el script - $_"
    }

    Start-Sleep -Seconds 3600  # Espera 1 hora
}
