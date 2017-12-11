---
title: Acertando o Horário de Verão em Java
excerpt: |
  |
    ATUALIZAÇÃO: O método sugerido aqui não lê a configuração de timezone do servidor (e, portanto, exige atualização a cada ano) . Se o seu servidor é Linux ou assemelhado, sugiro usar o timefix. Se você desenvolve aplicações Java para rodar...
layout: post
comments: true
permalink: /archives/2006/10/acertando_o_hor.html/
dsq_thread_id:
  - 1751450154
categories:
---
* * *

**<font color="red">ATUALIZAÇÃO:</font>** O método sugerido aqui não lê a configuração de timezone do servidor (e, portanto, exige atualização a cada ano) . Se o seu servidor é Linux ou assemelhado, sugiro usar o [timefix][1].</p>
* * *

<img title="Detalhe de uma propaganda do governo americano sobre horário de verão" align="right" src="//chester.me/archives/img/timezone.jpg" width="200" height="212" />Se você desenvolve aplicações Java para rodar em servidores, já deve ter se deparado com este problema: a máquina virtual nunca &#8220;acerta&#8221; o horário de verão, mesmo que você tenha configurado corretamente o *timezone* do sistema operacional do servidor para acertar o relógio.</p>
Este artigo aponta algumas soluções para o problema &#8211; incluindo uma que não exige recompilação de código e não se restringe à JVM da Sun.

<!--more-->

**Por que isso acontece?**

Dois dos meus vilões favoritos são os culpados deste quiproquó: o governo brasileiro e a Sun.

O governo muda a regra do horário a cada ano &#8211; em 2006, [a justificativa foram as urnas eletrônicas][2], e a questão é [historicamente complicada][3] no nosso país. Como dizia um administrador de sistemas que conheci, &#8220;no mundo todo o horário de verão é uma fórmula; no Brasil é uma lei&#8221;.

A Sun, por outro lado, deciciu que a máquina virtual Java deve gerenciar por si só todo o esquema de timezones, essencialmente ignorando o sistema hospedeiro (que se limita a informar o lugar onde o servidor se encontra e o horário UTC) &#8211; uma idéia razoável no passado, mas que desconsidera o fato de que Windows, Linux e tantos outros S.O.s modernos já resolvem este problema.

**Como eu resolvo?**

A solução comummente adotada é alterar o código para criar um timezone com as novas regras, e setá-lo como default. Por exemplo:

<div class="code">
        <pre class="java" style="font-family:monospace;"><span style="color: #000000; font-weight: bold;">import</span> <span style="color: #006699;">java.util.SimpleTimeZone</span><span style="color: #339933;">;</span>
<span style="color: #000000; font-weight: bold;">import</span> <span style="color: #006699;">java.util.TimeZone</span><span style="color: #339933;">;</span>
...
<span style="color: #003399;">TimeZone</span>.<span style="color: #006633;">setDefault</span><span style="color: #009900;">&#40;</span>
    <span style="color: #000000; font-weight: bold;">new</span> <span style="color: #003399;">SimpleTimeZone</span><span style="color: #009900;">&#40;</span>
        <span style="color: #003399;">TimeZone</span>.<span style="color: #006633;">getDefault</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span>.<span style="color: #006633;">getRawOffset</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span>,
            <span style="color: #0000ff;">"America/Sao_Paulo"</span>,
            <span style="color: #003399;">Calendar</span>.<span style="color: #006633;">NOVEMBER</span>,
            05,
            <span style="color: #cc66cc;"></span>,
            <span style="color: #cc66cc;">3600000</span><span style="color: #339933;">*</span><span style="color: #cc66cc;">1</span><span style="color: #339933;">+</span><span style="color: #cc66cc;">60000</span><span style="color: #339933;">*</span><span style="color: #cc66cc;"></span>,  <span style="color: #666666; font-style: italic;">// 01h00</span>
            <span style="color: #003399;">Calendar</span>.<span style="color: #006633;">FEBRUARY</span>,
            <span style="color: #cc66cc;">25</span>,
            <span style="color: #cc66cc;"></span>,
            <span style="color: #cc66cc;">3600000</span><span style="color: #339933;">*</span><span style="color: #cc66cc;">2</span><span style="color: #339933;">+</span><span style="color: #cc66cc;">60000</span><span style="color: #339933;">*</span><span style="color: #cc66cc;"></span>,  <span style="color: #666666; font-style: italic;">// 02h00</span>
            <span style="color: #cc66cc;">3600000</span><span style="color: #009900;">&#41;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span></pre>
