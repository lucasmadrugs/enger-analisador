import re

file_path = "index (1).html"
with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# 1. Update handleGeneratePDF options
content = content.replace(
    "pagebreak: { mode: 'css', before: '.pdf-page-break' }",
    "pagebreak: { mode: ['css', 'legacy'], before: '.nova-pagina' }"
)

# 2. Remove pdf-page-break
content = re.sub(r'\s*<div className="pdf-page-break"></div>\s*', '\n\n', content)

# 3. First page (Capa) - change height to minHeight
content = content.replace(
    "<div style={{ width: '794px', height: '1123px', background: 'linear-gradient",
    "<div style={{ width: '794px', minHeight: '1123px', background: 'linear-gradient"
)

# 4. Other pages (2-8) - add nova-pagina and change height to minHeight
content = content.replace(
    "<div style={{ width: '794px', height: '1123px', background: '#0f172a'",
    "<div className=\"nova-pagina\" style={{ width: '794px', minHeight: '1123px', background: '#0f172a'"
)

with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)
print("Pages fixed successfully.")
