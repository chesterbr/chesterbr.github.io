---
title: 'tilewriter &#8211; desenhando ladrilhos em JavaScript'
layout: post
comments: true
permalink: /archives/2010/06/tilewriter-desenhando-ladrilhos-em-javascript.html
onswipe_thumb:
  - '//chester.me/wp-content/plugins/onswipe/thumb/thumb.php?src=//chester.me/wp-content/uploads/2010/06/mario.png&amp;w=600&amp;h=800&amp;zc=1&amp;q=75&amp;f=0'
dsq_thread_id:
  - 1751447428
categories:
  - Portfolio
---
<img src="//chester.me/wp-content/uploads/2010/06/mario.png" alt="" title="Super Mario em tiles" width="120" height="140" class="alignleft size-full wp-image-4131" />Eu fiquei vidrado no layout de &#8220;ladrinhos&#8221; do logotipo do [site do RHoK][1], que lembra os micros de 8 bits sem deixar de ser moderno, e pensei &#8220;taí, vou <del datetime="2010-06-20T14:22:59+00:00">roubar</del> <del datetime="2010-06-20T14:22:59+00:00">me inspirar</del> criar um trabalho artístico derivativo para o próximo update visual do meu blog&#8221;.

O chato é que não apenas sou um zero à esquerda em GIMP/PhotoShop, mas também queria algo que pesasse menos no carregamento. Solução: programar.

O [`canvas` do HTML5][2] viria a calhar, mas o suporte dos browsers ainda está longe do ideal. Resolvi, então, criar uma biblioteca minimalista para fazer desenhos nesse estilo usando elementos de HTML.<!--more--> E ficou minimalista mesmo: basta incluir ela e o JQuery no

`<head>` da página, i.e.:

<div class="code">
        <pre class="javascript" style="font-family:monospace;"><span style="color: #339933;">&lt;</span>script src<span style="color: #339933;">=</span><span style="color: #3366CC;">"http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"</span> type<span style="color: #339933;">=</span><span style="color: #3366CC;">"text/javascript"</span><span style="color: #339933;">&gt;&lt;/</span>script<span style="color: #339933;">&gt;</span>
<span style="color: #339933;">&lt;</span>script src<span style="color: #339933;">=</span><span style="color: #3366CC;">//chester.me/tilewriter/tilewriter-0.2-min.js"</span> type<span style="color: #339933;">=</span><span style="color: #3366CC;">"text/javascript"</span><span style="color: #339933;">&gt;&lt;/</span>script<span style="color: #339933;">&gt;</span></pre>
</div>

Coloca-se na página um `<div>` (ou outro container HTML) no qual o &#8220;desenho&#8221; será montado, e aí é só brincar de JavaScript:

<div class="code">
        <pre class="javascript" style="font-family:monospace;">tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_teste"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"      X"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_teste"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">" XX    "</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_teste"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"X  X  X"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_teste"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"X  X  X"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_teste"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">" XX   X"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span></pre>
</div>

