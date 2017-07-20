
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sistemas de comunicação 2     Profº: Marcelo Lemos Rossi       tarefa-2 %
% Marlon Soares Sigales                                            2017/1 % 
% "lampel-ziv encoder e decoder"                              nome:lz77.m %
% descrição: Pesquisar e Programar um compactador e decompactador de texto%
% tipo Lempel-Zif                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Deverá ser feito um relatório contendo o princípio de funcionamento do
%algoritmo Lempel-Zif, exemplos de onde se é utilizado, código fonte e testes
%realizados
%
%referencia 
%https://pt.wikipedia.org/wiki/LZ77
%   Janela	Buffer	Restante do arquivo	Tupla emitida
%           A_AS	A_DA_CASA	        (0,0,A)
%        A	_ASA	_DA_CASA            (0,0,_)
%       A_	ASA_	DA_CASA             (2,1,S)
%     A_AS	A_DA	_CASA               (4,2,D)
%  A_ASA_D	A_CA	SA                  (3,2,C)
% ASA_DA_C	ASA                         (8,3,EOF)

%principios de funcionamento
%le um arquivo e atravéz de um buffer compara com uma janela de caracteres
%do arquivo que já passaram pelo buffer, gerando tuplas contendo o número
%de caracteres pra traz onde começa a semelhança, o numero de caracteres
%semelhantes e o caractere que rompe a sequencia de semelhança. com o
%conjunto de tuplas se reconstrói o aruivo.

%exemplos de aplicações, lempel zif é utilizado para compactação de
%arquivos e imagens, por exemplo o algoritmo lzw é utilizado como padrao unix
%para compactação gif, png entre outros, por ser uma forma de baixas perdas
%de compactação, os algoritmos iniciais 77 e 78 são menos utilizados hoje,
%mas foram as bases para os algoritmos mais eficases como lzw, lza e lzss.

%código fonte

function lz77 = lz77(texto,compordescomp,tamanhojanela,tamanhobuf)
close all;
%importando texto e iniciando variaveis
arquivo = fopen('texto.txt');%colocar a variavel texto no lugar do texto.txt
tamanhobuffer=4;               %tamanho do buffer passado na chamada, comentar isso depois
tamanhojanela=9;            %tamanho da janela passado na chamada, comentra isso também

janela=zeros(1,tamanhojanela); %inicia primeira janela com zeros.
[message1,errnum]=ferror(arquivo); %verifica erro

if (errnum ==0)  %decisão sobre erro
     
   message=['nao houve erro na abertura do arquivo: %c', message1]; 
   arquivo = fscanf(arquivo,'%c'); %converte o arquivo lido numa string de caracteres
   tamanhoarquivo = size(arquivo);
   
   if (compordescomp)
      %compactador    
   
      %laço
      i=1;
      j=1;
      w=1;
           while w<=tamanhoarquivo
              buffer = arquivo(w:(tamanhobuffer+w)); %atualiza buffer varrendo o arquivo
              
              while j<=tamanhobuffer
                  while i<=tamanhojanela
                      %seta variaveis para que sejam comparadas do while
                      %mais externo onde são verificadas as semelhanças
                      numerodesemelhancas=tamanhobuffer-j;
                      fimjaneladajanela=tamanhojanela-i;
                      janeladajanela=numerodesemelhancas-fimjaneladajanela;        %%%erro
                      
                      
                      sentenca1=buffer(1,(numerodesemelhancas));
                      sentenca2=janela((janeladajanela),(fimjaneladajanela));
                      similaridade = isequal(sentenca1,sentenca2);
                      i=i+1;  
                  end

                  %verifica se o buffer tem semeljanças com a janela
                  if similaridade
                      %se sim, monta a tupla.
                      tupla = [(janeladajanela), numerodesemelhancas, buffer(tamanhobuffer-j+2)];
                      %tupla=(numero de char pra tras para frente até a semelhança, numero de semelhanças, caractere que quebra a sequencia);

                      %escreve num segundo arquivo.
                      compac = fopen('compactado.txt','wt');
                      fprintf(compac,'%i %i %c \n',tupla);
                      fclose(compac);

                      %atualiza a janela e o buffer
                      w=w+numerodesemelhancas-1; %atualiza o buffer com mais deslocamentos;
                      janela = strcat(janela(numerodesemelhancas:(tamanhojanela)),buffer(1:numerodesemelhancas));

                      break;
                  end
                  j=j+1;
              end
              w=w+1;
           end
      
      
   else
       %descompactador
   end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
else %deu ruim
   message=['erro na abertura do arquivo: %c',message1];
  
end    






                        