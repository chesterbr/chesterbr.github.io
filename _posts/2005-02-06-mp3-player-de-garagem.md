---
locale: pt-BR
title: Mp3 player de garagem
layout: post
comments: true
permalink: /archives/2005/02/mp3-player-de-garagem.html/
categories:
---
Fui conferir o tão falado [Minty MP3](http://web.media.mit.edu/~ladyada/make/minty/index.html), um player de música digital feito em uma caixa de "mentinha". De fato, o jeitão descolado da caixinha impressiona, mas eu fui fisgado pelos detalhes técnicos – a começar pela própria caixinha (que, sendo metálica, diminui bastante o ruído eletromagnético). É impressionante a quantidade reduzida de componentes de prateleira, cada um executando funções bastante elaboradas.

A música, por exemplo, fica em um cartão CompactFlash. Este formato é desdenhado pelos usuários de câmeras digitais pelo tamanho, mas sua principal vantagem é a flexibilidade: é possível ler/gravar arquivos usando desde uma simples comunicação serial até uma interface IDE (ele "conversa" ATA, o mesmo padrão usado por HDs e CD-ROMs).

Um microcontrolador faz o papel de CPU, RAM e ROM, carregando e removendo as músicas do cartão flash. Ele envia as mesmas para um decodificador MP3 (sim, um chip especializado faz o que o meu 386 suava pra fazer). Colocando na frente um DAC (conversor digital-analógico), o circo está armado. O autor não se deu por contente e ainda adicionou conexão USB e transmissão FM – cada um também com um singelo componentezinho.

Claro, é preciso ter vários componentes "tradicionais" (resistores, capacitores) para conectar esses módulos todos, fora que a montagem não é muito simples de executar (o cara é do MIT, e recomenda um [outro projeto menos radical](http://web.archive.org/web/20181201024436/http://www.walrus.com:80/~raphael/html/mp3.html?) para os mortais). Ainda assim, ele ilustra o quanto o "hobbyismo" em eletrônica evoluiu desde o final dos anos 70.

**CORREÇÃO:** O autor é, na verdade, uma autora (valeu, Mario). Quando vi MIT, cometi o ato falho de, sem pesquisar, associar um homem, dando a entender que nem tanta coisa assim mudou desde os anos 70. Mau sapão, mau sapão.