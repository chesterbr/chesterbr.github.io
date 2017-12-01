---
title: Apple IIGS
author: chester
layout: page
robotsmeta:
  - index,follow
redirect_from: "/iigs.html/"  
---
<p style="text-align: right;">
  <strong><em>último update: 05/Jul/2003</em></strong>
</p>

## **Introdução**

Saudosismo é coisa de velho, mas que os anos 80 foram uma época fantástica para se conhecer informática, ah, isso foram. Devido à reserva de mercado, os fabricantes nacionais podiam copiar qualquer computador do exterior. Eu cheguei a ter um Exato CCE e um TK3000//e (clones de modelos populares do Apple II).

Meu sonho de consumo pré-adolescente era o Apple II<tt>GS</tt> &#8211; um modelo avançado, que não teve nenhum clone no Brasil. É possível comprar no no eBay por menos de US$ 10, mas o custo de transporte inviabiliza, assim, resolvi comprar só a placa-mãe e montar o resto aqui mesmo. Inspirado nos malucos do [AppleFritter][1], usei como gabinete uma embalagem tipo Tupperware.

Nesta página coloquei as fotos da montagem, algumas telas e diversas dicas, tanto para adaptar hardware de PC quanto para transferir software do PC para o Apple. Tem também bastante screenshots, para quem estiver com saudades do Karateka ou curioso para ver alguns jogos do II<tt>GS</tt>, que nunca chegaram aqui.

## **Montando o Apple II<tt>GS</tt>**

<img src="/img/micros/appleiigs/07_Gabinete%20ultraleve.JPG" border="0" alt="" />

Eu poderia ter montado num gabinete de PC, mas seria um pouco herege. Além disso, plástico é mais fácil de furar (embora ainda dê um trabalho, como descobri depois), e **bem** mais leve &#8211; fora que os conectores traseiros da placa limitavam muito as minhas opções.

<img src="/img/micros/appleiigs/03_Motherboard%20IIGS%20-%20Traseira.jpg" border="0" alt="" />

Eu achei que seria difícil convencer um leiloeiro tradicional a mandar só a placa-mãe, por isso peguei um especializado em equipamentos antigos. Ele tem uma &#8220;loja&#8221; no eBay, a [Electronic Recycler][2]. Tinha coisa mais barata ainda no eBay, mas valeu pela qualidade da transação: a placa chegou em pouco mais de uma semana. Recomendo.

<img src="/img/micros/appleiigs/01_Motherboard%20IIGS.jpg" border="0" alt="" />

Usei uma fonte de PC de 300W que eu tinha encostada &#8211; além de fornecer todas as voltagens que o Apple II precisa, dá pra alimentar todo e qualquer hardware que eu resolva encaixar neste micro, sem esquentar um mísero grau. A ventoinha até ajuda o Apple II a se manter resfriado (pasmem: quase nenhum Apple II tinha ventoinha, e ainda assim travavam menos que os PCs modernos).

<img src="/img/micros/appleiigs/04_Fonte%20de%20PC%20antes%20da%20adaptacao.jpg" border="0" alt="" />

O conector de força do PC (foto superior) é diferente do conector do Apple II (foto inferior). Tive que penar um pouco na Santa Ifigênia (meca dos eletro-eletrônicos em SP) para achar este último, mas consegui. Fuçando no Google encontrei as pinagens tanto para o conector do [Apple][3] quanto para o do [PC (ATX)][4].

Daí em diante é fácil: basta ir correspondendo os sinais (ex.: ligue o pino +12V do conector do Apple em qualquer fio +12V da fonte, GND em qualquer GND da fonte, etc.). Tome cuidado apenas com o +5V: não use o sinal Power Good (pino 1 do conector P8) nem o sinal opcional (pino 2 do conector P8). Use os pinos 4, 5 ou 6 do conector P9, e boa viagem.

<img src="/img/micros/appleiigs/05_Fonte%20adaptada%20com%20o%20conector%20Apple.JPG" border="0" alt="" />

Para fazer as furações usei um ferro de solda que já estava quebrado e velho (tanto que eu tinha que esquentar ele no fogão). Não use um ferro novo: ele já era feio quando eu comecei, mas no final ficou essa coisa imprestável:

<img src="/img/micros/appleiigs/08_Ferro%20de%20solda%20velho.JPG" border="0" alt="" />

Quando se faz os furos, eles ficam meio desengonçados, como na foto seguinte. A idéia é que você lixe depois. Dá um trabalho do cão. Eu até lixei um pouco as saídas dos conectores, mas os furos da fonte eu deixei feiosos mesmo, depois eu dou um acabamento com durex colorido ou algo assim.