</div>

Neste caso, ele está ajustando o horário de verão para iniciar em 05/Nov às 01h00 e terminar em 25/Fev às 02h00 (é preferível usar estes horários para evitar que a mudança de data bagunce outros processos, mas você pode começar/terminar à meia-noite, se preferir).

O problema é que você tem que chamar o código na incialização da aplicação. Se ela for uma aplicação stand-alone até que é fácil &#8211; no entanto, se ela residir em um web container (Tomcat, WebSphere, etc.) fica mais difícil. Fora que você tem que recompilar todas as aplicações a cada ano, o que nem sempre é desejável. Mas é um caminho.

**Outra solução: mexer na máquina virtual**

O Vitor Buitoni dá uma [solução coerente para o problema][4]: se a máquina virtual decide agir como um sistema operacional, vamos tratá-la como tal, e trocar a configuração de timezone nela também (brinde: um jeito bem esperto de fazer o Tomcat/WebSphere/qualquer web container executar a atualização sem precisar reiniciar).

Requer uma certa &#8220;pedalada&#8221;, pois o utilitário necessário para fazer a mudança (JavaZic) não é público, ele usa uma manobra para obter seu fonte e compilar. Além disso, ela se restringe à JVM da Sun. E também há quem alegue que a seção &#8220;Java Technology Restrictions&#8221; da licença da Sun para o runtime da máquina virtual se aplique neste caso (o [texto da versão 5.0][5] é menos restritivo, mas eu não sou advogado, então não me arrisco aqui).

Se nada disso te atrapalha, essa é a solução mais &#8220;limpinha&#8221;, sob o ponto de vista técnico, e eu recomendo.

**Um caminho intermediário**

Num antigo trabalho onde não era viável usar a solução do Buitoni nem alterar todas as aplicações, lancei mão de um expediente, que decidi publicar neste artigo: a criação de uma classe que faça o ajuste do timezone da JVM sem que tenhamos que alterar a aplicação a cada ano.

O código-fonte segue abaixo. Uma vez compilada e colocada no hv.jar (você pode usar o script Ant para fazer isto), você pode alterar o script de incialização do seu servidor para acessá-la. Suponhamos que, neste script, você tenha a chamada:

<code style="font-size:0.9em">&lt;br />
java -cp jar1.jar;jar2.jar ClassePrincipal arg1 arg2 arg3...&lt;br />
</code>

Basta adicionar a classe no classpath, e colocá-la antes da classe principal, i.e.:

<code style="font-size:0.9em">&lt;br />
java -cp &lt;font color=red>hv.jar;&lt;/font>jar1.jar;jar2.jar&nbsp;&lt;font color=red>br.inf.chester.hv.HorarioDeVerao&lt;/font>&nbsp;ClassePrincipal arg1 arg2 arg3...&lt;br />
</code>

Com isso, a máquina virtual irá chamar a classe para fazer o ajuste, e essa carregará o programa original, com os parâmetros originais.

O mais importante: **no ano seguinte, bastará gerar a nova versão do hv.jar, substitui-la no servidor e reiniciar**. Sem maiores complicações. Se preferir, você pode usar a classe apenas para centralizar os ajustes, chamando o método ajustaTimeZone() de dentro do seu código.

**Melhorias**

Seria bacana ter uma opção de hot-deployment, como na solução do Buitoni. Além disso, a classe poderia pegar os parâmetros do s.o. hospedeiro (dispensando a substituição anual, ao custo de não ser mais tão multiplataforma assim). Um dia desses eu faço essa mudança, mas quem quiser fica livre pra tentar.

**Listagem 1: HorarioDeVerao.java (classe que ajusta o Horário de Verão)**

<div class="code">
        <pre class="java" style="font-family:monospace;"><span style="color: #000000; font-weight: bold;">package</span> <span style="color: #006699;">br.inf.chester.hv</span><span style="color: #339933;">;</span>
&nbsp;
<span style="color: #666666; font-style: italic;">/*
 * Copyright © 2006 Carlos Duarte do Nascimento (Chester)
 * cd@pobox.com
 *
 * Este programa é um software livre; você pode redistribui-lo e/ou
 * modifica-lo dentro dos termos da Licença Pública Geral GNU como
 * publicada pela Fundação do Software Livre (FSF); na versão 2 da
 * Licença, ou (na sua opnião) qualquer versão.
 *
 * Este programa é distribuido na esperança que possa ser util,
 * mas SEM NENHUMA GARANTIA; sem uma garantia implicita de ADEQUAÇÂO
 * a qualquer MERCADO ou APLICAÇÃO EM PARTICULAR. Veja a Licença
 * Pública Geral GNU para maiores detalhes.
 *
 * Você deve ter recebido uma cópia da Licença Pública Geral GNU
 * junto com este programa, se não, escreva para a Fundação do Software
 * Livre(FSF) Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */</span>
