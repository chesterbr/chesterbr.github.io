---
title: Convertendo vários arquivos de um encoding para outro
layout: post
comments: true
permalink: /archives/2009/10/convertendo-varios-arquivos-de-um-encoding-para-outro.html
onswipe_thumb:
  - SKIP
dsq_thread_id:
  - 1751445010
categories:
---
Devem haver maneiras melhores de converter todos os arquivos numa pasta de um encoding para outro (no caso, MacRoman para UTF-8), mas essa funcionou, e achei por bem anotar/compartilhar:

> `find . -type f | xargs -I {} sh -c 'iconv -f MACROMAN -t UTF-8 {} > {}.converted_from_iconv'; find . -type f | grep -v converted_from_iconv | xargs -I {} mv {}.converted_from_iconv {}`

Funcionou no Mac OS X, e deve rodar bem em Linux/Cygwin também.