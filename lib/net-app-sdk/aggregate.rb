# function definitions to interface with NetApp filers
class Aggregate < Filer

    def self.create(aggr, diskcount, raidtype="raid_dp")
        aggr_create = @@filer.invoke("aggr-create",
                                     "aggregate", aggr,
                                     "disk-count", diskcount,
                                     "raid-type", raidtype)
        raise aggr_create.results_reason \
              if aggr_create.results_status == 'failed'
        return true
    end

    def self.purge(aggr)
        aggr_destroy = @@filer.invoke("aggr-destroy",
                                      "aggregate", aggr)
        raise aggr_destroy.results_reason \
              if aggr_destroy.results_status == 'failed'
        return true
    end

    def self.add(aggr)
        #TODO -  implement me!
        # Does this even fully work??? starting to question this shity ass code...
        return false
    end

    def self.online(aggr)
        aggr_online = @@filer.invoke("aggr-online",
                                     "aggregate", aggr)
        raise aggr_online.results_reason \
              if aggr_online.results_status == 'failed'
        return true
    end

    def self.offline(aggr)
        aggr_offline = @@filer.invoke("aggr-offline",
                                      "aggregate", aggr)
        raise aggr_offline.results_reason \
              if aggr_offline.results_status == 'failed'
        return true
    end

    def self.rename(aggr, newname)
        aggr_rename = @@filer.invoke("aggr-rename",
                                     "aggregate", aggr,
                                     "new-aggregate-name", newname)
        raise aggr_rename.results_reason \
              if aggr_rename.results_status == 'failed'
        return true
    end

    def self.list
        aggr_list_info = @@filer.invoke("aggr-list-info")
        raise aggr_list_info.results_reason \
              if aggr_list_info.results_status == 'failed'
        result = []
        aggr_list_info.child_get("aggregates").children_get.each do |key|
            result << key.child_get_string("name")
        end
        return result
    end

    #TODO - check this method against the parent class version that this overrides
    # there is some apprant duplication that should be able to refactor out
    def self.info(aggr, verbose=true)
        aggr_list_info = @@filer.invoke("aggr-list-info",
                                        "aggregate", aggr,
                                        "verbose", verbose)
        raise aggr_list_info.results_reason \
              if aggr_list_info.results_status == 'failed'
        result = {}
        aggr_list_info.child_get("aggregates").children_get.each do |key|
            volumes = []
            key.child_get("volumes").children_get.each { |vol|
                volumes << vol.child_get_string("name")
            }
            plexes = {}
            key.child_get("plexes").children_get.each { |plx|
                plexes[name: plx.child_get_string("name")] = {
                    isonline:         plx.child_get_string("is-online"),
                    isresyncing:      plx.child_get_string("is-resyncing"),
                    resyncpercentage: plx.child_get_string("resyncing-percentage")
                }
            }
            result = {
                name:               key.child_get_string("name"),
                uuid:               key.child_get_string("uuid"),
                state:              key.child_get_string("state"),
                type:               key.child_get_string("type"),
                haslocalroot:       key.child_get_string("has-local-root"),
                haspartnerroot:     key.child_get_string("has-partner-root"),
                checksumstatus:     key.child_get_string("checksum-status"),
                isinconsistent:     key.child_get_string("is-inconsistent"),
                sizetotal:          key.child_get_string("size-total"),
                sizeused:           key.child_get_string("size-used"),
                sizeavail:          key.child_get_string("size-available"),
                sizepercentage:     key.child_get_string("size-percentage-used"),
                filestotal:         key.child_get_string("files-total"),
                filesused:          key.child_get_string("files-used"),
                isnaplock:          key.child_get_string("is-snaplock"),
                snaplocktype:       key.child_get_string("snaplock-type"),
                mirrorstatus:       key.child_get_string("mirror-status"),
                raidsize:           key.child_get_string("raid-size"),
                raidstatus:         key.child_get_string("raid-status"),
                diskcount:          key.child_get_string("disk-count"),
                volumecount:        key.child_get_string("volume-count"),
                volstripeddvcount:  key.child_get_string("volume-count-striped-dv"),
                volstripedmdvcount: key.child_get_string("volume-count-striped-mdv"),
                volumes:            volumes,
                plexcount:          key.child_get_string("plex-count"),
                plexes:             plexes
            }
        end
        return result
    end
end

