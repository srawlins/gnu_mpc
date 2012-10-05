.PHONY : manual
manual: manual.pdf manual.html

manual.latex: manual.md
	gpp -T manual.md |pandoc --template manual_template.latex -o manual.latex

manual.pdf: manual.md
	gpp -T manual.md |pandoc --template manual_template.latex -o manual.pdf

manual.html: manual.md
	gpp -T -DHTML manual.md |pandoc --mathjax -o manual.html

