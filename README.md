# COLETA DE CAMPO
> Status: **Desenvolvendo** ⚙️<br>

## Objetivo 
A aplicação tem por finalidade simular uma pesquisa de campo. Formulários são criados e respondidos a cada visita, e todos os dados são armazenados.

## Autor
+   [Luiz Davi](https://github.com/luiz-davi)

## Funcionamento

+ Para se utilizar a aplicação, é de extrema importância que o usuário se cadastre do sistema e gere o token de autenticação, pois só com ele é possóvel editar as próprias informações de cadastro, como também para conseguir acessar as outras funcionalidades do sistema.
+ As operações referentes ao cadastro de usuário são acessadas via endpoints com final "*users*", tais como
  + Criação: <br>
  > curl --request POST http://localhost:3000/api/v1/users 
  + Listagem de Usuários: <br>
  > curl --request GET http://localhost:3000/api/v1/users 
## Ferramentas e versões 🛠

Ferramentas | Versões
----------- | ----------
Ruby        | 3.0.1
Rails       | 6.1.4.1
Git         | 2.25
JWT         | 2.3.0
Rspec       | 3.10



