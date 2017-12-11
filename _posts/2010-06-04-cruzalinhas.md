---
title: cruzalinhas
layout: post
comments: true
permalink: /archives/2010/06/cruzalinhas.html/
onswipe_thumb:
  - '//chester.me/wp-content/plugins/onswipe/thumb/thumb.php?src=//chester.me/wp-content/uploads/2010/06/cruzalinhas_tela.png&amp;w=600&amp;h=800&amp;zc=1&amp;q=75&amp;f=0'
dsq_thread_id:
  - 1751447629
categories:
  - Portfolio
---
O site da [SPTrans][1] oferece várias informações sobre as linhas de ônibus, trem e metrô que operam na cidade de São Paulo. A navegação, entretanto, deixa um pouco a desejar &#8211; razão que leva as pessoas a alternativas como o [Tô a Pé][2] e o eficiente sistema de rotas do [Google Maps][3].

Este último resolve bem a minha vida, mas às vezes tudo o que eu quero é saber quais ônibus passam por um determinado local. Ou ainda: quais, dentre eles, passam por um segundo local, e quais passam entre este e um terceiro, i.e., quais minhas opções para ir do ponto A ao ponto B, e dele ao ponto C, e por aí em diante.

Misturando essa demanda com um desejo de colocar as informações de itinerário do transporte público de São Paulo nas mãos da população, desenvolvi o [cruzalinhas][4]. A aplicação ainda precisa de muitas melhorias (eu diria que é &#8220;beta&#8221;, mas o que não é?) mas já permite responder às perguntas acima.

Como de costume, o [código-fonte][5] é livre ([licença MIT][6]), e esse post vai falar um pouco sobre o funcionamento do mesmo.

<p style="text-align: center;">
  <a href="http://cruzalinhas.com"><img class="size-full wp-image-4012  aligncenter" style="border: 1px solid black;" title="cruzalinhas" src="//chester.me/wp-content/uploads/2010/06/cruzalinhas_tela.png" alt="cruzalinhas" width="350" height="164" /></a>
</p>

<!--more-->O back-end da aplicação é escrito em [Python][7] e hospedado no [Google App Engine][8]. Ele disponibiliza um par de chamadas [AJAX][9]/[JSON][10] para o front-end: uma página HTML que usa o JQuery para acessar tanto esse back-end quanto a [API do Google Maps][11] (usada para desenhar os mapas/trajetos e buscar endereços).

[Obter os dados de itinerário][12] não foi trivial, mas o principal desafio mesmo era fazer buscas geográficas. Explico: eu tenho, para cada linha, os pontos (latitude e longitude) que compõem a sequência de segmentos de reta que, conectados, representam seu trajeto. Uma busca consiste em descobrir quais dessas figuras cortam um determinado ponto (idealmente com alguma tolerância).

Calcular a distância entre o ponto e cada um dos segmentos de reta já estaria fora de questão se estivessemos falando de geometria euclidiana simples (e [não estamos][13]). Já que a idéia era ter alguma tolerância mesmo, eu poderia verificar se o ponto está na caixa que contém o segmento de reta (reduzindo a questão a uma quadra de [comparações de desigualdade][14]). Infelizmente, 4 comparações x cerca de 620 mil pontos ainda é **muita** coisa.

A salvação da lavoura foi o [geohash][15] &#8211; essencialmente uma representação de uma área geográfica com precisão mais-ou-menos arbitrária (consulte o link para detahes, é um conceito genial). A [biblioteca de geohash que eu usei][16] permite &#8220;somar&#8221; dois geohashes e retornar o geohash da menor caixa que contém os dois pontos originais.

Limitando essa caixa em 6 caracteres, ficamos com um [erro][17] menor que 1 Km &#8211; e esse erro é exatamente a margem de manobra que eu precisava. Observe que muitos dos segmentos caem na mesma caixa, logo, uma linha típica (que era composta de várias centenas de pontos/segmentos) acaba &#8220;participando&#8221; apenas de umas poucas dezenas de geohashes de caixa desse tipo.

Quando o sistema precisa procurar quais linhas passam perto de um ponto geográfico, ele calcula o geohash desse ponto, corta nos 6 caracteres e simplesmente busca as linhas que possuem segmentos cuja string de geohash bata com esse valor calculado. Trocamos aquelas 4 x 620 mil comparações de desigualdade (que o App Engine [não iria conseguir combinar mesmo, por estarem em dois campos diferentes][18] &#8211; latitude e longitude) por uma única comparação de igualdade (ok, numa string, mas bem curtinha) feita sobre universo de pouco menos de de 2000 hashes distintos &#8211; uma bela otimização.

Esse tipo de busca é muito rápida em um banco de dados relacional corretamente modelado e indexado &#8211; e me surpreendi quando a performance inicial foi tão ruim que as buscas geralmente davam *timeout*! O fato é que a maneira com que o App Engine expõe o [BigTable][19] para aplicações Python/Java pode levar o desenvolvedor a tratá-lo como um banco de dados relacional, e foi o que eu fiz: tinha uma entidade Linha, uma entidade Ponto, e em cada ponto eu tinha o geohash do segmento que ele formava com o anterior.

Para a coisa dar certo, foi preciso [desnormalizar][20] um pouco: fiz a entidade Hash armazenar, para cada geohash de 6 caracteres (que tenha surgido em algum segmento) as chaves primárias de todas as linhas que passam por ele. Com isso, a busca ficou suficientemente rápida.

Uma segunda desnormalização foi armazenar em cada entidade Linha todos os hashes pelos quais ela passa, e retornar essa informação junto com o nome/URL da linha. Isso permite que o próprio JavaScript determine as linhas que ligam dois pontos: ele já tem a lista das linhas que passam em cada um deles, basta ver quais delas têm pelo menos um geohash em comum.

O uso do [memcache][21] melhora ainda mais a performance dessas chamadas. A cada busca, guarda-se em cache a lista de linhas para um geohash (beneficiando outros pontos que estejam na mesma &#8220;caixa&#8221;, cujo resultado é o mesmo) e os meta-dados de cada linha (em separado da lista, já que outros pontos podem retornar a mesma linha e aproveitar esse outro cache).

A outra chamada que o cliente tem que fazer é a lista de pontos da linha em si, para desenhar o trajeto. Ao invés de retornar isso na lista de linhas, achei melhor deixar que ele faça uma nova chamada para cada linha, quando e se precisar dela. Nnovamente o memcache tem a mesma granularidade, fazendo com que o desenho de uma linha seja cacheado independente do ponto utilizado na busca.

Com isso tudo arrumado, a aplicação ganhou corpo suficiente para ir para o ar, e a [repercussão][22] me fez ver que não era só eu que sentia falta dessa funcionalidade. Ainda falta uma boa versão mobile, e outros sites bacanas poderiam ser feitos com esses dados. Será que se eu disponibilizar uma API (via [YQL][23], por exemplo) alguém se habilita?

 [1]: http://www.sptrans.com.br/itinerarios/
 [2]: http://www.toape.com.br/
 [3]: http://maps.google.com
 [4]: http://cruzalinhas.com
 [5]: http://github.com/chesterbr/cruzalinhas
 [6]: http://pt.wikipedia.org/wiki/Licen%C3%A7a_MIT
 [7]: http://www.python.org/
 [8]: http://code.google.com/appengine/
 [9]: http://en.wikipedia.org/wiki/Ajax_%28programming%29
 [10]: http://json.org
 [11]: http://code.google.com/apis/maps/
 [12]: https://github.com/chesterbr/cruzalinhas/blob/master/src/sptscraper/sptscraper.py
 [13]: http://www.movable-type.co.uk/scripts/latlong.html
 [14]: http://en.wikipedia.org/wiki/Inequality
 [15]: http://en.wikipedia.org/wiki/Geohash
 [16]: https://github.com/chesterbr/cruzalinhas/blob/master/src/sptscraper/geohash.py
 [17]: http://en.wikipedia.org/wiki/Geohash#Worked_example
 [18]: http://aleatory.clientsideweb.net/2009/11/28/google-app-engine-datastore-gotchas/
 [19]: http://labs.google.com/papers/bigtable.html
 [20]: http://highscalability.com/how-i-learned-stop-worrying-and-love-using-lot-disk-space-scale
 [21]: http://code.google.com/appengine/docs/python/memcache/usingmemcache.html
 [22]: http://search.twitter.com/search?q=cruzalinhas
 [23]: http://developer.yahoo.com/yql/
