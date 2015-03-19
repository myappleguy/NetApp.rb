class Diag < Filer
    def self.status
        # "Overall system health (ok,ok-with-suppressed,degraded,
        # unreachable) as determined by the diagnosis framework"
        diag_status = @@filer.invoke("diagnosis-status-get")
        raise diag_status.results_reason \
              if diag_status.results_status == 'failed'
        stat = diag_status.child_get("attributes").children_get
        stat.each { |k| return k.child_get_string("status") }
    end
end


