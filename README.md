# Cookbook: Ruby

Installs Ruby from source.


## Dependencies

* apt
* build-essential


## Attributes

* ruby [Hash] contains the `users` Hash.
* users [Array<Hash>] contains an Array of user Hashes.
* user [String] name of the user.
* prefix [String] path to install all Ruby versions.
* versions [Array<String>] MRI versions to install.


## Recipes

* `recipe[ruby]` - Installs Ruby from source.


## Example

`nodes/192.168.1.10.json`

```json
{
  "ruby" : {
    "users" : [{
      "user" : "deployer",
      "prefix" : "/home/deployer/rubies",
      "versions": [{
        "version" : "2.0.0-p195",
        "gems" : [{
          "gem" : "bundler", "version" : "~> 1.3.5"
        }]
      }]
    }]
  },

  "run_list" : ["recipe[ruby]"]
}
```

## License

MIT. See `LICENSE`

