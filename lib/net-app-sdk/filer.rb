module NetAppSdk
  # connect to filer, assign object
  class Filer

    def initialize(filer, username, password, secure=true, type=filer)
      require "pry"; binding.pry
      @@filer = NaServer.new(filer, 1, 17) # specifies API version (1.17)
      if secure
        @@filer.set_transport_type("HTTPS")
        raise 'insecure connection!' unless @@filer.https?
      end
      @@filer.set_admin_user(username, password)

      # TODO: implement NaServer::set_server_type for NetApp DFM/Filer
      # TODO: implement different login styles (usr,pwd - cert - ...)
      #       see also - NaServer::set_style
    end

    def self.is_secure?
      @@filer.https?
    end

    def self.is_clustered?
      sys_version = @@filer.invoke("system-get-version")
      raise sys_version.results_reason if sys_version.results_status == 'failed'
      return sys_version.child_get_string("version") =~ /Cluster-Mode/ ? true : false
    end

    def self.is_ha?
      cf_status = @@filer.invoke("cf-status")
      return false if cf_status.results_status == 'failed' and cf_status.results_reason == 'monitor not initialiazed'
      raise cf_status.results_reason if cf_status.results_status == 'failed'
      result = cf_status.child_get_string("is-enabled")
      result
    end

    def self.set_vfiler(vfilername)
      @@filer.set_vfiler(vfilername)
    end

    def self.info
      system_info = @@filer.invoke("system-get-info")
      raise system_info.results_reason \
        if system_info.results_status == 'failed'
          result = {}
          system_info.child_get("system-info").children_get.each do |key|
            result = {
              systemid:                      key.child_get_string("system-id"),
              systemname:                    key.child_get_string("system-name"),
              systemmodel:                   key.child_get_string("system-model"),
              systemmachinetype:             key.child_get_string("system-machine-type"),
              systemrev:                     key.child_get_string("system-revision"),
              systemserialno:                key.child_get_string("system-serial-number"),
              vendorid:                      key.child_get_string("vendor-id"),
              prodtype:                      key.child_get_string("prod-type"),
              partnersystemid:               key.child_get_string("partner-system-id"),
              partnersystemname:             key.child_get_string("partner-system-name"),
              partnersystemserialno:         key.child_get_string("partner-system-serial-number"),
              backplanepartno:               key.child_get_string("backplane-part-number"),
              backplanerev:                  key.child_get_string("backplane-revision"),
              processorsno:                  key.child_get_string("number-of-processors"),
              memorysize:                    key.child_get_string("memory-size"),
              cpuserialno:                   key.child_get_string("cpu-serial-number"),
              cpurev:                        key.child_get_string("cpu-revision"),
              cputype:                       key.child_get_string("cpu-processor-type"),
              cpuid:                         key.child_get_string("cpu-processor-id"),
              cpupartno:                     key.child_get_string("cpu-part-number"),
              cpumicrocodeversion:           key.child_get_string("cpu-microcode-version"),
              cpufirmwarerel:                key.child_get_string("cpu-firmware-release"),
              cpuciobrevid:                  key.child_get_string("cpu-ciob-revision-id"),
              supportsraidarray:             key.child_get_string("supports-raid-array"),
              controlleraddress:             key.child_get_string("controller-address"),
              boardtype:                     key.child_get_string("board-type"),
              boardspeed:                    key.child_get_string("board-speed")
            }
          end
          return result
      end
    end

  end