<img src="/img/micros/appleiigs/09_Traseira%20perfurada%20do%20gabinete.JPG" border="0" alt="" />

Idealmente, deixaria o gabinete &#8220;de comprido&#8221; na mesa, com todos os fios saindo por trás, como um Apple II normal. Entretanto, seria difícil alinhar a fonte sem correr o risco de não encaixar alguma placa no futuro. Assim, resolvi orientá-lo com a face maior virada para mim (até porque o teclado de Mac que eu descolei é meio grandinho), com os fios saindo pelas laterais.

A fonte foi &#8220;pendurada&#8221; na lateral (e resolvi fixá-la bem antes de travar definitivamente a placa-mãe). Fiz os furos para os parafusos, mas reforcei com Epoxy &#8211; afinal, se ela cair em cima da placa-mãe eu vou chorar a noite toda.

<img src="/img/micros/appleiigs/10_Gabinete%20com%20fonte.JPG" border="0" alt="" />

Pra fixar a placa-mãe eu usei dois daqueles ferrinhos que são parafusos em uma ponta e buchas metálicas na outra (toda placa-mãe de PC tem pelo menos um). Também use três daqueles pininhos de plástico para ter uma base uniforme que distribuísse a pressão ao encaixar novas placas. Cortei a parte inferior deles &#8211; não faria sentido furar o plástico do gabinete para encaixar outro plástico.

<img src="/img/micros/appleiigs/11_Gabinete%20com%20fonte%20e%20MB.JPG" border="0" alt="" />

Tudo pronto, vamos ligar. Que ruflem os tambores&#8230;

<img src="/img/micros/appleiigs/12_Tela%20de%20boot%20do%20IIGS.JPG" border="0" alt="" />

