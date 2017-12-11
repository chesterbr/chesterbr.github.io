---
title: Migrando o Movable Type de BerkleyDB para MySQL
excerpt: |
  |
    As novas versões do Movable Type (publicador deste blog) não vão mais suportar o formato BerkleyDB para guardar os posts, comentários e configurações. Como pretendo atualizar em breve, resolvi adiantar o expediente e migrar para MySQL. Nada muito esotérico: o...
layout: post
comments: true
permalink: /archives/2007/09/migrando_o_mova.html/
robotsmeta:
  - index,follow
categories:
---
As novas versões do Movable Type (publicador deste blog) [não vão mais suportar o formato BerkleyDB][1] para guardar os posts, comentários e configurações. Como pretendo atualizar em breve, resolvi adiantar o expediente e migrar para MySQL. Nada muito esotérico: o MT tem um script de migração e uma [receita de bolo][2] bem simples.

A migração rolou sem problemas, mas um problema irritante aconteceu desde então: a tela de login passou a aparecer a cada vez que eu clicava em um link no administrador. Se eu voltasse para o BerkleyDB, o problema desaparecia.

Em 99% das aplicações web, esse tipo de coisa é problema com o cookie que identifica a sessão do usuário &#8211; mas o fato de só acontecer com o banco novo me fez desconfiar que este caso era dos 1% restantes. De fato, o script de migração BerkleyDB->MySQL não cria a tabela de sessões, e o @#%@ do MT simplesmente manda para a tela de login, ao invés de dar erro logo de cara &#8211; como [programadores pragmáticos][3] (#32) teriam feito.

De qualquer forma, uma boa alma postou o [script de criação da tabela faltante][4], e resolvi registrar aqui para quem vier a precisar.

 [1]: http://www.movabletype.org/documentation/upgrade/
 [2]: http://www.sixapart.com/movabletype/docs/mtupgrade#converting%20your%20berkeley%20db%20database%20to%20a%20sql%20database
 [3]: http://www.codinghorror.com/blog/files/Pragmatic%20Quick%20Reference.htm
 [4]: http://web.archive.org/web/20080217010356/http://forums.sixapart.com/lofiversion/index.php/t56070.html