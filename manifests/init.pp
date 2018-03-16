class zabbix_agent_corosync (
  $agent_include  = '/etc/zabbix/zabbix_agentd.d/',
  $bin_path       = '/usr/local/sbin',
  ) {

  file { 'pacemaker.conf':
    path   => "${agent_include}/pacemaker.conf",
    source => "puppet:///modules/${module_name}/zabbix-agent-pacemaker.conf",
    notify => Service['zabbix-agent'],
  }

  file { 'check_pacemaker_actions':
    path   => "${bin_path}/check_pacemaker_actions",
    source => "puppet:///modules/${module_name}/check_pacemaker_actions",
    mode   => '0775',
  }

  file { 'crm_mon_stats.sh':
    path   => "${bin_path}/crm_mon_stats.sh",
    source => "puppet:///modules/${module_name}/crm_mon_stats.sh",
    mode   => '0775',
  }

  sudo::conf { 'zabbix-corosync':
    priority => 10,
    content  => "%zabbix ALL=(ALL) NOPASSWD: ${bin_path}/crm_mon_stats.sh",
  }
}
