---
title: SlideMeme
layout: post
comments: true
permalink: /archives/2010/03/slidememe.html/
robotsmeta:
  - index,follow
onswipe_thumb:
  - |
    http://img.youtube.com/vi/nBhz7hPWTwA">Bani explicando e demonstrando a coisa toda em dois minutos</a> cravados no relógio - uma proeza digna de nota), e, claro, continue lendo este post.

    Tivemos a idéia olhando para os <a href="http://meme.yahoo.com/popular/now/all/pt/">Memes mais populares</a>: ali predominam as fotos e ilustrações "fofinhas" no mesmo estilo daquelas que recebemos por email das tias e mães, invariavelmente no formato do Microsoft PowerPoint (.ppt). Como o SlideShare é o site-referência para a publicação de apresentações neste e em outros formatos (à semelhança do que o YouTube se tornou para arquivos de vídeo), foi natural evoluir o conceito nessa direção.

    Claro que as pessoas podem simplesmente copiar e colar o endereço do SlideShare num post, mas o Meme funciona melhor com mídias visuais (a maior prova disso é a quase ausência de MP3). Na nossa cabeça, o leitor teria que ver algo que o estimulasse a clicar, à semelhança do que ocorre com vídeos e fotos maiores. Além disso, podíamos usar a idéia de <a href="http://www.bookmarklets.com/">bookmarklet</a> (que deu certo no <a href="http://memethis.com">MemeThis</a>) para simplificar o processo de copiar e colar.

    Após tentativas infrutíferas de embutir o player do SlideShare em um post de texto, decidimos converter as apresentações para algum formato que o Meme suportasse. Ficamos entre o vídeo (que permitiria um controle limitado de navegação, mas ficaria pesado) e o GIF animado (que é muito eficiente para dar uma amostra de alguns slides). Optamos pelo último, e não nos arrependemos.

    O próximo passo seria analisar o formato das apresentações do SlideShare. Além de uma <a href="http://developer.yahoo.com/yql/console/?q=desc%20slideshare.transcript/0.jpg
dsq_thread_id:
  - 1751447054
categories:
  - Portfolio
---
[<img src="//farm5.static.flickr.com/4063/4454847693_9c02af3d47_m.jpg" width="240" height="159" alt="Bani and ChesterBR @ Yahoo! Open Hack Day Brasil 2010" style="float:left; margin-right:6px; margin-bottom:4px; border:1px solid black;" />][1]O [SlideMeme][2] foi hack que eu e a [Bani][3] apresentamos no [Yahoo! Open Hack Day Brasil 2010][4]. O objetivo dele é oferecer uma forma visualmente agradável e conveniente para postar apresentações do [SlideShare][5] no [Yahoo! Meme][6], e claro que ficamos **muito** contentes por ele ter sido premiado como [melhor hack na categoria Meme][7]!
<!--more-->


**UPDATE**:Um dos grandes problemas que o hack teve foi o fato de ser baseado num componente ActiveX, o que exigia um servidor Windows &#8211; para o qual nós não tínhamos recursos (ou vontade) para manter no ar. Em Jun/2010 eu reescrevi a parte da conversão usando swftools e dei uma condensada na coisa toda, centralizando o back-end em [um único script][8]. O post foi mantido, pois os detalhes de funcionamento ainda valem, mas a [última versão de tudo][9] está no github para quem quiser.

<del datetime="2010-06-04T16:38:55+00:00">Mas eu falo do evento em outro post &#8211; esse aqui é para documentar o processo e publicar o código do hack (<del datetime="2010-04-22T17:12:39+00:00">até o final vai ficar claro que ele é curto e grosso demais para merecer um github/sourceforge, e que o maior valor está em detalhar o que foi feito e como</del>). <strong>UPDATE</strong>: com o fim do experimento, <a href="http://github.com/chesterbr/SlideMeme">o código fonte está disponível no github</a>, incluindo os arquivos do site.</del>

Para saber mais, veja a [apresentação no SlideShare][10], assista à [Bani explicando e demonstrando a coisa toda em dois minutos][11] cravados no relógio &#8211; uma proeza digna de nota), e, claro, continue lendo este post.

