module Pkgr

  module Distributions

    class Amazon < Base

      def release
        @release[/^[0-9]+/]
      end

      def runner
        @runner ||= Runner.new("sysv", "lsb-3.1", "chkconfig")
      end

      def package_test_command(package)
        "rpm -qa '#{package}' | grep '#{package}' > /dev/null 2>&1"
      end

      def package_install_command(packages)
        "sudo yum -q check-update ; sudo yum install -y #{packages.map{|package| "\"#{package}\""}.join(" ")}"
      end

      def installer_dependencies
        super.push("which").uniq
      end

      def fpm_command(build_dir)
        AmazonFpmCommand.new(self, build_dir).command
      end

      def templates
        list = super
        list.push Templates::DirTemplate.new("etc/init")
        list
      end

      class AmazonFpmCommand < FpmCommand
        def args
          list = super
          list << "-t" << "rpm"
          list
        end
      end

    end

  end

end
