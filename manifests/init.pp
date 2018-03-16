class zabbix_agent_corosync (
  $agent_include  = '/etc/zabbix/zabbix_agentd.d/',
  $bin_path       = '/usr/local/sbin',
  ) {

  file { 'pacemaker.conf':
    path   => "${agent_include}/pacemaker.conf",
    source => 'puppet:///modules/zabbix_agent_pacemaker/zabbix-agent-pacemaker.conf',
    notify => Service['zabbix-agent'],
  }

  file { 'check_pacemaker_actions':
    path   => "${bin_path}/check_pacemaker_actions",
    source => 'puppet:///modules/zabbix_agent_pacemaker/check_pacemaker_actions',
    mode   => '0775',
  }

  file { 'crm_mon_stats.sh':
    path   => "${bin_path}/crm_mon_stats.sh",
    source => 'puppet:///modules/zabbix_agent_pacemaker/crm_mon_stats.sh',
    mode   => '0775',
  }

  exec {'zabbix haclient membership':
    unless  => "grep -q 'haclient\\S*zabbix' /etc/group",
    command => 'usermod -aG haclient zabbix',
    notify  => Service['zabbix-agent'],
  }
}
