# *------------------------*
# *      Noticia.pl        *         
# *------------------------*

#   Monta a tela de exibição da matéria da notícia 


#  Parametros que devem ser passados como campo hidden pelo form chamador:

# titulo = titulo da materia
# olho = olho da materia
# assinatura = assinatura do redator da materia 
# data = data da noticia
# hora = hora da noticia
# numero = numero da edicao do jornal
 
# arquivo = nome do arquivo texto contendo a materia 
# template = nome do template da pagina HTM que exibirah a materia 
# diretorio = diretorio dos arquivos texto

# Dados usados para consultas entre Pauta, ordem do Dia e Resumo da Sessão

# arq_ordem = nome do arquivo texto contendo a materia da ordem do dia
# arq_pauta = nome do arquivo texto contendo a materia da pauta da sessão
# arq_resumo = nome do arquivo texto contendo a materia do resumo da sessão

# O arquivo da materia deve estar no diretorio definido no parametro $diretorio
# O template da pagina deve estar no mesmo diretorio deste CGI


# $diretorio:  define o diretório onde os arquivos de notícias estão armazenados 

$diretorio_p = 'd:\\inetpub\\wwwroot\\alesp\\noticias\\';


############################################################################

# Parse do Formulario - recupera os campos que serão montados na página
&parse_form;

# Check de campos obrigatorios
#&check_required;

# Pagina HTML de retorno
&return_html;


sub parse_form {

   if ($ENV{'REQUEST_METHOD'} eq 'GET') {
      # Split the name-value pairs
      @pairs = split(/&/, $ENV{'QUERY_STRING'});
   }
   elsif ($ENV{'REQUEST_METHOD'} eq 'POST') {
      # Get the input
      read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
    
      # Split the name-value pairs
      @pairs = split(/&/, $buffer);
   }
   else {
      &error('request_method');
   }

   foreach $pair (@pairs) {
      ($name, $value) = split(/=/, $pair);
 
      $name =~ tr/+/ /;
      $name =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;

      $value =~ tr/+/ /;
      $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;

      $value =~ s/<!--(.|\n)*-->//g;

      if ($name eq 'titulo' ||
	  $name eq 'olho' ||
	  $name eq 'assinatura' ||
	  $name eq 'arquivo' ||
	  $name eq 'data' ||
  	  $name eq 'hora' ||
  	  $name eq 'numero' ||
	  $name eq 'diretorio' ||
	  $name eq 'arq_ordem' ||
 	  $name eq 'arq_pauta' ||
  	  $name eq 'arq_resumo' ||
	  $name eq 'template' && ($value)) {
	 
	 $CONFIG{$name} = $value;
      }
   }
}


sub return_html {

#     Verifica se o template existe ...
 
      print "HTTP/1.0 200 OK\n";
      print "Content-type: text/html\n\n";

      if (! -r $CONFIG{'template'})
         {
          print "<html>\n <head>\n";
          print "  <title>Noticia</title>\n";
          print " </head>\n <body>";

          print "Arquivo template não encontrado.<br> ";
          print "Contate nosso WebMaster<br>";
          print "Arquivo chamado: ".$CONFIG{'template'};
          print "</body>\n</html>";
          exit
         }

#    Monta o path completo do arquivo texto.

      $arqtexto =  $diretorio_p.$CONFIG{'diretorio'}."//".$CONFIG{'arquivo'};

#     Verifica se o arquivo texto foi encontrado ...

      if (! -r $arqtexto)
         {
           print "<html>\n <head>\n";
	     print "  <title>Noticia</title>\n";
           print " </head>\n <body>";

           print "Desculpe, texto da matéria não foi encontrado ...<br> ";
           print "Contate nosso WebMaster <br>";
           print "Arquivo chamado: ".$diretorio_p.$CONFIG{'diretorio'}."//".$CONFIG{'arquivo'};
           print "</body>\n</html>";
           exit
          }

#     Strings para substituir os valores do titulo e do olho da materia 

      $p_titulo = "<%titulo%>";
      $val_titulo = $CONFIG{'titulo'};      

      $p_olho = "<%olho%>";
      $val_olho = $CONFIG{'olho'};      

      $p_assinatura = "<%assinatura%>";
      $val_assinatura = $CONFIG{'assinatura'};      

      $p_data = "<%data%>";
      $val_data = $CONFIG{'data'};      

      $p_hora = "<%hora%>";
      $val_hora = $CONFIG{'hora'};      

      $p_numero = "<%numero%>";
      $val_numero = $CONFIG{'numero'};      

      $p_arq_ordem = "<%arq_ordem%>";
      $val_arq_ordem = $CONFIG{'arq_ordem'};      

      $p_arq_pauta = "<%arq_pauta%>";
      $val_arq_pauta = $CONFIG{'arq_pauta'};      

      $p_arq_resumo = "<%arq_resumo%>";
      $val_arq_resumo = $CONFIG{'arq_resumo'};      


#     Recupera o template e começa a montagem da página, até encontrar a tag de 
#     corpo do texto

      open(PAGINA,"<$CONFIG{'template'}"); 

      while (<PAGINA>) {
         $linha=$_;
         if ($linha =~ /<%inicio_materia%>/) {
#   ---------  abre o arquivo com o texto da materia e descarrega na pagina --------
             open(TEXTO,"<$arqtexto"); 

             while (<TEXTO>) {
                $materia=$_;
                $materia =~ s/$parm1/$valparm1/gi;

                print "<p>";
                print $materia;
              }
   
         }
         else {
           $linha =~ s/$p_titulo/$val_titulo/gi;
           $linha =~ s/$p_olho/$val_olho/gi;
           $linha =~ s/$p_assinatura/$val_assinatura/gi;
           $linha =~ s/$p_data/$val_data/gi;
           $linha =~ s/$p_hora/$val_hora/gi;
           $linha =~ s/$p_numero/$val_numero/gi;
           $linha =~ s/$p_arq_ordem/$val_arq_ordem/gi;
           $linha =~ s/$p_arq_pauta/$val_arq_pauta/gi;
           $linha =~ s/$p_arq_resumo/$val_arq_resumo/gi;
		   
           print $linha;
         }
      }

      close TEXTO, PAGINA;

}

