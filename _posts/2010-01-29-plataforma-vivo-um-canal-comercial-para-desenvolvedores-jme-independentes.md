---
title: 'Plataforma Vivo: um canal comercial para desenvolvedores JME independentes.'
layout: post
comments: true
permalink: /archives/2010/01/plataforma-vivo-um-canal-comercial-para-desenvolvedores-jme-independentes.html
bb-custom-tags:
  - jogos celular
onswipe_thumb:
  - '//chester.me/wp-content/plugins/onswipe/thumb/thumb.php?src=//chester.me/wp-content/uploads/2010/01/vivo_java_c1.png&amp;w=600&amp;h=800&amp;zc=1&amp;q=75&amp;f=0'
dsq_thread_id:
  - 1751447513
categories:
---
<img src="//chester.me/wp-content/uploads/2010/01/vivo_java_c1.png" width="76" height="75" class="alignleft left size-full wp-image-3606" />Continuando o assunto do [último post][1]: fui ao workshop que a Vivo deu sobre a [plataforma][2] no Campus Party, no qual os palestrantes Sena e Lecy foram muito gentis em responder ao caminhão de perguntas que eu tinha sobre o assunto.

Antes de mais nada: ao contrário do que a apresentação da API SMS multi-linguagem dava a entender, a idéia inicial da plataforma **não é** disponibilizar aplicações server-side baseadas em SMS. Isso é tecnicamente possível, mas a idéia é realmente algo nos moldes da App Store da Apple, isto é, um marketplace para que as pessoas comprem e baixem aplicativos sem as complicações de download e pagamento tradicionalmente envolvidas nesse tipo de operação.

O público consiste em assinantes Vivo cujos celulares rodem aplicações [Java (JME)][3]. Pode parecer restritivo, mas fazendo as contas, estamos falando de algumas dezenas de milhões de clientes potenciais nessas características (segundo a própria Vivo). Com um detalhe: tudo em português, direto no celular, e debitando na conta &#8211; ou seja, nada de cartão de crédito ou de exigir um celular de elite &#8211; as maiores barreiras entre o &#8220;jeito Apple&#8221; e o público brasileiro.

O outro aspecto comercial interessante é que, de fato, o desenvolvedor interage diretamente com a Vivo, com um processo bem definido para colocar sua aplicação no ar. Isso é, talvez, a parte mais revolucionária da proposta. Hoje em dia, um desenvolvedor que queira colocar suas aplicações à venda numa operadora precisa, necessariamente, passar por um intermediário.

Comparando com iPhone OS/Objective C (a única outra plataforma viável para desenvolvedores independentes), os aparelhos não têm todas as plumas e paetês (alguns até tem, mas se você quer um público amplo tem que abrir mão), mas a curva de aprendizado e o tempo/complexidade de desenvolvimento são maiores &#8211; em particular se você for cuidadoso com detalhes como gerenciamento de memória. Além disso, você desenvolve usando qualquer computador/sistema operacional, o que é outra vantagem em termos de custo.

Com essa perspectiva fica bem mais fácil entender as informações no site. No geral, o processo é:

1.  Desenvolver a aplicação usando JME/Java. Se sua aplicação gerar envio de SMS, use as APIs &#8211; **fora isso é uma aplicação JME absolutamente normal**;
2.  Submeter a aplicação à certificação como &#8220;beta&#8221;. A aprovação nesse processo já vai permitir colocar a aplicação à venda por R$ 0,99 ou R$ 1,99 (à sua escolha). Disso, 70% é seu. E do tráfego de SMS que a aplicação gerar, 10% também vai para o seu bolso;
3.  Uma vez que a aplicação tenha sua viabilidade comprovada, ela pode ser submetida para o processo completo de certificação, no qual estará lado a lado com as aplicações dos grandes vendedores (a preços equivalentes).

Assim como o sistema, o processo ainda está sendo desenhado e implementado &#8211; o passo 2 só rola a partir de Março. Mas não é nada viajante como [roubar cuecas para obter lucro][4], e os caras estão realmente abertos a feedback.

Se vai dar certo, só o tempo dirá &#8211; mas é a chance que eu queria ter tido em 2005, quando comecei a desenvolver o [miniTruco][5]. Na época nenhuma integradora com que conversei se interessou: eles consideravam os gráficos minimalistas como &#8220;defeito&#8221; &#8211; sendo que isso foi feito propositalmente para garantir a universalidade e evitar telas de *loading* que tanto me irritam nos jogos tradicionais. Hoje, isto é, 300 mil downloads depois, eu suspeito que estava com a razão&#8230;

 [1]: //chester.me/archives/2010/01/plataforma-vivo-para-desenvolvimento-e-comercializacao-de-aplicativos-baseados-em-sms-sera-a-app-store-tupiniquim.html
 [2]: http://desenvolvedores.vivo.com.br/
 [3]: http://java.sun.com/javame/index.jsp
 [4]: http://poorbuthappy.com/ease/archives/2009/02/28/4482/phase-1-collect-underpants-phase-3-profit
 [5]: //chester.me/minitruco
