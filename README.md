# SSH Octopus Tentacle Registration

The goal of this LWRP is to register an octopus tentacle connecting via SSH.

Always looking for help.

## What it does

It registers a Linux agent with the Octopus Server via the API. To handle registration, the following occurs:

1. Looks for a file that contains the Octopus machine id (stored in step #3)
    * If file is found, it will not try to register machine (i.e. good for repeated chef runs)
2. Registers machine with Octopus Server
3. Stores resulting `Id` for use in step #1

## Usage

### Installation

Add to your metadata.rb and use whatever package manager to install.

```ruby
depends 'octopus_ssh_tentacle_registration'
```

### In recipe

```ruby
register_ssh_octopus_tenacle 'sample-server' do
  server_url 'https://my.octopus.server.me'
  api_key 'Octopus API Key'
  ssh_account_id 'Account ID of SSH user being used to connect to the boxes'
  environments ['environments', 'to put this', 'box in']
  roles ['roles this', 'box has']
  dotnet_core_platform 'linux-x64' # or osx-x64, not required
end
```

## Testing this cookbook

### Rspec

```
rspec spec --col
```

### Kitchen

1. You should replace the values in the [register recipe](./test/cookbooks/octopus-tentacle-registration-test/recipes/register.rb) with those are specific to you
2. `kitchen converge`
