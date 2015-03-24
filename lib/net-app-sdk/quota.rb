module NetAppSdk

  class Quota < Filer
    def self.create(qtreename="", volname, path, quotasize, type)
      quota_create = @@filer.invoke("quota-add-entry",
                                    "qtree", qtreename,
                                    "volume", volname,
                                    "quota-target", path,
                                    "soft-disk-limit", quotasize,
                                    "quota-type", type)
      raise quota_create.results_reason \
        if quota_create.results_status == 'failed'
          return true
      end

      def self.purge(qtreename="", volname, path, type)
        quota_delete = @@filer.invoke("quota-delete-entry",
                                      "qtree", qtreename,
                                      "volume", volname,
                                      "quota-target", path,
                                      "quota-type", type)
        raise quota_delete.results_reason \
          if quota_delete.results_status == 'failed'
            return true
        end

        def self.on(volname)
          quota_on = @@filer.invoke("quota-on",
                                    "volume", volname)
          raise quota_on.results_reason \
            if quota_on.results_status == 'failed'
              return true
          end

          def self.off(volname)
            quota_off = @@filer.invoke("quota-off",
                                       "volume", volname)
            raise quota_off.results_reason \
              if quota_off.results_status == 'failed'
                return true
            end

            def self.get_entry(qtreename, volname, path, type)
              quota_get_entry = @@filer.invoke("quota-get-entry",
                                               "qtree", qtreename,
                                               "volume", volname,
                                               "quota-target", path,
                                               "quota-type", type)
              raise quota_get_entry.results_reason \
                if quota_get_entry.results_status == 'failed'
                  return true
              end

              def self.list
                quota_list_entries = @@filer.invoke("quota-list-entries")
                raise quota_list_entries.results_reason \
                  if quota_list_entries.results_status == 'failed'
                    result = {}
                    quota_list_entries.child_get("quota-entries").children_get.each do |key|
                      result[qtree: key.child_get_string("qtree")] = {
                        line:           key.child_get_string("line"),
                        volume:         key.child_get_string("volume"),
                        quotaerror:     key.child_get_string("quota-error"),
                        quotatarget:    key.child_get_string("quota-target"),
                        quotatype:      key.child_get_string("quota-type")
                      }
                    end
                end

                def self.status(volname)
                  quota_status = @@filer.invoke("quota-status",
                                                "volume", volname)
                  raise quota_status.results_reason \
                    if quota_status.results_status == 'failed'
                      return result = quota_status.child_get_string("status")
                  end

                  # TODO: no longer supported in NMSDK API as it seems
                  #def self.user(userid, username, usertype)
                  #    quota_user = @@filer.invoke("quota-user",
                  #                                "quota-user-id", userid,
                  #                                "quota-user-name", username,
                  #                                "quota-user-type", usertype)
                  #    if quota_user.results_status == 'failed'
                  #        raise quota_user.results_reason
                  #    end
                  #end
                end
              end
