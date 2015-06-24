ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    # Here is an example of a simple dashboard with columns and panels.
    #
    columns do
      column do
        panel "Recent Hosts" do
          ul do
            Host.limit(5).map do |host|
              li link_to(host.name, admin_host_path(host))
            end
          end
        end
      end

      column do
        panel "Recent Rooms" do
          ul do
            Room.limit(5).map do |room|
              li link_to(room.name, admin_room_path(room))
            end
          end
        end
      end

    end
  end # content
end
