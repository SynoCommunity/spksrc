# Node Exporter

[Node Exporter](https://github.com/prometheus/node_exporter) is a Prometheus exporter for hardware and OS metrics.

## Configuration

To configure specific parameters for node_exporter service, edit the file:

```
/var/packages/node-exporter/var/parameters.txt
```

The default file provides some information on how to use it:

```
# node_exporter parameters
# ------------------------
# 
# Every line without a leading # is added as parameter to node_exporter
# 
# To list all available parameters call:
# /var/packages/node-exporter/target/bin/node_exporter --help
#
# To activate changes in this file, you need to restart (i.e. stop and start) 
# node-exporter service in the DSM Package Center.
# 
# examples:
# --collector.disable-defaults
# --collector.network_route
# --collector.textfile.directory='/tmp/prom'
#
```
