---
title: 'Android: Comentários e Desabafos'
excerpt: |
  |
    O Android é uma proposta anunciada recentemente pelo Google para uma arquitetura aberta de telefones celulares que privilegia o usuário e os desenvolvedores independentes de aplicativos - em contraste com as plataformas usadas nos aparelhos atuais (além das soluções para...
layout: post
comments: true
permalink: /archives/2007/11/android_comenta.html
dsq_thread_id:
  - 1751442727
categories:
---
<span class="mt-enclosure mt-enclosure-image"><img alt="Android" src="//chester.me/archives/img/android_logo.png" width="200" height="29" class="mt-image-right" style="float: right; margin: 0 0 20px 20px;" /></span>O [Android][1] é uma proposta anunciada recentemente pelo Google para uma arquitetura aberta de telefones celulares que privilegia o usuário e os desenvolvedores independentes de aplicativos &#8211; em contraste com as plataformas usadas nos aparelhos atuais (além das soluções para aplicativos de terceiros, como J2ME), que favorecem fabricantes e operadoras.

Sob o ponto de vista técnico, a arquitetura é um primor, a começar pela baixa propensão a reinventar a roda: o sistema operacional é baseado no kernel (2.6) do Linux, a exibição de páginas web é feita através do [WebKit][2] (que, grosso modo, está para o Safari assim como o [Gecko][3] está para o Firefox), e o desenvolvimento de aplicativos é feito através da já sedimentada linguagem Java.

Para executar aplicativos Java, o Android usa o Dalvik, uma interpretador de bytecode que mantém cada aplicação rodando em seu próprio processo, mas permitindo que elas se comuniquem, disponibilizem serviços e compartilhem dados de forma bem definida. Curiosamente, o Dalvik não roda bytecode java (i.e., arquivos .class). O desenvolvedor usa um compilador Java tradicional para transformar seus .java em .class, e, em seguida, um utilitário do SDK do Android (dx) para gerar arquivos .dex, a partir dos .class. Parece complicado, mas é bem automático.

Outra diferença notável para quem já trabalha com Java em celulares é que o J2ME sai de cena, dando lugar a uma nova biblioteca de classes. Superficialmente, elas têm suas semelhanças: por exemplo, quem já usou no primeiro as subclasses de [Screen][4]/[Item][5] ficará à vontade com suas contrapartes descendentes de [View][6] (que são mais complexas, mas escondem esta complexidade até que você precise do poder extra, como boas classes fazem).

No entanto, a biblioteca do Android oferece uma alternativa mais interessante para criar &#8220;telas&#8221;, que é defini-las num .XML. Desenvolvedores de aplicações desktop (fora do mundo RAD) sabem que quando a quantidade de elementos da interface começa a crescer, fica difícil dar manutenção quando estes são definidos através de programação, e descritores de *resources* como estes XMLs tornam-se mais atrativos.

Mais um pulo-do-gato: o Android centraliza a exibição e o fluxo de cada &#8220;tela&#8221; da aplicação na classe [Activity][7]. Por exemplo, num programa de e-mail, uma Activity mostraria a lista de e-mails. Ela poderia chamar uma Activity de visualização de e-mails, que, por sua vez, chamaria uma de escrita de e-mail. O usuário pode ir abrindo novas Activty (dentro do fluxo do programa) ou fechar a atual e retornar à anterior na pilha que se formou. Esse paradigma mescla o conceito de &#8220;form&#8221; com o de &#8220;navegador&#8221;, e, se bem utilizado, pode levar a reusos interessantes (inclusive entre aplicações), mas, como todo paradigma novo, requer uma certa ginástica mental.

<span class="mt-enclosure mt-enclosure-image"><img title="Imagem do filme ''Eu, Robô''" src="//chester.me/archives/img/android.jpg" width="160" height="199" class="mt-image-left" style="float: left; margin: 0 20px 20px 0;" /></span>Um ponto positivo é que mesmo as aplicações &#8220;core&#8221; do telefone (agenda, contatos, browser, etc.) são desenvolvidas em Java, usando esta nova biblioteca &#8211; ou seja, nada impede que desenvolvedores criem novas versões delas, ou complementem as já existentes com novas funcionalidades. Este conceito (&#8220;todas as aplicações nascem iguais&#8221;) é vendido como inovação, mas, se não me falha a memória, o Palm OS é exatamente assim desde os anos 90 (como qualquer usuário do [ZLauncher][8] ou do [Beyond Contacts][9] pode atestar).

Tudo isso é só uma fração do que eu pude analisar, o que, por sua vez, é só uma fração do que a API oferece (mesmo esta não sendo a versão final). Além disso, o SDK inclui luxos como um emulador que simplesmente funciona, uma documentação escrita por/para seres humanos e até um plugin bastante completo para o Eclipse (desenvolvedores J2ME têm que sambar para obter isso, ou lançar mão de atitudes desesperadas, como usar o NetBeans).

Enfim, a minha impressão é que o lado técnico da coisa é impecável. O que me preocupa é o lado prático.

Um dos grandes estímulos para o desenvolvimento de aplicações J2ME (comerciais ou não) é a quantidade de potenciais usuários, já que a plataforma está disponível em milhões de aparelhos no mundo todo. Num menor grau, Symbian, Palm OS e Windows Mobile atraem pelo mesmo motivo.

Em comparação com isto, até hoje foram comercializados zero aparelhos com o Android. Nenhum. Nada. Não é à toa que o Google está [usando seu recurso mais abundante][10] (dinheiro) para atrair desenvolvedores. Acredito que a idéia funcionará para criar um ecossistema básico de aplicações e inflacionar os números de desenvolvedores e aplicativos (cruciais para que a plataforma seja levada a sério). Infelizmente, isso não tornará o Android magicamente atrativo para quem quer ver sua aplicação em uso fora dos emuladores.

Mas esse **ainda** não é o pior problema.

O pior problema é justamente o que escrevi no primeiro parágrafo: o Android, por seu design, dá plenos poderes a usuários de telefones celulares e aos desenvolvedores independentes. Este poder todo está saindo de um lugar bem específico: das mãos dos fabricantes e das operadoras, que vivem uma relação que uns chamam de simbiótica, outros de promíscua, e os mais bocudos (como eu) de cartel mesmo.

São inúmeros os casos de telefones celulares que possuem características bloqueadas, ora para servir aos interesses das operadoras (ex.: eu tinha um aparelho que magicamente ignorava pedidos de transferência via Bluetooth de ringtones e aplicativos &#8211; afinal, estes são vendidos pelas operadoras), ora para ajudar os fabricantes (não é preciso procurar muito para encontrar aparelhos de hardware quase idêntico, mas cujo software libera o uso de determinados recursos apenas nos modelos mais caros).

O Android acabaria com tudo isso &#8211; e é por essa razão que eu não consigo entender porque operadoras (ou fabricantes que não queiram cair na desgraça delas) teriam interesse no seu sucesso. Claro, vários fabricantes (e até operadoras conhecidas aqui por seus desserviços na telefonia fixa) &#8220;participam&#8221; da [aliança][11] criada em torno da iniciativa. Mas convenhamos: para tanto basta assinar um papel bobo e mandar um estagiário bem-vestido nas reuniões.

Quem conhece um pouco desse tipo de empresa sabe quão comum &#8211; e quanto sucesso obtém &#8211; essa atitude de aliar &#8220;cara de conteúdo&#8221; com a dobradinha inaptidão/inação &#8211; no melhor estilo [chefe do Dilbert][12]. Agora é jogo estar lá e associar sua marca com a imagem de inovação e sucesso que o Google transpira, mas na hora do &#8220;vamos ver&#8221;, não me espantarei se algumas destas empresas se recusarem a abrir mão da chave-de-pescoço que travaram sobre seus usuários desde os primórdios da telefonia movel.

Deixo claro: não estou torcendo contra. Ao contrário: como usuário de smartphone **e** desenvolvedor independente, esse tipo de liberdade é um dos meus sonhos molhados digitais. E ver o cartel retrógrado da telefonia celular perder a mão-de-ferro (que mantém até hoje bobagens como o SIM Lock, que só começa a cair por força do marketing) me faria tatuar o logotipo do Google no coração. Mas enquanto o pessoal de Mountain View não explicar como (ou melhor, mostrar na prática que) a máfia das operadoras pode ser sobrepujada, eu permaneço cético.

 [1]: http://code.google.com/android/index.html
 [2]: http://webkit.org/
 [3]: http://developer.mozilla.org/en/docs/Gecko_Embedding_Basics
 [4]: http://java.sun.com/javame/reference/apis/jsr118/javax/microedition/lcdui/Screen.html
 [5]: http://java.sun.com/javame/reference/apis/jsr118/javax/microedition/lcdui/Item.html
 [6]: http://code.google.com/android/reference/android/view/View.html
 [7]: http://code.google.com/android/reference/android/app/Activity.html
 [8]: http://www.palmgear.com/index.cfm?fuseaction=software.showsoftware&#038;PartnerREF=&#038;siteid=1&#038;prodID=43812
 [9]: http://www.dataviz.com/products/beyondcontacts/index.html
 [10]: http://code.google.com/android/adc.html
 [11]: http://www.openhandsetalliance.com/oha_members.html
 [12]: http://en.wikipedia.org/wiki/Pointy_Haired_Boss
