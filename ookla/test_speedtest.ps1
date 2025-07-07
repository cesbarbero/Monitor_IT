# Ruta del ejecutable Ookla
$exe = "C:\ookla\speedtest.exe"

# Ruta del log de salida
$log = "C:\ookla\resultados.csv"

# Ejecutar speedtest y parsear JSON
$jsonRaw = & $exe -f json
$json = $jsonRaw | ConvertFrom-Json

# Extraer datos del JSON
$timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
$ping = [math]::Round($json.ping.latency, 2)
$downloadMbps = [math]::Round(($json.download.bandwidth * 8) / 1MB, 2)
$uploadMbps = [math]::Round(($json.upload.bandwidth * 8) / 1MB, 2)
$serverName = $json.server.name
$serverLocation = "$($json.server.location), $($json.server.country)"
$ip = $json.interface.externalIp

# Crear encabezado si no existe
if (!(Test-Path $log)) {
    "FechaHora,IP Publica,Latencia(ms),Bajada(Mbps),Subida(Mbps),Servidor,Ubicacion" | Out-File -FilePath $log -Encoding utf8
}

# Armar línea CSV, con servidor y ubicación entre comillas para evitar problemas con comas
$line = "$timestamp,$ip,$ping,$downloadMbps,$uploadMbps,""$serverName"",""$serverLocation"""

# Guardar en CSV
$line | Out-File -FilePath $log -Append -Encoding utf8
