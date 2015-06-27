# JSClassFinder - Repository Cleaner

Remove third-party and minified files of JavaScript projects in GitHub cloned repositories.

## How to use

Just: `ruby src/main.rb [DESTINATION]`, where `DESTINATION` is the absolute path to a directory
selected to save the cleaned repository.

## Contact

Daniel Carlos Hovadick Félix: [dfelix@dcc.ufmg.br](mailto://dfelix@dcc.ufmg.br)

## Dependencies

* [CURB](https://rubygems.org/gems/curb/versions/0.8.8)
* [Rugged](https://rubygems.org/gems/rugged)
* [github-linguist](https://rubygems.org/gems/github-linguist)