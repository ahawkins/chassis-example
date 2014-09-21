# Photo App Backend - A Chassis Example

This project was supposed to be the backend API for an iOS photo
sharing app. That app never happend, so I've repurposed the code as an
example on using Chassis!

Run tests with `bundle exec rake`. You can run tests against real
services using `bundle exec rake test:ci`.

I won't give away too much about the structure, because you should
explore it your self. Here's some quick info:

* Two repositories: memory and redis
* `Chassis.form` used for form objects
* `Chassis.strategy` used to create facades to external services
* see `config/test.rb` for info on setting up services & repos
* see `test/test_helper.rb` on how to switch between them

More questions? Just ask me!

## General Principles

* Authentication happens with a token header
* All responses in JSON
* 400 for malformed requests
* 412 if the auth header is required and missing
* 422 for validation failures
* 500 for server errors
* 503 maintenance and temporary availability errors
* host: `http://photo-app-backend-production.herokuapp.com`

## Authenticate a Device & Signup

First make request with the user's phone number. The server will send
an SMS to the number with a confirmation code. User enters the code.
Send a request to the server to create a user with the confirmation
code.

```
POST /user_token
Content-Type: application/json

{
  "user_token": {
    "phone_number": "+12531358183"
  }
}
```

`phone_number` is required and must be in international format
`(+1xxxxxx)`.

Server will returns `202 Queued` w/o a body. Wait for the SMS.

```
POST /users
Content-Type: application/json

{
  "user": {
    "name": "Adam Hawkins",
    "auth_token": "12345",
    "device": {
      "uuid": "edac577d-555c-460a-a96a-ef20f7d1bb30",
      "push_token": "e21ff6dc-99c7-43ad-bfe8-0a75d73bba16"
    }
  {
}
```

`name`, `auth_token`, and `device.uuid` are required. Send
`push_token` to enable push notifications. The server will respond
with the user and their api key.

```
Content-Type: application/json

{
  "user": {
    "id": "1",
    "token": "089b94ad71734d1f8820e80d39833b42",
    "name": "Adam Hawkins",
    "device": {
      "uuid": "edac577d-555c-460a-a96a-ef20f7d1bb30",
      "push_token": "e21ff6dc-99c7-43ad-bfe8-0a75d73bba16"
    }
  }
}
```

## Updating the User's Device

This call allows you to keep the user's device updated.

```
PUT /device
X-Token: 089b94ad71734d1f8820e80d39833b42
Content-Type: application/json

{
  "device": {
    "uuid": "edac577d-555c-460a-a96a-ef20f7d1bb30",
    "push_token": "e21ff6dc-99c7-43ad-bfe8-0a75d73bba16"
  }
}
```

Response will be a 200 with the same format.

## Create a group

```
PUT /groups
X-Token: 089b94ad71734d1f8820e80d39833b42
Content-Type: application/json

{
  "group": {
    "name": "Testing"
  }
}
```

Response should be 201.

## Upload a Picture

```
POST /groups/:group_id/pictures
X-Token: 089b94ad71734d1f8820e80d39833b42

{
  "picture": {
    "file": "...."
  }
}
```

Response should be 201.
