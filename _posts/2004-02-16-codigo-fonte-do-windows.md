---
title: Código-fonte do windows
layout: post
comments: true
permalink: /archives/2004/02/codigo-fonte-do-windows.html
categories:
---
<img src="//chester.me/img/blig/source.gif" border=1 alt="Código-Fonte" align="left">Por esses dias, parte do código-fonte do Windows NT/2000 <a href="http://br.wired.com/wired/tecnologia/0,1155,14701,00.html" >vazou</a> para a Internet.O que mais se discute é se isso pode viabilizar ataques baseados em vulnerabilidades até então desconhecidas no sistema. Já acharam <a href="http://news.com.com/2100-7355-5160566.html" >uma</a> no Internet Explorer 5 (que vem com o Windows 2000), mas esse browser é cheio delas: até eu, um mero mortal, descobri <a href="200401.html">como derrubar o IE5 usando apenas HTML</a>.

Tem bastante coisa na rede cobrindo o assunto, mas eu começaria pelo excelente <a href="http://www.kuro5hin.org/story/2004/2/15/71552/7795" >artigo</a> do Kuro5hin, que foca mais nos comentários deixados pelos programadores ao longo do código do que no próprio. Parece que o pessoal de Redmond andou enrolando e fumando o <a href="http://www.stevemcconnell.com/cc.htm" >Code Complete</a>: é um comentário mais engraçado que o outro.

Como a &#8220;esquerda Slashdot&#8221; da informática tende a só enxergar os deméritos no outro lado da cerca, acho relevante destacar os seguintes pontos (não costumo fazer isso porque a reação natural é atacar a fonte, mas o Kuro5hin é respeitado tanto pelos desenvolvedores sérios quanto pelos <a href="http://info.astrian.net/jargon/terms/w/wannabee.html" >wannabees</a>):

*&#8220;Despite the above, the quality of the code is generally excellent. Modules are small, and procedures generally fit on a single screen. The commenting is very detailed about intentions, but doesn&#8217;t fall into &#8216;add one to i&#8217; redundancy. &#8220;

&#8220;The security risks from this code appear to be low. Microsoft do appear to be checking for buffer overruns in the obvious places. The amount of networking code here is small enough for Microsoft to easily check for any vulnerabilities that might be revealed: it&#8217;s the big applications that pose more of a risk. This code is also nearly four years old: any obvious problems should be patched by now.&#8221;*

Aliás, eu tenho brincado esses dias, dizendo que, de um jeito ou de outro, caiu por terra a única vantagem que o Linux tinha sobre os Windows da família NT, que era a revisão feita por milhares de olhos no mundo todo&#8230; :-)
