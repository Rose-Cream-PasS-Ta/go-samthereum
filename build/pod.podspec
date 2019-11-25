Pod::Spec.new do |spec|
  spec.name         = 'G3TH'
  spec.version      = '{{.Version}}'
  spec.license      = { :type => 'GNU Lesser General Public License, Version 3.0' }
  spec.homepage     = 'https://github.com/musicoin/go-musicoin'
  spec.authors      = { {{range .Contributors}}
		'{{.Name}}' => '{{.Email}}',{{end}}
	}
  spec.summary      = 'iOS Ethereum Client'
  spec.source       = { :git => 'https://github.com/musicoin/go-musicoin.git', :commit => '{{.Commit}}' }

	spec.platform = :ios
  spec.ios.deployment_target  = '9.0'
	spec.ios.vendored_frameworks = 'Frameworks/G3TH.framework'

	spec.prepare_command = <<-CMD
    curl https://g3thstore.blob.core.windows.net/builds/{{.Archive}}.tar.gz | tar -xvz
    mkdir Frameworks
    mv {{.Archive}}/G3TH.framework Frameworks
    rm -rf {{.Archive}}
  CMD
end
