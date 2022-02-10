# COLETA DE CAMPO
> Status: **Desenvolvendo** ⚙️<br>

## Objetivo 
A aplicação tem por finalidade simular uma pesquisa de campo. Formulários são criados e respondidos a cada visita, e todos os dados são armazenados.

## Autor
+   [Luiz Davi](https://github.com/luiz-davi)

## Funcionamento

+ Para se utilizar a aplicação, é de extrema importância que o usuário se cadastre do sistema e gere o token de autenticação, pois só com ele é possóvel editar as próprias informações de cadastro, como também para conseguir acessar as outras funcionalidades do sistema.
+ A baixo demonstramos como se cadastrar na aplicação e gerar um token jwt:
  + Criação do usuário: <br>
  >  curl -d '{"user": { "nome": user_name, "email": user_email, "password": user_password, "cpf": user_cpf } }' -H 'Content-Type: application/json' http://localhost:3000/api/v1/users -v
  + Gerando JWT: <br>
  > curl -d '{ "email": email, "password": password }' -H 'Content-Type: application/json' http://localhost:3000/api/v1/authenticate -v
  + Esse JWT é um código como esse:
  > eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.DiPWrOKsx3sPeVClrm_j07XNdSYHgBa3Qctosdxax3w <br>
  Basta Salvá-lo em algum lugar para usar nos outros EndPoints
+ Com o JWT salvo, é possível agora ter acesso a todos os outros endpoints

## EndPoints

## Ferramentas e versões 🛠

Ferramentas | Versões
----------- | ----------
Ruby        | 3.0.1
Rails       | 6.1.4.1
Git         | 2.25
JWT         | 2.3.0
Rspec       | 3.10



