Pod::Spec.new do |s|
  s.name     = 'MTLManagedObjectAdapter'
  s.version  = '1.0-1'
  s.license  = 'MIT'
  s.summary  = 'Model framework for Cocoa and Cocoa Touch.'
  s.homepage = 'https://github.com/Mantle/Mantle'
  s.authors  = { 'GitHub' => 'support@github.com' }
  s.source   = { :git => 'https://github.com/Mantle/MTLManagedObjectAdapter.git', :tag => "1.0" }
  s.requires_arc = true

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.source_files = 'MTLManagedObjectAdapter/MTLManagedObjectAdapter.{h,m}'
  s.public_header_files = 'MTLManagedObjectAdapter/MTLManagedObjectAdapter.h'

  s.subspec "extobjc" do |ss|
    ss.source_files = 'MTLManagedObjectAdapter/extobjc/*.{h,m}'
    ss.private_header_files = 'MTLManagedObjectAdapter/extobjc/*.h'
  end

  s.dependency 'Mantle', '~> 2.0'
  s.frameworks = 'Foundation', 'CoreData'

  # Patches for header map and header search order (clashes with `Mantle`)
  s.prepare_command = <<-CMD
  PREFIX="mtl_moa_"
  # Add prefix to header imports
  ext_header_prefix_src() {
    SOURCE_FILE=$1
    EXT_HEADER_NAME=$2
    sed -i.bak "s/\"${EXT_HEADER_NAME}\"/\"${PREFIX}${EXT_HEADER_NAME}\"/g" ${SOURCE_FILE} && rm ${SOURCE_FILE}.bak
  }
  ext_header_prefix_src MTLManagedObjectAdapter/MTLManagedObjectAdapter.m EXTRuntimeExtensions.h
  ext_header_prefix_src MTLManagedObjectAdapter/MTLManagedObjectAdapter.m EXTScope.h
  ext_header_prefix_src MTLManagedObjectAdapter/extobjc/EXTRuntimeExtensions.m EXTRuntimeExtensions.h
  ext_header_prefix_src MTLManagedObjectAdapter/extobjc/EXTScope.m EXTScope.h
  # Change header name
  ext_header_prefix_mv() {
    SOURCE_FILE=$1
    FILE_NAME=`basename ${SOURCE_FILE}`
    DIR_NAME=`dirname ${SOURCE_FILE}`
    mv ${SOURCE_FILE} `dirname ${SOURCE_FILE}`/${PREFIX}`basename ${SOURCE_FILE}`
  }
  export -f ext_header_prefix_mv
  export PREFIX=${PREFIX}
  find MTLManagedObjectAdapter/extobjc -name "*.h" -exec bash -c 'ext_header_prefix_mv "$0"' {} \\;
  unset ext_header_prefix_mv
  unset PREFIX
  CMD
end
