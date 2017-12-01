---
title: 'JavaScript: The Good Parts (O Melhor do JavaScript)'
layout: post
comments: true
permalink: /archives/2010/09/javascript-the-good-parts-o-melhor-do-javascript.html
onswipe_thumb:
  - '//chester.me/wp-content/plugins/onswipe/thumb/thumb.php?src=//chester.me/wp-content/uploads/2010/09/crockford.jpg&amp;w=600&amp;h=800&amp;zc=1&amp;q=75&amp;f=0'
robotsmeta:
  - index,follow
dsq_thread_id:
  - 1751441288
categories:
---
<img class="alignright size-full wp-image-4561" title="crockford" src="//chester.me/wp-content/uploads/2010/09/crockford.jpg" alt="Douglas Crockford, autor de JavaScript: The Good Parts" width="199" height="295" />Não ia escrever sobre esse livro, simplesmente porque não teria muito a acrescentar, mas o [Lucas][1] me convenceu de que valeria a pena nem que fosse só pra convocar as pessoas a ler. Se você programa em JavaScript (mais ainda: se não programa ou não gosta dela por ter tido experiências ruins), preste atenção:

[Douglas Crockford][2] é possivelmente um dos caras que mais manjam de JavaScript do mundo: um dos responsáveis pela padronização e disseminação do [JSON][3], ele teve papel fundamental nos comitês que deram (e ainda dão) o rumo da linguagem &#8211; quem foi ao [QCon][4] teve a oportunidade de ouvir algumas histórias &#8220;do front&#8221; em primeira mão.

Ele começa desmontando o primeiro mito comum sobre a linguagem: revela que JavaScript **não é** um mero subset de Java (embora esse fosse o &#8220;[argumento de venda][5]&#8221; nos seus primórdios), e sim algo mais parecido com Lisp ou Scheme: uma linguagem funcional extremamente poderosa, que permite escrever código muito elegante &#8211; se for usada corretamente.

Muitos dos problemas que eu tive no passado com JavaScript eram causados por desconhecer este aspecto da linguagem. Ao tratá-la como uma linguagem script qualquer, não apenas eu escrevia muito mais código do que o necessário, mas também encontrava erros difíceis de debugar porque a abstração de Java/C que eu projetava nela simplesemente [não correspondia à realidade][6]. Como disse o Crockford no já mencionado QCon, &#8220;programar em JavaScript sem entender *closures* é como programar em Java sem entender classes&#8221;.

Com esse elefante fora da sala, o livro começa a mostrar como as coisas realmente funcionam na linguagem. E nesse ponto vem a explicação do título original: ele argumenta que algumas partes da linguagem simplesmente não se prestam à construção de código de qualidade, convidando o leitor a esquecê-las sem cerimônia! O livro se concentra nos construtos e conceitos que você precisa entender para escrever código que adere à característica funcional e prototípica da linguagem, em detrimento de tentar emular o que se faz em outros ambientes (em particular em linguagens OO como SmallTalk e Java).

No final ele lista as &#8220;partes ruins&#8221; (bem como as &#8220;partes péssimas&#8221;), detalhando em cada caso se a questão é conceitual (como no caso das variáveis globais), de implementação (o suporte a Unicode limitado em 16 bits é um exemplo) ou um conflito entre escolhas de design (ex.: ter um tipo único obriga a aritmética a trabalhar sempre com ponto flutante, o que [nem sempre é uma boa idéia][7]). Temas correlatos como [JSLint][8] e o já mencionado JSON encerram a exposição com chave de ouro.

É uma leitura excelente, mesmo para veteranos em JavaScript &#8211; desde que estejam abertos a uma revisão de conceitos. Ganharão em troca uma relação renovada com a linguagem, e entenderão porque seu uso pipoca até [além das barreiras do browser][9] &#8211; não que o uso neste já não fosse o bastante para torná-la uma das [linguagens mais usadas da atualidade][10] e justificar um carinho especial para com ela.

Optei pela edição nacional (&#8220;[O Melhor do JavaScript][11]&#8220;) pelo preço e disponibilidade, e me surpreendi com a qualidade da tradução. Os códigos têm seus comentários traduzidos, mas variáveis e todo o resto ficam intactos (isso é importante quando o autor começa a viajar, ex.: definindo &#8220;that&#8221; como complemento a &#8220;this&#8221;). Tirando e pequenos detalhes de editoração (ex.: o uso de aspas simples que &#8220;abrem e fecham&#8221; no código, coisa que não rolaria na vida real), a adaptação é bastante competente.

 [1]: http://xucros.com/
 [2]: http://www.crockford.com/
 [3]: http://www.json.org/
 [4]: //chester.me/archives/2010/09/qcon-sao-paulo-2010.html
 [5]: http://www.woodger.ca/js_orig.htm
 [6]: http://zef.me/2843/javascript-the-scope-pitfall
 [7]: http://polymathprogrammer.com/2008/05/19/float-finance-folly/
 [8]: http://www.jslint.com/
 [9]: http://en.wikipedia.org/wiki/Comparison_of_Server-side_JavaScript_solutions
 [10]: http://www.tiobe.com/index.php/content/paperinfo/tpci/index.html
 [11]: http://www.submarino.com.br/produto/1/21471189/melhor+do+javascript,+o?franq=273452
