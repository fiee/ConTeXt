#!/usr/bin/env python3
import yaml
from pprint import pprint
"""
Convert FontAwesome’s icons.yml into
a symbol file for ConTeXt
"""

HEAD = """
% \definefontsynonym [FA5brands] [file:Font Awesome 5 Brands-Regular-400.otf]
% \definefontsynonym [FA5regular] [file:Font Awesome 5 Free-Regular-400.otf]
% \definefontsynonym [FA5solid] [file:Font Awesome 5 Free-Solid-900.otf]
\definefontsynonym [FA5brands] [name:fontawesome5brandsregular]
\definefontsynonym [FA5regular] [name:fontawesome5freeregular]
\definefontsynonym [FA5solid] [name:fontawesome5freesolid]

\\def\\FAhsym#1#2{\\getglyphstyled{FA5#1}{\\tochar{x:#2}}}
\\def\\FAnsym#1#2{\\getnamedglyphdirect{FA5#1}{#2}}
"""

TAIL = """
"""

symbols = {
    'brands' : {},
    'solid' : {},
    'regular' : {},
}

with open('icons.yml', 'r') as yfile:
    data = yaml.safe_load(yfile)

for key, sym in data.items():
    sym['tex'] = {}
    for style in sym['styles']:
        sym['tex'][style] = '\t\\definesymbol[%s]\t[\\FAnsym{%s}{%s}]\t%% %s (%s)\n' % (key, style, key, sym['label'], sym['unicode'])
        symbols[style][key] = sym

with open('symb-awesome5.mkiv', 'w') as texfile:
    texfile.write(HEAD)
    for style, syms in symbols.items():
        texfile.write('\n\\startsymbolset[awesome5-%s]\n' % style)
        for key, sym in syms.items():
            texfile.write(sym['tex'][style])
        texfile.write('\\stopsymbolset\n')
    texfile.write(TAIL)
