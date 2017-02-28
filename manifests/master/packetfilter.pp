#
# == Class: buildbot::master::packetfilter
#
# Setup packet filtering rules for a buildmaster
#
class buildbot::master::packetfilter
(
    Integer $webui_port,
    Integer $buildslave_port,
    String  $webui_allow_address_ipv4,
    String  $webui_allow_address_ipv6,
    String  $buildslave_allow_address_ipv4,
    String  $buildslave_allow_address_ipv6
)
{
    $webui_source_v4 = $webui_allow_address_ipv4 ? {
        'any'   => undef,
        default => $webui_allow_address_ipv4,
    }
    $webui_source_v6 = $webui_allow_address_ipv6 ? {
        'any'   => undef,
        default => $webui_allow_address_ipv6,
    }

    $buildslave_source_v4 = $buildslave_allow_address_ipv4 ? {
        'any'   => undef,
        default => $buildslave_allow_address_ipv4,
    }
    $buildslave_source_v6 = $buildslave_allow_address_ipv6 ? {
        'any'   => undef,
        default => $buildslave_allow_address_ipv6,
    }

    Firewall {
        chain    => 'INPUT',
        proto    => 'tcp',
        action   => 'accept',
    }

    @firewall { '016 ipv4 accept buildmaster webui port':
        provider => 'iptables',
        dport    => $webui_port,
        source   => $webui_source_v4,
        tag      => 'default',
    }
    @firewall { '016 ipv6 accept buildmaster webui port':
        provider => 'ip6tables',
        dport    => $webui_port,
        source   => $webui_source_v6,
        tag      => 'default',
    }

    @firewall { '016 ipv4 accept buildmaster slave port':
        provider => 'iptables',
        dport    => $buildslave_port,
        source   => $buildslave_source_v4,
        tag      => 'default',
    }
    @firewall { '016 ipv6 accept buildmaster slave port':
        provider => 'ip6tables',
        dport    => $buildslave_port,
        source   => $buildslave_source_v6,
        tag      => 'default',
    }
}

