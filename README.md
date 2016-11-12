# Petsy
Petsy is an e-commerce platform for people to buy and sell costumes for their pets. Anyone can become a custom critter clothier with Petsy, just sign up for an account and you can start selling your creations in minutes!

## Development
### Prerequisites
* Ruby 2.3+
* Rails 4
* PostgreSQL (for production deployments)

### Setup
Fork and clone [the Petsy project](https://github.com/Ada-C6/betsy-shipping) to your computer and run the following commands to prepare for local development:

```bash
bundle install
bundle exec rake db:migrate
bundle exec rake db:seed
```

Next you'll need to configure any environment variables that are specified in the `.env` file. As the instructions mention within that file, please **DO NOT** commit any secret keys to `.env` -- the best thing is to place any environment variables specific to your application into `.env.local`, which will not be committed into Git.

### Running the server
Once the setup steps have been completed you can get your local development server up and running at `http://localhost:3000` by using the following command:

```bash
bundle exec rails server
```

### Testing
Our unit test suite can be run with the following command. Please ensure that all of your tests are passing before submitting any pull requests!

```bash
bundle exec rake test
```

You can check the results of the code coverage tool by running (on MacOS):

```bash
open coverage/index.html
```
As of 11.7.16 = 32.39%

### Deployment
These are the instructions for deploying this project to Heroku. Alternative deployment platforms will likely require different instructions.

1. Create a new Heroku project
  ```bash
  heroku create <app name>
  ```

1. Push latest committed code to Heroku
  ```bash
  git push heroku
  ```

1. Migrate and seed the database
  ```bash
  heroku run bundle exec rake db:schema:load
  heroku run bundle exec rake db:seed
  ```

1. Setup necessary environment variables
  ```bash
  heroku config:set <VAR_NAME>=<value> <VAR2_NAME>=<value2> ...
  ```

## Contributing
If you would like to contribute to the development of Petsy, first of all thank you! It's surprisingly hard to build, maintain, and operate your own e-commerce platform these days, and we rely heavily on volunteers for our core software infrastructure.

If you're a developer and would like to get involved with the project please follow the steps outlined above under Development, then open a [pull request](https://github.com/Ada-C6/betsy-shipping/pulls) with any changes you would like to contribute!

If you're just a fan of Petsy or animal costumes in general and you've got an idea, suggestion, or have been experiencing trouble with our site please submit a [GitHub issue](https://github.com/Ada-C6/betsy-shipping/issues) and one of the core contributors to the project will check it out!
