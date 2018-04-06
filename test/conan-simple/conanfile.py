from conans import ConanFile, CMake


class ConanSimple(ConanFile):
    name = 'conan-simple'
    version = '0.1'
    settings = 'os', 'compiler', 'build_type', 'arch'
    generators = 'cmake'
    exports_sources = '*.c', 'CMake*'

    def build(self):
        cmake = CMake(self)
        cmake.configure(source_folder='.')
        cmake.build()
        cmake.install()
