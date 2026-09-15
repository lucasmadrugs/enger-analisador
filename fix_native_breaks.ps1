$content = Get-Content -Path "index (1).html" -Raw -Encoding UTF8

# 1. Update handleGeneratePDF options
$content = $content -replace "pagebreak: \{ mode: \['css', 'legacy'\], before: '\.nova-pagina' \}", "pagebreak: { mode: ['css', 'legacy'] }"

# 2. Remove className="nova-pagina"
$content = $content -replace 'className="nova-pagina" ', ""

# 3. Insert html2pdf__page-break div between pages
# We identify the start of pages 2-8 by this string:
$pageStart = "<div style={{ width: '794px', minHeight: '1123px', background: '#0f172a'"
$breakDiv = "<div className=`"html2pdf__page-break`" style={{ height: '0px', clear: 'both', pageBreakAfter: 'always' }}></div>`r`n                                "
$content = $content -replace [regex]::Escape($pageStart), ($breakDiv + $pageStart)

Set-Content -Path "index (1).html" -Value $content -Encoding UTF8
Write-Output "Native page breaks added."
