module NetAppSdk

  class Snapshot < Filer
    def self.create(name, volname)
      snapshot_create = @@filer.invoke("snapshot-create",
                                       "snapshot", name,
                                       "volume", volname)
      raise snapshot_create.results_reason \
        if snapshot_create.results_status == 'failed'
          return true
      end

      def self.purge(name, volname)
        snapshot_delete = @@filer.invoke("snapshot-delete",
                                         "snapshot", name,
                                         "volume", volname)
        raise snapshot_delete.results_reason \
          if snapshot_delete.results_status == 'failed'
            return true
        end

        def self.rename(volume, name, newname)
          snapshot_rename = @@filer.invoke("snapshot-rename",
                                           "volume", volname,
                                           "current-name", name,
                                           "new-name", newname)
          raise snapshot_rename.results_reason \
            if snapshot_rename.results_status == 'failed'
              return true
          end

          def self.delta(snap1, snap2, volname)
            snapshot_delta = @@filer.invoke("snapshot-delta-info",
                                            "volume", volname,
                                            "snapshot1", snap1,
                                            "snapshot2", snap2)
            raise snapshot_delta.results_reason \
              if snapshot_delta.results_status == 'failed'
                result = {}
                return result = {
                  consumedsize:     snapshot_delta.child_get_string("consumed-size"),
                  elapsedtime:      snapshot_delta.child_get_string("elapsed-time")
                }
            end

            def self.delta_to_volume(snap, volname)
              snapshot_delta = @@filer.invoke("snapshot-delta-info",
                                              "volume", volname,
                                              "snapshot1", snap)
              raise snapshot_delta.results_reason \
                if snapshot_delta.results_status == 'failed'
                  result = {}
                  return result = {
                    consumedsize:     snapshot_delta.child_get_string("consumed-size"),
                    elapsedtime:      snapshot_delta.child_get_string("elapsed-time")
                  }
              end

              def self.reserve(volname)
                snapshot_reserve = @@filer.invoke("snapshot-get-reserve",
                                                  "volume", volname)
                raise snapshot_reserve.results_reason \
                  if snapshot_reserve.results_status == 'failed'
                    result = {}
                    return result = {
                      blocksreserved:     snapshot_reserve.child_get_string("blocks-reserved"),
                      percentreserved:    snapshot_reserve.child_get_string("percent-reserved")
                    }
                end

                def self.schedule(volname)
                  snapshot_schedule = @@filer.invoke("snapshot-get-schedule",
                                                     "volume", volname)
                  raise snapshot_schedule.results_reason \
                    if snapshot_schedule.results_status == 'failed'
                      result = {}
                      return result = {
                        days:          snapshot_schedule.child_get_string("days"),
                        hours:         snapshot_schedule.child_get_string("hours"),
                        minutes:       snapshot_schedule.child_get_string("minutes"),
                        weeks:         snapshot_schedule.child_get_string("weeks"),
                        whichhours:    snapshot_schedule.child_get_string("which-hours"),
                        whichminutes:  snapshot_schedule.child_get_string("which-minutes")
                      }
                  end

                  def self.info(volname)
                    snapshot_info = @@filer.invoke("snapshot-list-info",
                                                   "volume", volname)
                    raise snapshot_info.results_reason \
                      if snapshot_info.results_status == 'failed'
                        result = {}
                        snapshot_info.child_get("snapshots").children_get.each do |key|
                          result = {
                            name:                     key.child_get_string("name"),
                            accesstime:               key.child_get_string("access-time"),
                            busy:                     key.child_get_string("busy"),
                            containslunclones:        key.child_get_string("contains-lun-clones"),
                            cumpercentageblockstotal: key.child_get_string("cumulative-percentage-of-total-blocks"),
                            cumpercentageblocksused:  key.child_get_string("cumulative-percentage-of-used-blocks"),
                            cumtotal:                 key.child_get_string("cumulative-total"),
                            dependency:               key.child_get_string("dependency"),
                            percentageblockstotal:    key.child_get_string("percentage-of-total-blocks"),
                            percentageblocksused:     key.child_get_string("percentage-of-used-blocks"),
                            total:                    key.child_get_string("total")
                          }
                        end
                        return result
                    end
                  end
                end
