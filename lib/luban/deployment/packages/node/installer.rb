module Luban
  module Deployment
    module Packages
      class Node < Luban::Deployment::Package::Base
        class Installer < Luban::Deployment::Package::Installer
          define_executable 'node'

          def package_dist; task.opts.dist; end
          def package_full_name; "node-v#{package_version}-#{package_dist}"; end

          def source_repo
            @source_repo ||= 'https://nodejs.org'
          end

          def source_url_root
            @source_url_root ||= "dist/v#{package_version}"
          end

          def installed?
            return false unless file?(node_executable)
            pattern = Regexp.new(Regexp.escape("v#{package_version}"))
            match?("#{node_executable} --version 2>&1", pattern)
          end

          protected

          def build_package
            info "Building #{package_full_name}"
            within install_path do
              rm('-r', '*') # Clean up install path
              execute(:mv, build_path.join('*'), '.', ">> #{install_log_file_path} 2>&1")
            end
          end
        end
      end
    end
  end
end

