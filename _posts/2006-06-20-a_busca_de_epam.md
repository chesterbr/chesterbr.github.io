---
title: A Busca de Epaminondas Jr.
excerpt: |
  |
    Este jogo, criado no início dos anos 90, foi uma das primeiras coisas que disponibilizei na web, não sem um certo constrangimento: minha definição de "humor" mudou um pouco ao longo dos últimos quinze anos. Embora o jogo não use...
layout: post
comments: true
og_image: /img/epamin.gif
permalink: /archives/2006/06/a_busca_de_epam.html/
dsq_thread_id:
  - 1751441863
categories:
  - Portfolio
---
<img width="300" height="127" src="//chester.me/img/epamin.gif" alt="tela do jogo 'A Busca de Epaminondas Jr.'" align="right" style="margin-left:4px" />Este jogo, criado no início dos anos 90, foi uma das primeiras coisas que disponibilizei na web, não sem um certo constrangimento: minha definição de &#8220;humor&#8221; mudou um pouco ao longo dos últimos quinze anos.

Embora o jogo não use (nem de longe) os recursos dos PCs modernos, os e-mails que recebo mostram que ainda hoje há quem se divirta um pouco com ele. Este fenômeno curioso me levou a falar um pouco mais a respeito &#8211; incluindo algumas curiosidades e dicas para ajudar quem ficou travado em algum quebra-cabeças. E, claro, disponibilizar o jogo para download **ou direto no navegador (NOVIDADE)**!

<!--more-->

### Jogue no Navegador

Graças ao [PCjs][10] (© 2012-2013 por [@jeffpar][8]</a>), você pode jogar sem sair desta página, guardando o ponto onde está e até os saves! Ao menos no Firefox, roda 100%:

<button type="button" onClick="i=document.getElementById('iframe_epaminondas'); i.height='530px'; i.src='/epaminondas/'; i.scrollIntoView();" >Clique Aqui Para Abrir o Jogo!</button>

<iframe id="iframe_epaminondas" width="100%" height="1px" scrolling="no"></iframe>

### Como Jogar

O jogo é do tipo &#8220;text adventure&#8221;, ou seja, você assume o papel de um personagem (Epaminondas) que tem uma missão a cumprir: recuperar um disquete perdido por seu patrão. Para cumprir esta missão você terá que interagir com o mundo do jogo, através das seguintes janelas:

<img width="486" height="157" src="/archives/img/epa_mensagens.png" class="left"/>
Sempre que você entra num local, uma descrição do mesmo (e dos objetos que estão visíveis) aparece aqui. Suas ações também terão seus resultados mostrados nesta janela, enfim, a história do jogo corre nela.

<img width="322" height="36"  src="/archives/img/epa_comando.png" class="left" />
Aqui você digita os comandos. Um comando é sempre composto por um verbo e um objeto, sendo os termos intermediários eliminados. Por exemplo, CONVERSAR COM O HOMEM e CONVERSAR HOMEM produzem o mesmo resultado.

<img width="113" height="85"  src="/archives/img/epa_direcoes.png"  class="left"/>
A janela de direções permite a você saber quais saídas estão disponíveis, nas seis direções: norte, sul, leste, oeste, cima e baixo. Você pode andar numa direção com o comando completo (ex.: IR PARA O SUL ou IR SUL) ou apenas digitando a inicial (ex.: S).

<img width="160" height="59"  src="/archives/img/epa_objetos.png"  class="left"/>
Muitos dos enigmas do jogo consistem em PEGAR e USAR objetos na hora certa (ou mesmo DEIXAR um objeto para que um personagem o pegue). Esta janela lista os objetos que você tem em mãos(caso tenha mais objetos do que as linhas da janela, o comando LISTAR permite revelar os que estão ocultos).

<img width="348" height="48" src="/archives/img/epa_avisos.png" class="left">Além de avisos como &#8220;pressione qualquer tecla para continar&#8221;, esta última janela exibe um menu de opções quando você tecla ESC. Neste menu você pode salvar (gravar) o jogo em andamento, carregar um jogo salvo anteriormente, obter ajuda, reiniciar ou sair do programa.

### Download e Instalação

Caso não dê certo jogar direto no navegador (veja acima) e você tenha Windows ou algo do gênero, basta baixar o [epa15.zip][1] (84KB), descompactar em qualquer pasta e dar um duplo clique no AVENTURA.BAT.