Tivemos a idéia olhando para os [Memes mais populares][12]: ali predominam as fotos e ilustrações &#8220;fofinhas&#8221; no mesmo estilo daquelas que recebemos por email das tias e mães, invariavelmente no formato do Microsoft PowerPoint (.ppt). Como o SlideShare é o site-referência para a publicação de apresentações neste e em outros formatos (à semelhança do que o YouTube se tornou para arquivos de vídeo), foi natural evoluir o conceito nessa direção.

Claro que as pessoas podem simplesmente copiar e colar o endereço do SlideShare num post, mas o Meme funciona melhor com mídias visuais (a maior prova disso é a quase ausência de MP3). Na nossa cabeça, o leitor teria que ver algo que o estimulasse a clicar, à semelhança do que ocorre com vídeos e fotos maiores. Além disso, podíamos usar a idéia de [bookmarklet][13] (que deu certo no [MemeThis][14]) para simplificar o processo de copiar e colar.

Após tentativas infrutíferas de embutir o player do SlideShare em um post de texto, decidimos converter as apresentações para algum formato que o Meme suportasse. Ficamos entre o vídeo (que permitiria um controle limitado de navegação, mas ficaria pesado) e o GIF animado (que é muito eficiente para dar uma amostra de alguns slides). Optamos pelo último, e não nos arrependemos.

O próximo passo seria analisar o formato das apresentações do SlideShare. Além de uma [tabela YQL][15], o serviço possui uma [API][16] que revela algumas informações sobre as apresentações, mas não permite recuperar slides individuais. Pensamos em colocar um sniffer/proxy no meio do caminho e ver como o player recupera cada slide, mas Hasin Hayder [teve a idéia primeiro][17] e já deixou um script PHP prontinho, que gerava a URL de cada slide.

Nossa surpresa foi perceber que os slides **não** são arquivos de imagem: cada um deles é um arquivinho Flash (.swf), que o player do SlideShare embute. Converter isso para um GIF é bem mais complicado do que pode parecer. A maior parte das soluções para isso [depende de um browser][18] e/ou [exige uma sessão X rodando][19] &#8211; o que tornaria difícil escalar (e até mesmo hospedar de forma barata).

Achamos um software que conversava direto com o Flash para fazer isso, o [SWF To Image ActiveX Freeware Library][20], cujo nome já ilustra as duas coisas que não nos agradam nele: não é open source e exige um servidor Windows. Entretanto, ele funciona muito bem, e entre os amigos e a [cloud][21], não é impossível arrumar um servidor pra fazer o hack funcionar, então mandamos ver. Com um ASP minimalista disponibilizamos sua funcionalidade num serviço web, que recebe a URL de um .swf e devolve o primeiro (único no nosso caso) slide em .gif:

<div class="code">
        <pre class="asp" style="font-family:monospace;">    strFileURL <span style="color: #006600; font-weight: bold;">=</span> <span style="color: #990099; font-weight: bold;">Request</span>.<span style="color: #330066;">QueryString</span><span style="color: #006600; font-weight:bold;">&#40;</span><span style="color: #cc0000;">"url"</span><span style="color: #006600; font-weight:bold;">&#41;</span>
    <span style="color: #990099; font-weight: bold;">if</span> <span style="color: #990099; font-weight: bold;">Request</span>.<span style="color: #330066;">ServerVariables</span><span style="color: #006600; font-weight:bold;">&#40;</span><span style="color: #cc0000;">"REMOTE_ADDR"</span><span style="color: #006600; font-weight:bold;">&#41;</span><span style="color: #006600; font-weight: bold;">&lt;&gt;</span><span style="color: #cc0000;">"ip.of.the.php.server"</span> <span style="color: #990099; font-weight: bold;">Then</span>
        <span style="color: #990099; font-weight: bold;">Response</span>.<span style="color: #330066;">Write</span><span style="color: #006600; font-weight:bold;">&#40;</span><span style="color: #cc0000;">"Invalid Caller"</span><span style="color: #006600; font-weight:bold;">&#41;</span>
        <span style="color: #990099; font-weight: bold;">Response</span>.<span style="color: #990099; font-weight: bold;">End</span>
    <span style="color: #990099; font-weight: bold;">End</span> <span style="color: #990099; font-weight: bold;">If</span>