&nbsp;
<span style="color: #000000; font-weight: bold;">import</span> <span style="color: #006699;">java.lang.reflect.InvocationTargetException</span><span style="color: #339933;">;</span>
<span style="color: #000000; font-weight: bold;">import</span> <span style="color: #006699;">java.lang.reflect.Method</span><span style="color: #339933;">;</span>
<span style="color: #000000; font-weight: bold;">import</span> <span style="color: #006699;">java.util.Calendar</span><span style="color: #339933;">;</span>
<span style="color: #000000; font-weight: bold;">import</span> <span style="color: #006699;">java.util.SimpleTimeZone</span><span style="color: #339933;">;</span>
<span style="color: #000000; font-weight: bold;">import</span> <span style="color: #006699;">java.util.TimeZone</span><span style="color: #339933;">;</span>
&nbsp;
<span style="color: #008000; font-style: italic; font-weight: bold;">/**
 * Permite que as aplicações Java ajustem o timezone da JVM para o horário de
 * verão do Brasil, de duas formas:
 * &lt;p&gt;
 * - Chamando o método &lt;code&gt;ajustaTimeZone()&lt;/code&gt;&lt;br&gt;
 * - Trocando a chamada da jvm, passando esta classe (que por sua vez irá chamar
 * a classe original), vide método &lt;code&gt;main&lt;/code&gt; abaixo.
 *
 * @author chester
 */</span>
&nbsp;
<span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">class</span> HorarioDeVerao <span style="color: #009900;">&#123;</span>
&nbsp;
	<span style="color: #008000; font-style: italic; font-weight: bold;">/**
	 * Timezone para o horário de verão de 2006 Inicio: 05/Nov; Fim: 25/Fev;
	 * Hora início: 01h00; Hora fim: 02h00
	 */</span>
	<span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">static</span> <span style="color: #003399;">TimeZone</span> tz <span style="color: #339933;">=</span> <span style="color: #000000; font-weight: bold;">new</span> <span style="color: #003399;">SimpleTimeZone</span><span style="color: #009900;">&#40;</span><span style="color: #003399;">TimeZone</span>.<span style="color: #006633;">getDefault</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span>
			.<span style="color: #006633;">getRawOffset</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span>, <span style="color: #0000ff;">"America/Sao_Paulo"</span>, <span style="color: #003399;">Calendar</span>.<span style="color: #006633;">NOVEMBER</span>, 05, <span style="color: #cc66cc;"></span>,
			<span style="color: #cc66cc;">3600000</span> <span style="color: #339933;">*</span> <span style="color: #cc66cc;">1</span> <span style="color: #339933;">+</span> <span style="color: #cc66cc;">60000</span> <span style="color: #339933;">*</span> <span style="color: #cc66cc;"></span>, <span style="color: #003399;">Calendar</span>.<span style="color: #006633;">FEBRUARY</span>, <span style="color: #cc66cc;">25</span>, <span style="color: #cc66cc;"></span>,
			<span style="color: #cc66cc;">3600000</span> <span style="color: #339933;">*</span> <span style="color: #cc66cc;">2</span> <span style="color: #339933;">+</span> <span style="color: #cc66cc;">60000</span> <span style="color: #339933;">*</span> <span style="color: #cc66cc;"></span>, <span style="color: #cc66cc;">3600000</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
	<span style="color: #008000; font-style: italic; font-weight: bold;">/**
	 * Seta o timezone da máquina virtual Java para o nosso timezone customizado
	 */</span>
	<span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">static</span> <span style="color: #000066; font-weight: bold;">void</span> ajustaTimeZone<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
		<span style="color: #003399;">TimeZone</span>.<span style="color: #006633;">setDefault</span><span style="color: #009900;">&#40;</span>tz<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
	<span style="color: #009900;">&#125;</span>
