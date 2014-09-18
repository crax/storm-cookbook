module Storm
  module Helper
    def conf_file(service_name)
      case node[:storm][:init_style]
      when "upstart"
        "storm-#{service_name}.conf"
      when "init"
        "storm-#{service_name}"
      end
    end

    def conf_path(service_name)
      case node[:storm][:init_style]
      when "upstart"
        "/etc/init/#{conf_file(service_name)}"
      when "init"
        "/etc/init.d/#{conf_file(service_name)}"
      end
    end
  end
end

Chef::Recipe.send(:include, Storm::Helper)