&nbsp;
    <span style="color: #990099; font-weight: bold;">Set</span> SWFToImage <span style="color: #006600; font-weight: bold;">=</span> <span style="color: #330066;">CreateObject</span><span style="color: #006600; font-weight:bold;">&#40;</span><span style="color: #cc0000;">"SWFToImage.SWFToImageObject"</span><span style="color: #006600; font-weight:bold;">&#41;</span>
    SWFToImage.<span style="color: #9900cc;">InitLibrary</span> <span style="color: #cc0000;">"demo"</span>, <span style="color: #cc0000;">"demo"</span>
    SWFToImage.<span style="color: #9900cc;">InputSWFFileName</span> <span style="color: #006600; font-weight: bold;">=</span> strFileUrl
    SWFToImage.<span style="color: #9900cc;">FrameIndex</span><span style="color: #006600; font-weight: bold;">=</span><span style="color: #800000;"></span>
    SWFToImage.<span style="color: #9900cc;">ImageOutputType</span> <span style="color: #006600; font-weight: bold;">=</span> <span style="color: #800000;">2</span> <span style="color: #008000;">' (GIF)</span>
    SWFToImage.<span style="color: #330066;">Execute</span>
&nbsp;
    <span style="color: #990099; font-weight: bold;">Response</span>.<span style="color: #330066;">ContentType</span> <span style="color: #006600; font-weight: bold;">=</span> <span style="color: #cc0000;">"image/gif"</span>
    <span style="color: #990099; font-weight: bold;">Response</span>.<span style="color: #330066;">BinaryWrite</span><span style="color: #006600; font-weight:bold;">&#40;</span>SWFToImage.<span style="color: #9900cc;">BinaryImage</span><span style="color: #006600; font-weight:bold;">&#41;</span>
    <span style="color: #990099; font-weight: bold;">Set</span> SWFToImage <span style="color: #006600; font-weight: bold;">=</span> <span style="color: #0000ff; font-weight: bold;">Nothing</span></pre>
</div>