&nbsp;
	<span style="color: #008000; font-style: italic; font-weight: bold;">/**
	 * Ajusta o timezone e chama o método &lt;code&gt;main&lt;/code&gt; de uma classe.
	 * &lt;p&gt;
	 * A classe é determinada pelo primeiro parâmetro. Na prática, este método
	 * permite que se substitua:
	 * &lt;p&gt;
	 * &lt;code&gt;java minhaClasse p1 p2 p3 &lt;/code&gt;
	 * &lt;p&gt;
	 * por
	 * &lt;p&gt;
	 * &lt;code&gt;java HorarioDeVerao minhaClasse p1 p2 p3&lt;/code&gt;
	 * &lt;p&gt;
	 * e a classe será executada, só que sem problemas de horário
	 *
	 * @param args
	 *            Argumentos que serão passados para a classe
	 */</span>
	<span style="color: #000000; font-weight: bold;">public</span> <span style="color: #000000; font-weight: bold;">static</span> <span style="color: #000066; font-weight: bold;">void</span> main<span style="color: #009900;">&#40;</span><span style="color: #003399;">String</span> args<span style="color: #009900;">&#91;</span><span style="color: #009900;">&#93;</span><span style="color: #009900;">&#41;</span> <span style="color: #000000; font-weight: bold;">throws</span> <span style="color: #003399;">Throwable</span> <span style="color: #009900;">&#123;</span>
&nbsp;
		<span style="color: #666666; font-style: italic;">// Nome da classe cujo método main() queremos chamar</span>
		<span style="color: #003399;">String</span> nomeClasse <span style="color: #339933;">=</span> args<span style="color: #009900;">&#91;</span><span style="color: #cc66cc;"></span><span style="color: #009900;">&#93;</span><span style="color: #339933;">;</span>
&nbsp;
		<span style="color: #666666; font-style: italic;">// Vamos encontrar o método main</span>
		<span style="color: #003399;">Method</span> metodoMain<span style="color: #339933;">;</span>
&nbsp;
		<span style="color: #666666; font-style: italic;">// Cria um array cujo único elemento é a classe de um array</span>
		<span style="color: #666666; font-style: italic;">// de strings (já que main() recebe apenas um array de strings)</span>
		<span style="color: #000000; font-weight: bold;">Class</span><span style="color: #009900;">&#91;</span><span style="color: #009900;">&#93;</span> tiposArgs <span style="color: #339933;">=</span> <span style="color: #000000; font-weight: bold;">new</span> <span style="color: #000000; font-weight: bold;">Class</span><span style="color: #009900;">&#91;</span><span style="color: #cc66cc;">1</span><span style="color: #009900;">&#93;</span><span style="color: #339933;">;</span>
		tiposArgs<span style="color: #009900;">&#91;</span><span style="color: #cc66cc;"></span><span style="color: #009900;">&#93;</span> <span style="color: #339933;">=</span> <span style="color: #003399;">String</span><span style="color: #009900;">&#91;</span><span style="color: #009900;">&#93;</span>.<span style="color: #000000; font-weight: bold;">class</span><span style="color: #339933;">;</span>
&nbsp;
		<span style="color: #666666; font-style: italic;">// Cria um array de argumentos a passar para o método main</span>
		<span style="color: #666666; font-style: italic;">// cujo único elemento são os argumentos que recebemos</span>
		<span style="color: #666666; font-style: italic;">// (tirando o primeiro, que é o próprio nome da classe)</span>
		<span style="color: #003399;">Object</span><span style="color: #009900;">&#91;</span><span style="color: #009900;">&#93;</span> listaArgs <span style="color: #339933;">=</span> <span style="color: #000000; font-weight: bold;">new</span> <span style="color: #003399;">Object</span><span style="color: #009900;">&#91;</span><span style="color: #cc66cc;">1</span><span style="color: #009900;">&#93;</span><span style="color: #339933;">;</span>
		listaArgs<span style="color: #009900;">&#91;</span><span style="color: #cc66cc;"></span><span style="color: #009900;">&#93;</span> <span style="color: #339933;">=</span> removeElemento<span style="color: #009900;">&#40;</span>args, <span style="color: #cc66cc;"></span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
		<span style="color: #666666; font-style: italic;">// Acerta o timezone</span>
		ajustaTimeZone<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
		<span style="color: #666666; font-style: italic;">// Recupera a classe que ia ser executada originalmente</span>
		<span style="color: #666666; font-style: italic;">// e o seu método main</span>
		metodoMain <span style="color: #339933;">=</span> <span style="color: #000000; font-weight: bold;">Class</span>.<span style="color: #006633;">forName</span><span style="color: #009900;">&#40;</span>nomeClasse<span style="color: #009900;">&#41;</span>.<span style="color: #006633;">getDeclaredMethod</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"main"</span>,
				tiposArgs<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
		<span style="color: #666666; font-style: italic;">// Executa o método main, passando os argumentos que recebemos</span>
		<span style="color: #000000; font-weight: bold;">try</span> <span style="color: #009900;">&#123;</span>
			metodoMain.<span style="color: #006633;">invoke</span><span style="color: #009900;">&#40;</span><span style="color: #000066; font-weight: bold;">null</span>, listaArgs<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
		<span style="color: #009900;">&#125;</span> <span style="color: #000000; font-weight: bold;">catch</span> <span style="color: #009900;">&#40;</span><span style="color: #003399;">InvocationTargetException</span> ex<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
			<span style="color: #000000; font-weight: bold;">throw</span> ex.<span style="color: #006633;">getTargetException</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
		<span style="color: #009900;">&#125;</span>
	<span style="color: #009900;">&#125;</span>
