$content = Get-Content -Path "index (1).html" -Raw -Encoding UTF8

# 1. Scripts replacement
$oldScript = '<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>'
$newScripts = '<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>' + "`r`n    " + '<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>'
$content = $content.Replace($oldScript, $newScripts)

# 2. Add pdf-page to Capa
$content = $content.Replace(
    "<div style={{ width: '794px', minHeight: '1123px', background: 'linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #0f172a 100%)'",
    "<div className=`"pdf-page`" style={{ width: '794px', minHeight: '1123px', background: 'linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #0f172a 100%)'"
)

# 2b. Add pdf-page to the other pages
$content = $content.Replace(
    "<div style={{ width: '794px', minHeight: '1123px', background: '#0f172a'",
    "<div className=`"pdf-page`" style={{ width: '794px', minHeight: '1123px', background: '#0f172a'"
)

# 3. Remove html2pdf__page-break
$content = $content -replace '\s*<div className="html2pdf__page-break" style=\{\{ height: ''0px'', clear: ''both'', pageBreakAfter: ''always'' \}\}></div>', ""

# 4. Replace handleGeneratePDF function
$oldFunction = @"
            const handleGeneratePDF = () => {
                if (!analysis) return;
                setIsGeneratingPDF(true);
                
                const element = document.getElementById('proposta-template');
                if (!element) {
                    setIsGeneratingPDF(false);
                    return;
                }

                const opt = {
                    margin: 0,
                    filename: `"Proposta_Comercial_ENGER_`$" + `{(formData.nomeCliente || analysis.concessionaria || 'cliente').replace(/\s+/g, '_')}.pdf`,
                    image: { type: 'jpeg', quality: 0.98 },
                    html2canvas: { scale: 2, useCORS: true, letterRendering: true, logging: false, backgroundColor: '#0f172a' },
                    jsPDF: { unit: 'mm', format: 'a4', orientation: 'portrait' },
                    pagebreak: { mode: ['css', 'legacy'] }
                };

                html2pdf().set(opt).from(element).save().then(() => {
                    setTimeout(() => setIsGeneratingPDF(false), 500);
                }).catch(() => {
                    setIsGeneratingPDF(false);
                });
            };
"@

$newFunction = @"
            const handleGeneratePDF = async () => {
                if (!analysis) return;
                setIsGeneratingPDF(true);
                
                try {
                    const { jsPDF } = window.jspdf;
                    const pdf = new jsPDF('p', 'mm', 'a4');
                    const pages = document.querySelectorAll('.pdf-page');
                    
                    if (pages.length === 0) {
                        setIsGeneratingPDF(false);
                        return;
                    }
                    
                    for (let i = 0; i < pages.length; i++) {
                        const page = pages[i];
                        const canvas = await html2canvas(page, { 
                            scale: 2, 
                            useCORS: true, 
                            backgroundColor: '#0f172a',
                            logging: false
                        });
                        
                        const imgData = canvas.toDataURL('image/jpeg', 0.98);
                        pdf.addImage(imgData, 'JPEG', 0, 0, 210, 297);
                        
                        if (i < pages.length - 1) {
                            pdf.addPage();
                        }
                    }
                    
                    const filename = `"Proposta_Comercial_ENGER_`$" + `{(formData.nomeCliente || analysis.concessionaria || 'cliente').replace(/\s+/g, '_')}.pdf`;
                    pdf.save(filename);
                    
                } catch (error) {
                    console.error("Erro ao gerar PDF:", error);
                } finally {
                    setTimeout(() => setIsGeneratingPDF(false), 500);
                }
            };
"@

$content = $content.Replace($oldFunction, $newFunction)

Set-Content -Path "index (1).html" -Value $content -Encoding UTF8
Write-Output "PDF engine updated successfully."
