---
title: 'Desenvolvimento para iPhone: instalando o toolchain'
excerpt: |
  |
    A capacidade de hardware e software já fazem do iPhone uma plataforma atrativa para criar aplicativos. É difícil falar em número de usuários no Brasil - oficialmente são zero, tem relatório dizendo que são um mol. Mas o fato é...
layout: post
comments: true
permalink: /archives/2008/05/desenvolvimento_para_iphone_instalando_o_sdk.html
dsq_thread_id:
  - 1751449548
categories:
---
<span class="mt-enclosure mt-enclosure-image"><img alt="iphone" src="//chester.me/archives/img/iphone_review%282%29.jpg" width="150" height="200" class="mt-image-right" style="float: right; margin: 0 0 20px 20px;" /></span>A capacidade de hardware e software já fazem do iPhone uma plataforma atrativa para criar aplicativos. É difícil falar em número de usuários no Brasil &#8211; oficialmente são zero, tem [relatório][1] dizendo que são um mol. Mas o fato é que os aparelhos são populares entre os formadores de opinião (basta observar a enxurrada deles em qualquer evento sobre web), o que garante um público no mínimo interessante.

Este post dá uma visão superficial das alternativas para desenvolvimento mais populares e documenta as dificuldades que encontrei para colocar no meu Mac o conjunto de ferramentas livres que permite compilar aplicações.

Existem (pelo menos) três caminhos para construir aplicações para o iPhone:

