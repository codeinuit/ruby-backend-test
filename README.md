# ruby-backend-test
Simple Ruby API project for username creation and storage. If the username is already taken, the server returns a new available username instead.

## Installation
Clone the project and configure your database informations in `config/database.yml`.
To initialize databases, use :
```
rails db:setup
```

## Run
In your shell, use rails to run your server
```
rails s
```

## Use
### User creation
Method : POST

Path : /user/create

Required parameters :
* username (must be exactly 3 char long and must only contains uppercase letters  (A..Z)

Responses handled :
* 200 (OK)
* 406 (Incorrect parameters)
* 507 (No username available)
