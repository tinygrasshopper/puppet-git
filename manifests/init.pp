class git {
  $configdir = "${github::config::configdir}/git"
  $credentialhelper = "${github::config::bindir}/gh-setup-git-credential"

  package { 'github/brews/git':
    ensure => '1.7.10.4-github1'
  }

  file { $configdir:
    ensure => directory
  }

  file { $credentialhelper:
    ensure => link,
    target => "${github::config::home}/setup/script/setup-git-credential"
  }

  file { "${configdir}/gitignore":
    source  => 'puppet:///modules/git/gitignore',
    require => File[$configdir]
  }

  git::config::global{ 'credential.helper':
    value => $credentialhelper
  }

  git::config::global{ 'core.excludesfile':
    value   => "${configdir}/gitignore",
    require => File["${configdir}/gitignore"]
  }

  if $::gname {
    git::config::global{ 'user.name':
      value => $::gname
    }
  }

  if $::gemail {
    git::config::global{ 'user.email':
      value => $::gemail
    }
  }
}
