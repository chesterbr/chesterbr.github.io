---
title: My Retweeted Tweets
layout: post
comments: true
permalink: /archives/2011/07/my-retweeted-tweets.html/
onswipe_thumb:
  - '//chester.me/wp-content/plugins/onswipe/thumb/thumb.php?src=//chester.me/wp-content/uploads/2011/07/myretweetedtweets1.png&amp;w=600&amp;h=800&amp;zc=1&amp;q=75&amp;f=0'
dsq_thread_id:
  - 1754046187
categories:
  - Portfolio
---
[<img class="alignright size-full wp-image-6137" title="My Retweeted Tweets" src="//chester.me/wp-content/uploads/2011/07/myretweetedtweets1.png" alt="My Retweeted Tweets" width="88" height="285" />][1]Eu nunca me animei a colocar o [widget do Twitter][2] no blog porque meus tweets variam bastante, e nem todos são interessantes para um público mais amplo. Isso mudou quando ouvi, nos dois últimos minutos do [Nerdcast 264][3], o [Rafinha Bastos][4] confessar que:

> &#8220;Eu (&#8230;) deixo no meu twitter só as (&#8230;) tweetadas¹ que foram **bem** retweetadas&#8221;

O comentário pode parecer inócuo, mas ajuda a explicar como ele foi [considerado tão influente pelo The New York Times][5] &#8211; essa &#8220;limpeza&#8221; garante uma excelente proporção de retweets por tweet na timeline. E o filtro popular deixa quase tudo mais bacana &#8211; como qualquer leitor do [Digg][6] sabe. Mesmo sem a multidão de seguidores do Rafinha, é possível olhar a própria [página de tweets que foram retweetados][7] e conferir a diferença com relação ao &#8220;dia-a-dia&#8221;.

Infelizmente o widget do Twitter não permite colocar apenas os tweets retweetados. A [API de busca][8] também não ajuda, porque só vai até uns poucos dias no passado. O jeito foi colocar a mão na massa e criar o meu próprio widget. Usando o Google AppEngine, a API do Twitter (via [Twitter4J][9]) e um final de tarde, saiu o **[My Retweeted Tweets][10]**.

Basta autorizar o aplicativo e ele gera o código que você pode usar para deixar os tweets retweetados em evidência, como eu fiz na coluna lateral do blog (e na ilustração). O [código-fonte][11], como de costume, é livre (Apache License) e está disponível para quem quiser. O aplicativo foi feito para uso próprio, então ainda pode ser bastante melhorado, mas está lá.

¹ <span style="font-size:0.9em">Sim, <em>tweetar</em> e seus derivados forçam a amizade, como me lembrou a <a href="http://baniverso.com">Bani</a>. Mas é o que a <a href="http://blog.pt.twitter.com/2011/06/oba-twitter-em-portugues-brasileiro.html">tradução oficial do Twitter</a> diz, então paciência&#8230;<span></p>

 [1]: http://myretweetedtweets.appspot.com
 [2]: http://twitter.com/about/resources/widgets
 [3]: http://jovemnerd.ig.com.br/nerdcast/nerdcast-264-nerdcast-em-pe-com-rafinha-bastos/
 [4]: http://www.rafinhabastos.com.br/
 [5]: http://entretenimento.r7.com/famosos-e-tv/noticias/rafinha-bastos-e-o-mais-influente-do-twitter-segundo-o-new-york-times-20110324.html
 [6]: http://digg.com
 [7]: http://twitter.com/#!/retweeted_of_mine
 [8]: http://search.twitter.com/api/
 [9]: http://twitter4j.org/en/index.html
 [10]: http://myretweetedtweets.appspot.com/
 [11]: http://github.com/chesterbr/myretweetedtweets
