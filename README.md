# SSL Certificate module for Puppet

#### Table of Contents

1. [Overview](#overview)
1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with sslcertificate](#setup)
    - [What sslcertificate affects](#what-sslcertificate-affects)
    - [Beginning with sslcertificate](#beginning-with-sslcertificate)
1. [Usage - Configuration options and additional functionality](#usage)
    - [Parameters](#parameters)
    - [Examples](#examples)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Overview

Puppet Module to manage Windows certificates.

## Module Description

This sslcertificate module will allow you to install and remove your certificates on Windows machines.  
It can manage pfx, cer and crt certificates.  

The module is based/uses code from the following module:  
- voxpupuli-puppet-sslcertificate: https://github.com/voxpupuli/puppet-sslcertificate  

Although we borrowed the powershell scripts from voxpupuli, this module does not yet support all certificate types that voxpupuli does.  
This module uses Hiera to install certificates so you will have to convert your certificate file to a Base64 string.  

It is also possible to list all Local Machine certificates using:  
- puppet resource sslcertificate  
- puppet resource sslcertificate <thumbprint>  

## Setup

### Setup Requirements

This module requires:
- [puppetlabs-stdlib](https://github.tooling.kpn.org/kpn-puppet-forge/puppet-puppetlabs-stdlib)
- [puppetlabs-powershell](https://github.tooling.kpn.org/kpn-puppet-forge/puppet-puppetlabs-powershell)

### What sslcertificate affects

This module will install certificates into your Windows key stores. It is also possible to remove certificates.

### Beginning with sslcertificate

  To install a certificate in the My directory of the LocalMachine root store:

```puppet
    sslcertificate { '<certificate_name>' :
      ensure              => 'present'
      path                => 'LocalMachine\<store>\<thumbprint>',
      password            => '<password>',
      format              => '<format>',
      exportable          => true,
      certificate_content => '<certificate_content>'
    }
```

  It is also possible to use hiera. sslcertificate has been added to profile_windows as: profile_windows::sslcertificate.
  Please read the [README_sslcertifciate.md](https://github.tooling.kpn.org/kpn-puppet-forge/puppet-kpn-profile_windows/blob/master/README_sslcertifciate.md) of profile_windows for more details on using hiera.
  
## Usage

### Parameters
This module accepts the following parameters:

#### ensure
Type: string<br />
Default: `'present'`<br />
Values: 'present' or 'absent'<br />
Description: This is to determine if a certifcate needs to be installed or removed.<br />

#### path
Type: string<br />
Default: nil<br />
Values: Any valid certificate path but always starts with LocalMachine. (LocalMachine\<store>\<thumbprint><br />
Description: This is the path where the certifcate will be installed. The thumbprint is always 40 hexidecimal uppercase characters.<br />

#### password
Type: string<br />
Default: 'dummy'<br />
Values: Any valid password or passphrase, including spaces.<br />
Description: Only use a password if the certificate is password protected.<br />

#### format
Type: string<br />
Default: nil<br />
Values: 'cer', 'crt' or 'pfx'<br />
Description: This is the format of the certificate.<br />

##### exportable
Type: boolean<br />
Default: true<br />
Values: true or false<br />
Description: Sets the key to be exportable.<br />

#### certificate_content
Type: string<br />
Default: nil<br />
Values: Plaintext value to create the certificate<br />
Description: This contains the certifcate content to create the certificate file that will be imported.<br />

### Examples

To install a certificate in an alternative directory:

```puppet
    sslcertificate { 'certificate_pfx:' :
      ensure     => 'present',
      path       => 'LocalMachine\CA\C50BE50FCF7AF3E7D42C21A349D6153551D50F2A',
      format     => 'pfx',
      password   => 'the cow jumped over the moon',
	  certificate_content => 'MIIGzzCCBLegAwIBAgIEATE3FzANBgkqhkiG9w0BAQsFADBhMQswCQYDVQQGEwJO
            ovEj8FQY2pHm4qISNjQcSF86aNzIGn84hbsCDmJ8VeeoUAOhUaCwn38kquDSCaeQ
            Y3EVQGaRWS5eLJEFireJ8ABWmVKNOf2q+p9DZIhU2KefmKmeED9icW8sUMy9Mfpz
            B8lFPm+xqlsIm0LbGTuzN6g5fNgy+73PiME6qnYDkmXeZ3+qDpn/pTGHj986cR7Z
            /dgPkADVTzhhPOgUSaUW2/AEgOMPJyOmw5YpxgjxkIdcnvzgQc3y3zqj56vGx7Sa
            xLtMvKTEtFFMDMBZHUkiBOfyOaTEA5Bmbn0p6DyGNMu1a4MgDun7hxtG74Ao8DDe
            ejkB6QA+v4qzlHk+clOyHFyNJ9BUc70kmv9AWM4DLYX5cUGgMiJObh07DjGQrcRo
            XHpiIw4GzrOv7zZrpZ2Y5Roi86cJyrsaAENr69NZ56Heqamsv4jvyJMVOUyWw+qb
            l409YpY9zs9PyeP2WLK3rIH3hQ=='
    }
```

To remove a certificate:

```puppet
    sslcertificate { 'any_certificate' :
      ensure        => 'absent',
      path          => 'LocalMachine\CA\C50BE50FCF7AF3E7D42C21A349D6153551D50F2A
    }
```

## Reference

### Provider
- sslcertificate 


## Limitations
This module works on:

- Windows 2008 R2
- Windows 2012 R2
- Windows 2016


## Development
You can contribute by submitting issues, providing feedback and joining the discussions.

  Go to: `https://github.com/kpn-puppet/puppet-kpn-sslcertificate`

If you want to fix bugs, add new features etc:
- Fork it
- Create a feature branch ( git checkout -b my-new-feature )
- Apply your changes and update rspec tests
- Run rspec tests ( bundle exec rake spec )
- Commit your changes ( git commit -am 'Added some feature' )
- Push to the branch ( git push origin my-new-feature )
- Create new Pull Request
