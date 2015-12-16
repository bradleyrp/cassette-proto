#!/usr/bin/python

import os,sys,glob,re

ltype = ['ol','ul'][-1]

html = ["""<link rel="stylesheet" href="./cas/sources/main.css" type="text/css"/>"""]
html += ["<title>drafts</title><body>"]
html += ["""<div id="wrapper"><div id="main_content"><h1>drafts</h1>"""]
if 0: html += ["""<a style="color: black;" href="../index.html">back to main page</a>"""]
if 0: html += ["""<a href="javascript:history.go(-1)" style="color:black;">return</a>"""]
html += ["""<div class="article_text">"""]

html += ["<h3>HTML</h3><%s>"%ltype]
fns = glob.glob('*.html')
if 'index.html' in fns: fns.remove('index.html')
for fn in fns: html += ["<li><a href=%s>%s</a></li>"%(fn,re.findall('^(.+)\.html',fn)[0])]
html += ["</%s>"%ltype]

fns = glob.glob('*.pdf')
if any(fns):
	html += ["<h3>PDF</h3><%s>"%ltype]
	fns = glob.glob('*.pdf')
	for fn in fns: html += ["<li><a href=%s>%s</a></li>"%(fn,re.findall('^(.+)\.pdf',fn)[0])]
	html += ["</%s>"%ltype]

html += ["</div></div></body>"]

with open('index.html','w') as fp:
	for line in html: fp.write(line+'\n')
