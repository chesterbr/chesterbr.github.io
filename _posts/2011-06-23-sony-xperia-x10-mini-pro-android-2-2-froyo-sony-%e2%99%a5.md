---
title: 'Sony Xperia X10 Mini Pro + Android 2.3 (Gingerbread) &#8211; Sony = ♥♥♥'
layout: post
comments: true
permalink: /archives/2011/06/sony-xperia-x10-mini-pro-android-2-2-froyo-sony-%e2%99%a5.html/
robotsmeta:
  - index,follow
onswipe_thumb:
  - '//chester.me/wp-content/plugins/onswipe/thumb/thumb.php?src=//chester.me/wp-content/uploads/2011/06/froyo_cyanogen_x10_mini_pro.jpg&amp;w=600&amp;h=800&amp;zc=1&amp;q=75&amp;f=0'
dsq_thread_id:
  - 1751448069
categories:
---
<div style="border:1px solid red; padding:8px; margin:8px; text-align:center">
  Estou <b>vendendo</b> meu X10 Mini Pro (com o update 2.3 instalado)<br />clique na <a href="/lojinha">lojinha</a> e veja mais detalhes
</div>

[<img class="alignleft size-full wp-image-6043" title="Animação do boot do Froyo. Hit the road, Sony Ericsson!" src="//chester.me/wp-content/uploads/2011/06/froyo_cyanogen_x10_mini_pro.jpg" alt="Animação do boot do Froyo. Hit the road, Sony Ericsson!" width="200" height="200" />][1]*Este post falava originalmente de um upgrade para o Android 2.2 (que continua válido), mas já consegui atualizar o celular para o 2.3, daí a mudança no título. Pule para o [final][2] para obter os links para 2.3.*

