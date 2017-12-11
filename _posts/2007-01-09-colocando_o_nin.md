---
title: 'Colocando o Nintendo DS na sua rede sem fio (ou: o diabo mora nos detalhes)'
excerpt: |
  |
    Uma das características mais legais do Nintendo DS (NDS) é a comunicação sem fio: você pode jogar pessoalmente contra os amigos, ou, através de uma rede Wi-Fi, desafiar pessoas do mundo todo. O sucesso do NDS com o público infantil...
layout: post
comments: true
permalink: /archives/2007/01/colocando_o_nin.html/
dsq_thread_id:
  - 1751441348
categories:
---
<img title="Foto da BBC de pessoas jogando NDS, tirada de http://news.bbc.co.uk/2/hi/technology/5041690.stm" src="//chester.me/archives/img/ds_pessoas_bbc.jpg" width="203" height="152" border="1" align="left" style="margin-right:2px" />Uma das características mais legais do [Nintendo DS][1] (NDS) é a comunicação sem fio: você pode jogar pessoalmente contra os amigos, ou, através de uma rede Wi-Fi, desafiar pessoas do mundo todo. O sucesso do NDS com o público infantil no Japão garante um suprimento infindável de adversários &#8211; afinal, a produção de crianças japonesas não dá sinais de cansaço.

O objetivo deste post é ajudar aqueles que, como eu, querem aproveitar a rede sem fio de casa para jogar com o NDS &#8211; embora existam vários [tutoriais para Linux][2] e [Windows][3] ensinando a fazer isso, vale a pena mencinar dois detalhes me fizeram bater a cabeça um bom tempo. Se isso interessa, continue lendo.

Em redes sem fio, os dados costumam ser criptografados (codificados) para evitar o acesso não-autorizado. Grosso modo (os detalhes técnicos são cabeludos), esta criptografia pode ser feita usando o padrão WEP ou o WPA. O WEP é mais antigo, e, portanto, mais difundido (qualquer dispositivo sem fio funciona em redes WEP). No entanto, ele é bem menos seguro que o WPA &#8211; razão pela qual a minha rede doméstica usa WPA.

Infelizmente, o NDS só se conecta em redes WEP. Como eu não queria baixar a segurança das máquinas aqui de casa, resolvi criar uma rede alternativa em uma máquina com Linux (que já se pluga na minha rede atual), apenas para o DS entrar. E aí é que entram os detalhes mencionados, a saber:

**1) Fixar a Velocidade em 1MBps ou 2MBps**

As diferenças entre os dispositivos, aliadas às interferências (causadas por aparelhos externos) fazem com que a velocidade de uma rede sem fio varie bastante. Isso costuma acontecer automaticamente com PCs, palmtops e roteadores, mas o NDS parece não suportar muito bem esse tipo de flutuação.

Eu passei um bom tempo tentando me conectar com a rede, o que só deu certo quando &#8220;chumbei&#8221; a velocidade da mesma. Nos roteadores WiFi isso costuma ser uma opção chamada &#8220;Transmission Rate&#8221;, que deve ser setada em 1MBps ou 2MBps. Como eu estava usando o Linux, a solução é setar o parâmetro &#8220;rate&#8221; da placa, i.e.:

> iwconfig ath0 rate 2M

onde ath0 é minha placa de rede wi-fi, e 2M é a velocidade (2MBps).

**2) Chave WEP tem que ser SHARED**

Essa dica até que não é tão difícil encontrar &#8211; o problema foi descobrir como configurar esta opção no Linux. Algumas placas suportam esse setting direto no parâmetro &#8220;mode&#8221; (que determina o tipo de autenticação) do iwconfig, i.e.,:

> iwconfig ath0 mode shared

A minha (D-Link DWL-510) não ia nem a pau, até que descobri que esta configuração deve ser feita via iwpriv, i.e.:

> iwpriv ath0 authmode 2

As duas particularidades podem ser confirmadas em fóruns da Nintendo ([aqui][4] e [aqui][5]). Configure a sua rede e boa diversão!

 [1]: http://www.nintendo.com/channel/ds
 [2]: http://www.slackware-brasil.com.br/web_site/artigos/artigo_completo.php?aid=3561
 [3]: http://www.techzonept.com/archive/index.php/t-100378.html
 [4]: http://forums.nintendo.com/nintendo/board/message?board.id=tech_questions_wifi&#038;message.id=29078#M29078
 [5]: http://forums.nintendo.com/nintendo/board/message?board.id=tech_questions_wifi&#038;message.id=38921#M38921
