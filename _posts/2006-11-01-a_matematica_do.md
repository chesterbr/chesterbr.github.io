---
title: A Matemática dos Vampiros
excerpt: |
  |
    Outro dia chegou a uma lista de discussões da qual participo a notícia de que um cientista teria "provado matematicamente" que vampiros não existem. Como estudante de matemática de plantão, fiz a elocubração que se segue: Seja m o mês...
layout: post
comments: true
permalink: /archives/2006/11/a_matematica_do.html/
dsq_thread_id:
  - 1751441740
categories:
---
<img title="Cena do desenho Família Drácula. 'Mau sapão, mau sapão...'" src="/archives/img/familia_dracula.jpg" width="300" height="219" border="1" align="right" style="margin-left:2px" />Outro dia chegou a uma lista de discussões da qual participo a notícia de que [um cientista teria &#8220;provado matematicamente&#8221; que vampiros não existem][1]. Como estudante de matemática de plantão, fiz a elocubração que se segue:

Seja m o mês atual (o mês 0 foi aquele em que, por algum motivo arcano, surgiu o Conde Drácula). Sendo os vampiros imortais, e supondo que cada um morda apenas uma pessoa por mês, temos que a quantidade de vampiros no mês M é dada pela função abaixo (exponencial, para os íntimos):

q(m) = 2<sup><span style="font-size:x-small">m</span></sup>

A base é baixa, mas progressão geométrica é que nem coelho (ou: coelho é que nem progressão geométrica). Observe:

q(0) = 1
q(1) = 2 (o Drácula mordeu alguém no mês 1)
q(2) = 4 (o Drácula e o cara mordido no mês 1 morderam uma pessoa cada)
q(3) = 8 (cada um dos 4 mordeu um, and so on&#8230;)
&#8230;
q(10) = 1024 (o vilarejo foi pro saco, em menos de 1 ano&#8230; mas ainda assim parece que dá pra segurar)
q(11) = 2048
..
q(24) = 16.777.216 (em 2 anos, foram uns 2% da população mundial na época)

O senso comum diz que a humanidade ainda vai ter algum tempo, mas aqui é que entra o &#8220;poder coelhal&#8221; da exponencial &#8211; olhe o que uns poucos meses fazem:

q(25) = 33.554.432
q(26) = 67.108.864
q(27) = 134.217.728
q(28) = 268.435.456
q(29) = 536.870.912
q(30) = 1.073.741.824

Ou seja, em 2 anos e meio (2,5 x 12 meses = 30 meses) os vampiros superam a população mundial estimada (aliás, o artigo deve ter trocado as bolas, porque, &#8220;coincidentemente&#8221;, população mundial = q(29)-1 &#8211; provavelmente o artigo original não considerava o próprio Drácula e o jornalista confundiu cálculo com estimativa).

É o mesmo motivo pelo qual quando alguém vai tentar te convencer a entrar pra Amway / Herbalife / etc. você pode estar certo que a pessoa está mentindo: o único jeito de alguém ganhar as cifras que os caras dos pontos intermediários da estrutura alegam faturar é se a população inteira da Terra participar (e mesmo assim ainda falta nego).

Mas, por incrível que pareça, a matemática de colegial ainda tem uma coisa insanamente mais reprodutiva que a progressão geométrica: o fatorial. Aquela continha inocente:

1! = 1
2! = 2&#215;1 = 2
3! = 3x2x1 = 6
4! = 4x3x2x1 = 24

Olha a m@#$@:
&#8230;
13! = 6.227.020.800 (ordem de grandeza da população \*atual\*, contando os chineses!)
&#8230;
24! = +/- 6,20e+23 (ordem de grandeza de 1 mol, i.e., da quantidade de átomos contidos em 12g de carbono)
52! = +/- 8,06e+67 (ordem de grandeza da quantidade estimada de elétrons no UNIVERSO)

Pra arrematar o dia: o mesmo 52! também é a quantidade de possíveis combinações em um prosaico baralho &#8211; sim, é da mesma ordem de grandeza da quantidade de elétrons no universo &#8211; isso dá um novo sentido para a frase &#8220;não faz maço e embaralha direito essa p#$%a&#8221;&#8230;

Em tempo: um colega aqui do IME alega que há divergências sobre a [forma como surgem os vampiros][2], que eventualmente poderiam alterar este cálculo. Mas mesmo reduzindo significativamente o grau de infecção, o &#8220;fator coelho&#8221; (assegurado pela imortalidade dos vampiros) garante que das duas uma: ou eles não existem, ou somos todos vampiros.

**UPDATE: **O link para o artigo original estava quebrado (mais uma vez o Último Segundo jogou fora suas URLs antigas), troquei por um mais estável (espero), mas em inglês. Aproveito para dar link para o [Physics in Films][3], site mantido pelo Dr. Costas Efthimiou (o cientista mencionado), no qual ele motiva o aprendizado de física e ciências no geral apontando esse tipo de contradição em filmes e livros.

 [1]: http://www.livescience.com/strangenews/061025_vampire_debunk.html
 [2]: http://en.wikipedia.org/wiki/Vampire_lifestyle#Creation_of_new_vampires
 [3]: http://pif.physics.ucf.edu
