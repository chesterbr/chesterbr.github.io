---
title: Reproduzindo DVDs de qualquer região no Mac mini (morte ao DRM)
layout: post
comments: true
permalink: /archives/2009/08/reproduzindo-dvds-de-qualquer-regiao-no-mac-mini-morte-ao-drm.html/
dsq_thread_id:
  - 1753452160
categories:
---
### Introdução

Eu tenho um [Mac mini][1] conectado na minha TV &#8211; que eu chamo de &#8220;firewall da TV a cabo&#8221;, já que sua principal função é impedir que o sinal de TV chegue na televisão, e, a partir dela, invada meu cérebro. Apenas coisas da internet e mídias que eu introduzo nele podem passar, garantindo a minha satisfação e sanidade mental.

Optei por este micro como central de mídia porque é um hardware compacto, robusto e, admito, bonitinho. Mas produtos Apple são uma fonte de contradição na minha vida: por um lado, a qualidade justifica o preço mais salgado; por outro, a empresa pisa muito na chapinha quando o assunto é DRM, isto é, as restrições artificiais introduzidas pelos fabricantes para dizer onde, como e quando você vai assistir/ouvir/ler as obras de arte pelas quais pagou.

[<img class=" alignright right" src="http://farm4.static.flickr.com/3230/3050960030_236af92d3f_m.jpg" alt="Godfather - Brando by Popartdks, on Flickr" width="240" height="240" />][2]

No caso de DVDs, o que mais me incomoda é o &#8220;[region locking][3]&#8220;, isto é: um dia os barões da mídia dividiram o mundo em um punhado de regiões, para controlar onde e como você assiste os filmes pelos quais pagou. Os fabricantes (como a Apple) embutem essa proteção no leitor de DVD e no sistema operacional. Isso não atrapalha os piratas (que baixam o filme sem nenhuma restrição), mas impede que pessoas que pagam por filmes comprados em diferentes países possam assisti-los.

Ah, mas eles são bonzinhos: permitem que você mude a região do aparelho umas quatro ou cinco vezes &#8211; e só aí ele fica travado na última região escolhida. Dá vontade de realmente começar a piratear tudo, só de raiva, mas eu normalmente respiro fundo e uso o VLC para reproduzir estes DVDs. Além de reproduzir boa parte dos DVDs &#8220;alienígenas&#8221; (por tratar eles como DVDs de dados e decodificar por conta), ele possui muito mais recursos e é gratuito.

Até que um dia encontrei um DVD que não rolava no VLC nem a pau. E não era um DVD qualquer, era [O Poderoso Chefão][4]! O box todo. Não tinha como ficar sem assistir esse, mas é um absurdo eu terminar com o leitor travado em  uma região ou outra. Me deu cinco minutos e eu resolvi mostrar ao aparelho quem é que manda aqui, fazendo uma proposta que ele não poderia recusar &#8211; *capisce*?

### Tornando o leitor region-free

**ATENÇÃO**: Este procedimento pode &#8220;tijolar&#8221; o seu leitor de DVD, tornando-o inútil. Nenhuma garantia cobre isso. Faça apenas se você se sentir à vontade com essas coisas **e** odiar DRM tanto quanto eu (a ponto de arriscar o drive/micro para vê-lo livre). Não me responsabilizo por qualquer prejuízo que você possa ter, ok?

A maior fonte de informações foi [esta página][5] &#8211; um pouco antiga (o cara tinha um Powerbook G4), mas precisa. O primeiro passo foi descobrir qual era o fabricante, o modelo e a versão do firmware do meu leitor. Para isso é preciso clicar na maçã > &#8220;About This Mac&#8221; e no botão &#8220;more info&#8221; para chamar o Profiler. Nele, abri o item &#8220;Disc Burning&#8221;, e descobri que o meu drive era um UJ-846 da Matshita e que o firmware era a versão FM3J.

Com essa informação em mãos, procurei nesta [lista de desbloqueadores para leitores Matshita][6] o meu modelo e firmware e baixei o software correspondente. Mas não foi só sair rodando (existem instruções no software, recomendo ler): primeiro era necessário ter certeza que a região já estava definida &#8211; o jeito seguro para isso é baixar o [DVD Info X][7] e verificar se ele devolve &#8220;Region x&#8221;, onde x é um número.

A segunda coisa é que o software verifica se você tem a versão mínima necessária do Mac OS X, mas um bug faz com que versões **muito** novas sejam recusadas (ele até coloca um botão de update, achando que vai ajudar, tadinho.) Se acontecer isso, a solução é enganar ele, trocando a versão no o arquivo */System/Library/CoreServices/SystemVersion.plist* para uma mais antiga &#8211; o meu é o 10.5.8, mudei nas duas linhas para 10.4.9 usando o TextEdit e rolou.

Uma vez que o software [<img class="size-full wp-image-2696 alignleft left" style="margin-right: 12px" src="//chester.me/wp-content/uploads/2009/08/defectivebydesign.jpg" alt="Logo da campanha da Free Software Foundation para promover a consciência acerca dos males do DRM. Visite http://www.defectivebydesign.org/ para mais informações." width="169" height="225" />][8]esteja rodando, **não interrompa ele**, ou seu leitor quase certamente vai pro vinagre. Momento tenso: a barrinha ficou parada nos 80% uma cara, mas andou. A coisa levou uns dois minutos, acho, e no final ele pede pra dar reboot. **Peralá**: se você editou o arquivo acima, volte para o valor anterior antes de reiniciar, o Mac vai ficar doidão se você não fizer isso.

Quando você reiniciar, vai parecer que nada mudou, pois o DVD Player continua dizendo que a região está errada e dizendo que você tem apenas mais x mudanças pra fazer. Acontece que agora você pode reiniciar o contador de mudanças quando quiser &#8211; para isso pode usar o [Region X][9], que permite trocar a região e reiniciar o contador de uma tacada só.

### Conclusão

Ao final do processo, a saga dos Corleone corre solta aqui. Até o [HandBrake][10] (que eu uso para deixar meus filmes favoritos no HD) passou a ler o DVD, coisa que antes não acontecia (meio inesperado, mas enfim, não estou reclamando). Este processo deve funcionar para outros Macs com drives que estejam na lista do link informado acima &#8211; e possivelmente em outros se você encontrar o firmware.

Não é trivial, e valem os avisos acima sobre riscos e responsabilidade, mas pra mim era uma questão de princípios. Se para você também é, não deixe de visitar o site [Defective By Design][8], uma campanha da Free Software Foundation que procura aumentar a consciência do público acerca de questões desta natureza.

 [1]: http://www.apple.com/br/macmini/
 [2]: http://www.flickr.com/photos/dkstone/3050960030/
 [3]: http://pt.wikipedia.org/wiki/DVD#C.C3.B3digos_das_regi.C3.B5es
 [4]: http://pt.wikipedia.org/wiki/The_Godfather
 [5]: http://macosx.com/forums/hardware-peripherals/297480-my-powerbook-g4s-dvd-region-free.html
 [6]: http://forum.rpc1.org/viewtopic.php?t=43082
 [7]: http://www.macupdate.com/info.php/id/16366
 [8]: http://www.defectivebydesign.org/
 [9]: http://www.macupdate.com/info.php/id/13801
 [10]: http://handbrake.fr/
