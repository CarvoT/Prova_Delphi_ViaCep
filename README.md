# Prova_Delphi_ViaCep
Desenvolvido por Lucas Carvalho Goulart

## Descrição
Aplicação em Delphi que consome e retorna endereços e cep’s através da consulta pública da Viacep, permitindo o armazenamento e consulta dos dados armazenados. 


## Requisitos técnicos do projeto
1. Possibilitar armazenar os resultados das consultas em uma tabela (pode utilizar o banco de dados que preferir)
1. Possibilitar que as consultas possam ser feitas tanto por CEP quanto por Endereço Completo.
1. Permitir navegar através dos registros já inseridos, e caso seja feita a consulta de um CEP ou Endereço que já exista cadastrado, deverá perguntar ao usuário se deseja atualizar os dados encontrados.

## User Stories

### US 1.1 - Criar tabela de armazenamento

Como desenvolvedor,  
quero criar uma tabela em um banco de dados de minha escolha,  
para que os resultados das consultas ao WS ViaCEP possam ser armazenados e consultados posteriormente.

#### Exemplo da Tabela

| código (PK)| cep |logradouro|complemento|bairro|localidade|uf|
| --- | ---- | ---- | ---- | ---- | ---- | ---- |
|1|91790-072|Rua Domingos José Poli||Restinga|Porto Alegre|RS|

---

### US 1.2 - Pesquisar endereço através do CEP

**Como** usuário,  
**quero** pesquisar endereços informando um CEP,  
**para que** eu possa consultar e armazenar o resultado do WS ViaCEP na base de dados.

#### Critérios de Aceite

**CA1.1 - CEP não existente na base**
- **Dado** a utilização do software  
- **Quando** for informado um CEP para pesquisa  
- **E** o CEP informado não existir registrado na base de dados  
- **Então** o sistema deve consultar o WS ViaCEP utilizando o CEP informado  
- **E** armazenar o resultado na tabela criada.

**CA1.2 - CEP existente na base**
- **Dado** a utilização do software  
- **Quando** for informado um CEP para pesquisa  
- **E** o CEP informado existir na base de dados  
- **Então** o sistema deve mostrar uma mensagem perguntando se o usuário deseja visualizar o endereço encontrado ou efetuar uma nova consulta atualizando as informações.  
- **E** armazenar o novo resultado caso o usuário escolha atualizar.

**CA1.3 - CEP não encontrado**
- **Dado** a pesquisa por CEP  
- **Quando** o CEP informado não existir na base de dados e não for encontrado no WS ViaCEP  
- **Então** o sistema deve mostrar uma mensagem para o usuário informando que o CEP não foi encontrado.

---

### US 1.3 - Pesquisar endereço através do Endereço Completo

**Como** usuário,  
**quero** pesquisar endereços informando Estado, Cidade e Logradouro,  
**para que** eu possa obter e armazenar os dados retornados pelo WS ViaCEP.

#### Critérios de Aceite

**CA1.1 - Validação de campos incompletos**
- **Dado** a pesquisa por Endereço Completo  
- **Quando** o campo Estado, Cidade ou Endereço contiver menos de 3 caracteres  
- **Então** o sistema deve apresentar uma mensagem informando que os campos foram preenchidos incorretamente.

**CA1.2 - Endereço não existente na base**
- **Dado** a pesquisa por Endereço Completo  
- **Quando** os campos informados tiverem mais de 3 caracteres  
- **E** o endereço não existir na base de dados  
- **Então** o sistema deve consultar o WS ViaCEP utilizando o Endereço Completo  
- **E** armazenar o resultado na tabela criada.

**CA1.3 - Endereço existente na base**
- **Dado** a pesquisa por Endereço Completo  
- **Quando** os campos informados tiverem mais de 3 caracteres    
- **E** o endereço existir na base de dados
- **Então** o sistema deve perguntar se o usuário deseja visualizar o endereço existente ou efetuar uma nova consulta atualizando os dados.  
- **E** armazenar o novo resultado caso a opção seja de atualização.

**CA1.4 - Endereço não encontrado**
- **Dado** a pesquisa por Endereço Completo  
- **Quando** o endereço informado não existir na base de dados e não for encontrado no WS ViaCEP  
- **Então** o sistema deve informar que o endereço não foi encontrado.

---

## Arquitetura da solução
A arquitetura da solução se baseou em uma estrutura MVC, onde o form se comunica com uma classe de negócio e a classe de negócio se comunica com a classe da base de dados.

Para auxiliar na solução, foram desenvolvidos dois componentes proprietários, disponibilizados na pasta de componentes e detalhados a seguir:

### ucpComboBoxValue
O componente ucpComboBoxValue foi criado a partir de uma TComboBox para permitir a utilização de uma combo que liste o nome dos estados e permite retornar a sigla do mesmo. 
A propriedade publicada possui o nome valores e pode ser atribuída assim como os items de uma combobox normal.
Para extrair o valor selecionado foi criado o método ValorSelecionado onde é retornado o valor através do item index, realizando tratamentos para não apresentar falhas.

### ucpConsultaViaCep
Este é o componente principal do projeto, responsável pela comunicação com a viacep.
Foram criadas propriedades expostas para definição da forma de consulta, se XML ou JSON, assim como também foi publicada a url caso seja necessário futuramente ajustar por uma mudança de hospedagem do site, sem necessidade de se recompilar o componente.
O componente disponibiliza os métodos de consulta por CEP e consulta por endereço completo, onde é retornado um Record (ou array) com todos os atributos da consulta, sendo o componente responsável pela deserialização do JSON ou XML.

### Base de dados
Para desenvolvimento da solução, foi escolhida a base SQLlite, que se mostra razoável para um MVP onde será acessado apenas localmente através do desktop, sem necessidade de múltiplos acessos.
Sendo assim, foram utilizados componentes do FireDac para criação e alteração dos registros em base.

### Negócio
A classe de negócio apresenta todas as regras necessárias para o funcionamento da aplicação, realizando a comunicação entre o frontend e a base de dados.
Nesta classe, foi criado uma espécie de observer, mas como não eram necessário multiplos notificados, optei por alocar o observer como um proprietário da classe, permitindo a geração de mensagens em tela através da classe de negócio. Para isto foi utilizada uma interface da qual o frame principal é herdado.
Ainda na classe de negócio, se utilizou a orientação a objetos e clean code, priorizando a leitura simples do código, a singularidade de cada função e não duplicação de código.  


## Como executar
1. Faça o download do projeto para seu computador
2. Abra a pasta Prova_Delphi_ViaCep\Win32\Release
3. Execute o arquivo ConsultaCep.exe
4. Irá abrir a seguinte tela:

<div align="center">
<img width="786" height="393" alt="image" src="https://github.com/user-attachments/assets/5214442c-746b-4c7e-8c5a-4174f4597034" />
</div>

5. Selecione a aba conforme a sua opção de busca
6. Informe os campos disponíveis em tela e clique em "Buscar"
7. Os registros encontrados serão listados em tela.
8. O botão limpar apaga todos os campos em tela e disponibiliza a consulta de todos endereços da base.




