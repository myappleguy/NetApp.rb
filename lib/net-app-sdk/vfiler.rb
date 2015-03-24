class Vfiler < Filer
    def self.create(name, ipaddr, storage)
        vfiler_create = @@filer.invoke("vfiler-create",
                                       "vfiler", name,
                                       "ip-addresses", ipaddr,
                                       "storage-units", storage)
        raise vfiler_create.results_reason \
              if vfiler_create.results_status == 'failed'
        return true
    end

    def self.purge(name)
        vfiler_delete = @@filer.invoke("vfiler-destroy",
                                       "vfiler", name)
        raise vfiler_delete.results_reason \
              if vfiler_delete.results_status == 'failed'
        return true
    end

    def self.add_storage(name, storage)
        vfiler_add_stroage = @@filer.invoke("vfiler-add-storage",
                                            "vfiler", name,
                                            "storage-path", storage)
        raise vfiler_add_stroage.results_reason \
              if vfiler_add_stroage.results_status == 'failed'
        return true
    end
    # vfiler-add-ipaddress, setup, start, stop, migrate, status, list
end

