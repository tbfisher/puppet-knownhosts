# Puppet Module: Known Hosts

Adds servers to ssh known hosts file.

## Usage

    known_hosts { 'vagrant':
      server_list => [
        'github.com',
        'example.com:8080',
      ],
    }
