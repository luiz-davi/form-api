# COLETA DE CAMPO
> Status: **Desenvolvendo** ⚙️<br>

## Objetivo 
A aplicação tem por finalidade simular uma pesquisa de campo. Formulários são criados e respondidos a cada visita, e todos os dados são armazenados.

## Autor
+   [Luiz Davi](https://github.com/luiz-davi)

## Funcionamento

+ Para se utilizar a aplicação, é de extrema importância que o usuário se cadastre do sistema e gere o token de autenticação, pois só com ele é possível editar as próprias informações de cadastro, como também para conseguir acessar as outras funcionalidades do sistema.
+ A baixo demonstramos como se cadastrar na aplicação e gerar um token jwt:
  + Criação do usuário: <br>
  >  curl -d '{"user": { "nome": user_name, "email": user_email, "password": user_password, "cpf": user_cpf } }' -H 'Content-Type: application/json' http://localhost:3000/api/v1/users -v
  + Gerando JWT: <br>
  > curl -d '{ "email": email, "password": password }' -H 'Content-Type: application/json' http://localhost:3000/api/v1/authenticate -v
  + O JWT é um código nesse estilo: <br>
  > eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w
+ Com o JWT salvo, é possível agora ter acesso a todos os outros endpoints

## ENDPOINTS

### Users
+ Listagem:
> curl --request GET http://localhost:3000/api/v1/users -v
+ Edição:
> curl --header "Authorization: Bearer **token**" --header "Content-Type: application/json" --request PUT --data '{"user": { "nome": user_name, "email": user_email, "password": user_password, "cpf": user_cpf }}' http://localhost:3000/api/v1/users/ **user_id** -v <br><br> 
É válido sitar que basta colocar o novo dado no campo correspondente e ele será atualizado
+ Remoção:
> curl --header "Authorization: Bearer **token**" --header "Content-Type: application/json" --request DELETE http://localhost:3000/api/v1/users/ **user_id** -v

### Formularies

+ Criação
> curl --header "Authorization: Bearer **token**" --header "Content-Type: application/json" --request POST --data '{ "formulary": { "title": **form_title** }, "questions": [ { "nome": **title_question**, "tipo_pergunta": **tipo_question** } ] }'  http://localhost:3000/api/v1/formularies -v <br><br>
Esse esquema corresponde a uma pergunta do formulário<br><br>
**{ "nome": title_question, "tipo_pergunta": tipo_question }** <br><br>
Serão craidas tantas quanto forem colocadas <br>
+ Listagem
> curl --request GET http://localhost:3000/api/v1/formularies -v
+ Edição
> curl --header "Authorization: Bearer **token**" --header "Content-Type: application/json" --request PUT --data '{"formulary": {"title": **novo_titulo**} }' http://localhost:3000/api/v1/formularies/ **formulary_id** -v
+ Remoção
> curl --header "Authorization: Bearer **token**" --header "Content-Type: application/json" --request DELETE http://localhost:3000/api/v1/formularies/ **formulary_id** -v

### Questions

+ Criação
> curl --header "Authorization: Bearer **token**" --header "Content-Type: application/json" --request POST --data '{"formulary_id": **formulary_id**, "question": { "nome": **question_nome**, "tipo_pergunta": **question_tipo** } }' http://localhost:3000/api/v1/questions -v

+ Listagem
> curl --request GET http://localhost:3000/api/v1/questions -v
+ Edição
> curl --header "Authorization: Bearer **token**" --header "Content-Type: application/json" --request PUT --data '{"question": { "nome": novo_nome, "tipo_pergunta": novo_tipo } }' http://localhost:3000/api/v1/questions/ **question_id**  -v

+ Remoção
> curl --header "Authorization: Bearer **token**" --header "Content-Type: application/json" --request DELETE http://localhost:3000/api/v1/questions/ **question_id** -v

### Visits

+ Criação
> curl --header "Authorization: Bearer **token**" --header "Content-Type: application/json" --request POST --data '{"visit": { "data": data_visita, "status": visit_status } }' http://localhost:3000/api/v1/visits -v
+ Listagem
> curl -X GET http://localhost:3000/api/v1/visits -v
+ Edição
> curl --header "Authorization: Bearer **token**" --header "Content-Type: application/json" --request PUT --data '{"visit": { "status": novo_status, "checkin_at": novo_checkin, "checkout_at": novo_checkout } }' http://localhost:3000/api/v1/visits/ **visit_id** -v
+ Remoção
> curl --header "Authorization: Bearer **token**" --header "Content-Type: application/json" --request DELETE http://localhost:3000/api/v1/visits/ **visit_id** -v

### Answers

+ Criação
> curl --header "Authorization: Bearer **token**" --header "Content-Type: application/json" --request POST --data '{"answer": { "content": **answer_content**, "question_id": **question_id**, "formulary_id": **formulary_id**, "visit_id": **visit_id**, "answered_at": **answer_answered_at** } }' http://localhost:3000/api/v1/answers -v
+ Listagem
> curl --request GET http://localhost:3000/api/v1/visits -v
+ Edição
> curl --header "Authorization: Bearer **token**" --header "Content-Type: application/json" --request PUT --data '{"answer": { "content": **nova_resposta** } }' http://localhost:3000/api/v1/answers/ **answer_id** -v
+ Remoção
> curl --header "Authorization: Bearer **token**" --header "Content-Type: application/json" --request DELETE http://localhost:3000/api/v1/answers/ **amswer_id** -v
+ Responder Formulario
> Nesse ENPOINT, é necessário que o usuário saiba exatamente quantas questões o formulário tem, e quais são elas, para poder criar todas as respostas de uma vez, e que deem match com as questões corretas. <br><br>
curl --header "Authorization: Bearer **token**" --header "Content-Type: application/json" --request POST --data '{ "formulary": **formulary_title**, "visit": **visit_d**, "answers": [ { "content": **primeira_resposta** }, { "content": **segunda_resposta** } ] }'  http://localhost:3000/api/v1/responder_formulario -v <br><br>
Essa chama é um exemplo de uma resposta de um formulário que tem duas perguntas, mas pode haver mais, tudo depende do formulário.

## Explicação dos teste

+ Os testes consistem inteiramente em testes de *request*, pois testam as **rotas** e os **controladores** de uma vez só.
+ Grande parte dos testes são para validar as operações básicas como listagem, criação, edição e remoção, mas também checar seus possíveis erros, como entidade não encontrada, parâmetros faltando, etc. Porém, há dois ENDPOINTs que se comportam de forma diferente:
    + A **criação de um formulário** também cria, pelo menos, uma questão obrigatória, para que não seja possível criar formulários sem questões.
    + Um ENDPOINT chamado **responde formulário**, onde o usuário deve especificar a visita, o formulário, e todas as respostas referentes ao formulário. As validações necessárias ainda então sendo pensadas.
+ Também há testes de validações, como no caso das visitas, onde as datas tem que fazer sentido. No caso dos usuários, validações de cpf iguais e cpf inválido, por exemplo.
## Ferramentas e versões 🛠

Ferramentas | Versões
----------- | ----------
Ruby        | 3.0.1
Rails       | 6.1.4.1
Git         | 2.25
JWT         | 2.3.0
Rspec       | 3.10
Paranoia    | 2.5



