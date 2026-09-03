---
locale: pt-BR
title: FISL 11, cruzalinhas e iG Code Golf
layout: post
comments: true
permalink: /archives/2010/07/fisl-11-cruzalinhas-e-ig-code-golf.html/
onswipe_thumb:
  - '/wp-content/plugins/onswipe/thumb/thumb.php?src=/wp-content/uploads/2010/07/fisl.jpg&amp;w=600&amp;h=800&amp;zc=1&amp;q=75&amp;f=0'
dsq_thread_id:
  - 1751447256
categories:
---
<img class="alignright size-full wp-image-4358" title="fisl" src="/wp-content/uploads/2010/07/fisl.jpg" alt="" width="90" height="89" />A edição desse ano do [Fórum Internacional Software Livre][1] foi interessante como de costume: palestrantes de renome e a troca de experiências dentro e fora do evento com as pessoas que fazem o software livre acontecer seguramente justificam passar esses dias em Porto Alegre. Esse ano fiz dois lances bacanas por lá:

O primeiro foi preparar e apresentar uma palestra-relâmpago sobre o [cruzalinhas][2] ([slides aqui][3], vídeo em breve). Resolvi fazer isso na última hora, e me surpreendi com o interesse de pessoas de outras cidades (Manaus, Campinas, Florianópolis e da própria Porto Alegre) em fazer a mesma coisa, já que, segundo esse pessoal, a dificuldade em obter informações sobre o transporte público é a mesma.

O outro foi participar do [Code Golf do iG][4], uma proposta inusitada, na qual são apresentados cinco problemas de programação. Eles são relativamente simples &#8211; o desafio é escrever o **menor código-fonte** que resolva cada um.

Claro que um código Python é bem menor que o seu equivalente Java, e por isso haviam categorias isoladas para cada linguagem suportada (Perl, Python, PHP, Java e Ruby). Fui o [vencedor][5] da categoria Java, com os códigos que estão no final do post.

Um aviso: **NUNCA escreva código assim**, a não ser que esteja participando de um Code Golf. O objetivo era sempre reduzir o tamanho e compensar a [proibição][6] de imports explícitos. Isso tem um custo: a performance quase sempre é horrível, a legibilidade é zero, é quase impossível modificar. Senti esse último lance na prática: tive que fazer uma gambiarra na questão 4 (o formato da entrada mudou, e o fix apropriado implicaria em reescrever tudo) &#8211; o tamanho dobrou e fui penalizado por isso.

* * *

<p style="text-align:center;">
  Minhas soluções para o Code Golf (<a href="http://web.archive.org/web/20100725183357/http://ignofisl.ig.com.br:80/2010/07/22/problemas-do-code-golf/">enunciados aqui</a>)
</p>

**Problema 1:**

<div class="wrap-code">
{% highlight java %}
public class c{public static void main(String x[])throws Exception{int a=,b=1,c,i;for(i=Integer.parseInt(x[]);i>;i--){System.out.print(b+(i==1?"":", "));b=b+a;a=b-a;}}}
{% endhighlight %}
</div>

**Problema 2:**

<div class="wrap-code">
{% highlight java %}
public class c{public static void main(String x[]) throws Exception{char m,s[]=x[].replace(" ","").toLowerCase().toCharArray(),i=;int f[]=new int[255],c,l=s.length;boolean p=true;for(;i<l;i++){p=p&&s[i]==s[l-i-1];f[s[i]]++;}System.out.println((p?"":"Não é ")+"Palíndrome");while(true){m=;for(i=;i<255;i++){m=f[m]>f[i]?m:i;}if(f[m]==)return;System.out.println(f[m]+" "+m);f[m]=;}}}
{% endhighlight %}
</div>

**Problema 3:**

<div class="wrap-code">
{% highlight java %}
public class c{public static void main(String x[]) throws Exception{long a=,m=,b,c,F=0xFFFFFFFF;int i,j=;for(;j<2;j++){c=;for(i=;i<4;i++)c=c*256+Integer.parseInt(x[j].split("\\.")[i]);a=m;m=c;}a=a|(F-m);b=32;for(c=0xFF000000l;c>;c/=256){System.out.print(((a&c)>>(b-=8))+(b==?" /":"."));}for(b=32;(m&1)==;m/=2)b--;System.out.print(b);}}
{% endhighlight %}
</div>

**Problema 4:**

<div class="wrap-code">
{% highlight java %}
public class c{static int h=-1;static void w(int i){if(h!=i)System.out.print(i+" ");h=i;}public static void main(String y[])throws Exception{String[]x=(y[]+",-,"+y[1]).split(",");int m,l=x.length,n[]=new int[l],p=,i=,a=;for(;i<l;i++)if(x[i].equals("-")){a=i;p=i+1;}else n[i]=Integer.parseInt(x[i]);for(i=;(i<a&&p<l);){if(n[i]<n[p]){m=n[i];i++;}else{m=n[p];p++;}w(m);}for(;i<a;i++)w(n[i]);for(;p<l;p++)w(n[p]);}}
{% endhighlight %}
</div>

**Problema 5:**

<div class="wrap-code">
{% highlight java %}
public class c{public static void main(String x[])throws Exception{int c,p,t=,v[]={1,3,3,5,10,50};while((c=System.in.read())>-1){p=("pcbtar".indexOf(c));t+=p>-1?v[p]:;}System.out.print(t);}}
{% endhighlight %}
</div>

 [1]: http://softwarelivre.org/fisl11
 [2]: http://cruzalinhas.com
 [3]: http://www.slideshare.net/chesterbr/cruzalinhas-palestra-relmp
 [4]: http://ignofisl.ig.com.br/tag/code-golf/
 [5]: https://ignofisl.ig.com.br/codegolf/rankingfinal.php
 [6]: http://ignofisl.ig.com.br/2010/07/21/faq-do-code-golf/
