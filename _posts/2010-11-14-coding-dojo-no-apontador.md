---
title: Coding Dojo no Apontador
layout: post
comments: true
permalink: /archives/2010/11/coding-dojo-no-apontador.html
onswipe_thumb:
  - '//chester.me/wp-content/plugins/onswipe/thumb/thumb.php?src=//chester.me/wp-content/uploads/2010/11/dojo_screenshot.jpg&amp;w=600&amp;h=800&amp;zc=1&amp;q=75&amp;f=0'
dsq_thread_id:
  - 1751441252
categories:
---
O [Encontro Ágil 2010][1] (que merecia seu próprio post) se destacou pelo face-to-face: os open spaces e interações entre participantes foram tão produtivos que a tradicional carência de conectividade sem fio da USP trabalhou a favor. E foi justamente uma dessas interações, o Coding Dojo ([saiba o que é um][2]) organizado pelo [Bruno Gola][3] (com o forte apoio do [Asa][4]) que me inspirou a organizar uma sessão equivalente no [Apontador][5]. Segue uma visão geral da experiência:

### Preparação

Devido à heterogeneidade do público potencial (e também para levar o ambiente já preparado), era razoável escolher a linguagem com antecedência. Usamos [Python][6] por tres motivos: é fácil de aprender na hora para quem nunca viu, o código fica compacto e legível, e a expoisção a uma linguagem nova é um bônus extra (de fato, um dos pontos positivos mais enfatizados na retrospectiva).

A estação de trabalho era o meu Mac do trabalho mesmo, então usei o [TextWrangler][7], um editor básico com sintaxe colorida e que permite alternar facilmente entre o programa e o teste. Deixamos o editor ocupando 2/3 da tela, e o restante dividido entre o console (posicionado estrategicamente para garantir a visibilidade do OK ou FAILED do teste) e o cronômetro &#8211; ter as duas coisas na tela dá mais segurança e tranquilidade à dupla.

<p style="text-align: center;">
  <a href="//chester.me/wp-content/uploads/2010/11/dojo_screenshot.jpg"><img class="aligncenter size-medium wp-image-4846" style="border: 1px solid black;" title="Uma reprodução do jeitão da tela durante o Dojo no Apontador (clique para ampliar)" src="//chester.me/wp-content/uploads/2010/11/dojo_screenshot-300x225.jpg" alt="Uma reprodução do jeitão da tela durante o Dojo no Apontador (clique para ampliar)" width="300" height="225" /></a>
</p>

Eu queria um cronômetro offline &#8211; apesar da internet do Apontador ser boa, é sempre bom reduzir riscos. Adorei o [Coding Dojo Screenlet][8], escrito pelo próprio Gola, cuja cor de fundo (vermelho/verde) reflete o status do teste, ajudando a audiência saber quando (não) é apropriado se manifestar, mas ele só existe para Linux. A solução foi o [timer do Hora Agora][9] (criado pela [Bani][10]), que, aliado à interface minimalista do [Chrome][11], resolveu super bem: o alarme ininterrupto garantia que o piloto, ao sentar no teclado, não esquecesse de reiniciar o timer (usando o parâmetro &#8220;?t=05:00&#8243;, era só dar reload na página).

Num dojo (e em TDD no geral) é uma boa idéia que, quando viável, o teste seja executado automaticamente sempre que você salva o arquivo. Conseguimos isso graças ao uso de [nose + tdaemon ][12](que ainda dá o resultado em popups do [Growl][13]), mas tem outras alternativas por aí como o [autotest][14] e o [watchr][15]. Outra idéia é rodar todo o ambiente do Dojo online, usando o [CyberDojo][16]. Opções não faltam: escolha conforme a linguagem, ambiente e gosto &#8211; o importante é deixar tudo preparado **antes** de começar!

### No Dia

Após uma rápida introdução ao conceito de dojo e às &#8220;regras do jogo&#8221; (a [Karen][17] recomenda esses [dois][18] [resumos][19]), compilamos no quadro uma lista ordenada dos participantes &#8211; o que evita confusão na hora de trocar a dupla. A lista foi pela ordem em que as pessoas se voluntariaram, mas acho válida também a sugestão do Gola de alternar entre pessoas mais e menos familiarizadas com a tecnologia.

Dojo era novidade para quase todos os presentes, então pareceu razoável começar com um problema introdutório ([RandoriKata][20]), e fizemos o [RomanNumbers][21] (não por acaso, o mesmo que foi feito no Encontro Ágil). Foi interessante ver como a dinâmica e a técnica de solução de um mesmo problema variam em dojos diferentes.

### Conclusão

A retrospectiva foi parte importante da experiência &#8211; ajudou a medir o que aprendemos juntos, onde acertamos e onde poderíamos melhorar. E me chamou a atenção ver que, mesmo não sendo o objetivo principal do dojo resolver o problema em si, o pessoal não quis ir pra casa sem ver todos os testes funcionarem. Não tenho dúvidas sobre o impacto positivo que isso terá no dia-a-dia de cada um.

Organizar um dojo não é coisa de outro mundo (gastei mais tempo escrevendo esse post do que preparando) &#8211; só é preciso realmente ter um espaço com projetor, comida e interessados. Recomendo reservar entre 1h30 e 2h para a brincadeira, e levar o ambiente pronto, deixando o encontro focado em programar e interagir.

Abrace a simplicidade e ajude as pessoas a seguirem as regras, mas sem pressão. Não perca de vista o aspecto lúdico e não-competitivo do evento, e o resto sai por conta. O pessoal se animou a compartilhar [o código][22] e marcar os próximos logo de cara. E o Apontador está considerando promover **dojos abertos para visitantes &#8211; interessados, manifestem-se!
**

 [1]: http://www.encontroagil.com.br/2010/principal/home.html
 [2]: http://pet.inf.ufsc.br/dojo/o-que-eh-dojo/
 [3]: http://www.brunogola.com.br/
 [4]: http://www.facebook.com/#!/profile.php?id=710318510
 [5]: http://www.apontador.com.br/institucional/pt/index.php
 [6]: http://www.python.org/
 [7]: http://www.barebones.com/products/textwrangler/
 [8]: http://screenlets.org/index.php/CodingDojoScreenlet
 [9]: http://www.horaagora.com/timer
 [10]: http://baniverso.com/
 [11]: http://www.google.com/chrome
 [12]: http://isnomore.net/2010/08/01/automated-python-testing-nose-and-tdaemon/
 [13]: http://growl.info/about.php
 [14]: http://ph7spot.com/musings/getting-started-with-autotest
 [15]: http://www.rubyinside.com/watchr-generic-autotest-alternativ-2511.html
 [16]: http://www.cyber-dojo.com/
 [17]: http://www.apontador.com.br/profile/index/2201721751.html
 [18]: http://apoie.org/Dojo.htm
 [19]: http://www.slideshare.net/frevoonrails/dojo-20100127
 [20]: http://codingdojo.org/cgi-bin/wiki.pl?RandoriKata
 [21]: http://codingdojo.org/cgi-bin/wiki.pl?KataRomanNumerals
 [22]: https://github.com/zamlutti/Dojo-Apontador