Qualquer PC com DOS ou Windows deve ser capaz de rodar este jogo (ele foi desenvolvido em um PC-XT de 4.77Mhz e 512KB, i.e., 0,5MB de RAM), independente da versão de DOS ou Windows.

Algumas versões de Windows (notadamente o NT e o 2000) eventualmente se enroscam com a abertura &#8211; se for o caso, clique no CA1.EXE ao invés do AVENTURA.BAT e vá direto ao jogo (sua vida não será a mesma sem os os sons bizonhos no alto-falante e o clássico &#8220;T&#8221; pulando, mas é o jeito).

Para &#8220;entrar no clima&#8221;, sugiro dar um Ctrl+Enter (mudando para o modo &#8220;tela cheia&#8221;, se o seu Windows e driver de vídeo suportarem). O ideal era arrumar um monitor monocromático de fósforo verde, mas esse eu sei que é mais difícil.

Mac (Intel) e PCs com Linux rodam ele bem com o DOSBox ou VirtualBox rodam ele bem: baixe o [epaminondas.img][9] e "insira" ele no drive virtual, de acordo com as instruções de cada programa.

### Dicas

O jogo possui cinco &#8220;fases&#8221; distintas, e uma vez alcançada uma nova fase, você não volta à anterior. Isso tem um efeito colateral desagradável: existe a possibilidade de você deixar um objeto importante para trás (é uma chance pequena, afinal, é preciso fuçar muito para encontrar a saída de cada uma delas).

Por isso, grave o jogo sempre que entrar numa nova fase (ESC, Gravar), com um nome diferente (ex.: INICIOF1, INICIOF2). Aliás, a sua taxa de mortalidade nesse jogo é alta, recomendo gravar sempre que tiver algum tipo de sucesso.

A coisa mais importante é OLHAR (ou EXAMINAR) todos os objetos e pessoas que encontrar. EXAMINAR LOCAL geralmente vai repetir a descrição dada, mas vale a pena EXAMINAR PAREDE, EXAMINAR CHAO e outros cantinhos desse gênero, sobretudo em lugares diferenciados.

Você pode CONVERSAR com boa parte dos personagens encontrados, e costumam sair boas dicas daí. Cuidado com os jogos de palavras &#8211; creio que a falta de mulher me deixou um pouco cruel nessa época.

Um dado importante: não é possível DAR um item a alguém, porque o jogo só entende frases com um verbo e um objeto. Se você quiser dar um objeto a um personagem, basta DEIXAR o objeto. Se o personagem se interessar, ele pega, senão você pode pegar ele de volta.

O jogo não gosta de palavrões &#8211; a insistência pode enfurecê-lo, e ele não vai se preocupar com o andamento da partida se isso acontecer.

A maior parte dos objetos tem alguma utilidade. Não contei, mas creio que são apenas dois ou três que não servem pra nada, e dificilmente um objeto é usado mais de uma vez. Não tem limite, então pegue tudo o que conseguir.

Cada um joga adventures de texto à sua maneira, mas eu me dou muito melhor desenhando um mapa à medida em que vou jogando. Mudanças de plano (cima/baixo) exigem criativade, por isso não as usei muito no jogo. Quando um meio de transporte te levar a um lugar novo (e não for possível voltar), comece um novo mapa.

Eu costumava desenhar na mão, mas usando uma planilha eletrônica moderna foi possível esboçar o mapa abaixo em poucos minutos. Ele mostra os primeiros locais do jogo, dando uma idéia de como começar. À medida que o jogo prossegue, pode-se anotar a posição de objetos e personagens relevantes, enfim, tudo o que puder ajudar lá adiante, caso seja preciso retomar.

<center>
  <img width="470" height="395" src="//chester.me/archives/img/epa_mapa.png" />
</center>


### Curiosidades Gerais

*   O velhinho é uma &#8220;homenagem&#8221; ao velho amigo (ou seria amigo velho) Hilton, fanático por xadrez na época. O triste é que eu acho que ele é mais novo que eu&#8230;

*   Eu tinha 14 anos quando comecei a desenvolver o jogo (1989). Após dois anos de engavetamento e desengavetamento ele tomou sua forma final (a versão que eu chamo de 1.5b). A única mudança que fiz depois disso foi quando coloquei na web: o arquivo [LEIAME.TXT][2] (clique para ver em HTML) substituiu o programa LEIAME.

