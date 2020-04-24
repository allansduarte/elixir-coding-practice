# GithubStars

## Instalation
```
# Cloning the repository with --depth 1 removes everything except the .git commit history
$ git clone --depth 1 https://github.com/brainn-co/challenge-allansduarte.git

# Change the directory to the destination of the cloned folder
$ cd challenge-allansduarte
```

## Project setup
To get this project working is needed to run the migrations and install the dependencies:
```
$ mix ecto.setup
$ mix deps.get
$ mix deps.compile
$ cd assets/ && npm i
```

## Running the project
To get this project working is needed to run the migrations and install the dependencies:
```
$ mix phx.server
```

### Tests and linters
```
$ mix coveralls or mix test --cover --color
$ mix credo --strict
```

## Authors

* **Allan Duarte** - *Initial work* - [Allan Duarte](https://github.com/allansduarte)