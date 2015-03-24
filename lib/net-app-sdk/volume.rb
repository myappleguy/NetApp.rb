module NetAppSdk

  class Volume < Filer
    def self.create(aggr, volname, size)
      vol_create = @@filer.invoke("volume-create",
                                  "containing-aggr-name", aggr,
                                  "volume", volname,
                                  "size", size)
      raise vol_create.results_reason \
        if vol_create.results_status == 'failed'
          return true
      end

      def self.purge(volname)
        vol_destroy = @@filer.invoke("volume-destroy",
                                     "name", volname)
        raise vol_destroy.results_reason \
          if vol_destroy.results_status == 'failed'
            return true
        end

        def self.add(volname)
          # implement me!
          return false
        end

        def self.online(volname)
          vol_online = @@filer.invoke("volume-online",
                                      "name", volname)
          raise vol_online.results_reason \
            if vol_online.results_status == 'failed'
              return true
          end

          def self.offline(volname)
            vol_offline = @@filer.invoke("volume-offline",
                                         "name", volname)
            raise vol_offline.results_reason \
              if vol_offline.results_status == 'failed'
                return true
            end

            def self.container(volname)
              vol_container = @@filer.invoke("volume-container",
                                             "volume", volname)
              raise vol_container.results_reason \
                if vol_container.results_status == 'failed'
                  return result = vol_container.child_get_string("containing-aggregate")
              end

              def self.rename(volname, newname)
                vol_rename = @@filer.invoke("volume-rename",
                                            "volume", volname,
                                            "new-volume-name", newname)
                raise vol_rename.results_reason \
                  if vol_rename.results_status == 'failed'
                    return true
                end

                def self.list
                  vol_list_info = @@filer.invoke("volume-list-info")
                  raise vol_list_info.results_reason \
                    if vol_list_info.results_status == 'failed'
                      result = []
                      vol_list_info.child_get("volumes").children_get.each do |key|
                        result << key.child_get_string("name")
                      end
                      return result
                  end

                  def self.info(volname, verbose=true)
                    vol_list_info = @@filer.invoke("volume-list-info",
                                                   "volume", volname,
                                                   "verbose", verbose)
                    raise vol_list_info.results_reason \
                      if vol_list_info.results_status == 'failed'
                        result = {}
                        vol_list_info.child_get("volumes").children_get.each do |key|
                          plexes = {}
                          key.child_get("plexes").children_get.each { |plx|
                            plexes[name: plx.child_get_string("name")] = {
                              isonline:         plx.child_get_string("is-online"),
                              isresyncing:      plx.child_get_string("is-resyncing"),
                              resyncpercentage: plx.child_get_string("resyncing-percentage")
                            }
                          }
                          result = {
                            name:                  key.child_get_string("name"),
                            uuid:                  key.child_get_string("uuid"),
                            type:                  key.child_get_string("type"),
                            containingaggr:        key.child_get_string("containing-aggregate"),
                            sizetotal:             key.child_get_string("size-total"),
                            sizeused:              key.child_get_string("size-used"),
                            sizeavail:             key.child_get_string("size-available"),
                            percentageused:        key.child_get_string("percentage-used"),
                            filestotal:            key.child_get_string("files-total"),
                            filesused:             key.child_get_string("files-used"),
                            cloneparent:           key.child_get_string("clone-parent"),
                            clonechildren:         key.child_get_string("clone-children"),
                            ischecksumenabled:     key.child_get_string("is-checksum-enabled"),
                            checksumstyle:         key.child_get_string("checksum-style"),
                            compression:           key.child_get_string("compression"),
                            isinconsistent:        key.child_get_string("is-inconsistent"),
                            isinvalid:             key.child_get_string("is-invalid"),
                            isunrecoverable:       key.child_get_string("is-unrecoverable"),
                            iswraparound:          key.child_get_string("is-wraparound"),
                            issnaplock:            key.child_get_string("is-snaplock"),
                            expirydate:            key.child_get_string("expiry-date"),
                            mirrorstatus:          key.child_get_string("mirror-status"),
                            raidsize:              key.child_get_string("raid-size"),
                            raidstatus:            key.child_get_string("raid-status"),
                            owningvfiler:          key.child_get_string("owning-vfiler"),
                            quotainit:             key.child_get_string("quota-init"),
                            remotelocation:        key.child_get_string("remote-location"),
                            reserve:               key.child_get_string("reserve"),
                            reserverequired:       key.child_get_string("reserve-required"),
                            reserveused:           key.child_get_string("reserve-used"),
                            reservedusedact:       key.child_get_string("reserve-used-actual"),
                            snaplocktype:          key.child_get_string("snaplock-type"),
                            snapshotblkreserved:   key.child_get_string("snapshot-blocks-reserved"),
                            snapshotperreserved:   key.child_get_string("snapshot-percent-reserved"),
                            spacereserveenabled:   key.child_get_string("space-reserve-enabled"),
                            spacereserve:          key.child_get_string("space-reserve"),
                            diskcount:             key.child_get_string("disk-count"),
                            plexcount:             key.child_get_string("plex-count"),
                            plexes:                plexes
                            # add SIS and snaplock data
                          }
                        end
                        return result
                    end

                    def self.size(volname)
                      vol_size = @@filer.invoke("volume-size",
                                                "volume", volname)
                      raise vol_size.results_reason \
                        if vol_size.results_status == 'failed'
                          return result = vol_size.child_get_string("volume-size")
                      end

                      def self.resize(volname, newsize)
                        vol_resize = @@filer.invoke("volume-size",
                                                    "volume", volname,
                                                    "new-size", newsize)
                        raise vol_resize.results_reason \
                          if vol_resize.results_status == 'failed'
                            return true
                        end
                        # TODO:
                        # implement volume-move-*
                      end

                    end
