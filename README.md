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
Em construção...

## Como executar
Em construção...



