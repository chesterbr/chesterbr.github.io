---
title: EDGE Switch
excerpt: |
  |
    O EDGE Switch é um programa que desenvolvi para o iPhone com o objetivo de bloquear/liberar a conexão de dados da operadora (EDGE). Isso é necessário porque o sistema operacional da Apple assume que o seu plano de dados é...
layout: post
comments: true
permalink: /archives/2008/08/edge_switch.html/
dsq_thread_id:
  - 1751450048
categories:
  - Portfolio
---
<span class="mt-enclosure mt-enclosure-image"><img src="//chester.me/archives/img/on.png" width="57" height="59" class="mt-image-right right alignright" /></span>O EDGE Switch é um programa que desenvolvi para o iPhone com o objetivo de bloquear/liberar a conexão de dados da operadora ([EDGE][1]). Isso é necessário porque o sistema operacional da Apple assume que o seu plano de dados é generoso e usa esta conexão sem perguntar quando não encontra uma rede sem fio.

**UPDATE**: Este programa foi criado no início dos tempos do iPhone, quando mal existia SDK oficial. Ele não foi testado com o OS 2.x/3.x, e com certeza existem alternativas melhores (como o SBSettings) para fazer isso hoje. Mas o código-fonte permanece online para fins de curiosidade e para ilustrar o mínimo do mínimo que a parte não-visual de uma aplicação iPhone tem que ter.
<!--more-->

Existem outras formas de bloquear esta conexão ([Boss Prefs][2], [alteração manual da configuração][3], etc.), mas nenhuma me atendia. As vantagens do EDGE Switch são:

*   Ele mostra o status (bloqueado/desbloqueado) no próprio ícone, na tela principal do iPhone;
*   Para mudar o estado, basta um toque no ícone, sem burocracia;
*   A configuração não se perde ao reiniciar.

A grande desvantagem: ele reinicia o telefone para bloquear/liberar. Não é tão ruim assim (o reinício é rápido), mas se isso for um problema, talvez este software não seja para você.

O [código-fonte][4] está disponível sob a licença GPL. Os ícones são mais um excelente trabalho do [Felippo][5].

**Instalação, Uso e Remoção**

Para instalar, é preciso ter o iPhone liberado para instalar aplicativos de terceiros. No Installer, entre em &#8220;Sources&#8221; e adicione o meu repositório: <font face="courier">//chester.me/iphone</font>. Com isso o programa vai aparecer na categoria &#8220;Utilities&#8221;.

Depois de instalar ou atualizar o software, você verá o ícone amarelo. Clique uma vez nele, e o fone irá reiniciar, mostrando o ícone vermelho (EDGE bloqueado) ou o azul (EDGE liberado).

Não é preciso entrar no programa para saber se o EDGE está bloqueado ou liberado &#8211; é só olhar o ícone (que reflete o estado em que o programa deixou o iPhone na última vez em que foi chamado).

**IMPORTANTE:** Antes de remover o programa, certifique-se de que o EDGE está liberado (ícone azul). Se você remover com o EDGE desligado, vai ter que reinstalar pra ligar (ou remover manualmente).

**Funcionamento e Limitações**

O que o programa faz é automatizar o procedimento de entrar nos menus e invalidar/revalidar a configuração do EDGE (colocando ou retirando um &#8220;[off]&#8221; no final do endereço APN). A parte mais chata é que ele reinicia o telefone (porque eu não consegui fazer o iPhone reconhecer a mudança de outra forma &#8211; se alguém souber como, me fale ou altere no [código-fonte][6]).

Ele foi testado com o firmware 1.1.4, e imagino que funcione em versões anteriores sem problemas (mas não testei). Também não foi testado ainda no 2.0, e não tenho certeza se funcionará (por conta das mudanças introduzidas para suportar conexões 3G). Procurei ser extremamente conservador ao editar o arquivo, abortando a operação ao primeiro sinal de diferenças com o que eu tenho no meu telefone, mas o uso é por sua conta e risco.

**Avisos Legais**

Ele foi feito para uso pessoal, e disponibilizado na esperança de que possa ser útil, mas SEM NENHUMA GARANTIA; sem uma garantia implicita de ADEQUAÇÂO a qualquer MERCADO ou APLICAÇÃO EM PARTICULAR. Em particular não me responsabilizo se ele não tiver o efeito desejado, ou apresentar qualquer incompatibilidade com o seu aparelho ou sistema operacional. Veja a Licença Pública Geral GNU para maiores detalhes.

Este programa é um software livre; você pode redistribui-lo e/ou modifica-lo dentro dos termos da Licença Pública Geral GNU como publicada pela Fundação do Software Livre (FSF); na versão 3 da Licença, ou (na sua opnião) qualquer versão.

 [1]: http://pt.wikipedia.org/wiki/EDGE
 [2]: http://code.google.com/p/bossprefs/
 [3]: http://tinyurl.com/5jn6lg
 [4]: http://sourceforge.net/projects/edgeswitch/
 [5]: http://felippo.net
 [6]: http://edgeswitch.svn.sourceforge.net/viewvc/edgeswitch/trunk/EDGESwitch/src/edgeswitch.m?revision=2&view=markup
