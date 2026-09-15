$c = [System.IO.File]::ReadAllText('index (1).html', [System.Text.Encoding]::UTF8)
$b = [System.Text.Encoding]::GetEncoding('ISO-8859-1').GetBytes($c)
$f = [System.Text.Encoding]::UTF8.GetString($b)
[System.IO.File]::WriteAllText('index (1).html', $f, (New-Object System.Text.UTF8Encoding $false))
Write-Host "Encoding fixed successfully"
