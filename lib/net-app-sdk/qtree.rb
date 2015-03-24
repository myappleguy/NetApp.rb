module NetAppSdk
  class Qtree < Filer
    def self.create(qtreename, volname)
      qtree_create = @@filer.invoke("qtree-create",
                                    "qtree", qtreename,
                                    "volume", volname)
      raise qtree_create.results_reason \
        if qtree_create.results_status == 'failed'
          return true
      end

      def self.purge(qtreename)
        qtree_delete = @@filer.invoke("qtree-delete",
                                      "qtree", qtreename)
        raise qtree_delete.results_reason \
          if qtree_delete.results_status == 'failed'
            return true
        end

        def self.list
          qtree_list = @@filer.invoke("qtree-list")
          raise qtree_list.results_reason \
            if qtree_list.results_status == 'failed'
              result = {}
              qtree_list.child_get("qtrees").children_get.each do |key|
                result[qtree: key.child_get_string("qtree")] = {
                  volume: key.child_get_string("volume")
                }
              end
              return result
          end

          def self.info(volname)
            qtree_list = @@filer.invoke("qtree-list",
                                        "volume", volname)
            raise qtree_list.results_reason \
              if qtree_list.results_status == 'failed'
                result = {}
                qtree_list.child_get("qtrees").children_get.each do |key|
                  result[id: key.child_get_string("id")] = {
                    qtree:          key.child_get_string("qtree"),
                    volume:         key.child_get_string("volume"),
                    status:         key.child_get_string("status"),
                    oplocks:        key.child_get_string("oplocks"),
                    owningvfiler:   key.child_get_string("owning-vfiler"),
                    securitystyle:  key.child_get_string("security-style")
                  }
                end
                return result
            end
          end

        end
