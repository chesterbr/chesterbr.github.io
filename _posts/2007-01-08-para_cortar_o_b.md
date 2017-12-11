---
title: Para cortar o barulho da ventoinha, corte a voltagem
excerpt: |
  |
    Como um nerd que se preza, eu tenho um "servidorzinho" em casa. Após uma troca de ventoinha da CPU (Pentium III), me deparei com um problema muito chato: barulho. Depois de procurar inutilmente uma ventoinha de maior qualidade (só encontrei...
layout: post
comments: true
permalink: /archives/2007/01/para_cortar_o_b.html/
dsq_thread_id:
  - 1751441372
categories:
---
<img title="Um pouco (mais) de fios no gabinete, mas o silêncio resultante compensa" src="//chester.me/archives/img/mod_ventoinha.jpg" width="250" height="205" border="1" align="left" style="margin-right:2px" />Como um nerd que se preza, eu tenho um &#8220;servidorzinho&#8221; em casa. Após uma troca de ventoinha da CPU (Pentium III), me deparei com um problema muito chato: barulho.

Depois de procurar inutilmente uma ventoinha de maior qualidade (só encontrei para para CPUs/soquetes mais novos), me deparei com um hack meio assustador, mas que parecia fazer sentido (para um processador relativamente termo-eficiente como este): mudar a voltagem da ventoinha de 12V para 5V, diminuindo a rotação, e, por conseqüência, o barulho.

O mapa da mina está neste [post do fórum Guia Do Hardware.Net][1] &#8211; essencialmente você tem que remover os fios +12V (vermelho) e GND (preto) do conector que liga a ventoinha à placa-mãe, e ligá-los a um dos conectores de força sobressalentes dos drives, usando os fios de mesmas cores (já que, nestes conectores, vermelho significa +5V).

Dica: eu peguei uma ventoinha bem velha (daquelas que ligam nos conectores de força e não no conector de ventoinha da placa-mãe) e aproveitei o conector de força macho dela para ligar no fêmea da fonte do micro.

O resultado é que o barulho da ventoinha praticamente cessou, e o aumento de temperatura foi desprezível: subiu de 34 para 38 graus em situação normal. Com carga alta, chega a 45 (não medi antes da mudança, pena), o que está ainda bem abaixo do máximo recomendado para a CPU.

Claro que esses números variam de caso para caso, e é bom conferir em algum lugar confiável (ex.: [The Heatsink Guide][2]) a temperatura máxima da sua CPU, verificando que ela não seja atingida, especialmente em situações de carga alta (eu usei o [cpuload][3] para testar no Linux). Efeito colateral: mesmo mantendo o fio do sensor conectado, ele não dá mais a velocidade de rotação &#8211; mas isso não fez a menor falta.

**DISCLAIMER**: Faça por sua conta e risco. Não me responsabilizo por nada se a sua CPU explodir ou se o seu condomínio virar o novo Edifício Joelma. Mas fazendo em CPUs não muito agressivas (e que não estejam *overclocked*), e conferindo as pinagens corretamente (consulte as do \*seu\* equipamento), a modificação deve funcionar a contento.

 [1]: http://www.guiadohardware.net/comunidade/volcano-cu/25223/
 [2]: http://www.heatsink-guide.com/
 [3]: http://pages.sbcglobal.net/redelm/
