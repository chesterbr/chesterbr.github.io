---
title: 'simpleyql &#8211; usando as APIs do Yahoo! em Java'
layout: post
comments: true
permalink: /archives/2009/09/simpleyql-usando-as-apis-do-yahoo-em-java.html
categories:
  - Portfolio
---
O [simpleyql][1] é uma biblioteca que facilita bastante o desenvolvimento de aplicações em Java que manipulem dados de usuários do [Yahoo! Meme][2] (ou de quaisquer sites do Yahoo! que estejam expostos via [YQL][3] e [oAuth][4]).

Na teoria, é possível usar uma biblioteca de oAuth pré-existente para isso (o próprio simpleyql se baseia em [classes disponíveis no oauth.net][5]), mas quando eu e a [Bani][6] começamos o [MemeThis][7] (falo dele em outro post) vimos que as particularidades do Y! tornariam o código demasiadamente complexo.

Além disso, essas classes exigem um grau de entendimento de oAuth maior do que o puramente conceitual. E o fato de o Yahoo! disponibilizar [bibliotecas para outras linguagens][8] &#8211; mas **não** para Java &#8211; foi a gota d&#8217;água que motivou a criação da biblioteca.

Com ela, basta uma quantidade mínima de [código][9] para iniciar o processo de autorização do usuário &#8211; um passo necessário quando ele acessa sua aplicação pela primeira vez. Dali em diante basta manter a chave de acesso atualizada no banco de dados ou equivalente, e você poderá usá-la em uma chamada simples sempre que quiser interagir com o Y! em nome da pessoa.

Parece simples? Ótimo, essa era a idéia: encapsular os [detalhes][10] do vai-e-vem de tokens e permitir ao desenvolvedor focar apenas na aplicação. A biblioteca é compatível com o [Google App Engine][11] (o MemeThis roda nele), então não tem mais desculpa: se a sua praia é Java, a hora de desenvolver pro Yahoo! Meme é agora.

 [1]: http://simpleyql.sourceforge.net/
 [2]: http://meme.yahoo.com
 [3]: http://developer.yahoo.com/yql/
 [4]: http://developer.yahoo.com/oauth/
 [5]: http://oauth.googlecode.com/svn/code/java/core/
 [6]: http://baniverso.com/
 [7]: http://memethis.com/
 [8]: http://developer.yahoo.com/social/sdk/
 [9]: http://sourceforge.net/apps/mediawiki/simpleyql/index.php?title=Usage
 [10]: http://developer.yahoo.com/oauth/guide/oauth-auth-flow.html
 [11]: http://appengine.google.com