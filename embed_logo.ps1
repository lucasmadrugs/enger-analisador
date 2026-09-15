$htmlPath = "index (1).html"
$imgPath = "C:\Users\lucas\.gemini\antigravity\brain\20302ba1-598a-4049-be40-2956534e339d\.user_uploaded\media_1788615188986.png"

$base64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes($imgPath))
$dataUri = "data:image/png;base64,$base64"

$content = Get-Content -Path $htmlPath -Raw -Encoding UTF8
$content = $content.Replace('<img src="./Símbolo Branco (4).png"', "<img src=`"$dataUri`"")

Set-Content -Path $htmlPath -Value $content -Encoding UTF8
Write-Output "Image replaced successfully."