*   Muitas coisas boas (e algumas das ruins) foram inspiradas por adventures da Sierra On-Line para PC, notadamente por Leisure Suit Larry. Adventures do Apple II (The Incredible Hulk e Swiss Family Robinson me vêm à mente) também influenciaram.

*   A quantidade de dinheiro que você tem no jogo flutua. Eu pensei em fazer itens &#8220;compráveis&#8221; (como no Larry), mas o jeito com que o jogo lida com isso ficou bacana no final.

*   Quando o jogo estava em desenvolvimento, havia um jeito de se &#8220;teleportar&#8221; para qualquer local, digitando BEIJAR AKIRA (eu gostava muito de [Akira][3], era o gibi mais legal da galáxia para mim naquela época). Na versão final eu sumi com o AKIRA, impossibilitando esta brincadeira, mas se você tentar ele apenas vai dizer que ele não está ali (ou seja, a palavra AKIRA permaneceu no dicionário).

*   Por conta de limitações técnicas (vide seção seguinte para detalhes), o jogo usa o trema (¨) no lugar do til (~), e aspas simples (&#8216;) no lugar das duplas (&#8220;). No entanto, eu também eu colocava um espaço em branco entre o final da frase e o ponto de interrogação/exclamação, e **isso** não era limitação técnica, mas pessoal. Só parei com essa mania vários anos depois, ao perceber que não faz o menor sentido estético ou gramatical.

*   O jogo tem dois finais (dependendo de você ter encontrado ou não uma chave, escondida em um lugar bem improvável).

### Curiosidades Técnicas

*   O jogo é todo feito em Turbo Basic (uma tentativa da Borland de repetir o sucesso do Turbo Pascal nesta linguagem). Num dado momento, estourei o limite (32K ou 64K, não lembro) do editor, e não cosneguia mais dar andamento no jogo. Tentei migrar para o Microsoft QuickBasic (versão compilada do QBasic que vinha com o MS-DOS 5.0), mas ele era muito instável (mais que o Turbo Basic, que não era exatamente pacífico também).<br/><br/>A solução foi voltar para o Turbo Basic. Fiz um programinha que extraía as strings do código-fonte original para um arquivo à parte, e substituia elas por referências a um array, que eu carregava na inicialização do programa, o que me deu mais fôlego. Hoje fico pensando se o Turbo Basic não tinha algum sistema de múltiplos fontes (quase que certamente tinha), ou se poderia ter tentado um editor externo, mas na época foi a solução que eu consegui.

*   A abertura foi feita em C (não lembro em qual compilador). Eu cheguei a fazer ela quase toda em Turbo Basic também, mas não consegui resolver o lance do som sair junto com a animação, então apelei.

*   Eu desconhecia qualquer teoria sobre parsers, analisadores léxicos e afins. O processo de parse consistia em remover palavras não-relevantes (artigos, preposições), indexar o verbo e o objeto (recorrendo a um dicionário de sinônimos) e chamar a subrotina correspondente ao verbo, sem maiores sofisticações.

*   A programação teve forte influência do adventure da INPUT e de outras revistas e livros de programação da época.

*   O jogo foi desenvolvido num XT com monitor CGA monocromático. Quando tive acesso a uma máquina com monitor colorido (EGA), a primeira coisa que fiz (depois de rastejar e implorar por alguns minutinhos para o funcionário da [SEE/SP][4] que a ocupava) foi testar lá &#8211; onde vi que as cores eram absolutamente estapafúrdias e ilegíveis. Mudar para cores bacanas estragava o jogo no monitor de fósforo verde, então estabeleci um meio-termo (preservando o verde), que é o que se vê hoje.

*   O uso do trema no lugar do til se deve ao fato de que a maioria (se não todas) das placas de vídeo CGA não permitia trocar a tabela de caracteres (vulgo &#8220;codepage&#8221;) padrão quando se estava em modo texto. Esta tabela, conhecida como <a href="http://en.wikipedia.org/wiki/Code_page_437" target="_blank">CP437</a> era a mesma que associava aos códigos &#8220;00&#8243; e &#8220;01&#8243; os caracteres &#9786; e &#9787;, respectivamente &#8211; o que fazia com que as pessoas definissem arquivos executáveis e binários em geral (onde esses códigos de valor baixo aparecem bastante) como &#8220;aquelas bagunças cheias de carinhas&#8221;.

*   Já as aspas simples eram preferidas porque, em Basic, as aspas duplas são reservadas como delimitadores de strings, obrigando o uso de uma seqüência de escape (que nem sei se existia no Turbo Basic) ou de concatenação (que consumiria tempo de desenvolvimento e memória). Ao contrário da questão do til, essa até daria para contornar, mas seria trabalhoso.

*   Eu perdi o código fonte. Já na época não era exatamente um motivo de orgulho (ficou muito macarrônico no final, à medida em que eu me apressava pra terminar), mas hoje seria curioso dar uma olhada. Não sei se o código é passível de compilação reversa (e vai demorar para que eu tenha tempo e saco de desassemblar e dar uma fuçada), mas um compilador reverso de Turbo Basic 1.0 me divertiria um bocado se revelasse esse eco do passado.</ul>

### Dicas apelativas <font color="red">(SPOILER &#8211; vai estragar algumas surpresas)</font>

Essas dicas não chegam a entregar a solução do jogo, mas sugerem o caminho. É mais para o caso de você realmente enroscar em algum ponto. Caso prefira, pode [me mandar um e-mail][5] falando de onde você enroscou, e eu tentarei ajudar da melhor forma possível.

#### Mapa 1 (Escritório):

A rua é a saída evidente aqui, mas é preciso achar algum meio de transporte. Além disso, é preciso saber para onde foi o ladrão &#8211; deve ser alguém do escritório, o que sugere procurar pistas por lá. Mas é preciso OLHAR com muita insistência. E não deixe a fase sem explorar tudo o que a biblioteca tem a oferecer &#8211; saiba a hora de CONVERSAR com as pessoas e a hora de ENTRAR direto nas coisas, e você sairá de lá mais iluminado.

#### Mapa 2 (Campus):

O seu meio de transporte não vai te levar muito longe. É preciso recorrer à agência de viagens &#8211; mas quem disse que você tem passagem? O jeito é procurar &#8211; mas a faculdade ao sul não aceita gente sem cultura (ou seria sem dinheiro?) como Epaminondas, e gangues de punks e carecas no norte podem causar problemas, sobretudo se uma achar que você pertence à outra.

Tente tirar proveito de uma delas (há males que vêm pra bem), e você conseguirá entrar na faculdade, sem nem prestar vestibular. Ali você verá que valeu a pena passar um tempo na biblioteca &#8211; especialmente quando for procurar em lugares mais escuros &#8211; mas ainda lhe falta algo. Talvez um passeio na quadra de esportes te ajude a relaxar e encontrar o que precisal.

#### Mapa 3 (Bairro):

&#8220;Aha &#8211; the plot thickens&#8230;&#8221; (vide Kill Bill, vol. 2). Logo ao leste você descobre alguém que pode te ajudar, mas nada nessa vida é grátis (e nesse caso, nem muito barato é). Dá pra suspeitar da atividade criminosa nessa cidade &#8211; tem grana alta escondida em algum lugar, mas pode ser preciso abrir o caminho na base da ignorância pra encontrar.

E pra isso é preciso uma ferramenta &#8211; que o velhinho pode te dar se você der a ele o que ele tanto quer (lembre-se sempre: dar é DEIXAR algo no local). Vasculhe teto por teto, chão por chão, parede por parede, até achar algo vulnerável.

Você verá nesta fase que a falta de mulher leva as pessoas a medidas desesperadas &#8211; mas a falta de recursos também é um problema sério, então aproveite a distração dessas pessoas e veja se pelo menos um convite pra uma balada legal você descola.

#### Mapa 4 (BucanoWare Inc):

Só o taxista pra te tirar daqui. E ele não fala a sua língua, então é preciso achar algo que faça sentido para ele (mesmo que não faça sentido para você). Revire cada canto, meta a mão no lixo se isso for preciso &#8211; mas não esqueça de procurar um lugar pra lavar a mão depois, pois você pode achar algo útil nessa busca.

#### Mapa 5: (Danceteria).

Bastante coisa pra explorar. O mair importante é tirar o DJ da mesa, atraindo-o para longe. O truque é achar algo que interesse a ele, mas não bastará entregar de mão beijada. Em seguida, segredos serão revelados, mas o desafio final dependerá apenas de você. Esteja em ponto de bala!

 [1]: /download/epa15.zip
 [2]: /download/leiame_epa.html
 [3]: http://en.wikipedia.org/wiki/Akira_%28manga%29
 [4]: http://www.educacao.sp.gov.br/
 [5]: /fale.html
 [8]: http://twitter.com/jeffpar
 [9]: /download/epaminondas.img
 [10]: http://jsmachines.net/docs/pcjs/
