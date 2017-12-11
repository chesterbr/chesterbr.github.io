---
title: Linguagens de Programação Comparadas
excerpt: |
  |
    A comparação entre linguagens de programação (e incluem-se aí os ambientes sob os quais estas linguagens operam) é um assunto quase que inesgotável. Quando abordado de forma leviana, acaba em discussões que pouco diferem das mesas-redondas futebolísticas: programadores movidos por...
layout: post
comments: true
permalink: /archives/2007/02/linguagens_de_p.html/
dsq_thread_id:
  - 1751444127
categories:
---
A comparação entre linguagens de programação (e incluem-se aí os ambientes sob os quais estas linguagens operam) é um assunto quase que inesgotável.

Quando abordado de forma leviana, acaba em discussões que pouco diferem das mesas-redondas *futebolísticas*: programadores movidos por um ímpeto de paixão e desejo de preservar seu investimento intelectual defendem com unhas e dentes suas linguagens prediletas, agindo como se todo o resto fosse secundário. O argumento também pouco varia: linguagens mais pragmáticas (de menor nível que a escolhida) são sempre &#8220;improdutivas&#8221; e as mais abstratas (de maior nível) &#8220;performam pouco&#8221;. Não é exagero afirmar que a maioria esmagadora das discussões sobre o assunto se dá sob este cenário, e é fácil perceber que, assim como suas contrapartes desportivas, pouco avançam.

Uma discussão mais aprofundada requer um estudo igualmente profundo (nas palavras de [Robert Herrick][1], *&#8220;no pain, no gain&#8221;*). É preciso compreender não apenas as linguagens que estão sendo comparadas, mas também suas antecessoras. A abordagem histórica é importante porque uma linguagem não surge ao acaso &#8211; uma forte motivação é necessária, tal como a existência de um domínio cujos problemas não são apropriadamente descritos (ou processados) nas lingaugens pré-existentes &#8211; ao menos na opinião dos criadores da nova linguagem.

Mesmo trilhando este caminho, um erro comum (que já cometi) é concentrar os estudos naquilo que já se conhece. É uma abordagem muito produtiva: se eu trabalho com Java, não vou perder muito tempo com programação funcional; se uso PHP, é mais jogo procurar técnicas que otimizem o meu trabalho do que me envolver com as dificuldades do mapeamento objeto-relacional, e por aí vai.

Esta produtividade tem um custo &#8211; fica cada vez mais difícil situar o seu ambiente (e perceber onde ele pode melhorar). E quando a inenvitável mudança tecnológica vier (e sim, ela virá &#8211; independente do &#8220;padrão de mercado&#8221; ou do &#8220;imenso legado&#8221; &#8211; características já atribuídas a tantas outras linguagens, hoje marginais ou extintas), este custo se fará sentir, pois será muito mais difícil migrar para novos paradigmas.

Independente da justificação prática, achei que seria interessante aproveitar as férias da faculdade para preencher algumas lacunas pessoais neste assunto, o que me levou a alguns livros interessantes (que são o verdadeiro tema deste post). Vamos a eles:

<table cellspacing="0" cellpadding="0" border="0" width="98%">
  <tr>
    <td>
      <b>A Little Smalltalk</b></p> <p>
        <img title="A Little Smalltalk (capa)" src="/archives/img/smalltalk.jpg" width="120" height="150" border="1" align="left" style="margin-right:2px" />Se você, programador Java, já se perguntou por que a classe-mãe-de-todas-as-classes se chama Object (e não &#8220;Class&#8221;), ou porque chamamos o paradigma de &#8220;orientação a objeto&#8221; (considerando que o desenho da aplicação acaba lidando mais com as classes do que com os objetos em si), aprender Smalltalk vai acender algumas luzes.
      </p>

      <p>
        E é melhor ainda se este aprendizado se der sob uma ótica isenta de legado. <a href="http://web.engr.oregonstate.edu/~budd/Books/little/" >A Little Smalltalk</a> aborda um dialeto específico da linguagem, mas é mais do que suficiente para evidenciar variações sutis (por exemplo, em Smalltalk você não &#8220;chama um método&#8221;, e sim &#8220;envia uma mensagem&#8221;). Tais diferenças parecem, numa primeira análise, puramente estéticas/semânticas, mas ajudam a compreender as motivações (e reais limitações) existentes no Java como o usamos hoje. </td> </tr> <tr>
          <td>
            <br /><b>Programming in Common Lisp</b></p> <p>
              <img title="Programming in Common Lisp (capa)" src="/archives/img/lisp.jpg" width="104" height="150" border="1" align="left" style="margin-right:2px" />Lisp é como a <a href="http://en.wikipedia.org/wiki/Cher" >Cher</a>: de tempos em tempos volta com plena majestade. Seja quando <a href="http://www.paulgraham.com/avg.html" >Paul Graham defende seu aprendizado</a>, seja quando <a href="http://labs.google.com/papers/mapreduce.html" >programação funcional se torna o assunto da vez</a>, vira e mexe algo aparece que desperta a curiosidade sobre esta linguagem.
            </p>

            <p>
              Assim como o outro livro, <a href="http://www.amazon.com/Programming-Common-Rodney-Allen-Brooks/dp/0471818887" >Programming in Common Lisp</a> trata de um dialeto específico, mas suficiente para ajudar a compreender os fundamentos, e separar o <i>hype</i> da realidade.
            </p>

            <p>
              Para quem gosta de construções matemáticas &#8220;belas&#8221; (i.e., simples em suas definições, mas que possuem ramificações complexas), Lisp é um prato cheio: os reais fundamentos (CAR/CDR, lazy evaluation e cercanias) são bastante sintéticos, mas os desdobramentos (e aplicações) são infindáveis, e, a meu ver, justificam plenamente o interesse (ainda que teórico) em torno da linguagem e das técnicas associadas a ela. </td> </tr> <tr>
                <td>
                  <br /><b>Comparative Programming Languages &#8211; 2nd Edition</b></p> <p>
                    <img title="Comparative Programming Languages (capa da 3rd. edition)" src="/archives/img/comparative.jpg" width="110" height="150" border="1" align="left" style="margin-right:2px" />Muito mais denso que os anteriores, este livro traça um panorama das linguagens de programação mais relevantes, desde as primeiras tentativas de evoluir do código de máquina puramente numérico até os primeiros ambientes OO maduros.
                  </p>

                  <p>
                    Para quem, como eu, trabalha a maior parte do tempo com Java, é muito esclarecedor ter um contato com fontes de inspiração como Ada e Modula-2 (além de C++, que eu já conhecia, mas também ajudou ver em perspectiva).
                  </p>

                  <p>
                    E, independente da linguagem, aspectos como alocação de memória, passagem de parâmetros, escopo, tipagem e muitos outros são analisados em detalhe (do código fonte à execução final), considerando sempre o tripé performance-flexibilidade-confiabilidade.
                  </p>

                  <p>
                    Ao contrário de boa parte da literatura do gênero, <a href="http://www.cs.stir.ac.uk/~rgc/cpl/" >Comparative Programming Languages</a> não requer um background matemático, ou mesmo conhecimentos extremamente avançados em programação. A terceira edição (abordada no site) engloba linguagens mais modernas, mas a que li tem um bom equilíbrio entre a perspectiva histórica e a análise computacional.
                  </p>
                </td>
              </tr></table>

 [1]: http://www.momentummedia.com/articles/tc/tc1508/paingain.htm
