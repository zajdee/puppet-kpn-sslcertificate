2021-01-22 Release 4.1.5
- bugfix to use the specified cert-store folder instead of assuming the personal (my) store
- bugfix for windows private key import to persistent machine store
- fix importing a root cert into the trusted root store instead of the personal store (if present in a pfx file)
- fix importing an intermediate cert into the trusted intermediates store instead of the personal store (if present in a pfx file)
- change certificate install powershell script to not use string evaluation where not needed.
  * This allows e.g. a $ character in the password (a single quote still causes problems as it terminates the string)
- add windows 2019 as a supported platform
- fix rspec and beaker tests
- add support for PEM certificates

2018-03-21 Release 1.0.2
- add support for Puppet 5

2018-03-15 Release 1.0.1
- updated README.md

2018-03-13 Release 1.0.0
- sslcertificate has been rewriten als a provider.
 - sslcertificate now has new/different parameters. Please check the README.MD
 - a certificate can now be (ensure) present or absent
 - sslcertificate no longer uses certificate files as source for the import. 
   This also means that certificate files are not left behind on the client.
