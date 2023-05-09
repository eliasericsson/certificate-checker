# certificate-checker

A simple untility to check when the certificate for a domain expires.

__*NOTE*__: Make sure the script is executable.

## Examples
### Single domain
```sh
$ ./certcheck.sh www.google.com

89 days until expiration: www.google.com
```

### Multiple domains
```sh
$ ./certcheck.sh www.google.com www.facebook.com

89 days until expiration: www.google.com
89 days until expiration: www.facebook.com
```