*   **iPhone Web Apps**
    A idéia é usar tecnologias web (HTML, JavaScript, CSS, AJAX, server-side scripts, etc.), hospedando as aplicações remotamente e rodando via Mobile Safari. Existem [guidelines oficiais][2], livros (gostei [deste][3]) e pelo menos dois frameworks ([iUI][4] e [jPint][5]) que ajudam a tornar as aplicações web parecidas com as nativas &#8211; os [resultados][6] são surpreendentemente bons.

    As desvantagens são as mesmas de qualquer aplicação web: acesso limitado ao sistema (dá pra saber se o fone está em pé ou deitado, fazer chamadas e acessar o Maps, mas não tem como ler o acelerômetro ou acionar o iPod, entre outras coisas) e a necessidade de estar online para usar a app (agravada no Brasil, onde a cobertura de WiFi é mais restrita e os planos de dados tornam caro usar o EDGE).

    A facilidade de desenvolvimento, distribuição e instalação falam alto, tornando este caminho uma excelente opção para aplicações de uso casual, ou que dependam fortemente de recursos online (agregadores de dados, clientes/front-ends para sites e assemelhados).</li>

    *   **Apple iPhone SDK**</p>
        O [SDK da Apple][7] é tentador: o beta é baseado numa IDE amigável (XCode), e gera aplicações que irão rodar em qualquer iPhone &#8211; quando for lançado definitivamente. O mais provável é que elas sejam distribuídas via iTunes, viabilizando a venda de software a baixo custo.

        Nem tudo são flores: é preciso se familiarizar com Objective C, e tudo o que for desenvolvido tem que ser aprovado pela Apple &#8211; que impõe [restrições][8] técnicas (nada de processos em segundo plano) e de domínio (p0rn está vetado). Além disso, o XCode só roda em Mac, e (o problema mais sério): ainda não é possível distribuir as aplicações.</li>

        *   **iphone-dev toolchain + installer.app**</p>
            O [Installer][9] é uma aplicação conhecida de que tem iPhone desbloqueado: ele permite localizar e instalar centenas de pacotes de software gratuito (boa parte sendo software livre). Estes programas são criados, em sua maioria, através do iphone-dev toolchain &#8211; um kit baseado em ferramentas livres para desenvolvimento UNIX (essencialmente gcc/make, usando [llvm][10] para viabilizar a [compilação cruzada][11]) e empacotados em um [formato que o Installer.app entende][12].

            A única restrição é que o usuário tem que ter um iPhone [desbloqueado][13]. Você também fica sujeito ao esquema de distribuição do Installer &#8211; um pequeno risco a correr, mas é razoável crer que continuará funcionando no futuro, e que será menos restrito que a proposta da Apple. </li> </ul>
            Para começar a brincar eu optei pela terceira via. É um caminho meio tortuoso, já que é preciso baixar/compilar todo o software do qual o iphone-dev depende. Na real eu descobri (meio tardiamente) que é possível baixar o [toolchain pré-compilado para Mac OS X Leopard][14] &#8211; mas compilar ainda é o único caminho para quem usa Windows/Linux/Mac OS X Tiger.

            Teoricamente basta seguir o [passo-a-passo oficial][15] &#8211; na prática, a teoria é outra. Por exemplo, eu já tinha o llvm instalado via [DarwinPorts][16], mas a ferramenta exige uma versão em particular, então tive que desinstalar primeiro. Da mesma forma, para compilar o odcctools foi preciso prestar atenção ao [issue 31][17]. De fato, a [lista de issues][18] ajuda um bocado nessas horas.

            O link que informa como obter uma cópia do sistema de arquivos do iPhone está quebrado. Um método razoável é baixar da Apple, só que é preciso des-criptografar, seguindo [estas instruções][19]. Outra alternativa é copiar instalando o [OpenSSH][20] e usando o scp a partir do micro, na forma <span class="dp-highlighter">scp -Cr root@ip.do.seu.iphone:/Diretório .</span>, para cada diretório desejado). Tive que fazer isso para um ou dois arquivos que deram problema com o outro esquema.

            Por falar em OpenSSH, eu achei meio sinistro ter um servidor ssh rodando sendo que as senhas dos dois usuários (mobile e root) são as mesmas em todos os iPhones, e resolvi mudar. **NÃO FAÇA ISSO!** &#8211; o aparelho entoru em loop (provavelmente o [SpringBoard][21] ou algum programa dependente tem uma chave de login chumbada, e usar o [passwd][22] atropela ela), e pra voltar só [restaurando o /etc/passwd][23] original &#8211; o que só foi possível porque o OpenSSH estava lá.

            Um ponto que me assusta um pouco no passo-a-passo é um certo excesso de [sudo][24]. E não sei exatamente o que eu fiz de errado, mas algum desses passos sobrescreveu um arquivo de sistema do meu Mac (era um binário universal que passou a só ter o código ARM), deixando o micro inutilizado até que eu dei boot pelo DVD de instalação (nem o boot single-mode funcionava mais) e copiei o arquivo de volta. Esteja preparado para este tipo de problema.

            A última parte (que é o build final dos binários) enroscou por conta de algum problema acontecido na criação dos headers. Até consegui concluir o processo copiando alguns .h do SDK beta do iPhone, mas ao tentar dar build das aplicações novos problemas eram encontrados. Solução: baixei o [toolchain pré-compilado][14] e copiei o diretório de headers dele sobre o meu.

            Com isso foi possível compilar um [hello world básico][25] e rodar no telefone. Ainda é preciso empacotar para o Installer, mas isso é uma segunda fase.

            Agora é só programar! :-)

            **UPDATE:** O kit também funciona direitinho no Linux ([Ubuntu 8.04 num Eee PC][26]). Eu segui este outro [guia passo-a-passo][27] e a coisa rolou praticamente sem problemas (os poucos que tive estão documentados nos comentários do guia).

 [1]: http://www.coxacreme.com.br/2008/03/11/iphone/
 [2]: http://developer.apple.com/webapps/
 [3]: http://www.amazon.com/Professional-iPhone-iPod-touch-Programming/dp/0470251557
 [4]: http://code.google.com/p/iui/
 [5]: http://www.journyx.com/jpint/
 [6]: http://iphoneappsmanager.com/
 [7]: http://developer.apple.com/iphone/
 [8]: http://www.techcrunch.com/2008/03/07/iphone-sdk-some-of-the-details-arent-great/
 [9]: http://www.appleiphoneschool.com/installerapp/
 [10]: http://llvm.org/
 [11]: http://en.wikipedia.org/wiki/Cross_compiler
 [12]: http://iphone.nullriver.com/beta/
 [13]: http://www.techradar.com/news/audio/portable-audio/jailbreak-the-iphone-hacking-story-153739
 [14]: http://www.zdziarski.com/iphone/
 [15]: http://code.google.com/p/iphone-dev/wiki/Building
 [16]: http://darwinports.com/
 [17]: http://code.google.com/p/iphone-dev/issues/detail?id=31
 [18]: http://code.google.com/p/iphone-dev/issues/list
 [19]: http://tungchingkai.blogspot.com/2008/01/decrypt-iphone-filesystem-firmware_28.html
 [20]: http://blog.psmxy.org/pkg-info/openssh/
 [21]: http://en.wikipedia.org/wiki/Springboard_%28iPhone%29
 [22]: http://pt.wikipedia.org/wiki/Passwd
 [23]: http://blog.matsimitsu.nl/english/183/howto-fix-the-edit-home-screen-loop-for-iphone
 [24]: http://pt.wikipedia.org/wiki/Sudo
 [25]: http://www.oreillynet.com/mac/blog/2007/08/a_simpler_hello_world_for_the.html
 [26]: //chester.me/archives/2008/07/eee_pc_900_ubuntu.html
 [27]: http://jewclaw.net/2008/01/the-iphone-toolchain-for-linux/
