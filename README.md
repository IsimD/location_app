# Location app
An application that checks if given points area inside defined areas

## Prerequisites
### Used libraries 

* Ruby on Rails 6.0.0
* Ruby version 2.6.4
* Grape        1.2.4
* Sidekiq     6.0.0
* PostgreSQL  10.x

### App setup
After download a repository:

Install gems:
```bundle install``` 

Create database and migrate
```
$ bundle exec rake db:create
$ bundle exec rake db:migrate
```
Run rails server 
```
bundle exec rails s
```
Run sidekiq server
```
bundle exec sidekiq
```

To connect with google api:
1. create account on: ```https://maps.googleapis.com```
2. create file inside the repository `.env.local`
3. paste your api key to it:
```
GOOGLE_API_KEY=A*****8

```

## Heroku
Application os hosted on heroku(API only)
base:
```https://r1-location-app.herokuapp.com/api/v1/```


## Endpoints:

### Sessions / Users
To make the app better in use or testing each action may be made as a default user(without passing authorization header) or in private session(with authorization header). default session is global -> everybody has access to objects created in default session and private sessions objects are private. user using private session has access only to their own data.
To use session it's required to add Authorization to header request: `Authorization: "Bearer auth-token"`

```POST https://r1-location-app.herokuapp.com/api/v1/users/registrations```

Create session(user) and return session token

```GET https://r1-location-app.herokuapp.com/api/v1/users/me```

Return user id and auth token

### Areas 
```POST https://r1-location-app.herokuapp.com/api/v1/areas```

User can add new area by send geoJSON in polygon format. Adding new area / areas will  delete previous areas 

```GET https://r1-location-app.herokuapp.com/api/v1/areas```
User can check created areas 


```POST https://r1-location-app.herokuapp.com/api/v1/locations?name=Wroclaw ```
User can create location by name

```GET https://r1-location-app.herokuapp.com/api/v1/locations/:location_id```
User can check location -> location name, coordinates and if it's inside given areas


Link to requests in Postman:
```https://www.getpostman.com/collections/e3d1374639b603170a1b```