Isso produz o mosaico abaixo (que pode não aparecer num leitor RSS &#8211; o que é esperado, é só decoração &#8211; nesse caso, abra o [post original][3]):

<div id="div_teste" style="text-align:center">
</div>




Também é possível configurar a palheta de cores utilizada, o tamanho de cada &#8220;azulejo&#8221; e o espaçamento entre eles, o que permite várias possibilidades interessantes. Por exemplo, esse encanador familiar:

<div id="div_mario" style="text-align:center">
</div>




é produzido pelo script:

<div class="code">
        <pre class="javascript" style="font-family:monospace;">tilewriter.<span style="color: #660066;">reset</span><span style="color: #009900;">&#40;</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">spacing</span> <span style="color: #339933;">=</span> <span style="color: #CC0000;"></span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">size</span> <span style="color: #339933;">=</span> <span style="color: #CC0000;">8</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">colors</span> <span style="color: #339933;">=</span> <span style="color: #009900;">&#91;</span><span style="color: #3366CC;">""</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"#EA590C"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"#AC7C00"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"#FFA440"</span><span style="color: #009900;">&#93;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_mario"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"   111111    "</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_mario"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"  1111111111 "</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_mario"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"  22233233   "</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_mario"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">" 23233323333 "</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_mario"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">" 232233323333"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_mario"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">" 22333322222 "</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_mario"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"   33333333  "</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_mario"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"  2232222    "</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_mario"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">" 22212212222 "</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_mario"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"2222111122222"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_mario"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"3321311312333"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_mario"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"3331111113333"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_mario"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"3311111111333"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_mario"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"  1111 1111  "</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_mario"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">" 2222   2222 "</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_mario"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"22222   22222"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span></pre>
</div>

Para usar mais do que 10 cores, basta passar a palheta como um objeto do tipo `{"caractere" : "cor"}`, usando qualquer cor CSS válida. Espaços e caracteres não-mapeados ficam sem cor, i.e., com a cor do fundo.

Isso bastava para o que eu queria, mas me empolguei: já que a idéia é logotipos e afins, por que não automatizar a escrita de textos? Para isso bastava ter uma fonte bitmap que fosse compacta e legível &#8211; tal qual tínhamos nos micros de 8 bits &#8211; e aí veio o estalo: ao invés de criar uma fonte, era mais fácil pegar uma direto da ROM de um deles!

A escolhida foi a fonte do [TK90x][4] (ZX Spectrum), que não apenas está prontinha na ROM, mas tabmém é fácil de encontrar [salva][5] na web. Ela é 8&#215;8, o que significa que se eu guardar como texto hexadecimal, cada &#8220;imagem&#8221; de caractere ocupa 16 bytes (mais o payload do JavaScript), e fica bem fácil de converter para binário.

O resultado é que pra escrever o &#8220;oi&#8221;, agora basta programar:

<div class="code">
        <pre class="javascript" style="font-family:monospace;">tilewriter.<span style="color: #660066;">drawText</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_teste_2"</span><span style="color: #339933;">,</span><span style="color: #3366CC;">"oi"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span></pre>
</div>

e temos:

<div id="div_teste_2" style="text-align:center">
</div>




Como de costume, dá pra melhorar bastante, e o [código-fonte][6] é livre para quem quiser brincar. O chato é que eu queimei o tempo que ia usar no update do layout com esse brinquedo, mas valeu a pena &#8211; a lib ficou com menos de 4K minificada (incluindo a fonte). Olha como dá pra se empolgar na nostalgia:

<div class="code">
        <pre class="javascript" style="font-family:monospace;">tilewriter.<span style="color: #660066;">spacing</span> <span style="color: #339933;">=</span> <span style="color: #CC0000;"></span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">size</span> <span style="color: #339933;">=</span> <span style="color: #CC0000;">1</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawText</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_tk90x_cima"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"TK90X - Color Computer"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">spacing</span> <span style="color: #339933;">=</span> <span style="color: #CC0000;"></span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">size</span> <span style="color: #339933;">=</span> <span style="color: #CC0000;">8</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">colors</span> <span style="color: #339933;">=</span> <span style="color: #009900;">&#91;</span><span style="color: #3366CC;">"white"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"yellow"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"cyan"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"green"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"magenta"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"red"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"blue"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"black"</span><span style="color: #009900;">&#93;</span><span style="color: #339933;">;</span>
tilewriter.<span style="color: #660066;">drawRow</span><span style="color: #009900;">&#40;</span><span style="color: #3366CC;">"#div_tk90x_baixo"</span><span style="color: #339933;">,</span> <span style="color: #3366CC;">"000111222333444555666777"</span><span style="color: #009900;">&#41;</span><span style="color: #339933;">;</span></pre>
</div>

<div id="div_tk90x_borda" style="text-align:center; border:1px solid black; padding:4px;;margin-left:auto;margin-right:auto;width:220px;">
  <div id="div_tk90x_cima" >
  </div>

  <p>
    <br /><br /><br /><br /><br />
  </p>

  <div id="div_tk90x_baixo" style="border:2px solid black;width:192px;margin-left:auto; margin-right:auto;">
  </div>
</div>

<p>
  <script src="//chester.me/tilewriter/tilewriter-0.2-min.js" type="text/javascript"></script>
  <script type="text/javascript">if(tilewriter){tilewriter.drawRow("#div_teste","      X");tilewriter.drawRow("#div_teste"," XX    ");tilewriter.drawRow("#div_teste","X  X  X");tilewriter.drawRow("#div_teste","X  X  X");tilewriter.drawRow("#div_teste"," XX   X");tilewriter.reset();tilewriter.spacing=0;tilewriter.size=8;tilewriter.colors=["","#EA590C","#AC7C00","#FFA440"];tilewriter.drawRow("#div_mario","   111111    ");tilewriter.drawRow("#div_mario","  1111111111 ");tilewriter.drawRow("#div_mario","  22233233   ");tilewriter.drawRow("#div_mario"," 23233323333 ");tilewriter.drawRow("#div_mario"," 232233323333");tilewriter.drawRow("#div_mario"," 22333322222 ");tilewriter.drawRow("#div_mario","   33333333  ");tilewriter.drawRow("#div_mario","  2232222    ");tilewriter.drawRow("#div_mario"," 22212212222 ");tilewriter.drawRow("#div_mario","2222111122222");tilewriter.drawRow("#div_mario","3321311312333");tilewriter.drawRow("#div_mario","3331111113333");tilewriter.drawRow("#div_mario","3311111111333");tilewriter.drawRow("#div_mario","  1111 1111  ");tilewriter.drawRow("#div_mario"," 2222   2222 ");tilewriter.drawRow("#div_mario","22222   22222");tilewriter.reset();tilewriter.drawText("#div_teste_2","oi");tilewriter.reset();tilewriter.spacing=0;tilewriter.size=1;tilewriter.drawText("#div_tk90x_cima","TK90X - Color Computer");tilewriter.spacing=0;tilewriter.size=8;tilewriter.colors=["white","yellow","cyan","green","magenta","red","blue","black"];tilewriter.drawRow("#div_tk90x_baixo","000111222333444555666777");}</script>
</p>

 [1]: http://www.rhok.org
 [2]: http://en.wikipedia.org/wiki/Canvas_element
 [3]: //chester.me/archives/2010/06/tilewriter-desenhando-ladrilhos-em-javascript.html
 [4]: http://www.tk90x.com.br/
 [5]: http://homepage.ntlworld.com/wholehog/stuart/fonts/index.html
 [6]: http://github.com/chesterbr/tilewriter/blob/master/tilewriter.js