Fazendo dessa forma, essa parte fica isolada para o dia em que conseguirmos outra solução (o [Gnash][22] é bastante promissor &#8211; a versão dev já tem a opção de screenshot). Com isso, restou a tarefa de juntar os slides usando o [ImageMagick][23] &#8211; optamos por fazer isso no mesmo PHP que identifica a URL de cada um deles e chama o serviço acima para converetr um a um (e manter esse PHP no mesmo host, para otimizar):

<div class="code">
        <pre class="php" style="font-family:monospace;">    <span style="color: #000088;">$CONVERT</span> <span style="color: #339933;">=</span> <span style="color: #0000ff;">"
"</span><span style="color: #339933;">;</span>
    <span style="color: #000088;">$URL_PREFIX</span> <span style="color: #339933;">=</span> <span style="color: #0000ff;">"http://img.slide.memethis.com/"</span><span style="color: #339933;">;</span>
    <span style="color: #000088;">$ASP_HOST</span> <span style="color: #339933;">=</span> <span style="color: #0000ff;">""</span><span style="color: #339933;">;</span>
&nbsp;
    <span style="color: #000088;">$slideshowUrl</span> <span style="color: #339933;">=</span> <span style="color: #000088;">$_REQUEST</span><span style="color: #009900;">&#91;</span><span style="color: #0000ff;">"url"</span><span style="color: #009900;">&#93;</span><span style="color: #339933;">;</span>
    <span style="color: #b1b100;">if</span> <span style="color: #009900;">&#40;</span><span style="color: #990000;">strpos</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$slideshowUrl</span><span style="color: #339933;">,</span> <span style="color: #0000ff;">"http://www.slideshare.net/"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">!==</span><span style="color: #cc66cc;"></span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
        <span style="color: #990000;">die</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"Invalid parameter"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #009900;">&#125;</span>
    <span style="color: #000088;">$slideshowPageContent</span> <span style="color: #339933;">=</span> <span style="color: #990000;">file_get_contents</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$slideshowUrl</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #000088;">$pattern</span> <span style="color: #339933;">=</span> <span style="color: #0000ff;">"~doc=([\w-]+)~"</span><span style="color: #339933;">;</span>
    <span style="color: #990000;">preg_match</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$pattern</span><span style="color: #339933;">,</span><span style="color: #000088;">$slideshowPageContent</span><span style="color: #339933;">,</span><span style="color: #000088;">$matches</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #000088;">$xmlurl</span> <span style="color: #339933;">=</span> <span style="color: #0000ff;">"http://s3.amazonaws.com/slideshare/<span style="color: #006699; font-weight: bold;">{$matches[1]}</span>.xml"</span><span style="color: #339933;">;</span>
    <span style="color: #990000;">preg_match</span><span style="color: #009900;">&#40;</span><span style="color: #0000ff;">'/\(.*)\&lt;\/title\&gt;/'</span><span style="color: #339933;">,</span><span style="color: #000088;">$slideshowPageContent</span><span style="color: #339933;">,</span><span style="color: #000088;">$matches</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #000088;">$title</span> <span style="color: #339933;">=</span> <span style="color: #000088;">$matches</span><span style="color: #009900;">&#91;</span><span style="color: #cc66cc;">1</span><span style="color: #009900;">&#93;</span><span style="color: #339933;">;</span>
&nbsp;
    <span style="color: #000088;">$sxml</span> <span style="color: #339933;">=</span> <span style="color: #990000;">simplexml_load_file</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$xmlurl</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
    <span style="color: #000088;">$tempprefix</span> <span style="color: #339933;">=</span> <span style="color: #0000ff;">"img/img"</span><span style="color: #339933;">.</span><span style="color: #990000;">uniqid</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #000088;">$i</span> <span style="color: #339933;">=</span> <span style="color: #cc66cc;">1</span><span style="color: #339933;">;</span>
    <span style="color: #b1b100;">foreach</span> <span style="color: #009900;">&#40;</span><span style="color: #000088;">$sxml</span><span style="color: #339933;">-&</span>gt<span style="color: #339933;">;</span>Slide <span style="color: #b1b100;">as</span> <span style="color: #000088;">$slide</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
        <span style="color: #000088;">$filename</span> <span style="color: #339933;">=</span> <span style="color: #000088;">$tempprefix</span> <span style="color: #339933;">.</span> <span style="color: #000088;">$i</span> <span style="color: #339933;">.</span> <span style="color: #0000ff;">".gif"</span><span style="color: #339933;">;</span>
        <span style="color: #000088;">$ch</span> <span style="color: #339933;">=</span> <span style="color: #990000;">curl_init</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$ASP_HOST</span> <span style="color: #339933;">.</span> <span style="color: #0000ff;">"swf2gif.asp?url="</span> <span style="color: #339933;">.</span> <span style="color: #000088;">$slide</span><span style="color: #009900;">&#91;</span><span style="color: #0000ff;">'Src'</span><span style="color: #009900;">&#93;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
        <span style="color: #000088;">$fp</span> <span style="color: #339933;">=</span> <span style="color: #990000;">fopen</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$filename</span><span style="color: #339933;">,</span> <span style="color: #0000ff;">"w"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
        <span style="color: #990000;">curl_setopt</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$ch</span><span style="color: #339933;">,</span> CURLOPT_FILE<span style="color: #339933;">,</span> <span style="color: #000088;">$fp</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
        <span style="color: #990000;">curl_setopt</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$ch</span><span style="color: #339933;">,</span> CURLOPT_HEADER<span style="color: #339933;">,</span> <span style="color: #cc66cc;"></span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
        <span style="color: #990000;">curl_exec</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$ch</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
        <span style="color: #990000;">curl_close</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$ch</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
        <span style="color: #990000;">fclose</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$fp</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
        <span style="color: #000088;">$i</span><span style="color: #339933;">++;</span>
        <span style="color: #b1b100;">if</span> <span style="color: #009900;">&#40;</span><span style="color: #000088;">$i</span><span style="color: #339933;">&</span>gt<span style="color: #339933;">;</span><span style="color: #cc66cc;">5</span><span style="color: #009900;">&#41;</span> <span style="color: #b1b100;">break</span><span style="color: #339933;">;</span>
    <span style="color: #009900;">&#125;</span>
&nbsp;
    <span style="color: #000088;">$cmd</span> <span style="color: #339933;">=</span> <span style="color: #000088;">$CONVERT</span><span style="color: #339933;">.</span><span style="color: #0000ff;">" -delay 200 -loop 0 "</span><span style="color: #339933;">.</span><span style="color: #000088;">$tempprefix</span><span style="color: #339933;">.</span><span style="color: #0000ff;">"*.gif img/end.gif "</span><span style="color: #339933;">.</span><span style="color: #000088;">$tempprefix</span><span style="color: #339933;">.</span><span style="color: #0000ff;">".gif"</span><span style="color: #339933;">;</span>
    <span style="color: #000088;">$WshShell</span> <span style="color: #339933;">=</span> <span style="color: #000000; font-weight: bold;">new</span> COM<span style="color: #009900;">&#40;</span><span style="color: #0000ff;">"WScript.Shell"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #000088;">$output</span> <span style="color: #339933;">=</span> <span style="color: #000088;">$WshShell</span><span style="color: #339933;">-&</span>gt<span style="color: #339933;">;</span><span style="color: #990000;">Exec</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$cmd</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">-&</span>gt<span style="color: #339933;">;</span>StdOut<span style="color: #339933;">-&</span>gt<span style="color: #339933;">;</span>ReadAll<span style="color: #339933;">;</span>
&nbsp;
    <span style="color: #b1b100;">for</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$i</span><span style="color: #339933;">=</span><span style="color: #cc66cc;">1</span><span style="color: #339933;">;</span> <span style="color: #000088;">$i</span><span style="color: #339933;">&</span>lt<span style="color: #339933;">;=</span><span style="color: #cc66cc;">5</span><span style="color: #339933;">;</span> <span style="color: #000088;">$i</span><span style="color: #339933;">++</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
        <span style="color: #990000;">unlink</span><span style="color: #009900;">&#40;</span><span style="color: #000088;">$tempprefix</span> <span style="color: #339933;">.</span> <span style="color: #000088;">$i</span> <span style="color: #339933;">.</span> <span style="color: #0000ff;">".gif"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
    <span style="color: #009900;">&#125;</span>
&nbsp;
    <span style="color: #b1b100;">echo</span> <span style="color: #000088;">$_REQUEST</span><span style="color: #009900;">&#91;</span><span style="color: #0000ff;">"callback"</span><span style="color: #009900;">&#93;</span><span style="color: #339933;">.</span><span style="color: #0000ff;">'({"gif":"'</span><span style="color: #339933;">.</span><span style="color: #000088;">$URL_PREFIX</span><span style="color: #339933;">.</span><span style="color: #000088;">$tempprefix</span><span style="color: #339933;">.</span><span style="color: #0000ff;">'.gif","title":"'</span><span style="color: #339933;">.</span><span style="color: #000088;">$title</span><span style="color: #339933;">.</span><span style="color: #0000ff;">'","url":"'</span><span style="color: #339933;">.</span><span style="color: #000088;">$slideshowUrl</span><span style="color: #339933;">.</span><span style="color: #0000ff;">'"})'</span><span style="color: #339933;">;</span></pre>
</div>

Dessa vez (e ao contrário de como fizemos o MemeThis) não usamos [oAuth][24] ou [YQL][25] para postar &#8211; queríamos algo mais dinâmico, e a [API semi-oficial de pré-preenchimento de formulários do Meme][26] veio a calhar. A bookmarklet simplesmente injeta na página o código abaixo, que:

*   Escurece a tela;
*   Aciona o PHP (note que ele retorna [JSON][27][[P][28]], justamente pra isso);
*   Posta o resultado no Meme.

(tudo isso é apoiado em outra malandragem: aproveitamos o [JQuery][29] do próprio SlideShare, tomando o cuidado de só referenciar quando temos certeza que estamos no site certo)

<div class="code">
        <pre class="javascript" style="font-family:monospace;">    <span style="color: #000066; font-weight: bold;">var</span> SLIDEMEME_PATH <span style="color: #339933;">=</span> <span style="color: #3366CC;">"http://slide.memethis.com/"</span><span style="color: #339933;">;</span>
&nbsp;
    <span style="color: #000066; font-weight: bold;">function</span> slideMeme<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
        <span style="color: #000066; font-weight: bold;">if</span> <span style="color: #009900;">&#40;</span>location.<span style="color: #660066;">href</span>.<span style="color: #660066;">indexOf</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"http://www.slideshare.net/"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">!=</span><span style="color: #CC0000;"></span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
            alert<span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"This only works with SlideShare"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
            <span style="color: #000066; font-weight: bold;">return</span> <span style="color: #003366; font-weight: bold;">false</span><span style="color: #339933;">;</span>
        <span style="color: #009900;">&#125;</span>
        <span style="color: #000066; font-weight: bold;">if</span> <span style="color: #009900;">&#40;</span><span style="color: #339933;">!</span>$<span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#svPlayerId"</span><span style="color: #009900;">&#41;</span>.<span style="color: #660066;">length</span><span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
            alert<span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"You need to be on a presentation to use this"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
            <span style="color: #000066; font-weight: bold;">return</span> <span style="color: #003366; font-weight: bold;">false</span><span style="color: #339933;">;</span>
        <span style="color: #009900;">&#125;</span>
&nbsp;
        $<span style="color: #009900;">&#40;</span><span style="color: #3366CC;">'
&nbsp;
&nbsp;
&lt;div id="darkBackgroundLayer" class="darkenBackground"&gt;&lt;img src="'</span><span style="color: #339933;">+</span>SLIDEMEME_PATH<span style="color: #339933;">+</span><span style="color: #3366CC;">'js/ajax-loader.gif" alt="" /&gt;&lt;/div&gt;
&nbsp;
&nbsp;
'</span><span style="color: #009900;">&#41;</span>.<span style="color: #660066;">appendTo</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">'body'</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
        $.<span style="color: #660066;">ajax</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#123;</span>
            url<span style="color: #339933;">:</span> <span style="color: #3366CC;">'http://img.slide.memethis.com/slidememe.php?callback=?'</span><span style="color: #339933;">,</span>
            data<span style="color: #339933;">:</span> <span style="color: #009900;">&#123;</span>
                url<span style="color: #339933;">:</span> location.<span style="color: #660066;">href</span>
            <span style="color: #009900;">&#125;</span><span style="color: #339933;">,</span>
            dataType<span style="color: #339933;">:</span> <span style="color: #3366CC;">"jsonp"</span><span style="color: #339933;">,</span>
            success<span style="color: #339933;">:</span> <span style="color: #000066; font-weight: bold;">function</span> <span style="color: #009900;">&#40;</span>data<span style="color: #339933;">,</span> status<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
                location.<span style="color: #660066;">href</span> <span style="color: #339933;">=</span> <span style="color: #3366CC;">'http://meme.yahoo.com/dashboard/?photo='</span><span style="color: #339933;">+</span>data.<span style="color: #660066;">gif</span><span style="color: #339933;">+</span><span style="color: #3366CC;">'&amp;caption=&lt;a href="'</span><span style="color: #339933;">+</span>data.<span style="color: #660066;">url</span><span style="color: #339933;">+</span><span style="color: #3366CC;">'"&gt;'</span><span style="color: #339933;">+</span>data.<span style="color: #660066;">title</span><span style="color: #339933;">+</span><span style="color: #3366CC;">'&lt;/a&gt;'</span><span style="color: #339933;">;</span>
            <span style="color: #009900;">&#125;</span><span style="color: #339933;">,</span>
            error<span style="color: #339933;">:</span> <span style="color: #000066; font-weight: bold;">function</span> <span style="color: #009900;">&#40;</span>xOptions<span style="color: #339933;">,</span> textStatus<span style="color: #009900;">&#41;</span> <span style="color: #009900;">&#123;</span>
                $<span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#darkBackgroundLayer"</span><span style="color: #009900;">&#41;</span>.<span style="color: #660066;">hide</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
                alert<span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"Error! :-("</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
            <span style="color: #009900;">&#125;</span>
        <span style="color: #009900;">&#125;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
&nbsp;
    <span style="color: #009900;">&#125;</span>
    slideMeme<span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span></pre>
</div>

Sim, o código acima pode e deve ser **bem** melhorado. Por exmeplo, o [PHP 5 suporta objetos COM][30] de forma muito natural, dispensando o ASP só para isso. E também poderíamos ter experimentado as [bibliotecas do ImageMagick para PHP][31] (ao invés de chamar o [convert][32] &#8220;na veia&#8221;).

Acima de tudo, todos os fontes deveriam ter um tratamento de erros e edge cases mais apropriado, e provavelmente menos redundância &#8211; mas nada disso cabe na realidade de um hack de 24h (que nós começamos um ou dois dias antes &#8211; [dentro das regras][33] &#8211; mas na soma final levou mais ou menos esse tempo mesmo).

Ah, teve um sub-hack extra: depois da correria (mas ainda no evento) eu olhei com mais carinho o PHP, percebendo que o processo de separar os slides era baixar um arquivo, aplicar uma expressão regular nele e iterar. Aí resolvi criar uma [tabela YQL][34] que faz isso. Ainda precisa ser melhorada (ex.: colocando os slides em itens-raiz para facilitar cruzamentos) mas já dá pra [brincar com ela no YQL Console][35].

Ufa, foi um fim-de-semana movimentado&#8230; :-)

**UPDATE**: O [Gleicon Moraes][36] me passou a dica de que o [swfrender][37] (componente do swftools) consegue fazer a conversão. Eu cheguei a considerar ele na época, mas a [documentação][37] dá a entender que ele só funcionaria com arquivos previamente criados pelo swftools (o que pode ou não ser o caso dos slides do SlideShare). O fato é: funcionou em um ou dois testes preliminares, e pode ser a chave para migrar o hack para usar ferramentas livres e hospedagem mais acessível. Assim que eu tiver tempo vou olhar isso com carinho.

 [1]: http://www.flickr.com/photos/guilhermechapiewski/4454847693/ "Bani and ChesterBR @ Yahoo! Open Hack Day Brasil 2010 by Guilherme Chapiewski, on Flickr"
 [2]: http://slide.memethis.com
 [3]: http://baniverso.com/
 [4]: http://openhackbrazil.pbworks.com/
 [5]: http://www.slideshare.net
 [6]: http://meme.yahoo.com
 [7]: http://developer.yahoo.net/blog/archives/2010/03/open_hack_day_brazil_i_dont_want_to_go_back_into_the_rain.html
 [8]: http://github.com/chesterbr/SlideMeme/blob/master/slidememe.php
 [9]: http://github.com/chesterbr/slidememe
 [10]: http://meme.yahoo.com/chesterbr/p/XP_pCZM/
 [11]: http://www.youtube.com/watch?v=nBhz7hPWTwA
 [12]: http://meme.yahoo.com/popular/now/all/pt/
 [13]: http://www.bookmarklets.com/
 [14]: http://memethis.com
 [15]: http://developer.yahoo.com/yql/console/?q=desc%20slideshare.transcript&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys
 [16]: http://www.slideshare.net/developers/documentation
 [17]: http://hasin.wordpress.com/2008/02/09/hacking-slidesharenet-using-php/
 [18]: http://pearlcrescent.com/products/pagesaver/
 [19]: http://marginalhacks.com/Hacks/html2jpg/
 [20]: http://bytescout.com/download/download_freeware.html
 [21]: http://vpsland.com/
 [22]: http://www.gnu.org/software/gnash/
 [23]: http://www.imagemagick.org/script/index.php
 [24]: http://developer.yahoo.com/oauth/guide/oauth-guide.html
 [25]: http://developer.yahoo.com/yql/
 [26]: http://meme.yahoo.com/api/p/C47bC9M/
 [27]: http://json.org
 [28]: http://en.wikipedia.org/wiki/JSON#JSONP
 [29]: http://jquery.com/
 [30]: http://php.net/manual/en/book.com.php
 [31]: http://php.net/manual/en/book.imagick.php
 [32]: http://www.imagemagick.org/script/convert.php
 [33]: http://openhackbrazil.pbworks.com/Instru%C3%A7%C3%B5es-para-entrega-dos-projetos
 [34]: http://slide.memethis.com/slideshare.slides.xml
 [35]: http://developer.yahoo.com/yql/console/?q=use%20%22http%3A%2F%2Fslide.memethis.com%2Fslideshare.slides.xml%22%3B%20select%20*%20from%20slideshare.slides%20where%20url%3D%27http%3A%2F%2Fwww.slideshare.net%2Fskytland%2Fparticipatory-space-exploration-3422969%27%3B
 [36]: http://zenmachine.wordpress.com/
 [37]: http://wiki.swftools.org/index.php/Swfrender
