define knownhosts (
  $hostname = $title,
  $user,
){

  $home = $user ? {
    'root' => '/root',
    default => "/home/${user}"
  }

  if ! defined(File["${home}/.ssh"]) {
    file { "${home}/.ssh":
      ensure => directory,
      owner => $user,
      group => $user,
      mode => 700,
    }
  }
  if ! defined(File["${home}/.ssh/known_hosts"]) {
    file { "${home}/.ssh/known_hosts":
      ensure => file,
      group => $user,
      owner => $user,
      mode => 600,
      require => File["${home}/.ssh"],
    }
  }

  $script = "/usr/local/bin/puppet_knownhosts_${user}_${title}.sh"

  file { $script:
    ensure => present,
    mode => '0700',
    content => template('knownhosts/known_hosts.sh.erb'),
    owner => $user,
    group => $user,
  }

  exec { $script:
    command => $script,
    provider => shell,
    user => $user,
    environment => ["home=${home}"],
    require => [
      File[$script],
      File["${home}/.ssh/known_hosts"],
    ],
  }

}
