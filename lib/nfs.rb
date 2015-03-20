class NFS < Filer

    def self.on
        nfs_on = @@filer.invoke("nfs-enable")
        raise nfs_on.results_reason \
              if nfs_on.results_status == 'failed'
        return true
    end

    def self.off
        nfs_off = @@filer.invoke("nfs-disable")
        raise nfs_off.results_reason \
              if nfs_off.results_status == 'failed'
        return true
    end

    def self.add_export(pathname, type, anon=false, nosuid=false, allhosts=false, exports)
        #
        # - type = read-only || read-write || root
        # - exports  = string (hostname, IP, subnet [CIDR])

        raise "unkown argument in type" unless type == "read-only" or \
                                               type == "read-write" or \
                                               type == "root"
        raise "empty pathname" if pathname.empty?

        nfs_exports_rule_info = NaElement.new("exports-rule-info")
        nfs_exports_rule_info.child_add_string("anon", anon) if anon
        nfs_exports_rule_info.child_add_string("nosuid", nosuid) if nosuid
        nfs_exports_rule_info.child_add_string("pathname", pathname)

        nfs_exports = NaElement.new(type)
        nfs_exports_host = NaElement.new("exports-hostname-info")
        nfs_exports_host.child_add_string("all-hosts", true) if allhosts == true
        nfs_exports_host.child_add_string("name", exports) if exports

        nfs_exports.child_add(nfs_exports_host)
        nfs_exports_rule_info.child_add(nfs_exports)

        nfs_rules = NaElement.new("rules")
        nfs_rules.child_add(nfs_exports_rule_info)

        nfs_exports_invoke = NaElement.new("nfs-exportfs-append-rules")
        nfs_exports_invoke.child_add(nfs_rules)
        nfs_exports_invoke.child_add_string("verbose", true)

        nfs_add_export = @@filer.invoke_elem(nfs_exports_invoke)
        raise nfs_add_export.results_reason \
              if nfs_add_export.results_status == 'failed'
        return true
    end

    def self.del_export(pathname)
        nfs_exports_path_del = NaElement.new("pathname-info")
        nfs_exports_path_del.child_add_string("name", pathname)

        nfs_pathnames = NaElement.new("pathnames")
        nfs_pathnames.child_add(nfs_exports_path_del)

        nfs_exports_invoke = NaElement.new("nfs-exportfs-delete-rules")
        nfs_exports_invoke.child_add(nfs_pathnames)
        nfs_exports_invoke.child_add_string("verbose", true)

        nfs_del_export = @@filer.invoke_elem(nfs_exports_invoke)
        raise nfs_del_export.results_reason \
              if nfs_del_export.results_status == 'failed'
        return true
    end

    def self.status
        nfs_status = @@filer.invoke("nfs-status")
        raise nfs_status.results_reason \
              if nfs_status.results_status == 'failed'
        return result = {
            isdrained:          nfs_status.child_get_string("is-drained"),
            isenabled:          nfs_status.child_get_string("is-enabled")
        }
    end
end


