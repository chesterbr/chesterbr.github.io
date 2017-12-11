---
title: Minificação automática de JavaScript no Eclipse
layout: post
comments: true
permalink: /archives/2010/05/minificacao-automatica-de-javascript-no-eclipse.html/
onswipe_thumb:
  - '//chester.me/wp-content/plugins/onswipe/thumb/thumb.php?src=//chester.me/wp-content/uploads/2010/05/builder.png&amp;w=600&amp;h=800&amp;zc=1&amp;q=75&amp;f=0'
categories:
---
*Esse post mostra como configurar o Eclipse/Aptana para gerar uma versão compacta e unificada dos .js do seu projeto sempre que você salvar um deles &#8211; um lance que eu tentei [explicar em 140 caracteres][1], mas [não deu muito certo][2]&#8230;*

<!--more-->

* * *

Foi-se o tempo em que a interface de uma aplicação web se resumia a um punhado de páginas web. Em muitos contextos, você vai lançar mão de diversas bibliotecas e plugins, bem como escrever seus próprios módulos de código JavaScript.

O problema que isso acarreta é que as chamadas necessárias para carregar isso tudo aumentam o tempo geral de carga da sua página. Pior ainda: uma dessas chamadas pode segurar o carregamento do restante da página, atrasando todo o processo. Era o que rolava no meu [último projeto][3], e o [ricbit][4] me chamou a atenção para o fato.

Uma solução geral que minimiza esse problema é colocar os scripts indispensáveis para a exibição inicial da página (e apenas eles) dentro do seu próprio servidor, [minificá-los][5] (i.e., reduzir o tamanho sem alterar a funcionalidade) e juntá-los num arquivo só &#8211; que o seu servidor, bem configurado, deve servir [comprimido][6].

Só que fazer isso &#8220;na mão&#8221; toda hora é muito chato. É possível ter uma [página dinâmica que executa essa tarefa][7], e outra idéia é inserir o procedimento no processo de build (se houver um). Ambas funcionam, mas a primeira gera uma preocupação adicional com cache (num conteúdo que até então era estático), e a segunda tira o dinamismo de salvar e testar imediatamente.

Eu precisava de um caminho intermediário, para o qual não escaparia de criar um script que automatiza o trabalho. Como já estava com a &#8220;mão suja de graxa Python&#8221;, eu chamei [esse][8] port do [JsMin][9] num [script bem simples][10], e troquei no HTML vários scripts externos por um só, que carrega em paralelo com outros elementos da página, reduzindo bastante o tempo de carga inicial.

*(Isso **não** é regra. Nunca assuma, sempre meça. Existem ótimas ferramentas para fazer isso, sendo as minhas prediletas a aba *net* do [Firebug][11] e sua equivalente embutida no menu &#8220;Developer&#8221; do Chrome.)*

A questão é: quando chamar esse script? Idealmente, eu queria que ele rodasse quando eu salvasse um dos scripts envolvidos (e **só** quando eu fizesse isso). Felizmente o Eclipse/Aptana possibilita isso, e é fácil:

1.  Certifique-se de que o seu script funciona na linha de comando;
2.  Com o botão direito na pasta do projeto, escolha *Properties*;
3.  Selecione *Builders* no menu da esquerda;
4.  Clique em *New*, selecione o tipo *Program* e dê *Ok*;
5.  Na aba *Main*, especifique o script no campo *Location* e o diretório onde ele vai rodar (*Working Directory*);
6.  Em *Build Options*, deixei as opções conforme o screenshot abaixo (clique para ampliar):

<p style="text-align: center;">
  <a href="//chester.me/wp-content/uploads/2010/05/builder.png"><img class="size-medium wp-image-3984  aligncenter" title="Opções do Builder (clique para ampliar)" src="//chester.me/wp-content/uploads/2010/05/builder-300x245.png" alt="Opções do Builder (clique para ampliar)" width="300" height="245" /></a>
</p>

O pulo-do-gato (alguém ainda fala isso?) é acionar o *Specify working set of relevant resources*, e, usando o botão ao lado, marcar **apenas** os scripts que serão colados/minificados &#8211; caso contrário ele vai ficar rodando o script o tempo todo.

Se você fizer direitinho, sempre que salvar um script ou der um clean, build, etc., o minificador vai rodar em background, e você vai poder testar no browser imediatamente, como fazia antes dessa brincadeira toda. Pra mim foi uma mão na roda, e espero que para você também seja!

 [1]: http://twitter.com/chesterbr/statuses/14963168347
 [2]: http://twitter.com/leomeloxp/statuses/14965109213
 [3]: http://cruzalinhas.com
 [4]: http://blog.ricbit.com/
 [5]: http://en.wikipedia.org/wiki/Minification_%28programming%29
 [6]: http://en.wikipedia.org/wiki/HTTP_compression
 [7]: http://www.ataraxia.com.br/posts/otimizacao-em-php-parte-1-minify
 [8]: http://stackoverflow.com/questions/1199470/combine-javascript-files-at-deployment-in-python/1905612#1905612
 [9]: http://www.crockford.com/javascript/jsmin.html
 [10]: https://github.com/chesterbr/cruzalinhas/blob/master/src/aux/build_all_scripts.py
 [11]: http://getfirebug.com/
