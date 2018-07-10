# InSpec HPE Oneview Plugin

This is the plugin for providing [InSpec](https://inspec.io) with HPE Oneview backend support.

# Requirements #

This has been built with Ruby 2.4.3 and InSpec 2.1.78. It most likely works with InSpec 1.5.x and its versions of Ruby.

# Installation #

`inspec-hpe-oneview` is a plugin for InSpec and may be installed as follows

```bash
# install InSpec
gem install inspec
```

Then install the `inspec-hpe-oneview` plugin via `~/.inspec/plugins` or a gem build:

## * for development: ##

```bash
# Install `inspec-hpe-oneview` via a symlink:
git clone git@github.com:inspec/inspec-hpe-oneview ~/inspec-hpe-oneview
mkdir -p ~/.inspec/plugins
ln -s ~/inspec-hpe-oneview/ ~/.inspec/plugins/inspec-hpe-oneview
inspec oneview help
```

## * or build a gem: ##

```bash
# Build the `inspec-hpe-oneview` then install:
git clone https://github.com/inspec/inspec-hpe-oneview.git && cd inspec-hpe-oneview && gem build *gemspec && gem install *gem
inspec oneview help
```

## Oneview Settings File

This file requires the following information:

| Parameter | Description | Example Value |
|---|---|---|
| url | URL to the Oneview server | https://192.168.1.93 |
| user | Username to connect to Oneview with | myuser |
| password | Password associated with the specified user |
| api_version | The API version to use. The default value is 200 | 300 |

This file can be written out in JSON or YAML.

```json
{
    "url": "https://192.168.1.93",
    "user": "myuser",
    "password": "12345",
    "api_version": 300
}
```

```yaml
url: https://192.168.1.93
user: myuser
password: 12345
api_version: 300
```

A different settings file, with the same format, can be specified as an environment variable `INSPEC_ONEVIEW_SETTINGS`:

```bash
INSPEC_ONEVIEW_SETTING="/path/to/another/file" inspec detect -t oneview://
```

# Testing the Oneview API connection

An example API call is provided to allow testing of the Oneview connection, sample output below:

```
inspec-hpe-oneview spaterson$ bundle exec inspec oneview server_hardware
Oneview API version: 300
Oneview URI: oneview://administrator@10.0.0.123
=> API call to server-hardware ...
{"type"=>"server-hardware-list-5", "category"=>"server-hardware", "count"=>21, "created"=>"2018-06-11T14:42:49.756Z", "eTag"=>"1528728169756", "members"=>[{"type"=>"server-hardware-5", "name"=>"0000A66102, bay 4", "state"=>"Monitored", "stateReason"=>"NotApplicable", "assetTag"=>"", "category"=>"server-hardware", "created"=>"2018-02-26T20:19:10.068Z", "description"=>nil, "eTag"=>"1524893180979", "formFactor"=>"FullHeight", "intelligentProvisioningVersion"=>"2.30", "licensingIntent"=>"NotApplicable", "locationUri"=>"/rest/enclosures/0000000000A66102", "memoryMb"=>1048576, "migrationState"=>"NotApplicable", "model"=>"HPE Synergy 660 Gen9 Compute Module", "modified"=>"2018-04-28T05:26:20.979Z", "mpFirmwareVersion"=>"2.30 Jul 23 2015",
... (output curtailed)
```

# Running InSpec with the Oneview plugin

With the Oneview plugin correctly installed, InSpec profiles can make use of it as follows:
```
$ inspec exec . -t oneview://
```

# Usage #

# How to ensure the Oneview transport is picked up in Inspec

Run the following command to confirm the InSpec Oneview plugin environment is working as expected:

```
inspec-hpe-oneview spaterson$ bundle exec inspec detect -t oneview://

== Platform Details

Name:      oneview
Families:  iaas, api
Release:   oneview-v5.5.0
```

# Code Examples #

## Run the unit tests via ##

At the time of writing there is only a single unit test.  If necessary a Rake task will be added to improve on the below:
```
$ bundle exec ruby -W -Ilib:test/unit test/unit/transports/oneview_test.rb
```

## Code

InSpec uses ```chefstyle``` for code formatting.