&nbsp;
	<span style="color: #008000; font-style: italic; font-weight: bold;">/**
	 * Remove um elemento de um array de strings
	 *
	 * @param a
	 *            Array cujo elemento se quer remover
	 * @param pos
	 *            Posição do elemento a remover
	 * @return Array com o elemento removido
	 */</span>
	<span style="color: #000000; font-weight: bold;">private</span> <span style="color: #000000; font-weight: bold;">static</span> <span style="color: #003399;">String</span><span style="color: #009900;">&#91;</span><span style="color: #009900;">&#93;</span> removeElemento<span style="color: #009900;">&#40;</span><span style="color: #003399;">String</span><span style="color: #009900;">&#91;</span><span style="color: #009900;">&#93;</span> a, <span style="color: #000066; font-weight: bold;">int</span> pos<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
		<span style="color: #000000; font-weight: bold;">if</span> <span style="color: #009900;">&#40;</span>pos <span style="color: #339933;">&lt;</span> <span style="color: #cc66cc;"></span> <span style="color: #339933;">||</span> pos <span style="color: #339933;">&gt;=</span> a.<span style="color: #006633;">length</span><span style="color: #009900;">&#41;</span>
			<span style="color: #000000; font-weight: bold;">return</span> a<span style="color: #339933;">;</span>
		<span style="color: #003399;">String</span><span style="color: #009900;">&#91;</span><span style="color: #009900;">&#93;</span> aa <span style="color: #339933;">=</span> <span style="color: #000000; font-weight: bold;">new</span> <span style="color: #003399;">String</span><span style="color: #009900;">&#91;</span>a.<span style="color: #006633;">length</span> <span style="color: #339933;">-</span> <span style="color: #cc66cc;">1</span><span style="color: #009900;">&#93;</span><span style="color: #339933;">;</span>
		<span style="color: #000000; font-weight: bold;">if</span> <span style="color: #009900;">&#40;</span>pos <span style="color: #339933;">&gt;</span> <span style="color: #cc66cc;"></span><span style="color: #009900;">&#41;</span>
			<span style="color: #003399;">System</span>.<span style="color: #006633;">arraycopy</span><span style="color: #009900;">&#40;</span>a, <span style="color: #cc66cc;"></span>, aa, <span style="color: #cc66cc;"></span>, pos<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
		<span style="color: #000000; font-weight: bold;">if</span> <span style="color: #009900;">&#40;</span>pos <span style="color: #339933;">&lt;</span> a.<span style="color: #006633;">length</span> <span style="color: #339933;">-</span> <span style="color: #cc66cc;">1</span><span style="color: #009900;">&#41;</span>
			<span style="color: #003399;">System</span>.<span style="color: #006633;">arraycopy</span><span style="color: #009900;">&#40;</span>a, pos <span style="color: #339933;">+</span> <span style="color: #cc66cc;">1</span>, aa, pos, aa.<span style="color: #006633;">length</span> <span style="color: #339933;">-</span> pos<span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
		<span style="color: #000000; font-weight: bold;">return</span> aa<span style="color: #339933;">;</span>
	<span style="color: #009900;">&#125;</span>
&nbsp;
<span style="color: #009900;">&#125;</span></pre>
</div>

**Listagem 2: build.xml (exemplo de script para gerar o hv.jar)**

<div class="code">
        <pre class="xml" style="font-family:monospace;"><span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;?xml</span> <span style="color: #000066;">version</span>=<span style="color: #ff0000;">"1.0"</span> <span style="color: #000066;">encoding</span>=<span style="color: #ff0000;">"UTF-8"</span><span style="color: #000000; font-weight: bold;">?&gt;</span></span>
