---
title: 'Plataforma Vivo para desenvolvimento e comercialização de aplicativos baseados em SMS &#8211; será a App Store tupiniquim?'
layout: post
comments: true
permalink: /archives/2010/01/plataforma-vivo-para-desenvolvimento-e-comercializacao-de-aplicativos-baseados-em-sms-sera-a-app-store-tupiniquim.html/
onswipe_thumb:
  - |
    http://img.youtube.com/vi/rKgtyxbWXOg">tchuva</a></em>.

    A <a href="http://www.tiinside.com.br/26/01/2010/vivo-lanca-plataforma-para-desenvolvedores-de-aplicativos/ti/163831/news.aspx">notícia</a> (TI Inside) me deixou salivando: potencialmente a coisa permitiria publicar apps sem o envolvimento de terceiros (como na App Store), mas cobrando direto na conta telefônica - só isso já merece alguma consideração.

    O processo começa com a abertura de um <a href="http://desenvolvedores.vivo.com.br/user-registration-by-role">cadastro</a> e leitura da <a href="http://desenvolvedores.vivo.com.br/tools/document-library/technical-documents-and-guides">documentação das APIs</a> - que são chamadas externamente (ou seja, seu aplicativo não roda no celular, e sim no seu próprio servidor), e consistem no envio de SMS, MMS e <a href="http://en.wikipedia.org/wiki/Wireless_Application_Protocol#WAP_Push">WAP Push</a> (que é, grosso modo, o envio de um link para um conteúdo WAP) através de uma API REST (que cheira a SOAP com uma capinha REST por cima, apesar de contar com conversão implícita de JSON), com <a href="http://desenvolvedores.vivo.com.br/tools/network-enablers/sdk">bibliotecas prontas para PHP, Java e .Net</a> - mas, claro sendo REST, qualquer linguagem vale.

    Pode parecer pobre em comparação, digamos, com apps iPhone, mas aplicações baseadas em SMS rodam até mesmo nos celulares mais modestos - eu lembro que, quando vi um pager pela primeira vez, minha primeira reação foi "cara, eu muito faria um <a href="/archives/2006/06/a_busca_de_epam.html">adventure de texto</a> rolando nessa parada". De repente um <a href="/minitruco">miniTruco</a> baseado em SMS... idéias mil.

    Dei uma olhada na biblioteca Java. Ela é empacotada de maneira, digamos, pouco carinhosa (ex.: inclui o <a href="http://hc.apache.org/httpclient-3.x/">Jakarta Commons HttpClient</a> como código-fonte, misturado com o código da API - provavelmente foi gerada por alguma ferramenta) e abre com um caminhão de issues no Eclipse. O mérito é que vem com uns exemplos (bem básicos) de uso, e os issues devem ser coisa fácil de resolver (depois eu vejo com calma).

    Juntando o fato de as APIs só rolarem atualmente num sandbox com a quantidade de "em breve" no site, a primeira leitura é que o produto ainda está bem em construção - o link "<a href="http://desenvolvedores.vivo.com.br/business-model">modelo de negócio</a>" ser um Flash com quatro slides explica muito sobre o estágio embrionário da empreitada enquanto produto. Dá pra encarar como risco (i.e., será que a plataforma vai pro ar?) ou como oportunidade (dá tempo de desenvolver algo e sair na frente).

    E ficam no ar duas grandes dúvidas:

    	<ul>
    <li>As APIs só falam (numa leitura superficial que fiz até agora) em envio de mensagens. E o recebimento? A coisa só pode ser considerada uma aplicação autônoma se o usuário puder enviar SMS de volta, e não achei nenhuma API para que a app consiga receber respostas. Será que a idéia é fazer WAP Push, mandar o cara para o meu site e lá ele interagir para receber o próximo SMS?</li>
    <br>
    	<li>Quanto isso custa pro usuário? O artigo fala em porcentagens sobre o tráfego gerado, mas não diz quanto o usuário do aplicativo vai pagar por esse tráfego (se for preço normal de SMS, esquece - sai mais barato comprar um netbook pra jogar o adventure de texto :-P). E ainda fala em venda dos aplicativos, o que também é complicado: se o cara tiver que pagar pra baixar <strong>e</strong> pagar pra usar, só vai dar certo em um país onde as pessoas sejam conformistas a ponto de pagar imposto várias vezes sobre o mesmo produto... ah, tá, entendi.</li>
    </ul>

    Espero que as pessoas que foram à apresentação tenhma perguntado essas coisas e postem em algum lugar em breve. Também devo perguntar no <a href="http://desenvolvedores.vivo.com.br/forum">fórum</a> e ver no que dá. Eu sou sempre reticente com qualquer associação com operadoras de celular, mas numa primeira análise essa plataforma (quando e se ficar pronta) parece menos <em>evil</em> do que de costume. Vamos ver./0.jpg
dsq_thread_id:
  - 1751447464
