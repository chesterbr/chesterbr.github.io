---
title: 'Harmony: rodando jogos (e testando programas) num Atari de verdade'
layout: post
comments: true
permalink: /archives/2011/11/harmony-rodando-jogos-e-testando-programas-num-atari-de-verdade.html/
robotsmeta:
  - index,follow
onswipe_thumb:
  - http://farm7.static.flickr.com/6037/6296967178_6e1753e599_m.jpg
dsq_thread_id:
  - 1751447829
categories:
---
[<img src="//farm7.static.flickr.com/6037/6296967178_6e1753e599_m.jpg" width="180" height="240" alt="Cartucho Harmony" style="float:left;margin:4px;border:1px solid black" />][1]A programação para Atari 2600 é uma curiosidade que já me levou a escrever [artigo][2] e minstrar [palestras][3] sobre o assunto. Vira e mexe estou lendo e experimentando, e até acredito que um dia alguma dessas brincadeiras pode se tornar um jogo de verdade.

Um bom emulador é necessário para programar para qualquer dispositivo, seja ele um celular ou um console. O Atari tem o excelente [Stella][4] (cujo debugger é bom até para quem só quer entender como algum jogo funciona). Mas é igualmente importante testar o programa no console &#8220;de verdade&#8221;, pois só lá os detalhes vão aparecer.

Foi com esse objetivo que eu encomendei o [Harmony][5]. Em termos simplificados, é um cartucho com slot para [cartão SD][6], que disponibiliza os jogos (ROMs) gravados no cartão através de um menu no console. Comparando com aqueles [cartuchos com 2 ou 4 jogos][7] selecionáveis através de chaves, é uma evolução incrível.

[<img src="//farm7.static.flickr.com/6224/6296434661_1ac7df1365_m.jpg" width="240" height="180" alt="Cartucho Harmony: Menu" style="float:right;margin:4px;border:1px solid black" />][8]Como tudo que é simples, tem uma engenharia sofisticada por trás. As [especificações][9] mostram que, só em termos de clock, a CPU do cartucho é 70 vezes mais rápida que o do videogame (na prática a diferença é ainda maior, afinal, é uma arquitetura ARM de 32 bits contra um 6502 de 8 bits). Talvez não precisasse de tudo isso, mas um hardware mais generoso pode embarcar um software que reconhece dezenas de formatos de ROMs, e que pode ser atualizado com faclidade.

Para mim foi útil logo de cara, porque o &#8220;Hello, World&#8221; que eu apresentei no [Dev In Sampa][10] nunca tinha rodado em um console de verdade, e eu não acreditava que acertaria de primeira. Dito e feito: eu não zerei os registradores do TIA (chip de vídeo) correspondentes aos objetos visuais que não estava usando, e eles apareciam como &#8220;lixo&#8221; na tela. Este problema não acontecia no emulador, porque ele zera a memória emulada ao inicializar. Felizmente a correção foi fácil, e já foi aplicada nos [slides][11] e no [código-fonte][12].

<p style="text-align:center">
  <a href="http://www.flickr.com/photos/chesterbr/6296433993/" title="Cartucho Harmony: Hello World by chesterbr, on Flickr"><img src="//farm7.static.flickr.com/6218/6296433993_4bbcc3d1c2.jpg" width="500" height="375" alt="Cartucho Harmony: Hello World" style="margin:4px;border:1px solid black" /></a>
</p>

Ele também foi útil para viabilizar o [sorteio2600][13], um programinha que sorteia números entre 0 e uma centena qualquer (100, 200, 300, etc.), feito especialmente para o [Dev In Vale][14]. Novamente, entre o emulador e a vida real havia uma diferença: o *score mode*, que divide o fundo (*playfield*) monocromático em duas cores (uma à esquerda e outra à direita) não faz essa divisão de forma 100% precisa (a cor muda um tiquinho antes da hora).

Como os projetistas de jogos já sabiam disso (dificilmente usariam emuladores naquela época), eles não usavam o playfield todo quando habilitavam o score mode. Mas o meu código já tinha sido pensado para sumir com metade dele (e usar toda a outra metade), então eu &#8220;roubei&#8221;, usando um dos *missiles* para cobrir a parte do playfield que não deveria aparecer. Isso está [documentado][15] no código, e fica como mais um exemplo dos truques que eram necessários para fazer o hardware limitado do Atari 2600 atender às necessidades de cada jogo.

Se interessar, veja mais [fotos do Harmony][16] em ação.

*(esse post pede um agradecimento especial ao Alexandre Oliveira, que me cedeu vários cartuchos de Atari para testar o console &#8220;novo&#8221;, evitando que eu procurasse problemas onde eles não existiam)*

 [1]: http://www.flickr.com/photos/chesterbr/6296967178/ "Cartucho Harmony by chesterbr, on Flickr"
 [2]: http://web.archive.org/web/20040810001018/http://fliperama.ig.com.br/emuladores/atari/program/index.html
 [3]: chester.me/archives/2011/08/palestra-sobre-programacao-para-atari-2600-no-dev-in-sampa-2011.html
 [4]: http://stella.sourceforge.net/
 [5]: http://harmony.atariage.com/
 [6]: http://cartaodememoria.com/cartao-sd
 [7]: http://romerogames.blogspot.com/2011/08/atari-2600-cartuchos-com-varios-jogos.html
 [8]: http://www.flickr.com/photos/chesterbr/6296434661/ "Cartucho Harmony: Menu by chesterbr, on Flickr"
 [9]: http://www.randomterrain.com/atari-2600-memories-harmony-cartridge.html#technical_specifications
 [10]: http://devinsampa.com.br/
 [11]: http://www.slideshare.net/chesterbr/programao-para-atari-2600
 [12]: http://pastebin.com/abBRfUjd
 [13]: http://github.com/chesterbr/sorteio2600
 [14]: http://devinvale.com.br/
 [15]: https://github.com/chesterbr/sorteio2600/blob/ffe34001c266c716b750e3863b782df7c5657722/sorteio2600.asm#L85
 [16]: http://www.flickr.com/photos/chesterbr/sets/72157628015276696/with/6296433993/
