import re
import sys

with open('index (1).html', 'rb') as f:
    raw = f.read()

# Try multiple rounds of fixing double/triple UTF-8 encoding
content = raw
for attempt in range(3):
    try:
        decoded = content.decode('utf-8')
        # Try to re-encode as latin1 and decode as utf-8
        fixed = decoded.encode('latin-1').decode('utf-8')
        content = fixed.encode('utf-8')
        print(f"Round {attempt+1}: Fixed encoding layer")
    except (UnicodeDecodeError, UnicodeEncodeError):
        print(f"Round {attempt+1}: No more layers to fix")
        break

# Write the final result
final = content if isinstance(content, bytes) else content.encode('utf-8')
# Remove BOM if present
if final.startswith(b'\xef\xbb\xbf'):
    final = final[3:]
    
with open('index (1).html', 'wb') as f:
    f.write(final)

# Verify
with open('index (1).html', 'r', encoding='utf-8') as f:
    text = f.read()
    
# Check for common Portuguese words
test_words = ['Diagnóstico', 'geração', 'própria', 'ação', 'eficiência', 'Composição', 'Simulação']
found = 0
for word in test_words:
    if word in text:
        found += 1
        print(f"  OK: '{word}' found correctly")
    else:
        print(f"  MISSING: '{word}' not found")

print(f"\nResult: {found}/{len(test_words)} words verified")