categories:
---
<img src="/wp-content/uploads/2010/01/vivo_grana1.png" alt="Show me the money!" width="85" height="75" class="alignright right size-full wp-image-3589" />Parece que ontem a operadora de telefonia móvel Vivo [apresentou][1] no Campus Party sua plataforma de desenvolvimento de aplicativos para celulares &#8211; apresentação que infelizmente eu perdi por causa de trabalho e *[tchuva][2]*.

A [notícia][3] (TI Inside) me deixou salivando: potencialmente a coisa permitiria publicar apps sem o envolvimento de terceiros (como na App Store), mas cobrando direto na conta telefônica &#8211; só isso já merece alguma consideração.

O processo começa com a abertura de um [cadastro][4] e leitura da [documentação das APIs][5] &#8211; que são chamadas externamente (ou seja, seu aplicativo não roda no celular, e sim no seu próprio servidor), e consistem no envio de SMS, MMS e [WAP Push][6] (que é, grosso modo, o envio de um link para um conteúdo WAP) através de uma API REST (que cheira a SOAP com uma capinha REST por cima, apesar de contar com conversão implícita de JSON), com [bibliotecas prontas para PHP, Java e .Net][7] &#8211; mas, claro sendo REST, qualquer linguagem vale.

Pode parecer pobre em comparação, digamos, com apps iPhone, mas aplicações baseadas em SMS rodam até mesmo nos celulares mais modestos &#8211; eu lembro que, quando vi um pager pela primeira vez, minha primeira reação foi &#8220;cara, eu muito faria um [adventure de texto][8] rolando nessa parada&#8221;. De repente um [miniTruco][9] baseado em SMS&#8230; idéias mil.

Dei uma olhada na biblioteca Java. Ela é empacotada de maneira, digamos, pouco carinhosa (ex.: inclui o [Jakarta Commons HttpClient][10] como código-fonte, misturado com o código da API &#8211; provavelmente foi gerada por alguma ferramenta) e abre com um caminhão de issues no Eclipse. O mérito é que vem com uns exemplos (bem básicos) de uso, e os issues devem ser coisa fácil de resolver (depois eu vejo com calma).

Juntando o fato de as APIs só rolarem atualmente num sandbox com a quantidade de &#8220;em breve&#8221; no site, a primeira leitura é que o produto ainda está bem em construção &#8211; o link &#8220;[modelo de negócio][11]&#8221; ser um Flash com quatro slides explica muito sobre o estágio embrionário da empreitada enquanto produto. Dá pra encarar como risco (i.e., será que a plataforma vai pro ar?) ou como oportunidade (dá tempo de desenvolver algo e sair na frente).

E ficam no ar duas grandes dúvidas:

*   As APIs só falam (numa leitura superficial que fiz até agora) em envio de mensagens. E o recebimento? A coisa só pode ser considerada uma aplicação autônoma se o usuário puder enviar SMS de volta, e não achei nenhuma API para que a app consiga receber respostas. Será que a idéia é fazer WAP Push, mandar o cara para o meu site e lá ele interagir para receber o próximo SMS?


*   Quanto isso custa pro usuário? O artigo fala em porcentagens sobre o tráfego gerado, mas não diz quanto o usuário do aplicativo vai pagar por esse tráfego (se for preço normal de SMS, esquece &#8211; sai mais barato comprar um netbook pra jogar o adventure de texto :-P). E ainda fala em venda dos aplicativos, o que também é complicado: se o cara tiver que pagar pra baixar **e** pagar pra usar, só vai dar certo em um país onde as pessoas sejam conformistas a ponto de pagar imposto várias vezes sobre o mesmo produto&#8230; ah, tá, entendi.

Espero que as pessoas que foram à apresentação tenhma perguntado essas coisas e postem em algum lugar em breve. Também devo perguntar no [fórum][12] e ver no que dá. Eu sou sempre reticente com qualquer associação com operadoras de celular, mas numa primeira análise essa plataforma (quando e se ficar pronta) parece menos *evil* do que de costume. Vamos ver.

 [1]: http://www.vivo.com.br/campusparty/desenvolvedores.php
 [2]: http://www.youtube.com/watch?v=rKgtyxbWXOg
 [3]: http://www.tiinside.com.br/26/01/2010/vivo-lanca-plataforma-para-desenvolvedores-de-aplicativos/ti/163831/news.aspx
 [4]: http://desenvolvedores.vivo.com.br/user-registration-by-role
 [5]: http://desenvolvedores.vivo.com.br/tools/document-library/technical-documents-and-guides
 [6]: http://en.wikipedia.org/wiki/Wireless_Application_Protocol#WAP_Push
 [7]: http://desenvolvedores.vivo.com.br/tools/network-enablers/sdk
 [8]: /archives/2006/06/a_busca_de_epam.html
 [9]: /minitruco
 [10]: http://hc.apache.org/httpclient-3.x/
 [11]: http://desenvolvedores.vivo.com.br/business-model
 [12]: http://desenvolvedores.vivo.com.br/forum
