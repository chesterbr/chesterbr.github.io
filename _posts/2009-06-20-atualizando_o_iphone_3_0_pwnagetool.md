---
title: Atualizando o iPhone (incluindo jailbreak e unlock) para o OS 3.0 usando o PwnageTool
excerpt: |
  |
    Fiz a atualização do meu iPhone californiano não-3G para o OS 3.0, com o auxílio do PwnageTool - que faz isso garantindo o jailbreak (que permite instalar as apps que eu quero, independente da vontade e do DRM do Steve...
layout: post
comments: true
permalink: /archives/2009/06/atualizando_o_iphone_3_0_pwnagetool.html/
dsq_thread_id:
  - 1751449366
categories:
---
<span class="mt-enclosure mt-enclosure-image"><img alt="logo.png" src="//chester.me/archives/img/mt/2009/06/20/logo.png" width="84" height="120" class="mt-image-right" style="float: right; margin: 0 0 20px 20px;" /></span>Fiz a atualização do meu iPhone californiano não-3G para o OS 3.0, com o auxílio do [PwnageTool][1] &#8211; que faz isso garantindo o jailbreak (que permite instalar as apps que eu quero, independente da vontade e do DRM do Steve Jobs) e o unlock (isto é, fazer ele funcione com qualquer operadora). Além dos fixes do OS 3.0 já comentados [por aí][2], o jailbreak novo inclui o Icy, um programa bem mais rápido que o Cydia para instalar software via apt.

O processo consiste nos passos abaixo, e por ora é preciso usar um Mac. Como de costume, não me responsabilizo se o seu iPhone travar, explodir ou se transformar num BlackBerry. Só faça se souber o que está fazendo (ou estiver pensando em inutilizar o seu pra comprar um 3GS oficial ou um Nokia bacanudo).

**ATENÇÃO**: Isso é para o iPhone original, **não para o iPhone 3G** (menos ainda para o 3GS). O 3G é mais enroscado porque não tem a falha fundamental que permite a simples troca do software de baseband (grosso modo, a parte do iPhone que é efetivamente o telefone). Rolou um software chamado yellowsn0w que fazia essa troca em memória, mas o último update (2.2.1) matou essa possibilidade. A boa notícia é que está pra sair o ultrasn0w, versão nova desse software que promete des-tijolar esses modelos &#8211; fique de olho no [blog do ultrasn0w][3] para mais novidades.

<u>Parte I</u>: Gerando um firmware do mal:

*   Atualize o iTunes para 8.2 (se já não fez isso);
*   Sincronize o iPhone;
*   Baixe o [PwnageTool para Mac][4] (torrent), o [firmware 3.0][5] e os bootloaders [3.9][6]/[4.6][7] (os dois);
*   Instale o PwnageTool (abra o DMG e arraste o abacaxi para Applications). Deixe o resto na pasta Downloads que a ferramenta acha;
*   Rode o PwnageTool, selecione o primeiro iPhone;
*   Clique na seta para a direita, selecione o firmware quando ele encontrar e seta novamente;
*   A primeira pergunta é só um aviso (de que ele vai criar um firmware do mal baseado no que você baixou e botar no seu desktop), clique em Yes;
*   Em segiuda ele pergunta se o seu iPhone ativa normalmente pelo iTunes, clique em No;
*   Ele vai trabalhar um pouco (hora de tomar um café);
*   Ele vai perguntar se o seu iPhone já foi pwnado antes. Responda que não (mesmo que já tenha).

Com isso ele deve gerar o firmware do mal no seu desktop (não confunda com o que você baixou, que está na pasta Downloads.) Mas não acabou, é preciso instalar isso no iPhone.

<u>Parte II</u>: Instalando o firmware do mal:

*   Colocar o iPhone no modo DFU (*device firmware upgrade*): se você acabou de executar os passos acima, clique na seta que o PwnageTool te ensina a fazer. Caso contrário (ou se não rolar), siga [estes passos][8];
*   O iTunes vai detectar o telefone em modo de restauração e oferecer para dar o restore. **Segure a tecla alt/option** enquanto clica no botão restore (se não fizer isso ele vai baixar e instalar o firmware original, e adeus jailbreak/unlock) e selecione o firmware do mal (o que está no desktop, não confunda com o que você baixou na pasta Downloads).

Ele vai instalar o firmware novo (você vai ver o abacaxi no lugar da maçã). Após o demorado processo, o telefone deve iniciar normalmente e reconhecer a operadora &#8211; mas em estado de novo (sem os seus dados). Basta ir no iTunes e restaurar o backup (ele vai perguntar se é um iPhone novo ou se é o que você tinha backup antes) e pronto, você é um feliz usuário do OS 3.0.

Eu separei o procedimento em duas partes porque assim você pode atualizar os iPhones dos seus amigos (que **não sejam 3G**, já falei, [p\*** moleque mala][9]) sem passar por esse processo todo: basta guardar o firmware alterado (todo o resto, inclusive o PwnageTool, é dispensável) e executar a Parte II.

**UPDATE**: Murphy strikes again: foi só eu ter todo esse trabalho pra atualizar e escrever o post que o iPhone Dev Team lançou o [redsn0w][10], um software que permite alcançar o mesmo objetivo de uma forma bem mais simples, na linha do QuickPwn: você atualiza o firmware para o 3.0 pelo jeito oficial, roda o software e ele faz o patch direto no iPhone. Tem pra Windows e Mac, e embora ele não faça o unlock do 3G (vide acima), pelo menos faz o jailbreak (pra quem tem um 3G oficial, é perfeito). **Eu não testei esse método**, mas parece uma alternativa razoável (ainda mais para os apressadinhos que já sairam fazendo o update e ficaram sem telefone.)

 [1]: http://blog.iphone-dev.org/
 [2]: http://www.applebrasil.net/2009/06/12/confira-108-novidades-do-iphone-os-3-0/
 [3]: http://www.yellowsn0w.net/
 [4]: http://torrents.thepiratebay.org/4963802/PwnageTool_3.0.dmg.4963802.TPB.torrent
 [5]: http://appldnld.apple.com.edgesuite.net/content.info.apple.com/iPhone/061-6580.20090617.XsP76/iPhone1,1_3.0_7A341_Restore.ipsw
 [6]: http://www.iphone-hacks.com/downloads/file/131
 [7]: http://www.iphone-hacks.com/downloads/file/132
 [8]: http://www.iblogeek.com/wiki/index.php?title=Modo_DFU
 [9]: http://cersibon.blogspot.com/2008/04/naldo.html
 [10]: http://blog.iphone-dev.org/post/126908912/redsn0w-in-june