Demorou, mas finalmente rolou: um programador ([slade87][3]) juntou código dele com o [MiniCM][4] (baseada no [CyanogenMod][5]) e conseguiu gerar uma versão do Android 2.2 (conhecido como &#8220;Froyo&#8221;) que funciona no X10 Mini Pro. Um amigo me [avisou][6] da existência de um [tutorial em português][7] escrito pelo [NightCrawler][8], e foi o que eu segui.

**IMPORTANTE**: O processo não é trivial, e, embora não seja ilegal, não é autorizado pelo fabricante. **Uma falha PODE inutilizar o seu aparelho**, &#8220;tijolando&#8221; ele de forma possivelmente **irreversível** e certamente não coberta pela garantia. Não faça se não estiver disposto a assumir o risco ou se não souber bem o que está fazendo. Nem eu, nem o slade87, nem o NightCrawler nem **NINGUÉM será responsável por qualquer dano, mas apenas VOCÊ**. Se estiver em dúvida ou não for a sua praia fazer essas coisas, **NÃO FAÇA**.

Aviso dado, estou muito feliz com o resultado. Este Android é &#8220;debranded&#8221;, isto é, não tem as customizações que a Sony Ericsson inclui com a versão que vem com o telefone &#8211; é o Android do jeito que foi pensado originalmente pelo Google, com alguns toques extras dos programadores que o customizaram. A Sony [afirma][9] que não haveria vantagem em ter o 2.2 (e [diz o mesmo][10] do 2.3), mas sinto informar que o celular ficou **bem** mais rápido e funcional. Se foi o upgrade para o Froyo ou a remoção do software da Sony que proporcionou a melhora, fica a critério de cada um (a minha opinião é que são as duas coisas, e que a Sony devia contratar esses hackers sem pestanejar).

O tutorial enfatiza (e eu reforço) a importância dos backups com o [XRecovery][11], que pode ser carregado antes do sistema operacional e permite executar backups e upgrades do mesmo. O [Titanium Backup][12] é outra ferramenta que já justifica fazer *root* do celular, e também reitero o custo/benefício de comprar o [Root Explorer][13], além de recomendar doações para os autores dos outros softwares.

É preciso ter uma máquina com Windows para executar o upgrade (tanto o [SuperOneClick][14], usado para ganhar acesso root, quanto o atualizador da Sony &#8211; usado no passo de &#8220;debranding&#8221; &#8211; só rodam neste sistema operacional). Mas os updates futuros podem ser feitos direto no celular, através do XRecovery. Eu queimei umas duas ou três horinhas entre downloads, backups e atualizações.

No final tudo funcionou, com a exceção do layout do teclado (o &#8220;ç&#8221; e outras teclas diferentes do original americano) &#8211; mas isso dá pra resolver com [outro software][15] do slade87. Depois de rodar o programa no PC e reiniciar o celular, é preciso descobrir qual o método de entrada correto: entre numa caixa de texto qualquer, toque ela até vir o menu, escolha *Input Method* e vá testando as opções (*Android Keyboard*, *Default Input*, etc.), até achar uma que esteja acentuada (pra mim variou conforme o firmware instalado).

Dentre os &#8220;brindes&#8221; que o firmware customizado oferece estão opções como fazer reboot direto para o XRecovery/ClockworkMod, e um programa que habilita o uso do flash LED da câmera como lanterna! Mas o ponto alto é a agilidade: a lista de contatos e o envio de SMS eram incapazes de administrar a quantidade de contatos que eu tenho, e no novo sistema é tudo instantâneo e bem integrado &#8211; bem mais próximo da experiência do iOS. E é cedo pra falar, mas até a bateria parece que está segurando melhor. Aprovadíssimo!

**UPDATE**: O slade87 não está mais desenvolvendo esta ROM (aparentemente ele [ficou cansado dos trolls][16] nos fóruns, que esquecem que ele está doando seu tempo), mas experimentei o [FroyoBread][17] que parece funcionar bem também.

<a name="gingerbread"></a>**UPDATE 2 (GINGERBREAD)**: O FroyoBread não foi tão liso quanto eu esperava. Mas tem um [build de Android 2.3][18] que parece estável o bastante, e instalei hoje. Dei wipe nos dados do usuário dentro do XRecovery, instalei o [firmware][19] e logo em seguida, sem reboot, o [patch][20], [arrumei o teclado][15] e parece que funciona tudo agora. Ou seja, **estou com Android 2.3 (Gingerbread) no X10 Mini Pro!!!!**

<a name="minicm"></a>**UPDATE 3 (MiniCM)**: Pouco antes do final de 2011 saiu o MiniCM7, outro firmware para o X10 Mini Pro customizado a partir do CyanogenMod 7 (e, portanto, Android 2.3). Ele promete mais estabilidade e performance, e, como sempre, tem a [receita de bolo para instalar][21] no xda-developers. O catch: para ser instalada, ela exige a troca do kernel Linux por um customizado (o [nAa][22]), e a instalação deste, por sua vez, pede o [unlock do bootloader][22] (além do root do celular que as outras pediam). É uma operação com uma bela possibilidade de tijolar o celular &#8211; eu só fiz porque estava em um delírio de insônia. Vamos ver se melhora algo.

 [1]: //chester.me/wp-content/uploads/2011/06/froyo_cyanogen_x10_mini_pro.jpg
 [2]: #gingerbread
 [3]: http://forum.xda-developers.com/member.php?u=3261285
 [4]: http://code.google.com/p/minicm/
 [5]: http://www.cyanogenmod.com/
 [6]: http://twitter.com/#!/bombox/status/83400482512568320
 [7]: http://www.plusgsm.com.br/forums/showthread.php/99581-TUTORIAL-Debranding-Root-XRecovery-e-Froyo-para-o-X10-Mini-Pro
 [8]: http://www.g33k4u.blogspot.com/
 [9]: http://idgnow.uol.com.br/computacao_pessoal/2011/01/06/smartphones-da-linha-xperia-x10-nao-serao-atualizados-com-android-2.2/
 [10]: http://www.sonyericsson.com/br/preview/aparelhos/por-que-nao-e-possivel-atualizar-o-x8-x10-mini-e-x10-mini-pro-com-o-android-2-3/comment-page-3
 [11]: http://www.addictivetips.com/mobile/xrecovery-mini-is-a-custom-recovery-for-xperia-x10-mini-pro/
 [12]: http://matrixrewriter.com/android/
 [13]: https://market.android.com/details?id=com.speedsoftware.rootexplorer
 [14]: http://meiobit.com/75205/superoneclick-fazendo-root-em-quase-todos-smartphones-android/
 [15]: http://forum.xda-developers.com/showthread.php?t=1113863
 [16]: http://forum.xda-developers.com/showthread.php?t=1176039
 [17]: http://forum.xda-developers.com/showthread.php?t=1190037
 [18]: http://forum.xda-developers.com/showthread.php?t=1201116
 [19]: http://depositfiles.com/files/jq415u18e
 [20]: http://www.multiupload.com/A6BCL5SFKB
 [21]: http://forum.xda-developers.com/showthread.php?t=1415026
 [22]: http://forum.xda-developers.com/showthread.php?t=1254225
