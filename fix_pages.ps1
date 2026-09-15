$content = Get-Content -Path "index (1).html" -Raw -Encoding UTF8

$content = $content -replace "pagebreak: \{ mode: 'css', before: '.pdf-page-break' \}", "pagebreak: { mode: ['css', 'legacy'], before: '.nova-pagina' }"
$content = $content -replace '\s*<div className="pdf-page-break"></div>\s*', "`r`n`r`n"
$content = $content -replace "<div style=\{\{ width: '794px', height: '1123px', background: 'linear-gradient", "<div style={{ width: '794px', minHeight: '1123px', background: 'linear-gradient"
$content = $content -replace "<div style=\{\{ width: '794px', height: '1123px', background: '#0f172a'", "<div className=`"nova-pagina`" style={{ width: '794px', minHeight: '1123px', background: '#0f172a'"

Set-Content -Path "index (1).html" -Value $content -Encoding UTF8
Write-Output "Pages fixed successfully."