<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;project</span> <span style="color: #000066;">name</span>=<span style="color: #ff0000;">"hv"</span> <span style="color: #000066;">default</span>=<span style="color: #ff0000;">"gera_tudo"</span> <span style="color: #000066;">basedir</span>=<span style="color: #ff0000;">"."</span><span style="color: #000000; font-weight: bold;">&gt;</span></span>
&nbsp;
	<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;property</span> <span style="color: #000066;">name</span>=<span style="color: #ff0000;">"SOURCE"</span> <span style="color: #000066;">value</span>=<span style="color: #ff0000;">"src"</span> <span style="color: #000000; font-weight: bold;">/&gt;</span></span>	<span style="color: #808080; font-style: italic;">&lt;!-- onde ficam os fontes (.java) --&gt;</span>
	<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;property</span> <span style="color: #000066;">name</span>=<span style="color: #ff0000;">"BUILD"</span> <span style="color: #000066;">value</span>=<span style="color: #ff0000;">"temp"</span> <span style="color: #000000; font-weight: bold;">/&gt;</span></span>	<span style="color: #808080; font-style: italic;">&lt;!-- onde sao gerados os .class --&gt;</span>
&nbsp;
	<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;path</span> <span style="color: #000066;">id</span>=<span style="color: #ff0000;">"classpath"</span><span style="color: #000000; font-weight: bold;">&gt;</span></span>
		<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;pathelement</span> <span style="color: #000066;">path</span>=<span style="color: #ff0000;">"${java.class.path}"</span> <span style="color: #000000; font-weight: bold;">/&gt;</span></span>
	<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/path<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
&nbsp;
	<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;target</span> <span style="color: #000066;">name</span>=<span style="color: #ff0000;">"gera_tudo"</span> <span style="color: #000066;">description</span>=<span style="color: #ff0000;">"Compila todos os fontes e gera o jar"</span><span style="color: #000000; font-weight: bold;">&gt;</span></span>
		<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;delete</span> <span style="color: #000066;">dir</span>=<span style="color: #ff0000;">"${BUILD}"</span> <span style="color: #000000; font-weight: bold;">/&gt;</span></span>
		<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;mkdir</span> <span style="color: #000066;">dir</span>=<span style="color: #ff0000;">"${BUILD}"</span> <span style="color: #000000; font-weight: bold;">/&gt;</span></span>
		<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;javac</span> <span style="color: #000066;">srcdir</span>=<span style="color: #ff0000;">"${SOURCE}"</span> <span style="color: #000066;">destdir</span>=<span style="color: #ff0000;">"${BUILD}/"</span> <span style="color: #000066;">target</span>=<span style="color: #ff0000;">"1.3"</span></span>
<span style="color: #009900;">			<span style="color: #000066;">source</span>=<span style="color: #ff0000;">"1.3"</span><span style="color: #000000; font-weight: bold;">&gt;</span></span>
			<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;classpath</span> <span style="color: #000066;">refid</span>=<span style="color: #ff0000;">"classpath"</span> <span style="color: #000000; font-weight: bold;">/&gt;</span></span>
		<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/javac<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
		<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;jar</span> <span style="color: #000066;">jarfile</span>=<span style="color: #ff0000;">"hv.jar"</span> <span style="color: #000066;">basedir</span>=<span style="color: #ff0000;">"${BUILD}"</span><span style="color: #000000; font-weight: bold;">&gt;</span></span>
		<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/jar<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
		<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;delete</span> <span style="color: #000066;">dir</span>=<span style="color: #ff0000;">"${BUILD}"</span> <span style="color: #000000; font-weight: bold;">/&gt;</span></span>
	<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/target<span style="color: #000000; font-weight: bold;">&gt;</span></span></span>
&nbsp;
<span style="color: #009900;"><span style="color: #000000; font-weight: bold;">&lt;/project<span style="color: #000000; font-weight: bold;">&gt;</span></span></span></pre>
</div>

 [1]: //chester.me/archives/2007/02/timefix.html
 [2]: http://noticias.uol.com.br/ultnot/reuters/2006/08/14/ult27u57276.jhtm
 [3]: //chester.me/archives/2005/10/horario_de_vera.html
 [4]: http://www.javafree.org/javabb/viewtopic.jbb?t=12070
 [5]: http://www.java.com/en/download/license.jsp
