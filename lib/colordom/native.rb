module Colordom
  module Native
    extend FFI::Library

    LIBNAME = "colordom.#{FFI::Platform::LIBSUFFIX}".freeze
    LIBPATH = File.expand_path('..', __dir__).freeze

    ffi_lib File.expand_path(LIBNAME, LIBPATH)

    attach_function :to_histogram, :to_histogram, [:string], Result
    attach_function :to_mediancut, :to_mediancut, [:string, :uint8], Result
    attach_function :to_kmeans, :to_kmeans, [:string, :uint], Result

    attach_function :free, :free_result, [Result], :void
  end
end
