---
title: Programando para iPhone no Eee PC com Ubuntu
excerpt: |
  |
    A combinação Eee PC + Ubuntu continua me surpreendendo positivamente: consegui compilar o iphone-dev toolchain, isto é, o kit de desenvolvimento da comunidade para o iPhone (não confundir com o da Apple, que é bacanudo, mas só roda em Macs...
layout: post
comments: true
permalink: /archives/2008/08/programando_par.html/
dsq_thread_id:
  - 1751450243
categories:
---
A combinação[ Eee PC + Ubuntu][1] continua me surpreendendo positivamente: consegui compilar o [iphone-dev toolchain][2], isto é, o kit de desenvolvimento da comunidade para o iPhone (não confundir com o da Apple, que é bacanudo, mas só roda em Macs e tem um mol de restrições).

Eu já tinha [feito][3] isso no Mac. No Ubuntu foi até mais fácil, por conta [deste roteiro][4], que torna fáceis passos enroscados como a transferência do sistema de arquivos do iPhone e a extração dos headers do XCode. Foi preciso fazer apenas umas poucas adaptações:

*   Quando fui compilar o odcctools, ele reclamou do parâmetro -Wno-long-double. Abri o config.status (gerado pelo configure), localizei e removi este parâmetro, e aí compilou de boa;
*   Em mais de um ponto, os scripts da receita de bolo usam o atalho ~, ex.: ~/iphone/MacOSX10.4u.sdk. Isso deu problema aqui, mas troquei pelo nome completo &#8211; no exemplo e no meu micro ficaria /home/chester/iphone/MacOSX10.4u.sdk. Isso aconteceu no install-headers e na compilação final do llvm

O resultado final é um compilador que permitiu dar o build do [EDGE Switch][5] numa boa &#8211; a menos, claro, do meu makefile tosqueira, que tem n dependências de Mac, e isso só pra empacotar no formato do Installer. Mas isso eu arrumo fácil, o pior já foi.

 [1]: //chester.me/archives/2008/07/eee_pc_900_ubuntu.html
 [2]: http://code.google.com/p/iphone-dev/
 [3]: //chester.me/archives/2008/05/desenvolvimento_para_iphone_instalando_o_sdk.html
 [4]: http://jewclaw.net/2008/01/the-iphone-toolchain-for-linux/
 [5]: //chester.me/archives/2008/08/edge_switch.html