Incrível, funciona ! :-) Passei o início do Carnaval desmontando e consertando o teclado de Mac (foi comprado como sucata, e justo a tecla de liga/desliga &#8211; que no II<tt>GS</tt> é o Reset &#8211; não funcionava). Descobri que um acidente com café comprometeu uma das trilhas da membrana, o que resolvi ligando um fio da placa de circuito do teclado diretamente a ela. Meio tosco, mas rolou (nem tirei foto porque não valia a pena).

<img src="/img/micros/appleiigs/13_Tela%20Check%20Startup%20Device.JPG" border="0" alt="" />

Arrumei um daqueles mouses quadradões de Mac, que eram os mesmos usados no II<tt>GS</tt>. Ficou bacana. Os drives tiveram que ser de Apple mesmo, mas consegui, o que só deixava faltando o joystick. Arrumei um analógico bem das antigas, ideal para o projeto, mas era de PC. Como o Apple II é micro de hackers para hackers, não foi difícil achar um [esquema para conectar joystick de PC no Apple][5].

Optei pela versão mais simples (que não suporta auto-fire) e sem os potenciômetros de calibragem. Ainda por cima, fiz no esquema &#8220;teia de aranha&#8221; (soldando os componentes uns nos outros sem ponte de terminais ou placa de circuito). Parece desleixo, mas fazendo assim, pude colocar os dois resistores e dois capacitores dentro do conector de 15 pinos, ou seja, ficou apenas um cabo (que, de lambuja, funciona como extensão do controle).

## <img src="/img/micros/appleiigs/joy_teia.jpg" border="0" alt="" /> <img src="/img/micros/appleiigs/joy_teste.jpg" border="0" alt="" />

## **Transferindo Software do PC para o Apple  
**

O próximo passo foi ligar o Apple no PC, para poder usar no Apple os programas disponíveis na Internet. A porta serial do II<tt>GS</tt> usa um conector bizarro ([Mini-DIN8][6]). Depois de uma tentativa frustrada de montar um cabo, descobri que um cabo de impressora serial da Apple (Mini-DIN8 numa ponta e DB-25 na outra) funcionaria como cabo &#8220;null-modem&#8221; para ligar o Apple II no PC. Comprei o cabo no [site do fabricante][7] (peça pelo número: 10432) junto com um adaptador DB25-DB9 (no. 10223).

Depois disso, o &#8220;diliema Tostines&#8221;: pra transferir software do PC pro Apple, eu precisava do disco do DOS &#8211; e o único jeito de obter o disco do DOS era transferir ele do PC pro Apple ! Fuçando um pouco, encontrei o [DOS 3.3 Dump][8] &#8211; um esquema que redireciona a porta serial (IN#2) fazendo o PC &#8220;digitar&#8221; o DOS no Apple, byte a byte. Com isso foi possível formatar um disquete e começar transmitir programas do PC pro Apple pelo a usar o [ADTGS][9] (que também se &#8220;auto-digita&#8221; pela serial).

<img src="/img/micros/appleiigs/dos33dmp.jpg" border="0" alt="" /> <img src="/img/micros/appleiigs/adtgs.jpg" border="0" alt="" />

O ADT funciona bem para arquivos DSK (i.e., disquetes de 5¼), o que já permite brincar com Karateka, Print Shop e coisas do gênero. Mas os programas do II<tt>GS</tt> vêm em discos de 3½, que correspondem a arquivos com extensão SHK ou SDK, com os quais o ADT não trabalha.

A solução é passar para o Apple algum software de transfência de arquivos. Usando o ADT, eu peguei o [ZLink][10]. No PC usei o HyperTerminal, transferindo arquivos com o protocolo YModem-G (ZModem seria ideal, mas só o ProTerm, um shareware meio caro, suporta ZModem).

Também recomendo que você pegue [este outro][11] disquete de 5¼. Ele tem o ShrinkIt, que lhe permitirá descompactar os arquivos SDK e SHK para disquetes. É meio enroscado no começo, mas dá pra acostumar.

<img src="/img/micros/appleiigs/zlink.jpg" border="0" alt="" /> <img src="/img/micros/appleiigs/shrinkit.jpg" border="0" alt="" />

[Aqui][12] tem links para vários softwares que você pode precisar (ex.: GSShrinkit, necessário para descomprimir imagens com forks e outras bizarrices).

Uma vez resolvidas todas essas encrencas, achar software chega a ser tarefa fácil. Uma excelente fonte de programas clássicos é o [Asimov][13]. Também recomendo uma olhada [nestes][14] aqui, especialmente para jogos de II<tt>GS</tt>.

## **Resultado Final e Screenshots  
**

A minha primeira idéia era dar um visual mais retrô. Mas o gabinete tem tanta semelhança com o estilo iMac que eu não resisti a decorá-lo apropriadamente.

<img src="/img/micros/appleiigs/final1.jpg" border="0" alt="" />

A minha bancada, no final, ficou bem simpática (e zoneada).

<img src="/img/micros/appleiigs/final2.jpg" border="0" alt="" />

No fim das contas, me decepcionei um pouco com os softwares de II<tt>GS</tt>. A máquina é poderosa, mas não sobreviveu à egotrip do Steve Jobs e seu Macintosh. Mas só pelos programas clássicos já vale.

<img src="/img/micros/appleiigs/karateka.jpg" border="0" alt="" /> <img src="/img/micros/appleiigs/aprestk3000.jpg" border="0" alt="" />

<img src="/img/micros/appleiigs/joy_cap_tit.jpg" border="0" alt="" /> <img src="/img/micros/appleiigs/joy_cap_jogo.jpg" border="0" alt="" />

<img src="/img/micros/appleiigs/printshop.jpg" border="0" alt="" /> <img src="/img/micros/appleiigs/ark2.jpg" border="0" alt="" />

<img src="/img/micros/appleiigs/tt1.jpg" border="0" alt="" /> <img src="/img/micros/appleiigs/tt2.jpg" border="0" alt="" />

 [1]: http://www.applefritter.com
 [2]: http://www.stores.ebay.com/id=9743630
 [3]: http://apple2.info/wiki/index.php?title=Pinouts#GS_Motherboard_Power_Connector
 [4]: http://pinouts.ru/Power/atxpower_pinout.shtml
 [5]: http://web.archive.org/web/20090110010728/http://home.swbell.net/rubywand/Csa2KBPADJS.html#004
 [6]: http://www.panintl.com/CN-1-1.htm
 [7]: http://www.labramo.com.br/
 [8]: http://www.apple2.org.za/gswv/a2zine/Sel/dos33dmp.htm
 [9]: http://www.cobit.xpg.com.br/materias/apple2gs/pc_appleIIgs.htm
 [10]: ftp://ftp.apple.asimov.com/pub/apple_II/images/utility/communications/zlink.dsk
 [11]: ftp://ftp.apple.asimov.com/pub/apple_II/images/utility/communications/modem_util.dsk
 [12]: http://home.swbell.net/rubywand/Csa2FLUTILS.html#007
 [13]: ftp://ftp.apple.asimov.net/
 [14]: http://home.swbell.net/rubywand/A2FAQs7GAMESITES.html
